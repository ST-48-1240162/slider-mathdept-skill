---
name: slider-mathdept-skill
description: |
  Build presentation slides as LaTeX beamer PDFs with the MathDept theme, the
  user's default slide look. Use whenever the user asks for slides, a slider, a
  deck, a talk, 幻灯片, 做个 slider, beamer, 讲稿, or "tex to pdf slides", and
  whenever existing slides need editing or rebuilding. Covers the theme files,
  the English-slides-plus-Chinese-notes two-PDF build, the xeCJK load-order
  trap, branding rules, and the page-by-page visual check.
---

# Slides: MathDept beamer

The user's default deck format. Two PDFs from one source: English slides, and the
same deck as Chinese speaker notes.

## Theme

`theme/beamerthemeMathDept.sty` in this skill directory, by Martin Helsø, MIT
(`theme/LICENSE`). If the user asks for a specific institution's design, say
that this is a different theme before building.

This copy differs from the original release in a few places: a `chinese` language option in place
of the Norwegian ones, image paths renamed to `images/man-*` (unused, since branding is off), `calc`
commented out (the three block widths use `\dimexpr` instead, so it is not needed), one trailing `%`, the colors renamed to `mdred`, `mdgrey1`..`mdgrey5` and `mdlink`,
and a shorter header comment. Everything the original example `main.tex` demonstrates (theorem
blocks, `alertblock`, `\SectionPage`, list styles, `\enumref`, bibliography icons) works with it.

Copy both files into the project (`slides/theme/`), never reference the skill
directory from a document: decks must build on their own.

## Branding: off by default

Always start with:

```latex
\usetheme[MathSerif, NoLogo, NoTitlePage, NoFinalFrame]{MathDept}
```

`MathSerif` keeps text in the theme's sans serif but typesets formulas in the standard Computer Modern
math fonts. The theme's default (`SansSerif`) sets math in sans serif and swaps in neohellenic Greek, which
the user rejected (2026-10-05: formulas and letters must use a standard math font). Keep `MathSerif`.

The theme's title page, closing frame and corner logo pull in image files
(`images/man-*`) that belong to other parties. Disabling them also removes the
only reason to copy the `images/` folder. Write a plain title frame instead,
using the theme's own fonts, so the deck carries no institutional identity.

Add a logo only when the user names one they are entitled to use, and only from
a file they supply. Never draw an approximation of an institution's wordmark.

## Document skeleton

```latex
% !TEX program = xelatex
\documentclass[UKenglish, aspectratio=169]{beamer}

\usepackage{xeCJK}                       % BEFORE \usetheme, see the trap below
\setCJKmainfont{Noto Sans CJK SC}[Scale=0.95]
\setCJKsansfont{Noto Sans CJK SC}[Scale=0.95]
\XeTeXlinebreaklocale "zh"
\XeTeXlinebreakskip = 0pt plus 1pt

\usetheme[MathSerif, NoLogo, NoTitlePage, NoFinalFrame]{MathDept}

\usepackage{booktabs}
\usepackage{array}
\usepackage{amsmath}

\definecolor{good}{RGB}{0,110,70}
\colorlet{bad}{mdred}                     % the theme's own red
\newcommand{\up}{\color{good}}
\newcommand{\dn}{\color{bad}}
\newcommand{\lead}[1]{\structure{\textbf{#1}}}

\ifdefined\NOTESONLY \setbeameroption{show only notes}\else \setbeameroption{hide notes}\fi
\setbeamerfont{note page}{size=\small}

\title{...}
\subtitle{...}
\author{...}
\date{...}

\begin{document}

\begin{frame}[plain, noframenumbering]
  \vspace{1.2cm}
  {\usebeamerfont{title}\structure{\inserttitle}}\par\medskip
  {\usebeamerfont{subtitle}\structure{\insertsubtitle}}\par
  \vfill
  {\usebeamerfont{author}\insertauthor}\hfill{\usebeamerfont{date}\insertdate}\par
  \note{中文讲稿}
\end{frame}

\begin{frame}{Table of contents}
  \tableofcontents
\end{frame}

\section{...}
\SectionPage          % outside a frame; inserts a grey full-page section divider

\end{document}
```

**The trap:** the theme does `\RequirePackage[LGR, T1]{fontenc}`. Load `xeCJK`
(or `fontspec`) *after* `\usetheme` and xelatex fails with `Encoding scheme 'TU'
unknown` plus stray `\else`/`\fi` errors, while still emitting a PDF, so it is
easy to miss. Load it before.

## Build

`build.sh` (copy it into the project beside the `.tex`):

```bash
export TEXINPUTS="./theme//:$TEXINPUTS"
xelatex v2-pivot-talk.tex                                      # x3 for the TOC
xelatex -jobname=NAME-notes '\def\NOTESONLY{}\input{NAME.tex}' # x2
```

Three passes for the slides so `\tableofcontents` and the section pages settle.
The notes PDF puts a slide thumbnail above each note page.

## Theme features worth using

