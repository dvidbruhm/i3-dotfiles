#!/usr/bin/env bash
rofi_command="rofi -theme themes/appmenu"

# Options
shutdown="襤"
reboot="ﰇ"
lock=""

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 0)"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        i3lock
        ;;
esac

