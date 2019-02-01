#!/bin/sh
# Invoke bin2c to generate C arrays from webpage files (*.html, *.css,...).
# This is to avoid using a filesystem library just for these files.

bin2cTool="python ./bin2c/bin2c.py"
htmlFolder="html"
htmlFiles=$(find ${htmlFolder} -maxdepth 1 -type f)

${bin2cTool} --attribute PROGMEM --out src/chtml --include pgmspace.h ${htmlFiles}