- `\SectionPage` outside a frame for a grey divider page.
- `\alert{}` and `alertblock` use the theme red; `\structure{}` is its accent.
- Lists get the theme's grey-box bullets; use plain `itemize`, do not restyle.
- `booktabs` tables with `\footnotesize` inside `\begin{center}`.
- Footer carries author, title, date and page automatically from the metadata,
  so set all four or the footer looks half-filled.

## References and citations (the original template's reference UI)

The theme's original example template (`main.tex`) shows three
reference forms. The theme already styles all of them; nothing extra is needed
beyond `csquotes` for `\enquote`.

**A References section at the end**, with `allowframebreaks` so a long list
splits into "References I", "References II":

```latex
\usepackage{csquotes}                    % in the preamble, for \enquote

\section{References}

\begin{frame}[allowframebreaks]{References}
  \footnotesize                          % fits more entries per page
  \begin{thebibliography}{}
    % article is the default icon; switch before the items it should apply to
    \setbeamertemplate{bibliography item}[article]
    \bibitem{Patino2021}
    Patino, J., Tomashenko, N., Todisco, M., Nautsch, A.\ and Evans, N.
    \newblock \enquote{Speaker anonymisation using the McAdams coefficient}.
    \newblock \emph{Proc.\ Interspeech}, 2021.

    \setbeamertemplate{bibliography item}[book]      % books, theses
    \bibitem{McAdams1984}
    McAdams, S.
    \newblock \emph{Spectral fusion, spectral parsing and the formation of auditory images}.
    \newblock PhD thesis, Stanford University, 1984.

    \setbeamertemplate{bibliography item}[online]    % web pages, preprints
    \bibitem{VPC2022}
    VoicePrivacy 2022 evaluation plan.
    \newblock \url{https://www.voiceprivacychallenge.org}
  \end{thebibliography}
\end{frame}
```

Icons: `article` (default), `book`, `online`, `triangle` (the theme's bullet),
`text` (a plain `[n]` label). Pick by source type and keep it consistent.

**Citing in the text**: always author + year, then the number: `McAdams 1984~\cite{McAdams1984}`
prints "McAdams 1984 [4]"; two authors "Kitamura and Akagi 1994~\cite{KA1994}", three or more
"Patino et al.\ 2021~\cite{Patino2021}" (Chinese slides: "Patino 等 2021~\cite{...}"). Never a bare
`[n]`, and never a description in place of the author ("McAdams's 1984 PhD thesis [4]"); the user
asked for this form on 2026-10-06. Numbers follow the order of the `\bibitem`s, so list them in
order of first citation. Cite on the slide where a number or
claim from that source appears, and put every cited source in the References
frame; this is how "every number traceable" shows on the slides themselves.

**Referring to a numbered list item**: `\label{enum:key}` inside the `\item`,
then `\enumref{enum:key}` prints the same grey numbered box as the list
(defined in the theme). Use it instead of writing "item 2" by hand.

Run xelatex at least twice (the build script does three passes) so `\cite` and
`\enumref` resolve; unresolved ones print `[?]` or `??`.

## Typography (the user's standing rules)

- **Never** a middle dot (U+00B7) or an em dash (U+2014), in any language. Use a
  comma, a colon, parentheses, or a new sentence. `--` only for numeric ranges.
- No all-caps styling for emphasis.
- Check with: `grep -c -P '\x{2014}|\x{00B7}' file.tex`

## Content proportion

Lead with the result. The user has cut decks for spending too many slides on
self-correction: methodological caveats and "what I got wrong" belong in one
compact slide, not one slide each. Keep the limits slide, keep the honesty, but
do not let it outweigh the findings.

Every number on a slide should be traceable to a file in the project. Put a
table in the slides README mapping slide to source.

## Verify before handing over

Beamer silently lets content run past the bottom edge into the footer, and the
log does not always warn. So:

1. `pdfinfo NAME.pdf | grep Pages` and check the count is what you intended.
2. `grep -cE "^! |Overfull \\\\hbox \([0-9]{2,}"` on a fresh xelatex run **in a scratch
   directory** (`-output-directory=$(mktemp -d)`), then run `build.sh` last. A single
   check pass in the slides folder runs after `build.sh` has deleted the `.aux` files,
   so it overwrites the finished PDF with one that has an empty table of contents and
   footers reading "8 / 1". This happened (2026-10-05) and went unnoticed for two
   commits. Confirm with `pdftotext NAME.pdf - | grep -oE "[0-9]+ / [0-9]+" | sort -u`:
   every total must be the real frame count.
3. **Render and look at every page:** `pdftoppm -r 60 -png NAME.pdf /tmp/sl`,
   then read the images. This is the only reliable check for text colliding with
   the footer. Fix by adding `\small` to the frame, shortening a sentence, or
   splitting the frame.
4. Render one notes page too, to confirm the Chinese actually typeset.
5. If the deck cites sources, search the PDF text for `[?]` and `??`; both mean a
   missing `\bibitem` or label.

Fonts present on this machine: Noto Sans CJK SC, LXGW WenKai, TeX Gyre Heros
(texmf only, load by filename with `Extension=.otf`, not by family name).
