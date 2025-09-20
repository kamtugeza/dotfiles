download() {
  if [[ $# -ne 2 ]]; then
    err "Invalid arguments. Usage: download <source_url> <output_path>"
    exit 1
  fi

  local source_url="$1"
  local output_path="$2"

  if [[ -f "$output_path" ]]; then
    return 0
  fi
  
  make_dir "$(dirname "$output_path")"

  info "Downloading: $source_url"

  if ! curl -L "$source_url" -o "$output_path"; then
    err "Failed to download $source_url"
    exit 1
  fi

  info "Downloaded into: $output_path"
}
