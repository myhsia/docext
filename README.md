[![CTAN Version](https://img.shields.io/ctan/v/docext)](https://ctan.org/pkg/docext)
[![GitHub Release](https://img.shields.io/github/v/release/myhsia/docext)](https://github.com/myhsia/docext/releases/latest)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/myhsia/docext)](https://github.com/myhsia/docext/commits)
[![Actions Status](https://github.com/myhsia/docext/actions/workflows/test.yaml/badge.svg?branch=main)](https://github.com/myhsia/docext/actions)
[![GitHub Repo stars](https://img.shields.io/github/stars/myhsia/docext)](https://github.com/myhsia/docext)

The `docext` Package
====================

The `docext` package is an extension for documenting LaTeX source files.

It provides
- An elegant way to typeset the `key-value` list.
- The `codedemo` enviornment for typesetting the code within a `verbatim` and a
`demo` environment at the same time.
- Tagged-PDF output for `codemo`: with `\DocumentMetadata{tagging=on}` the code
panel is tagged as code, the result panel as a text block, and the frames are
artifacts.  Under `l3doc`, load `latex-lab-testphase-l3doc` as well.

It fixes the drawbacks of the `doc` package under
- The engines: `pTeX` and `upTeX`.
- The classes: `book` and `report` (or any class uses the `titlepage`
environment in `\maketitle`)

In the `l3doc` class, it resets the counter of `section` at the beginning of the
`documentation` environment to support the bilingual manuals.

This package is based on the `doc` package and works smoothly under the `l3doc`,
`ltxdoc`, and `article` classes.

Overview
--------

To load this template, write the line

    \usepackage[<options>]{docext}

See `docext.pdf` for more. Happy TeXing!

Issues
------

The issue tracker for `docext` is currently located
[on GitHub](https://github.com/myhsia/docext/issues).

Build status
------------

This project uses [GitHub Actions](https://github.com/features/actions) as a
hosted continuous integration service. For each commit, the build status is
tested using the current release of TeX Live.

_Current build status:_
![build status](https://github.com/myhsia/docext/actions/workflows/test.yaml/badge.svg?branch=main)

Copyright and License
---------------------

Copyright (C) 2026 by Mingyu Xia
[`<myhsia@outlook.com>`](mailto:myhsia@outlook.com)

This work may be distributed and/or modified under the conditions
of the LaTeX Project Public License (LPPL), either version 1.3c of
this license or (at your option) any later version.
The latest version of this license is in

    http://www.latex-project.org/lppl.txt

and version 1.3c or later is part of all distributions of LaTeX
version 2008 or later.

This work has the LPPL maintenance status `maintained`.

The Current Maintainer of this work is **Mingyu Xia**.
