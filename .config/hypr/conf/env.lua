-- Environment variables (incl. NVIDIA)
local lang = os.getenv("LANG") or ""
local home = os.getenv("HOME") or ""

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "Arc-Dark")
hl.env("LC_CTYPE", lang)
hl.env("LC_NUMERIC", lang)
hl.env("LC_TIME", lang)
hl.env("LC_COLLATE", lang)
hl.env("LC_MONETARY", lang)
hl.env("LC_MESSAGES", lang)
hl.env("LC_PAPER", lang)
hl.env("LC_NAME", lang)
hl.env("LC_ADDRESS", lang)
hl.env("LC_TELEPHONE", lang)
hl.env("LC_MEASUREMENT", lang)
hl.env("LC_IDENTIFICATION", lang)
hl.env("LC_ALL", "")

-- hyprcursor
hl.env("HYPRCURSOR_THEME", "Nordzy-cursors")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
-- https://github.com/hyprwm/Hyprland/issues/2591
hl.env("FCITX_DATA_HOME", home .. "/.config/fcitx5/data")

-- NVIDIA-specific environment variables
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("__GL_GSYNC_ALLOWED", "0")
hl.env("__GL_VRR_ALLOWED", "0")
