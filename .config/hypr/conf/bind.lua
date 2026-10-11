-- Keybinds

-- Terminal / Apps
hl.bind("SUPER + RETURN",         hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + c",              hl.dsp.exec_cmd("~/.local/bin/x-www-browser"))
hl.bind("SUPER + SHIFT + c",      hl.dsp.exec_cmd("~/.local/bin/x-www-browser -incognito"))
hl.bind("SUPER + o", hl.dsp.exec_cmd([[xdg-open "$(find ~/Downloads -type f -not -name ".*" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)"]]))

-- Session
hl.bind("SUPER + SHIFT + e",      hl.dsp.exec_cmd([[walker --provider "menus:power"]]))
hl.bind("SUPER + p",              hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + SHIFT + period", hl.dsp.exec_cmd("systemctl suspend"))

-- Audio / Brightness (repeating = bindel, locked = bindl)
local RL = { repeating = true, locked = true }
local L  = { locked = true }
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), RL)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), RL)
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), L)
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), L)
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"), RL)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), RL)

-- Media player controls
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), L)
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), L)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"), L)
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), L)

-- Reload (hl.dsp.reload_config is absent in 0.56.2)
hl.bind("SUPER + SHIFT + r", hl.dsp.exec_cmd("hyprctl reload"))

-- rofi
hl.bind("SUPER + d", hl.dsp.exec_cmd("rofi -show drun"))

-- Group
hl.bind("SUPER + g",       hl.dsp.group.toggle())
hl.bind("SUPER + Tab",     hl.dsp.group.next())
hl.bind("SUPER + n",       hl.dsp.group.prev())
hl.bind("SUPER + ALT + h", hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind("SUPER + ALT + l", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind("SUPER + ALT + k", hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind("SUPER + ALT + j", hl.dsp.window.move({ direction = "down",  group_aware = true }))

-- Mouse
hl.bind("SUPER + mouse:272",         hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273",         hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

-- Window
hl.bind("SUPER + SHIFT + q", hl.dsp.window.close())
hl.bind("ALT + F4",          hl.dsp.window.close())
-- fullscreen 0 = true fullscreen (covers waybar); 1 = maximize (honours waybar's reserved zone)
hl.bind("SUPER + f",          hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + f",  hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + SHIFT + space", hl.dsp.window.float())
hl.bind("SUPER + CTRL + space",  hl.dsp.window.float())
-- legacy `resizeactive exact 50% 50%`: percent-exact is not expressible, compute from monitor
hl.bind("SUPER + equal", function()
    local m = hl.get_active_monitor()
    if not m then return end
    hl.dispatch(hl.dsp.window.resize({
        x = math.floor(m.width / m.scale * 0.5),
        y = math.floor(m.height / m.scale * 0.5),
        relative = false,
    }))
end)
hl.bind("SUPER + SHIFT + backslash", hl.dsp.layout("preselect r"))
hl.bind("SUPER + minus",             hl.dsp.layout("preselect d"))

-- Focus
hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + h",     hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + l",     hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + k",     hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + j",     hl.dsp.focus({ direction = "down" }))

-- Move window
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + CTRL + h",  hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + l",  hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + CTRL + k",  hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + CTRL + j",  hl.dsp.window.move({ monitor = "d" }))

-- Workspace
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind("SUPER + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind("SUPER + CTRL + SHIFT + h", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + SHIFT + l", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind("SUPER + M",                hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind("SUPER + mouse_down",       hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up",         hl.dsp.focus({ workspace = "e-1" }))

-- Resize submap
hl.bind("SUPER + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    local R = { repeating = true }
    hl.bind("h",     hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), R)
    hl.bind("j",     hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), R)
    hl.bind("k",     hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), R)
    hl.bind("l",     hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), R)
    hl.bind("left",  hl.dsp.window.resize({ x = -40, y = 0,   relative = true }), R)
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 40,  relative = true }), R)
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -40, relative = true }), R)
    hl.bind("right", hl.dsp.window.resize({ x = 40,  y = 0,   relative = true }), R)
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Toggle waybar visibility
hl.bind("SUPER + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
