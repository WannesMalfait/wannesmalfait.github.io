The website is generated with [Typst](https://typst.app/). It makes use of MathML export which is currently only in the development version of typst, so you will need to build a recent version of Typst that includes that to be able to build the website. The generated code is pushed to the `gh-pages` branch by setting up the output `main` directory as a git worktree:
```
  git worktree add main gh-pages
```
To publish I just run `./publish.sh`.
