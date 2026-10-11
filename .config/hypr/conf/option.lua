-- Port of config.d/option.conf
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,
        border_size = 2,
        col = {
            active_border = "rgba(285577ff)",   -- 0xff285577
            inactive_border = "rgba(33333366)", -- 0x66333333
        },
    },

    input = {
        kb_layout = "",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 1,
        sensitivity = -0.2,
        repeat_rate = 50,
        repeat_delay = 500,
        scroll_factor = 1.0,

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        no_hardware_cursors = true, -- required on NVIDIA
        inactive_timeout = 5,
    },

    decoration = {
        rounding = 10,
        blur = {
            size = 2,
            passes = 2,
            noise = 0.0, -- 0 = clean (no film-grain through transparent windows)
        },
    },

    animations = {
        enabled = true,
    },

    opengl = {
        nvidia_anti_flicker = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },

    debug = {
        disable_logs = true,
    },
})

hl.animation({ leaf = "windows",    enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "border",     enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

-- Lower the sensitivity of the touchpad
hl.device({
    name = "dell0a7e:00-04f3:3147-touchpad",
    sensitivity = 0.0,
})
