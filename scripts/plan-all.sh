#!/usr/bin/env bash
set -euo pipefail

for env in dev staging production; do
  echo "==> planning ${env}"
  terraform -chdir="${env}" plan
  echo
 done
