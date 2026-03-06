#!/bin/bash
# =====================================================
# SYNAPSE HUB — Dev Server (Hot-Reload + Debugger)
# =====================================================
# Usage:
#   ./hub/dev_server.sh            → Auto-reload only
#   ./hub/dev_server.sh --debug    → Auto-reload + debugpy on port 5678

set -e

WATCH_DIRS="./hub ./pc_hub"
ENTRY="hub/main_server.py"
DEBUG_PORT=5678

if [[ "$1" == "--debug" ]]; then
  echo "[Dev Server] Starting with debugpy on port $DEBUG_PORT..."
  echo "[Dev Server] Attach VS Code to localhost:$DEBUG_PORT"
  watchmedo auto-restart \
    --patterns="*.py" \
    --recursive \
    --directory="$WATCH_DIRS" \
    -- python -m debugpy --listen $DEBUG_PORT --wait-for-client $ENTRY
else
  echo "[Dev Server] Starting with hot-reload (no debugger)..."
  watchmedo auto-restart \
    --patterns="*.py" \
    --recursive \
    --directory="$WATCH_DIRS" \
    -- python $ENTRY
fi
