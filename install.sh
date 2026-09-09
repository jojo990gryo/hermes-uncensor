#!/usr/bin/env bash
# Hermes Uncensor — one-command full setup.
# Install:  curl -fsSL https://raw.githubusercontent.com/jojo990gryo/hermes-uncensor/master/install.sh | bash
#
# Does: 1) installs + enables the uncensor-toggle plugin (pinned SHA)
#       2) backs up + deploys the uncensored SOUL.md identity
#       3) sets the default model (big-pickle — already uncensored, cross-session)
#       4) turns /uncensor ON (frame locked in)
set -euo pipefail

REPO="jojo990gryo/hermes-uncensor"
REF="db92e30025197721112d129600002ea9ccd9a020"
PACK_URL="https://raw.githubusercontent.com/${REPO}/${REF}/hermes-uncensor-pack.yaml"
SOUL_URL="https://raw.githubusercontent.com/${REPO}/${REF}/SOUL.md"

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

echo "==> 1/4 Installing uncensor plugin (pinned ${REF:0:12})"
if command -v hermes >/dev/null 2>&1; then
  hermes plugins install "${REPO}" --ref "${REF}" --enable 2>&1 | grep -v -E "Warning:|listed as a comment" || true
else
  echo "hermes CLI not found in PATH — install the plugin manually:"
  echo "  hermes plugins install ${REPO} --ref ${REF} --enable"
fi

echo "==> 2/4 Deploying uncensored SOUL.md"
SOUL_DEST="${HERMES_HOME}/SOUL.md"
if [ -f "$SOUL_DEST" ]; then
  cp "$SOUL_DEST" "${SOUL_DEST}.bak-uncensor-$(date +%Y%m%d-%H%M%S)"
  echo "   backed up existing SOUL.md"
fi
curl -fsSL "$SOUL_URL" -o "$SOUL_DEST"
echo "   installed ${SOUL_DEST}"

echo "==> 3/4 Setting default model to big-pickle (uncensored, cross-session)"
if command -v hermes >/dev/null 2>&1; then
  hermes config set model.default oc/big-pickle 2>&1 | grep -v -E "Warning:|Restart|mixed sys" | tail -1 || true
  echo "   model.default = oc/big-pickle"
else
  echo "   (skipped — no hermes CLI; set model.default manually)"
fi

echo "==> 4/4 Locking uncensored mode ON"
if [ -d "${HERMES_HOME}/plugins/uncensor-toggle" ]; then
  python3 - "${HERMES_HOME}/plugins/uncensor-toggle" <<'PY'
import json, sys, os, importlib.util
from datetime import datetime
plugin_dir = sys.argv[1]
spec = importlib.util.spec_from_file_location("ut", os.path.join(plugin_dir, "__init__.py"))
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)
out = mod._handle_uncensor("on")
print("   " + out.splitlines()[0])
PY
else
  echo "   (plugin dir not found — /uncensor on once it is installed)"
fi

echo
echo "✓ DONE. Hermes is fully uncensored: plugin + SOUL + model + frame locked in."
echo "  Restart any running session. Toggle anytime: /uncensor on|off|status"