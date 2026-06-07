#!/usr/bin/env sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
CLIPS_BIN=${CLIPS_EXE:-clips}

cd "$PROJECT_ROOT"
"$CLIPS_BIN" -f2 clips/main_cli.clp
