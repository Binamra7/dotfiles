-- Port of config.d/window-rule.conf
hl.window_rule({ match = { class = "^(GTK Application)$" }, size = "50% 70%" })
hl.window_rule({ match = { class = "^(GTK Application)$" }, center = true })
hl.window_rule({ match = { fullscreen = true }, border_size = 0 })

-- no gaps in fullscreen
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

-- assign apps to dedicated workspaces (i3 `assign` equivalent). Match strings are
-- the Wayland app_id / class from `hyprctl clients`. `silent` opens the window on
-- its workspace without switching focus there, like i3 `assign`.
hl.window_rule({ match = { class = "^(neovide)$" },                    workspace = "1 silent" })
hl.window_rule({ match = { class = "^(com.mitchellh.ghostty)$" },      workspace = "2 silent" })
hl.window_rule({ match = { class = "^(google-chrome)$" },              workspace = "3 silent" })
hl.window_rule({ match = { class = "^(firefox-developer-edition)$" },  workspace = "4 silent" })
