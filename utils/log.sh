msg() {
  printf "[%s] %s\n" "${1^^}" "$2"  
}

err() {
  msg "ERROR" "$1"
}

info() {
  msg "INFO" "$1"
}

warn() {
  msg "WARN" "$1"
}
