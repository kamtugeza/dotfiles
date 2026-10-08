hl.on("hyprland.start", function()
    -- Notifications
    hl.exec_cmd("swaync")

    -- Clipboard
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
