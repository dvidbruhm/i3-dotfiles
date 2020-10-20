rofi="/home/david/.config/rofi/themes/colors.rasi"
polybar="/home/david/.config/polybar/config"
dunst="/home/david/.config/dunst/dunstrc"
neovim="/home/david/.config/nvim/general.vim"
xfceterm="/home/david/.config/xfce4/terminal/terminalrc"
i3="/home/david/.config/i3/config"
gtk="/home/david/.config/gtk-3.0/settings.ini"

currenttheme="/home/david/.config/scripts/current_theme"
xfce4lighttheme="/home/david/.config/scripts/xfce4_term_onelight.theme"
xfce4darktheme="/home/david/.config/scripts/xfce4_term_onedark.theme"

gtklight="Arc-Lighter"
gtkdark="Arc-Dark"

dark=#424242
light=#ffffff
darktrans=#55424242
lighttrans=#aaffffff

fromdark=#424242
fromlight=#ffffff
fromdarktrans=#55424242
fromlighttrans=#aaffffff

function darktolight {
    # Set current theme
    echo light > $currenttheme

    # Change polybar colors
    sed -i "s/bg = $fromdarktrans/bg = $lighttrans/g" $polybar
    sed -i "s/fg = $fromlight/fg = $dark/g" $polybar

    # Change rofi theme colors
    sed -i "s/foreground: $fromlight/foreground: $dark/g" $rofi
    sed -i "s/foreground-trans: ${fromlight}cc/foreground-trans: ${dark}cc/g" $rofi
    sed -i "s/foreground-null: ${fromlight}00/foreground-null: ${dark}00/g" $rofi

    sed -i "s/background: $fromdark/background: $light/g" $rofi
    sed -i "s/background-trans: ${fromdark}cc/background-trans: ${light}cc/g" $rofi
    sed -i "s/background-null: ${fromdark}00/background-null: ${light}00/g" $rofi

    # Change dunst theme
    sed -i "s/foreground = \"$fromlight\"/foreground = \"$dark\"/g" $dunst
    sed -i "s/background = \"$fromdark\"/background = \"$light\"/g" $dunst
    sed -i "s/frame_color = \"$fromlight\"/frame_color = \"$dark\"/g" $dunst

    # Change vim background
    sed -i "s/set background=dark/set background=light/g" $neovim

    # Change xfce4 terminal theme
    a=$(sed 's/Color.*//g' $xfceterm)
    b=$(cat $xfce4lighttheme)
    c="$a\n$b"
    echo "$c" > $xfceterm

    # Change i3 colors
    temp=#xxxxxx
    sed -i "s/$fromlight/$temp/g" $i3
    sed -i "s/$fromdark/$light/g" $i3
    sed -i "s/$temp/$dark/g" $i3

    # Change gtk theme
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtklight/g" $gtk

    # Set spotify theme
    spicetify config current_theme Dribbblish color_scheme Nord-Light
    spicetify apply
}

function lighttodark {
    # Set current theme
    echo dark > $currenttheme

    # Change polybar colors
    sed -i "s/fg = $fromdark/fg = $light/g" $polybar
    sed -i "s/bg = $fromlighttrans/bg = $darktrans/g" $polybar

    # Change rofi theme colors
    sed -i "s/background: $fromlight/background: $dark/g" $rofi
    sed -i "s/background-trans: ${fromlight}cc/background-trans: ${dark}cc/g" $rofi
    sed -i "s/background-null: ${fromlight}00/background-null: ${dark}00/g" $rofi

    sed -i "s/foreground: $fromdark/foreground: $light/g" $rofi
    sed -i "s/foreground-trans: ${fromdark}cc/foreground-trans: ${light}cc/g" $rofi
    sed -i "s/foreground-null: ${fromdark}00/foreground-null: ${light}00/g" $rofi

    # Change dunst theme
    sed -i "s/foreground = \"$fromdark\"/foreground = \"$light\"/g" $dunst
    sed -i "s/background = \"$fromlight\"/background = \"$dark\"/g" $dunst
    sed -i "s/frame_color = \"$fromdark\"/frame_color = \"$light\"/g" $dunst

    # Change vim background
    sed -i "s/set background=light/set background=dark/g" $neovim

    # Change xfce4 terminal theme
    a=$(sed -e '1h;2,$H;$!d;g' -re "s/Name=.*//g" $xfceterm)
    b=$(cat $xfce4darktheme)
    c="$a\n$b"
    echo "$c" > $xfceterm

    # Change i3 colors
    temp=#xxxxxx
    sed -i "s/$fromlight/$temp/g" $i3
    sed -i "s/$fromdark/$light/g" $i3
    sed -i "s/$temp/$dark/g" $i3

    # Change gtk theme
    sed -i "s/gtk-theme-name=.*/gtk-theme-name=$gtkdark/g" $gtk

    # Set spotify theme
    spicetify config current_theme Dribbblish color_scheme Nord-Dark
    spicetify apply
}

function restartall {
    # Restart dunst
    killall dunst;notify-send "Restart" "Dunst updated colors"
    # Restart i3
    i3-msg reload
}

isdarktheme=$(grep -q "dark" $currenttheme; [ $? -eq 0 ] && echo "yes" || echo "no")
echo $isdarktheme

if [[ $1 = light && $isdarktheme == "yes" ]];
then
    darktolight
    echo 盛
    restartall
elif [[ $1 = dark && $isdarktheme == "no" ]];
then
    lighttodark
    echo 
    restartall
else
    echo "Choose dark or light."
fi
