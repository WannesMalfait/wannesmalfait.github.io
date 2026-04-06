The website is generated with [Typst](https://typst.app/). It uses the [MathML PR](https://github.com/typst/typst/pull/7436), so you will need to build that branch if you want to generate the website. The generated code is pushed to the `gh-pages` branch by setting up the output `main` directory as a git worktree:
```
  git worktree add main gh-pages
```
To publish I just run `./publish.sh`.
