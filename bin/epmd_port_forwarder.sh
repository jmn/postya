#! /bin/bash -

# Unoffical Bash "strict mode"
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
#ORIGINAL_IFS=$IFS
IFS=$'\t\n' # Stricter IFS settings

usage() {
    cat <<EOF
    This script SSHs into a remote server, runs an epmd command to get the port
    numbers of all running Erlang nodes, then uses SSH port forwarding to
    forward all the ports to localhost. This allows remsh'ing into Erlang nodes
    as if they were on your local machine. This makes running observer on a
    node running on another machine trivial.

    Usage: epmd_port_forwarder [options]

    Options:
    --server                             Hostname of the remote server running
                                         epmd
    --only-epmd                          Whether or not to forward ports to all
                                         Erlang nodes
EOF
}

error_exit() {
    usage
    exit 1
}

get_value() {
  raw_flag=$1
  first=${1#*'='}
  second=$2

  # If the raw flag contains an equals sign and the value after it (first) is
  # not null return first, otherwise return the next argument (second)
  if [[ "$raw_flag" == *=* ]] && [ -n "$first" ]; then
    echo "$first"
  else
    if [[ "$second" == -* ]]; then
      echo "$second"
    else
      echo "$second"
    fi
  fi
}

get_shift_count() {
  if [[ "$1" == *=* ]]; then
    echo "1"
  else
    echo "2"
  fi
}

server=""
only_epmd=false

while :; do
    case ${1:-} in
        -h|-\?|--help)
            usage
            exit
            ;;
        -s|--server|--server=*)
            server=$(get_value "$1" "${2:-}")
            shift $(get_shift_count "$1")
            ;;
        -o|--only-epmd)
            only_epmd=true
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            if [ -z "${1:-}" ]; then
                shift
                break
            else
                echo "Unknown option ${1:-}"
                error_exit
            fi
    esac
done

# Make sure required arguments are present
if [ -z "$server" ]; then
    error_exit
fi

# Make sure no local epmd is running
# if epmd isn't running and this command returns a non-zero exit code we don't care
epmd -kill || true
echo "Killed local epmd"

# SSH into server and find epmd port
epmd_names=$(ssh "$server" "epmd -names")
echo "$epmd_names"

# Extract port numbers from epmd output
port_numbers=()

# if we are only forwarding the epmd port discard the other lines in the output
if $only_epmd; then
    epmd_names=$(echo "$epmd_names" | head -n1)
fi

# Grab the port number on each line of the epmd output and build the forwarding
# option from it
while read -r epmd_line
do
    port=$(echo "$epmd_line" | sed 's/.*port //g; s/[^0-9]*//g')
    port_numbers+=(-L $port:localhost:$port)
done <<< "$epmd_names"

# Forward epmd port(s) to localhost
echo "Forwarding ports"
set -x
ssh -N "${port_numbers[@]}" $server