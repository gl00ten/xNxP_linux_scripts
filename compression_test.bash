#!/usr/bin/env bash

set -u
set -o pipefail

DIR="/mnt/10t/tese"
MIN_MIB="${1:?Usage: $0 MIN_SIZE_MIB MAX_RATIO_PERCENT}"
MAX_RATIO="${2:?Usage: $0 MIN_SIZE_MIB MAX_RATIO_PERCENT}"

CHUNK=$((8 * 1024 * 1024))
MIN_BYTES=$((MIN_MIB * 1024 * 1024))

checked=0
selected=0
total_size=0
total_after=0
total_gain=0

printf '%-5s %7s %11s %11s  %s\n' USE RATIO SIZE SAVING FILE

while IFS= read -r -d '' file; do
    size=$(stat -c '%s' -- "$file") || continue

    # Use three non-overlapping chunks.
    chunk=$CHUNK
    (( size < chunk * 3 )) && chunk=$((size / 3))
    (( chunk > 0 )) || continue

    offsets=(
        0
        $(((size - chunk) / 2))
        $((size - chunk))
    )

    sample_size=0
    compressed_size=0
    failed=0

    for offset in "${offsets[@]}"; do
        if ! compressed=$(
            dd if="$file" bs=1M \
                iflag=skip_bytes,count_bytes \
                skip="$offset" count="$chunk" \
                status=none 2>/dev/null |
            zstd -q -3 -c |
            wc -c
        ); then
            failed=1
            break
        fi

        sample_size=$((sample_size + chunk))
        compressed_size=$((compressed_size + compressed))
    done

    (( failed )) && {
        printf 'ERROR: %q\n' "$file" >&2
        continue
    }

    ratio=$(awk \
        -v compressed="$compressed_size" \
        -v original="$sample_size" \
        'BEGIN { printf "%.1f", compressed * 100 / original }'
    )

    estimated_after=$(awk \
        -v size="$size" \
        -v compressed="$compressed_size" \
        -v original="$sample_size" \
        'BEGIN { printf "%.0f", size * compressed / original }'
    )

    gain=$((size - estimated_after))
    checked=$((checked + 1))

    if awk -v ratio="$ratio" -v max="$MAX_RATIO" \
        'BEGIN { exit !(ratio <= max) }'; then

        use="YES"
        selected=$((selected + 1))
        total_size=$((total_size + size))
        total_after=$((total_after + estimated_after))
        total_gain=$((total_gain + gain))
    else
        use="NO"
        gain=0
    fi

    printf '%-5s %6s%% %11s %11s  %q\n' \
        "$use" \
        "$ratio" \
        "$(numfmt --to=iec-i --suffix=B "$size")" \
        "$(numfmt --to=iec-i --suffix=B "$gain")" \
        "$file"

done < <(
    find "$DIR" \
        -type f \
        -size +"${MIN_BYTES}"c \
        ! -name '*.zst' \
        -print0
)

echo
printf 'Files tested:            %d\n' "$checked"
printf 'Worth compressing:       %d\n' "$selected"
printf 'Current selected size:   %s\n' \
    "$(numfmt --to=iec-i --suffix=B "$total_size")"
printf 'Estimated compressed:    %s\n' \
    "$(numfmt --to=iec-i --suffix=B "$total_after")"
printf 'Estimated space gained:  %s\n' \
    "$(numfmt --to=iec-i --suffix=B "$total_gain")"
