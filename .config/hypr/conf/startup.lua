-- Startup commands (hyprland.start) and their keybinds

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprctl setcursor Nordzy-cursors 24")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprsunset -t 4500")

    -- Sound
    hl.exec_cmd("systemctl --user start pipewire pipewire-pulse wireplumber")

    -- Lock (keybind lives in bind.lua: SUPER+p)
    hl.exec_cmd("hypridle")

    -- Notification
    hl.exec_cmd("dunst")

    -- walker
    hl.exec_cmd("GSK_RENDERER=cairo LANG=en_US.UTF-8 walker --gapplication-service")
    hl.exec_cmd("elephant")

    -- cliphist (Wayland-only wl-paste watchers)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- text only
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- image only
end)

-- Waybar restart
-- (plain `waybar`: `hyprctl dispatch exec` no longer works under the Lua config)
hl.bind("SUPER + w", hl.dsp.exec_cmd("pkill waybar && waybar"))

-- Notifications
hl.bind("SUPER + BackSpace",         hl.dsp.exec_cmd("dunstctl close"))
hl.bind("SUPER + SHIFT + BackSpace", hl.dsp.exec_cmd("dunstctl close_all"))
hl.bind("SUPER + grave",             hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind("SUPER + SHIFT + grave",     hl.dsp.exec_cmd("dunstctl context"))
hl.bind("SUPER + CTRL + grave",      hl.dsp.exec_cmd("dunstctl action"))

-- walker
hl.bind("SUPER + space", hl.dsp.exec_cmd("walker"))

-- cliphist via rofi (walker's clipboard provider keeps a separate history)
hl.bind("SUPER + backslash", hl.dsp.exec_cmd([[cliphist list | rofi -dmenu -display-columns 2 -p clipboard | cliphist decode | wl-copy]]))

-- Screenshots
hl.bind("Print",         hl.dsp.exec_cmd([[mkdir -p ~/Pictures/screenshots && grim ~/Pictures/screenshots/$(date +'%Y%m%d_%H%M%S').png]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | swappy -f -]]))
