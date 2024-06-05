---
layout: post
title: Computing prime numbers in parallel
date: 2024-03-16
description: Coming up with an algorithm to compute primes in parallel
tags: programming rust
---

## The problem statement

Given an integer `n`, the goal is to compute all the prime numbers less than or equal to `n`.

Most programmers have probably written a program to do exactly this at least once in their life. I recently needed this for [a program](https://github.com/WannesMalfait/prime-sum-sequences) I was writing to compute “prime sum sequences”: permutations of the numbers `1` to `n` such that the sum of two consecutive numbers is always a prime, e.g., `1,4,3,2,5,6`.

## The solution

We will be writing all the code in rust, because I like writing things in rust, and because it is easy to write high-performance parallel code in.

### A naive implementation

Let us start with perhaps the most simple implementation:

```rust
fn compute_primes(n: usize) -> Vec<usize> {
    (2..=n).filter(|&i| (2..i).all(|divisor| i % divisor != 0)).collect()
}
```

We make heavy use of iterators here. The code almost reads like the definition of a prime number: A number \\(i > 1\\) is prime, if it has no non-trivial divisors, i.e., for all \\(j \in \{2, 3, \dotsc, i -1 \}\\), the number \\(j\\) does not divide \\(i\\). For those less familiar with iterators, here is a version with classic for loops:

```rust
fn compute_primes(n: usize) -> Vec<usize> {
    let mut primes = vec![];
    for i in 2..=n {
        let mut is_prime = true;
        for divisor in 2..i {
            if i % divisor == 0 {
                is_prime = false;
                break
            }
        }
        if is_prime {
            primes.push(i);
        }
    }
    primes
}
```

Let us now clean this up a bit by splitting the primality check into a separate function:

```rust
fn is_prime(n: &usize) -> bool {
    (2..*n).all(|divisor| n % divisor != 0)
}

fn compute_primes(n: usize) -> Vec<usize> {
    (2..=n).filter(is_prime).collect()
}
```

It is now trivial to parallelize this with rayon:

```rust
use rayon::prelude::*;

fn is_prime(n: &usize) -> bool {
    (2..*n).all(|divisor| n % divisor != 0)
}

fn compute_primes(n: usize) -> Vec<usize> {
    (2..=n).into_par_iter().filter(is_prime).collect()
}
```

That is quite elegant and neat. We can still speed this up by a lot, because we are doing a lot of redundant work.

### Removing redundant checks

Observe that if \\(n = a \cdot b\\), then either \\(a \leq \sqrt{n}\\) or \\(b \leq \sqrt{n}\\). Indeed, otherwise we would have \\(a > \sqrt{n}\\) and \\(b > \sqrt{n}\\) from which
\\[
n = a \cdot b > \sqrt{n} \cdot \sqrt{n} = n,
\\]
a contradiction. So, it suffices to check for divisors less than the square root of \\(n\\). Alternatively, one can check that the square of the divisor is less than \\(n\\). To avoid potential overflows we use a saturated multiplication:

```rust
fn is_prime(n: &usize) -> bool {
    // Note that i <= sqrt(n) if and only if i^2 <= n.
    (2..*n).filter(|&i| i.saturating_mul(i) <= *n).all(|divisor| n % divisor != 0)
}
```

Note that this is a big reduction in complexity, e.g., to check if 1000 is prime we now only need to check 31 numbers, instead of 1000.

The next observation is that we only need to check if the number is divisible by prime numbers, since every number is a product of prime numbers. However, to implement this, we already need a list of prime numbers! Luckily we can get around this:

```rust
// `primes` should contain at least all primes less than sqrt(n).
fn is_prime(n: usize, primes: &[usize]) -> bool {
    primes.iter().filter(|&i| i.saturating_mul(*i) <= n).all(|prime| n % prime != 0)
}

fn compute_primes(n: usize) -> Vec<usize> {
    // We can no longer use filter -> collect,
    // because we need primes while iterating.
    let mut primes = vec![];
    for i in 2..=n {
        if is_prime(i, &primes) {
            primes.push(i);
        }
    }
    primes
}
```

The good news is that this also gives a nice reduction in complexity. One can show that the number of primes less than \\(n\\) is approximately \\(n / \ln{n}\\), where \\(\ln\\) denotes the natural logarithm. So we have gone from \\(O(n)\\) to \\(O(\sqrt{n})\\) to
\\[
O\left(\frac{\sqrt(n)}{\ln{\sqrt(n)}}\right) = O\left(2 \cdot \frac{\sqrt{n}}{\ln{n}}\right) = O\left(\frac{\sqrt{n}}{\ln{n}}\right).
\\]
Concretely, from checking 1000 numbers, to checking 30 numbers, to checking just 11. For 10000, we go to 100 and then down to 25. That is quite the reduction!

The bad news is that we have lost our parallel iterator. We will now see how we can get it back.

### Back to parallelism

The main issue is that our main loop has gone from a parallel loop to a sequential one. Previously, the `is_prime` function only depended on the current number in the loop. Now, `is_prime` also depends on the already computed list of primes. Thus, `is_prime(n+1)` can only be computed after `is_prime(n)` has been computed. This prevents a simple parallelization of the loop.

The key insight is that we don't actually need to know all the primes up to `n` to compute `is_prime(n)`. As we already observed, we only need to know the primes up to \\(\sqrt{n}\\). For example, if we already know the primes up to 100, we can safely compute all the primes up to \\(100^2 = 10000\\) using the list of primes up to 100. This gives the final algorithm:

```rust
use std::cmp::min;
use rayon::prelude::*;

// `primes` should contain at least all primes less than sqrt(n).
fn is_prime(n: usize, primes: &[usize]) -> bool {
    primes.iter().filter(|&i| i.saturating_mul(*i) <= n).all(|prime| n % prime != 0)
}

fn compute_primes(n: usize) -> Vec<usize> {
    let mut primes = vec![];

    // We first compute some initial primes on 1 thread,
    // since to properly iterate in parallel we need to already
    // have a decent number of primes.
    let initial_cutoff = 5_000;
    let mut cap = min(initial_cutoff, n);
    for i in 2..=cap {
        if is_prime(i, &primes) {
            primes.push(i);
        }
    }

    // Now we can iterate in parallel.
    while cap < n {
        let start = cap + 1;

        // We know the primes up to cap,
        // so we can compute the primes up to
        // cap^2.
        cap = min(n, cap.saturating_mul(cap));

        let new_primes = (start..=cap)
            .into_par_iter()
            .filter(|&i| is_prime(i, &primes))
            .collect::<Vec<usize>>();
        primes.extend_from_slice(&new_primes); 
   }
    primes
}
```

For my laptop with 8 threads, this parallel version was around 6 times faster than the single-threaded version. This indicates that the parallelism works quite well.

## Closing remarks

The final algorithm as it is written is not fully optimized. Things that could be added include:

- Only iterate over odd numbers. This seems like it halves execution time, but in reality doesn't make a big difference. The reason is that being even is always the first thing being checked in `is_prime`, so skipping over even numbers only skips numbers that would be rejected quickly anyway.
- Allocate space for the `primes` vector ahead of time using the `n / ln(n)` approximation for its size. This might give a minor improvement in speed.
- Choose an `initial_cutoff` value depending on the number of threads. The value I picked is somewhat arbitrary, but seemed to work well on my laptop.

I decided to make this blog post because I couldn't find any decent parallel prime generating functions when I searched for it online. After thinking about it a bit myself, I ended up with the above algorithm and then made this blog post, so others can use it too. Over all, I am quite pleased with the result.
