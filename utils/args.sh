parse_args() {
  while [[ $# -gt 0 ]]; do
    case $1 in

      --force|-f)
        FORCE=true
        shift
        ;;

      --help|-h)
        echo "Usage: $(basename "$0") [OPTIONS]"
        echo ""
        echo "Options:"
        echo "--force, -f     Overwrite existing files without backup."
        echo "--help, -h      Show help message."
        exit 0
        ;;

      *)
        err "Unknown option: $1"
        exit 1
        ;;

    esac
  done
}