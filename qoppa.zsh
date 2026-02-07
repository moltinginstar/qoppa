[[ -n "${_qoppa_sourced:-}" ]] && return
_qoppa_sourced=1

if [[ -z "${QOPPA_VIEWER:-}" ]]; then
  if command -v mcat > /dev/null; then
    QOPPA_VIEWER=(mcat --paging always)
  elif command -v bat > /dev/null; then
    QOPPA_VIEWER=(bat --paging always)
  else
    QOPPA_VIEWER=(less -R)
  fi
fi

: "${QOPPA_PREFERRED_TOOLS:=fd, fzf, ripgrep, jq, git-filter-repo, uv}"

_qoppa_static_context="You are 'q' (short for Qoppa), a terse command-line assistant.
OS: $(uname -srm)
Shell: ${ZSH_NAME:-unknown}
Preferred tools: ${QOPPA_PREFERRED_TOOLS:-none}"

function _qoppa_extra_context() {
  :
}

typeset -ga _qoppa_thread

function _q() {
  [[ $# -lt 1 || -z "$1" ]] && return 1

  local mode="${2:-cmd}"
  if ! command -v lms > /dev/null; then
    print -ru2 -- "'lms' not found in PATH. Install LM Studio and the CLI."
    return 127
  fi

  _qoppa_last_output=""

  local extra_context
  extra_context="$(_qoppa_extra_context)"

  _qoppa_system_prompt="$_qoppa_static_context
PWD: $PWD${extra_context:+
$extra_context}"
  if [[ "$mode" == "cmd" ]]; then
    _qoppa_system_prompt="${_qoppa_system_prompt}

Your response will be pasted directly in the buffer; the user just has to press enter to run it.
So unless they ask otherwise, they probably want a shell command.
Whenever possible, return the best command to run.
NO Markdown, NO backticks, NO escaping, NO variants, NO comments, just the raw command."
  fi

  _qoppa_thread+=($'[user]\n'"$1")
  _qoppa_prompt="$(printf "%s\n\n" "${_qoppa_thread[@]}")"$'\n\n[assistant]\n'

  _qoppa_last_output="$(
    lms chat \
      --system-prompt "$_qoppa_system_prompt" \
      --prompt "$_qoppa_prompt"
  )" || return 1
  _qoppa_thread+=($'[assistant]\n'"$_qoppa_last_output")
}

function q() {
  [[ -z "$*" ]] && return

  _qoppa_thread=()

  _q "$*" > /dev/null || return
  print -z -- "$_qoppa_last_output"
}

function q!() {
  [[ -z "$*" ]] && return

  _q "$*" > /dev/null || return
  print -z -- "$_qoppa_last_output"
}

function qq() {
  [[ -z "$*" ]] && return

  _qoppa_thread=()

  _q "$*" explain > /dev/null || return
  "${QOPPA_VIEWER[@]}" <<< "$_qoppa_last_output"
}

function qq!() {
  [[ -z "$*" ]] && return

  _q "$*" explain > /dev/null || return
  "${QOPPA_VIEWER[@]}" <<< "$_qoppa_last_output"
}
