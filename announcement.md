## Version 0.2D released

- The result panel of `codemo` keeps its full width when the demo body is a
  single vertical box, such as a display-like environment (`CJKfilltwosides`
  in `LuaCJK`).  A panel is a `\parbox` and takes its width from its content,
  so the body now starts by leaving vertical mode.
- `codemo` works in the `article` class again.  The panel widths are
  arithmetic expressions, and `\setlength` understands the subtraction only
  with `calc` loaded, which `l3doc` provides and `article` does not; both
  widths are now evaluated with `\dim_eval:n`.
- The first test, `testfiles/codemo01.lvt`, compares the panel width of a
  text body with that of a one-box body, on all four engines.
