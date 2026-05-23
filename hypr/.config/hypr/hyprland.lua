-- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "1920x0", scale = "1.25" })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@144", position = "0x0", scale = "1" })

-- Bind specific workspaces to monitors
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })

hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })

-- Set programs that you use
local terminal = "ghostty"
local fileManager = "dolphin"
local menu = "fuzzel"

-- Some default env vars.
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GTK_IM_MODULE", "simple")

hl.env("EDITOR", "nvim")

-- Execute apps at launch
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar && swaync && hypridle")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("wl-paste --type text --watch cliphist store # Stores only text data")
	hl.exec_cmd("wl-paste --type image --watch cliphist store # Stores only image data")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	hl.exec_cmd("xdg-settings set default-web-browser app.zen_browser.zen.desktop")

	-- Fix for ZapZap APP
	hl.exec_cmd(
		"flatpak override --user --filesystem=/usr/share/fonts:ro io.github.zapzap ; flatpak override --user--filesystem=/etc/fonts:ro io.github.zapzap ; flatpak override --reset io.github.zapzap"
	)

	-- Default applications for workspaces
	hl.exec_cmd("ghostty --command=tmux", { workspace = "1 silent" })
	hl.exec_cmd("flatpak run app.zen_browser.zen", { workspace = "2 silent" })
	hl.exec_cmd("snap run obsidian", { workspace = "4 silent" })
	hl.exec_cmd("flatpak run com.rtosta.zapzap", { workspace = "6 silent" })
	hl.exec_cmd("ghostty --command=btop", { workspace = "9 silent" })
end)

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
hl.config({
	input = {
		kb_layout = "br",
		-- kb_layout = "us",
		kb_variant = "",
		kb_model = "abnt2",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		numlock_by_default = true,

		touchpad = {
			natural_scroll = false,
		},

		sensitivity = 0,
	},

	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",

		allow_tearing = false,
	},

	decoration = {
		rounding = 4,

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
		},

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		force_default_wallpaper = -1,
	},

	dwindle = {
		preserve_split = true, -- You probably want this
	},

	scrolling = {
		fullscreen_on_one_column = true,
	},

	cursor = {
		no_hardware_cursors = true,
	},
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})
--
local mainMod = "SUPER"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(" Print", function()
	hl.exec_cmd("hyprshot -m window --clipboard-only")
end)
hl.bind("SHIFT + Print", function()
	hl.exec_cmd("hyprshot -m region --clipboard-only")
end)
hl.bind(mainMod .. "+ V", function()
	hl.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy")
end)

hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
