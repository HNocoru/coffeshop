#!/usr/bin/env bash

OUTPUT=${1:-contexto.txt}
shift

> "$OUTPUT"

for path in "$@"; do
    if [[ -d "$path" ]]; then
        find "$path" -type f | sort | while read -r file; do
            echo >> "$OUTPUT"
            echo "================================================================================" >> "$OUTPUT"
            echo "FILE: $file" >> "$OUTPUT"
            echo "================================================================================" >> "$OUTPUT"
            cat "$file" >> "$OUTPUT"
            echo >> "$OUTPUT"
        done
    elif [[ -f "$path" ]]; then
        echo >> "$OUTPUT"
        echo "================================================================================" >> "$OUTPUT"
        echo "FILE: $path" >> "$OUTPUT"
        echo "================================================================================" >> "$OUTPUT"
        cat "$path" >> "$OUTPUT"
        echo >> "$OUTPUT"
    else
        echo "No encontrado: $path"
    fi
done

echo "Generado: $OUTPUT"