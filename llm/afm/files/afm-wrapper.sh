#!/bin/sh

config_path=@@CONFIG_PATH@@
env_file="$config_path/@@ENV_FILE@@"
args_file="$config_path/@@ARGS_FILE@@"
afm_bin=@@AFM_HOME@@/afm

# Match apfel's environment-file approach. An argument and its value may share
# a line; text after the first whitespace is one value. A matching outer pair
# of single or double quotes is optional and removed without shell evaluation.
if [ -f "$env_file" ]; then
    set -a
    . "$env_file"
    set +a
fi

if [ -z "${AFM_USER:-}" ]; then
    echo "Set AFM_USER in $env_file to a user with Apple Intelligence enabled" >&2
    exit 1
fi

case "$AFM_USER" in
    \#*)
        afm_uid=${AFM_USER#\#}
        case "$afm_uid" in
            ''|*[!0-9]*)
                echo "AFM_USER must be a username or a numeric UID prefixed with #: $AFM_USER" >&2
                exit 1
                ;;
        esac
        ;;
    *)
        if ! afm_uid=$(/usr/bin/id -u "$AFM_USER" 2>/dev/null); then
            echo "AFM_USER does not name an existing user: $AFM_USER" >&2
            exit 1
        fi
        ;;
esac

set --
if [ -f "$args_file" ]; then
    while IFS= read -r arg || [ -n "$arg" ]; do
        arg=${arg#"${arg%%[![:space:]]*}"}
        arg=${arg%"${arg##*[![:space:]]}"}
        case "$arg" in
            ''|'#'*) continue ;;
        esac
        case "$arg" in
            *[[:space:]]*)
                flag=${arg%%[[:space:]]*}
                value=${arg#"$flag"}
                value=${value#"${value%%[![:space:]]*}"}
                case "$value" in
                    \"*\") value=${value#\"}; value=${value%\"} ;;
                    \'*\') value=${value#\'}; value=${value%\'} ;;
                esac
                set -- "$@" "$flag" "$value"
                ;;
            *) set -- "$@" "$arg" ;;
        esac
    done < "$args_file"
fi

# A LaunchDaemon needs the configured user's bootstrap namespace to reach
# per-user Apple services such as naturallanguaged. sudo changes credentials,
# but not that namespace, so it must run inside launchctl asuser.
exec /bin/launchctl asuser "$afm_uid" \
    /usr/bin/sudo -nHEu "#$afm_uid" "$afm_bin" "$@"
