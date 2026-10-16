#!/bin/bash
# Builds both PDFs: the English slides and the Chinese speaker notes.
# usage: bash build.sh [basename]      (default: the only .tex beside this script)
set -e
cd "$(dirname "$0")"
NAME="${1:-}"
if [ -z "$NAME" ]; then
  NAME=$(ls *.tex | grep -v -- '-notes\.tex$' | head -1); NAME="${NAME%.tex}"
fi
export TEXINPUTS="./theme//:$TEXINPUTS"
for i in 1 2 3; do xelatex -interaction=nonstopmode "$NAME.tex" > /dev/null 2>&1 || true; done
for i in 1 2; do
  cp "$NAME.aux" "$NAME-notes.aux"   # citations: notes mode never writes \bibitem labels
  xelatex -interaction=nonstopmode -jobname="$NAME-notes" \
    "\\def\\NOTESONLY{}\\input{$NAME.tex}" > /dev/null 2>&1 || true
done
rm -f *.aux *.log *.nav *.out *.snm *.toc
ls -l *.pdf
