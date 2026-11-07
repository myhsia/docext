## Version 0.2F released

- Fix the `keyval` label alignment in tagged documents.  The tagging
  emulation of `enumitem` does not compute enumitem's widest label, so
  `keyval` now pins `labelwidth` to `\marginparwidth`, the width `\keys`
  already scales against, and hangs the label left by the same amount.  The
  `=` signs stay in one column in tagged and untagged documents.
- Add `testfiles/keyval01.lvt`, which checks the `=` column when the list is
  tagged.
- `codemo` now cooperates with the LaTeX tagging project.  With
  `\DocumentMetadata{tagging=on}` the code panel is tagged as code, the result
  panel as a text block, and the surrounding frames are artifacts.  The manual
  itself is typeset with tagging enabled and loads
  `latex-lab-testphase-l3doc` for the `l3doc` class.
- The result panel of `codemo` keeps its full width when the demo body is a
  single vertical box, such as a display-like environment (`CJKfilltwosides`
  in `LuaCJK`).  A panel is a `\parbox` and takes its width from its content,
  so the body starts by leaving vertical mode.
- `codemo` works in the `article` class again.  The panel widths are
  arithmetic expressions, and `\setlength` understands the subtraction only
  with `calc` loaded, which `l3doc` provides and `article` does not; both
  widths are now evaluated with `\dim_eval:n`.
- `testfiles/codemo01.lvt` compares the panel width of a text body with that
  of a one-box body, on all four engines; `testfiles/tagging01.lvt` checks
  `codemo` with tagging enabled where the engine supports it.
