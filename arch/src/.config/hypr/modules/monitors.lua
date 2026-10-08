hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -i ~/.local/share/wallpapers/000-fantasy-landscape.jpg -m fill")
end)

hl.monitor({
    output   = "DP-2",
    mode     = "5120x2160@60",
    position = "auto",
    scale    = "1.67",
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})
