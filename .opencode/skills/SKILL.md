---
name: docext
description: Use when working on docext — the codedemo/keyval documentation extension, its tagging support, its four-engine tests, or its GitHub-Actions CTAN release.
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  scope: project
---

# docext

`docext` extends the LaTeX `doc`/`l3doc` documentation classes.  A session needs
this skill because `codemo` is an I/O-plus-layout environment, not a simple
verbatim wrapper, and because the package is released by a push to
`announcement.md` rather than by a local upload.

## Repository rules

Repo etiquette, the git/PR workflow, LaTeX style, `expl3` source style, manuals
and DocStrip, tooling and upkeep are **machine-global**: see the `repo-rules`
skill.  This skill carries only the project's architecture.

## Background

The package has three interfaces:

- `\keys`, `\val`, `\TF`, `\TTF`, `\TFF`, and the `keyval` environment for
  typesetting key-value lists.  They share `enumitem` and the `keyval` list
  setup (`\setlist[keyval]{leftmargin=0pt,labelsep=0pt}`).
- `codemo`/`codemo*`, which write a verbatim body to
  `\jobname.codemo.vrb`, then typeset the code in a monospaced `\parbox` and
  execute the body in a second `\parbox` inside `\fbox` frames.  The width
  ratio comes from the `ratio` package option (default `.625`).
- A small set of `l3doc` patches: `\meta`, the section counter at the start of
  a `documentation` environment, the `macrocode` font, and the `l3doc`
  warning filter.

## Current work

`codemo` is the part that needs care.  `\@@_codemo_start:` opens the write
stream and lets `verbatim` process the body; `\@@_codemo_end:Nn` closes it,
counts its lines, and builds the two panels.  The result panel starts with
`\mode_leave_vertical:` so a body that is a single vertical box (for example
LuaCJK's `CJKfilltwosides`) does not shrink the panel.  The panel widths use
`\dim_eval:n`, not `\setlength` arithmetic, so the package works in `article`
without `calc`.

Tagging is enabled by the document, not by the package: the manual driver
declares `\DocumentMetadata{tagging=on,pdfversion=1.7,lang=en-US}` and loads
`latex-lab-testphase-l3doc`.  With tagging on, the code panel is `Code`
(the `verbatim` role), the result panel is a text block, and the frames are
artifacts.  The package itself must not depend on `tagpdf` at run time.

The `arguments` environment is `l3doc`'s, and it passes `enumitem` keys
(`nolistsep`, `labelsep=*`) that the tagging list code rejects.  The docext
manual uses `itemize` in that one place; do not patch `arguments` globally.

## Conventions

- `%<@@=docext>` names the namespace; private names are `\@@_...`.
- `codemo` is kept outside `\TEST` in tests because a verbatim body cannot be
  read from a macro argument.
- The test matrix is `pdftex`, `xetex`, `uptex`, `luatex`.  A transcript that
  depends on a font loaded only by upTeX needs `name.uptex.tlg`; l3build picks
  it automatically.
- The manual is tagged by default, so `l3build doc` is a tagging test too.
- `build.lua`'s `date` is the release date and the Git tag name; a second
  release on the same day would collide.

## Workflows and validation

```bash
l3build unpack
l3build check              # four engines, must print "All checks passed"
l3build save <name>        # bare name, no .lvt
l3build doc                # tagged manual, no tagpdf errors or Parent-Child warnings
l3build tag
l3build ctan
```

Release:

1. bump `version`/`date` in `build.lua`;
2. rewrite `announcement.md`;
3. run the checks and `l3build doc`;
4. commit and push to `main` **with a change to `announcement.md`**;
5. `release.yaml` runs `l3build tag`, `l3build ctan --dev`, and
   `l3build upload`, creates the date tag and the GitHub release.

Do not run `l3build upload` locally.  After CTAN processes the release, install
with `sudo l3build install --full`.
