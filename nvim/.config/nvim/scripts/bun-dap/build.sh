#!/usr/bin/env bash
# Baixa o adapter do repo do Bun e gera ~/.local/share/nvim/bun-dap/bun-dap.js
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
git clone -q --depth 1 --filter=blob:none --sparse https://github.com/oven-sh/bun.git "$work/bun"
git -C "$work/bun" sparse-checkout set packages/bun-debug-adapter-protocol packages/bun-inspector-protocol
(cd "$work/bun/packages/bun-debug-adapter-protocol" && bun install --silent)
mkdir -p "$work/app/node_modules"
ln -s "$work/bun/packages/bun-debug-adapter-protocol" "$work/app/node_modules/bun-debug-adapter-protocol"
cp "$here/main.ts" "$work/app/main.ts"
out="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/bun-dap"
mkdir -p "$out"
bun build "$work/app/main.ts" --target=bun --define process.env.NODE_ENV="\"production\"" --outfile "$out/bun-dap.js"
echo "OK: $out/bun-dap.js"
