#!/usr/bin/env bash

DIR="${2:-/mnt/10t/tese}"
THRESHOLD=90   # Compress if sample becomes 90% or less

case "$1" in
  compress)
    find "$DIR" -type f -size +50M ! -name '*.zst' -print0 |
    while IFS= read -r -d '' file; do
      [[ -e "$file.zst" ]] && {
        echo "Skipping, output exists: $file.zst"
        continue
      }

      size=$(stat -c %s -- "$file")
      mib=$((size / 1048576))
      middle=$((mib / 2 - 4))
      end=$((mib - 8))

      compressed_sample=$(
        {
          dd if="$file" bs=1M skip=0         count=8 status=none
          dd if="$file" bs=1M skip="$middle" count=8 status=none
          dd if="$file" bs=1M skip="$end"    count=8 status=none
        } |
        zstd -q -3 -c |
        wc -c
      )

      sample_size=$((24 * 1048576))
      ratio=$((compressed_sample * 100 / sample_size))

      if (( ratio <= THRESHOLD )); then
        echo "Compressing ($ratio% sample ratio): $file"
        zstd -T0 -3 --rm -- "$file"
      else
        echo "Skipping ($ratio% sample ratio): $file"
      fi
    done
    ;;

  uncompress)
    find "$DIR" -type f -name '*.zst' -print0 |
    while IFS= read -r -d '' file; do
      output="${file%.zst}"

      if [[ -e "$output" ]]; then
        echo "Skipping, output exists: $output"
      else
        echo "Restoring: $file"
        zstd -d --rm -- "$file"
      fi
    done
    ;;

  *)
    echo "Usage: $0 compress|uncompress [directory]"
    exit 1
    ;;
esac
