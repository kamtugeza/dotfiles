backup() {
  local path="$1"
  local backup_dir="${XDG_CACHE_HOME}/dotfile-backups"
  local backup_path="$backup_dir/${path#$HOME/}.bak.$(date +%Y-%m-%dT%H-%M-%SZ)"
  local flags="-a"

  make_dir "$(dirname "$backup_path")"

  if [[ -d "$path" && ! -L "$path" ]]; then
    flags="-ar"
  fi

  if ! output=$(cp "$flags" -- "$path" "$backup_dir" 2>&1); then
    err "$output"
    exit 1
  fi

  info "Backup: $backup_path"

  return 0
}

copy() {
  local source="${1:-}"
  local target="${2:-}"

  if [[ -z "$source" && ! -e "$source" ]]; then
    err "Source not found: $source" 
    exit 1
  fi

  if [[ -z "$target" ]]; then
    err "No target path specified"
    exit 1
  fi

  local action="Created"

  if [[ -e "$target" ]]; then 
    warn "Found: $target"
    action="Overwritten"

    if ! $FORCE; then
      backup "$target"
    fi
  fi

  make_dir "$(dirname "$target")"

  local flags="-a"

  if [[ -d "$source" && ! -L "$source" ]]; then
    flags="-ar"
  fi

  if ! output=$(cp "$flags" -- "$source" "$target" 2>&1); then  
    err "$output"
    exit 1
  fi

  info "$action: $target"

  return 0
}

make_dir() {
  for dir in "$@"; do
    if [[ ! -d $dir ]]; then 

      if ! output=$(mkdir -p "$dir" 2>&1); then
        err "$output"
        exit 1
      fi

      info "Created: $dir"
    fi
  done
}