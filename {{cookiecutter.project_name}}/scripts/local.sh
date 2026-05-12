#!/usr/bin/env bash
set -euo pipefail

TOML_FILE="pixi.toml"

TRUE_MARK="# local:true"
FALSE_MARK="# local:false"

fail() {
    echo "Error: $1" >&2
    exit 1
}

toggle_lines() {
    local mode="$1" # start | stop

    awk -v true_mark="$TRUE_MARK" -v false_mark="$FALSE_MARK" -v mode="$mode" '
        function is_commented(line) {
            return line ~ /^[[:space:]]*#/
        }

        function toggle_on(line) {
            sub(/^[[:space:]]*#[[:space:]]?/, "", line)
            return line
        }

        function toggle_off(line) {
            return is_commented(line) ? line : "# " line
        }

        {
            has_true_mark  = ($0 ~ true_mark)
            has_false_mark = ($0 ~ false_mark)
            needs_toggle = has_true_mark || has_false_mark

            if (needs_toggle) {
                toggle_switch = (mode == "start" && has_true_mark) || (mode == "stop" && has_false_mark)
                if (toggle_switch) {
                    print toggle_on($0)
                } else {
                    print toggle_off($0)
                }
                next
            }

            print
        }
    ' "$TOML_FILE" > "$TOML_FILE.tmp"

    mv "$TOML_FILE.tmp" "$TOML_FILE"
}

case "${1:-}" in
    start)
        toggle_lines "start"
        ;;
    stop)
        toggle_lines "stop"
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
