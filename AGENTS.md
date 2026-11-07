# docext

`docext` is a documentation package for LaTeX source files.  It extends the
`doc`/`l3doc` documentation classes with an elegant key-value list, the
`codemo` environment (code and its result side by side), and a tagging-safe
manual.  Everything ships from the single source `docext.dtx`: the derived
`docext.sty`, the generated `README.md`, and the manual `docext.pdf`.  The
package is used by the manuals of `LuaCJK` and `notebeamer`, but it has no
dependency on either of them.

## Shared rules

Repo etiquette, Python style, the git/PR workflow, LaTeX style, `expl3` source
style, manuals and DocStrip, tooling and upkeep are **machine-global**: see the
`repo-rules` skill at `~/.config/opencode/skills/repo-rules/SKILL.md`.  Do not
copy them here; state only the exceptions this repository makes.

## Environment

TeX Live 2026; every command runs from the repository root, where `build.lua`
lives.  The test matrix is the four engines `pdftex`, `xetex`, `uptex`, and
`luatex`; the manual is typeset with `pdflatex-dev` through `latexmk -pdf`.
The release is made by GitHub Actions, not by a local `l3build upload`.

Entry points:

- `l3build` (`unpack`, `check`, `save`, `doc`, `tag`, `ctan`);
- `.github/workflows/test.yaml` for the engine matrix;
- `.github/workflows/release.yaml` for the CTAN upload and GitHub release.

## Project layout

| path | what it is |
| --- | --- |
| `docext.dtx` | the single source: README, driver, user documentation, implementation |
| `docext.ins` | DocStrip map from the `dtx` blocks to `docext.sty` and `README.md` |
| `build.lua` | `l3build` configuration: module `docext`, version and date, four test engines, `typesetexe = latexmk -pdf -pdflatex=pdflatex-dev`, the CTAN `uploadconfig`, `update_tag`, and the `docinit_hook` that copies the generated README back to the root |
| `testfiles/codemo01.lvt` + `.tlg` | panel-width regression for a text body and a one-box body |
| `testfiles/keyval01.lvt` + `.tlg` | `keyval` compiles under tagging; the visual `=` column is checked in the tagged manual |
| `testfiles/tagging01.lvt` + `.tlg` (+ `.uptex.tlg`) | `codemo` under `\DocumentMetadata{tagging=on}` where the engine supports tagging; the upTeX transcript is engine-specific because that engine loads `cmex10` |
| `.github/workflows/test.yaml` | `l3build check --dev` on Ubuntu, macOS and Windows; uploads `build/**/*.diff` and `.fc` on failure |
| `.github/workflows/release.yaml` | triggered by a push that changes `announcement.md`; runs `l3build tag`, `l3build ctan --dev`, `l3build upload`, creates the date tag and the GitHub release |
| `.github/workflows/cache.yaml` | daily TeX Live cache refresh on the three operating systems |
| `.github/tl_packages` | the TeX Live packages CI installs; the tagging jobs need `latex-lab` and `tagpdf` |
| `announcement.md` | the release notes; **changing it is the release trigger** |
| `README.md` | generated from the `<readme>` block of the `dtx` |
| `docext.pdf` | the generated manual |
| `LICENSE` | the LPPL text |

Generated, never edited by hand: `docext.sty`, `README.md`, `docext.pdf`,
`*.zip`, `build/`.

## Conventions and pitfalls

- **One source.** Edit `docext.dtx`; `l3build unpack` regenerates `docext.sty`
  and `README.md`.  A change to a derived file that is not in the `dtx` is lost
  at the next unpack.
- **`codemo` is an I/O environment.** `\@@_codemo_start:` opens
  `\jobname.codemo.vrb` and writes the verbatim body through
  `\verbatim@processline`; `\@@_codemo_end:Nn` closes it, counts its lines,
  and builds two `\fbox`/`\parbox` panels.  The result panel starts with
  `\mode_leave_vertical:` so a body that is one vertical box keeps the panel
  width.  A change to the panel must preserve that vertical-mode start.
- **Tagging is a document property.** The package does not load `tagpdf` and
  must not: tagging is enabled by `\DocumentMetadata{tagging=on}` before
  `\documentclass`.  Under `l3doc`, the document also loads
  `latex-lab-testphase-l3doc`; the manual driver does this.  `codemo`'s code
  panel becomes `Code`, its result panel a text block, and the frames are
  artifacts.
- **`arguments` is an `l3doc` environment, not docext's.** It passes
  `enumitem` keys that the tagging list code rejects.  The docext manual avoids
  it in that one spot; do not redefine it globally just for docext.
