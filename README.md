# slider-mathdept-skill

A [Claude Code](https://claude.com/claude-code) skill for building LaTeX beamer slides with the
MathDept theme: English slides and Chinese speaker notes as two PDFs from one source.

- `SKILL.md`: the instructions Claude follows (theme options, document skeleton, build, checks).
- `build.sh`: builds both PDFs.
- `theme/beamerthemeMathDept.sty`: the beamer theme.

## Install

```bash
git clone https://github.com/ST-48-1240162/slider-mathdept-skill ~/.claude/skills/slider-mathdept-skill
```

## License

The theme is by Martin Helsø, released under the MIT License; see [`theme/LICENSE`](theme/LICENSE).
This copy is modified (see `SKILL.md`).
