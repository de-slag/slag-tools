function read_cli_args {
  for i in "$@"
  do
  case $i in

    -h|--help)
      echo "this is a help template"
      shift
      ;;

    -c=*|--config=*)
      CONFIG="${i#*=}"
      shift
      ;;

    *)
     log_warn "'read_cli_args' unknown option: '$i', skipped"
          # unknown option
      ;;
  esac
  done
}
read_cli_args "$@"
