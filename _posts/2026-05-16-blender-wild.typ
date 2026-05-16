== What?

When compiling blender, one of the slowest steps on rebuilds is the linking. I had already set up my blender builds to use the #link("https://github.com/rui314/mold")[mold linker] which is much faster than the default. Blender has some CMake rules to make this relatively easy to do. Having heard about the wild linker, which seems to be even faster, I set out to get blender compiling with wild as an experiment.

== How?

I found the following way of getting it to work, but in the future easier options might be available. (These are instructions for linux.)

+ Set up a build with clang as the compiler. Some version of `CC=/usr/bin/clang CXX=/usr/bin/clang++ make ninja <otherflags>` should work. Cancel the build immediately once the configuring is done, we still need to change the settings.
+ Go the build folder and open `CMakeCache.txt` to edit the build configuration. Enable mold (`WITH_LINKER_MOLD=ON`) and then change the path to point to the wild binary instead (`MOLD_BIN=path/to/wild`).
+ Change any other settings that you want.
+ Starting a build now (with e.g. `ninja install`) should link the binary with wild. You can verify this using, for example, `readelf --string-dump .comment ./bin/blender`.

At the moment this prints some warnings, but those should be gone by the next version of wild (0.9). The final binary works without problems.

== Is it actually faster?

I then used the #link("https://github.com/wild-linker/wild/blob/main/BENCHMARKING.md")[benchmarking documentation for wild] to test if it was actually faster than mold.

```
WILD_SAVE_BASE=/tmp/wild/blender_debug_lite ninja install
hyperfine --warmup 2 '/tmp/wild/blender_debug_lite/2/run-with ld' '/tmp/wild/blender_debug_lite/2/run-with mold' '/tmp/wild/blender_debug_lite/2/run-with wild'
Benchmark 1: /tmp/wild/blender_debug_lite/2/run-with ld
  Time (mean ± σ):     10.278 s ±  0.084 s    [User: 8.724 s, System: 1.525 s]
  Range (min … max):   10.184 s … 10.435 s    10 runs

Benchmark 2: /tmp/wild/blender_debug_lite/2/run-with mold
  Time (mean ± σ):     639.5 ms ±   4.8 ms    [User: 5.6 ms, System: 2.2 ms]
  Range (min … max):   630.5 ms … 645.4 ms    10 runs

Benchmark 3: /tmp/wild/blender_debug_lite/2/run-with wild
  Time (mean ± σ):     392.6 ms ±   8.2 ms    [User: 1.8 ms, System: 1.3 ms]
  Range (min … max):   383.8 ms … 409.8 ms    10 runs

Summary
  /tmp/wild/blender_debug_lite/2/run-with wild ran
    1.63 ± 0.04 times faster than /tmp/wild/blender_debug_lite/2/run-with mold
   26.18 ± 0.59 times faster than /tmp/wild/blender_debug_lite/2/run-with ld
```

Since it is indeed (a bit) faster, I've decided to switch over to wild. (If you're still using `ld` then you will save a lot of time by switching.)
