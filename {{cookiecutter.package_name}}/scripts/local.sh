#!/usr/bin/env bash
set -euo pipefail

TOML_FILE="pixi.toml"
LOCAL_FILE=".local.txt"

PLACE_MARKER="# local dependencies placeholder"
START_MARKER="# local dependencies start"
END_MARKER="# local dependencies end"

fail() {
    echo "Error: $1" >&2
    exit 1
}

remove_local_deps() {
    awk -v start="$START_MARKER" -v end="$END_MARKER" -v place="$PLACE_MARKER" '
    {
        if ($0 == start) {
            print place
            while (getline) {
                if ($0 == end) {
                    break
                }
            }
            next
        }
        print
    }
    ' "$TOML_FILE" > "$TOML_FILE.tmp"

    mv "$TOML_FILE.tmp" "$TOML_FILE"
}

add_local_deps() {
    [[ -f "$LOCAL_FILE" ]] || fail "$LOCAL_FILE not found"

    remove_local_deps

    awk -v start="$START_MARKER" -v end="$END_MARKER" -v place="$PLACE_MARKER" -v insert_file="$LOCAL_FILE" '
    {
        if ($0 == place) {
            print start
            while ((getline line < insert_file) > 0) {
                print line
            }
            close(insert_file)
            print end
            next
        }
        print
    }
    ' "$TOML_FILE" > "$TOML_FILE.tmp"

    mv "$TOML_FILE.tmp" "$TOML_FILE"
}

case "${1:-}" in
    start)
        add_local_deps
        ;;
    stop)
        remove_local_deps
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
