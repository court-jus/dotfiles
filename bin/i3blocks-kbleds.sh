#!/bin/bash

kbleds | \
    sed -e "s/0/<span font_desc='Fira Code Regular' foreground='black'>⬤<\/span>/g" | \
    sed -e "s/1/<span font_desc='Fira Code Regular' foreground='white'>⬤<\/span>/g"
