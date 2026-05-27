#!/usr/bin/env bash
set -u

mode="${1:-full}"
dir="$HOME/Pictures/Screenshots"
timestamp="$(date +%F_%H-%M-%S)"
full_path="${dir}/${timestamp}.png"
region_path="${dir}/${timestamp}_region.png"

have() {
    command -v "$1" >/dev/null 2>&1
}

notify() {
    notify-send "Screenshot" "$1"
}

copy_image() {
    if have wl-copy; then
        wl-copy --type image/png < "$1"
    fi
}

mkdir -p "$dir"

case "$mode" in
    full)
        if ! have grim; then
            notify "Missing grim. Install grim for screenshots."
            exit 1
        fi

        if grim "$full_path"; then
            copy_image "$full_path"
            notify "Saved full screenshot to $full_path"
        else
            notify "Could not capture full screenshot."
            exit 1
        fi
        ;;
    region)
        if ! have grim || ! have slurp; then
            notify "Missing grim and/or slurp. Install both for region screenshots."
            exit 1
        fi

        geometry="$(slurp)" || exit 1
        if [ -z "$geometry" ]; then
            exit 1
        fi

        if grim -g "$geometry" "$region_path"; then
            copy_image "$region_path"
            notify "Saved region screenshot to $region_path"
        else
            notify "Could not capture region screenshot."
            exit 1
        fi
        ;;
    *)
        notify "Unknown screenshot mode: $mode"
        exit 1
        ;;
esac
