msg() {
  printf "[%s] %s\n" "${1^^}" "$2"  
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

info() {
  msg "INFO" "${1:-}"
}

warn() {
  msg "WARN" "$1"
}
