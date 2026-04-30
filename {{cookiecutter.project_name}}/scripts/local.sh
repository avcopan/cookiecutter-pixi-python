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

apply_and_reinstall_if_changed() {
    local tmp_file="$1"

    if ! cmp -s "$TOML_FILE" "$tmp_file"; then
        mv "$tmp_file" "$TOML_FILE"
        echo "Updated $TOML_FILE → running pixi reinstall"
        pixi reinstall -e dev
    else
        rm "$tmp_file"
        echo "No changes to $TOML_FILE"
    fi
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

    apply_and_reinstall_if_changed "$TOML_FILE.tmp"
}

add_local_deps() {
    [[ -f "$LOCAL_FILE" ]] || fail "$LOCAL_FILE not found"

    # First normalize file (removes any existing block)
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

    apply_and_reinstall_if_changed "$TOML_FILE.tmp"
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