- **`keyval` pins its label width.**  `latex-lab`'s `enumitem` emulation does
  not reproduce enumitem's widest-label calculation; left at its default, the
  labels sit at the text margin and the `=` signs lose their column.  The
  `\setlist[keyval]` therefore sets `labelwidth = \marginparwidth` and
  `labelindent = -\marginparwidth`; `\keys` already scales a wider label
  against the same length, so this is the upper bound.  Keep the two values
  equal, or the value column moves.
- **`enumitem` is a runtime dependency.** `\setlist[keyval]` and the `keyval`
  environment rely on it; the manual also loads `verbatim` and `xcolor`.
- **Names use `@@`.** The `dtx` sets `%<@@=docext>` in the implementation; every
  private name is written `\@@_...`, `\l_@@_...`, etc.  DocStrip expands the
  leading `@@` to `__docext`.
- **The manual is tagged by default.** The driver starts with
  `\DocumentMetadata{tagging=on,pdfversion=1.7,lang=en-US}` and loads
  `latex-lab-testphase-l3doc`.  `l3build doc` must finish without tagpdf errors
  or `Parent-Child` warnings.
- **The engine matrix includes upTeX.** A test whose transcript depends on a
  font loaded only by pTeX/upTeX needs an engine-specific `.tlg`
  (`name.uptex.tlg`); `l3build` selects it automatically.
- **Release is a push, not an upload.** Bump `version` and `date` in
  `build.lua`, rewrite `announcement.md`, run the local checks, then commit and
  push.  The `release.yaml` workflow runs `l3build tag` (the `\GetIdInfo` line
  in the `dtx`), `l3build ctan --dev`, and `l3build upload`, and creates the
  date tag and GitHub release.  Do not run `l3build upload` locally.
- **The date tag is the release date.** The workflow names the tag after
  `build.lua`'s `date`; a second release on the same day would collide, so move
  the date forward before another release.
- **`uploadconfig.note` is the CTAN-internal channel.** Use it to ask the CTAN
  maintainers to merge a pending upload or to explain a patch release.  It is
  not part of `announcement.md` and never appears in the GitHub release notes.

## Workflows

```bash
l3build unpack        # ~2 s, regenerates docext.sty and README.md
l3build check         # ~1 min, four engines
l3build check codemo01
l3build save codemo01 # bare test name, no extension
l3build doc           # ~20 s, tagged manual, needs latex-lab and tagpdf
l3build tag           # syncs \GetIdInfo with build.lua
l3build ctan          # builds docext.zip
```

The release itself:

```bash
# after the local checks pass
git push origin main   # the commit must change announcement.md
```

CI then runs `l3build tag`, `l3build ctan --dev`, `yes y | l3build upload`,
creates tag `<date>`, and publishes the GitHub release.  CTAN sends the
confirmation mail; after it processes the package, a local
`sudo l3build install --full` installs it into TeX Live.

## Validation

- `l3build check` must print `All checks passed` on all four engines; the
  `.tlg` baselines must match byte for byte.  A difference is a behaviour
  change until proven otherwise.
- `l3build doc` must finish with no `^!` error, no tagpdf `Error`, and no
  `Parent-Child` warning; the manual must contain a `/StructTreeRoot`.
- The tagging test is deliberately engine-neutral except for the upTeX
  transcript; when changing `codemo`'s logging, regenerate both the common
  `.tlg` and `tagging01.uptex.tlg`.
- `keyval01` is a compile smoke test for the list under tagging; the visible
  `=` column is checked in the tagged manual, where all four keys must share
  one x position.
- `l3build ctan` must produce `docext.zip`; the release workflow uploads it.

## CI

- `test.yaml`: every push to any branch and every pull request; three
  operating systems, `l3build check --dev`; failure artifacts are
  `docext-diff-<short-sha>-<os>`.
- `release.yaml`: a push that changes `announcement.md` (or manual dispatch);
  Ubuntu only; tag, CTAN upload, date tag, GitHub release.
- `cache.yaml`: daily at 09:41 UTC, three operating systems, refreshes the
  TeX Live cache.
- Local and CI use TeX Live 2026; the parity risks are `.github/tl_packages`
  and the `latex-lab`/`tagpdf` versions.

## Git style

See the global `repo-rules` skill: `type(scope): summary`, commit only when
asked, never commit generated output or secrets.  Scopes used here: `codemo`,
`keys`, `l3doc`, `tagging`, `docs`, `ci`, `release`, `build`.
