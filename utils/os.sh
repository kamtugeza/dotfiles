is_ubuntu() {
  [[ "$OS" == "Linux" ]] && [[ "$ARCH" == "x86_64" ]]
}

is_mac() {
  [[ "$OS" == "Darwin" ]] && [[ "$ARCH" == "arm64" ]]
}
