home_relative() {
  local path="${1}"

  case "${path}" in
    "${HOME}")
      printf '~'
      ;;
    "${HOME}"/*)
      printf '~/%s' "${path#"${HOME}/"}"
      ;;
    *)
      printf '%s' "${path}"
      ;;
  esac
}
