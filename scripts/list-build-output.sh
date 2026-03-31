#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 <result-path>"
  exit 1
fi

result_path="$1"

if [ ! -e "$result_path" ]; then
  echo "path not found: $result_path"
  exit 1
fi

find "$result_path" -maxdepth 3 -type f | sort
