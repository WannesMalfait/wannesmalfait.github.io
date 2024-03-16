---
layout: post
title: LaTeX compilation with GitHub actions
date: 2024-03-16
description: Setting up GitHub actions to compile LaTeX documents on push
tags: GitHub LaTeX programming
# toc:
#     sidebar: left
---

## Why I wanted to compile LaTeX code with GitHub actions

Whenever I write a document in LaTeX, I set up a (local) git repository for version control. This lets me make big changes without having to worry about permanently deleting things that I might need in the future. By looking at the commit log, I can get a quick overview of what I was working on, after revisiting the document after some time. Because LaTeX generates a lot of extra files on compilation, I have a `.gitignore` file set up to essentially ignore everything that isn't a `.bib` or a `.tex` file. Importantly, I ignore `.pdf` files. There are a couple of reasons for this:

1. As a general rule of thumb, only source files should be included in a git repository. The compilation outputs can be recreated from the source file, and do not carry extra information.
1. A `.pdf` file is relatively big. It can easily be 10 times the size of the source file.
1. The binary data of the output `.pdf` file can change quite drastically, even after making small changes to `.tex` source. This makes it quite useless to use something like `git diff` directly on the PDF. Instead, a tool like [latexdiff](https://ctan.org/pkg/latexdiff) should be used.
1. I often only compile a small part of the whole document, to speed up compilation time. The output PDF's do not reflect the “actual” state of the document, and shouldn't be picked up by the version control.

My only problem, so far, with this approach, was that I didn't have an easy way to share the PDF with my supervisors. Every time I wanted to share a version, I had to compile the full document, and e-mail them the PDF. This is not terribly difficult to do, but it annoyed me slightly. Additionally, I wanted my supervisors to be able to view the latest version or a previous version at any time, without me having to spam them with e-mails.

## My solution

Setting up a simple GitHub action workflow, was surprisingly easy. A few searches on the web and some copy-pasting from README examples got me there. Here's the code:

{% raw %}

```yaml
# .github/workflows/compile.yml
name: Build LaTeX document
on: [push]
jobs:
  build_latex:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Get current date
        id: date 
        run: | # You can change the time zone if needed
            echo "date=$(TZ='Europe/Brussels' date +'%Y-%m-%d--%H-%M')" >> $GITHUB_ENV
      - name: Set up Git repository
        uses: actions/checkout@v4
      - name: Compile LaTeX document
        uses: xu-cheng/latex-action@v3
        with:
          root_file: main.tex # Change to the name of your main file 
      - name: Upload PDF file to new release
        uses: ncipollo/release-action@v1
        with:
          tag: ${{ env.date }}
          commit: "main" # The name of the branch to commit to
          name: ${{ env.date }}
          artifacts: "main.pdf" # Make sure this is the same name as your main file
```

{% endraw %}

It works quite well, but there are some things which you might not like:

- This creates a new release on every push to the GitHub repository. I first tried just uploading the compiled PDF to an artifact instead of a release. The problem is that these can not be accessed without being logged in to GitHub, and they don't have an easily accessible download link.
- I have not bothered to collect all the commit names into a change log for each release. That could be a possible improvement. Right now, the release just has the current date/time as its name and tag. This ensures it doesn't accidentally get overwritten, but it could also be formatted a bit more nicely.
- The `latex-action` uses a full `texlive` environment. Currently, the full release workflow takes around 2 minutes to complete. This could probably be shortened by using a more minimal LaTeX environment.

Over all, I'm happy with the result I got for the small amount of time I put into it.
