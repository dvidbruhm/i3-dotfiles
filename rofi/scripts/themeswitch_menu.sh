rofi_command="rofi -theme themes/appmenu"

light=""
dark=""

options="$light\n$dark"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected_row 0)"
case $chosen in
    $light)
        ~/.config/scripts/toggle_dark_light.sh light
        ;;
    $dark)
        ~/.config/scripts/toggle_dark_light.sh dark
        ;;
esac
