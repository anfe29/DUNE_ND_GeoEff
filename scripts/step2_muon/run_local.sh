#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
MODE="${1:-nd}"
shift || true
export PYTHONPATH="${REPO_ROOT}/python:${PYTHONPATH:-}"
case "${MODE}" in
  nd) exec python3 -m ndgeoeff.step2_muon.make_tree_nd "$@" ;;
  fd) exec python3 -m ndgeoeff.step2_muon.make_tree_fd "$@" ;;
  *) echo "Usage: $0 {nd|fd} <input-root-file>" >&2; exit 2 ;;
esac
