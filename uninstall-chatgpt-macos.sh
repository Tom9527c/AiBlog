#!/usr/bin/env bash
set -u
set -o pipefail

# macOS ChatGPT/Codex cleanup helper.
# Default is preview only. Use --execute and type DELETE_CHATGPT to delete.

readonly EXTENSION_ID="hehggadaopoacecdllhhajmbjkdcmajg"
readonly HOME_DIR="${HOME}"
readonly CODEX_HOME="${CODEX_HOME:-${HOME_DIR}/.codex}"
readonly CONFIRM_WORD="DELETE_CHATGPT"

execute=0
case "${1:-}" in
  "") ;;
  --execute) execute=1 ;;
  -h|--help)
    printf 'Usage: %s [--execute]\n' "$0"
    printf 'Default mode previews targets; --execute performs deletion after confirmation.\n'
    exit 0
    ;;
  *) printf 'Unknown option: %s\nUsage: %s [--execute]\n' "$1" "$0" >&2; exit 2 ;;
esac

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This script only supports macOS.\n' >&2
  exit 1
fi

targets=()
add_target() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] && targets+=("$path")
}

# Desktop application bundles.
add_target "/Applications/ChatGPT.app"
add_target "${HOME_DIR}/Applications/ChatGPT.app"

# Desktop/Codex state, caches, logs, preferences, and support data.
for path in \
  "$CODEX_HOME" \
  "${HOME_DIR}/Library/Application Support/Codex" \
  "${HOME_DIR}/Library/Application Support/com.openai.codex" \
  "${HOME_DIR}/Library/Application Support/com.openai.codex.installer" \
  "${HOME_DIR}/Library/Application Support/OpenAI/Codex" \
  "${HOME_DIR}/Library/Caches/Codex" \
  "${HOME_DIR}/Library/Caches/com.openai.codex" \
  "${HOME_DIR}/Library/Caches/com.openai.sky.CUAService" \
  "${HOME_DIR}/Library/Caches/com.openai.sky.CUAService.cli" \
  "${HOME_DIR}/Library/Logs/com.openai.codex" \
  "${HOME_DIR}/Library/HTTPStorages/com.openai.codex" \
  "${HOME_DIR}/Library/HTTPStorages/com.openai.sky.CUAService" \
  "${HOME_DIR}/Library/HTTPStorages/com.openai.sky.CUAService.cli" \
  "${HOME_DIR}/Library/Preferences/com.openai.codex.plist" \
  "${HOME_DIR}/Library/Preferences/com.openai.codex.installer.plist" \
  "${HOME_DIR}/Library/Preferences/com.openai.sky.CUAService.plist" \
  "${HOME_DIR}/Library/Preferences/com.openai.sky.CUAService.cli.plist" \
  "${HOME_DIR}/Library/Saved Application State/com.openai.codex.savedState" \
  "${HOME_DIR}/Library/Application Scripts/2DC432GLL2.com.openai.sky.CUAService" \
  "${HOME_DIR}/Library/Group Containers/2DC432GLL2.com.openai.sky.CUAService" \
  "${HOME_DIR}/Library/Group Containers/2DC432GLL2.com.openai.codex.notifications"; do
  add_target "$path"
done

# Native messaging manifests for the official browser bridge.
for browser_support in "Google/Chrome" "Microsoft Edge" "Chromium" "com.operasoftware.Opera" "Vivaldi"; do
  add_target "${HOME_DIR}/Library/Application Support/${browser_support}/NativeMessagingHosts/com.openai.codexextension.json"
done

# Official extension files only. Browser history, cookies, passwords, and other
# extensions are not selected.
browser_roots=(
  "${HOME_DIR}/Library/Application Support/Google/Chrome"
  "${HOME_DIR}/Library/Application Support/Microsoft Edge"
  "${HOME_DIR}/Library/Application Support/Chromium"
  "${HOME_DIR}/Library/Application Support/com.operasoftware.Opera"
  "${HOME_DIR}/Library/Application Support/Vivaldi"
)
for browser_root in "${browser_roots[@]}"; do
  [[ -d "$browser_root" ]] || continue
  while IFS= read -r -d '' path; do add_target "$path"; done < <(
    while IFS= read -r -d '' path; do
      printf '%s\0' "$path"
    done < <(find "$browser_root" -type d -name "*${EXTENSION_ID}*" -print0 2>/dev/null)
  )
done

printf '%s\n' "ChatGPT/Codex cleanup targets for ${USER:-current user}:"
if ((${#targets[@]} == 0)); then
  printf '  (none found)\n'
else
  printf '  %s\n' "${targets[@]}"
fi
printf '%s\n' '' 'Intentionally preserved:'
printf '%s\n' '  CC Switch and ~/.cc-switch (including provider/API configuration)' \
  '  Your projects, browser history, cookies, passwords, and unrelated extensions'

if ((execute == 0)); then
  printf '%s\n' '' 'Preview only. Nothing was deleted.'
  printf 'Run %s --execute to perform cleanup.\n' "$0"
  exit 0
fi

printf '%s' $'\nThis permanently removes the listed local data. Type DELETE_CHATGPT to continue: '
IFS= read -r confirmation
if [[ "$confirmation" != "$CONFIRM_WORD" ]]; then
  printf '%s\n' 'Confirmation did not match. Nothing was deleted.'
  exit 1
fi

if pgrep -x ChatGPT >/dev/null 2>&1; then
  osascript -e 'tell application "ChatGPT" to quit' >/dev/null 2>&1 || true
  sleep 1
fi
if pgrep -x ChatGPT >/dev/null 2>&1; then
  printf '%s\n' 'ChatGPT is still running. Quit it and run this script again.' >&2
  exit 1
fi
if pgrep -f '/Google Chrome.app/Contents/MacOS/Google Chrome' >/dev/null 2>&1 || \
   pgrep -f '/Microsoft Edge.app/Contents/MacOS/Microsoft Edge' >/dev/null 2>&1; then
  printf '%s\n' 'Chrome or Edge is still running. Quit all browser windows and run this script again.' >&2
  exit 1
fi
if pgrep -f '/CC Switch.app/' >/dev/null 2>&1; then
  printf '%s\n' 'CC Switch is still running. Quit it to prevent configuration write-back, then run this script again.' >&2
  exit 1
fi

removed=0
for path in "${targets[@]}"; do
  if [[ -e "$path" || -L "$path" ]]; then
    rm -rf -- "$path"
    printf 'Removed: %s\n' "$path"
    removed=$((removed + 1))
  fi
done

# Codex may store OAuth credentials in the macOS keychain instead of auth.json.
canonical_codex_home="$(cd "$CODEX_HOME" 2>/dev/null && pwd -P || printf '%s' "$CODEX_HOME")"
codex_hash="$(printf '%s' "$canonical_codex_home" | shasum -a 256 | awk '{print substr($1,1,16)}')"
for service_account in "Codex Auth|cli|${codex_hash}" "codex|secrets|${codex_hash}"; do
  service="${service_account%%|*}"
  account="${service_account#*|}"
  security delete-generic-password -s "$service" -a "$account" >/dev/null 2>&1 || true
done

printf '%s\n' '' "Cleanup complete. Removed ${removed} filesystem targets." \
  'CC Switch was left intact.'
