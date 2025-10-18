backup() {
  local path="$1"
  local backup_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfile-backups"
  local backup_path="$backup_dir/${path#$HOME/}.bak.$(date +%Y-%m-%dT%H-%M-%SZ)"
  local flags="-a"

  make_dir "$(dirname "$backup_path")"

  if [[ -d "$path" && ! -L "$path" ]]; then
    flags="-ar"
  fi

  if ! output=$(cp "$flags" -- "$path" "$backup_path" 2>&1); then
    err "$output"
    return 1
  fi

  info "Backup: $path -> $backup_path"

  return 0
}

err() {
  local trace="${2:-true}"
  msg "ERROR" "$1"

  if [[ $trace == "true" ]]; then
    local i=5
    local line func file
    while [[ $i -ge 0 ]]; do
      read -r line func file <<< "$(caller $i)"

      if [[ ! -z $line && ! -z $file ]]; then
        msg "ERROR" "  $file:$line"
      fi

      (( i-- ))
    done
  fi
}

has_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    warn "Command not found: $1"
    return 1
  fi

  return 0
}

info() {
  msg "INFO" "${1:-}"
}

input_var() {
  local name=${1:-}
  local default=${!name:-}
  local question=${2:-}
  local label=${3:-}

  info "$question"
  local value=$(gum input --value "$default")
  info "$label: $value"

  if [[ "$value" == "$default" ]]; then
    return 0
  fi

  if [[ -z "$value" ]]; then
    err "Value cannot be empty."
    return 1
  fi
  
  declare -g "$name"="$value"
  echo "export $name=\"$value\"" >> "${XDG_CACHE_HOME}/.exports"

  return 0
}

is_mac() {
  [[ "$OS" == "Darwin" ]] && [[ "$ARCH" == "arm64" ]]
}

is_ubuntu() {
  [[ "$OS" == "Linux" ]] && [[ "$ARCH" == "x86_64" ]]
}

link() {
  local source=${1:-}
  local target=${2:-}

  if [[ ! -e "$source" ]]; then
    err "Source not found: $source"
    return 1
  fi

  if [[ -e "$target" && ! -L "$target" ]]; then
    warn "Found: $target"
    backup "$target"
  fi

  if [[ -d "$source" && ! -L "$source" ]]; then 
    local target_dir="$target"
  elif [[ -f "$source" && ! -L "$source" ]]; then
    local target_dir="$(dirname "$target")"
  else
    err "Source is neither a file nor a directory: $source"
    return 1
  fi

  make_dir "$target_dir"
  ln -sf "$source" "$target"
  info "Linked: $source -> $target"
}

make_dir() {
  for dir in "$@"; do
    if [[ ! -d "$dir" ]]; then
      if ! output=$(mkdir -p "$dir" 2>&1); then 
        err "$output"
        return 1
      fi
    fi
  done
}

msg() {
  printf "[%s] %s\n" "${1^^}" "$2"
}

warn() {
  msg "WARN" "$1"
}
