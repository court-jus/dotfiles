#!/bin/bash


convert -density 300 "$1" /tmp/pdfpngpng-%03d.png
convert -density 300 /tmp/pdfpngpng*png /tmp/pdfpngpdf.pdf
rm -f /tmp/pdfpn*png
evince /tmp/pdfpngpdf.pdf
