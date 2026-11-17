#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODE="${1:-fd}"
shift || true

case "${MODE}" in
  fd)
    exec python3 "${REPO_ROOT}/app/make_tree_fd.py" "$@"
    ;;
  nd)
    exec python3 "${REPO_ROOT}/app/make_tree_nd.py" "$@"
    ;;
  *)
    echo "Usage: $0 {fd|nd} <CAF-file-or-glob>" >&2
    exit 2
    ;;
esac
