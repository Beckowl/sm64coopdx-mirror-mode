gMirrorEnabled = mod_storage_load_bool("mirrorEnabled") or not mod_storage_exists("mirrorEnabled")
gFlipCButtons = mod_storage_load_bool("flipCButtons")

local function mirror_checkbox(_, value)
    gMirrorEnabled = value

    if value then
        replace_directional_dialogs()
    else
        restore_directional_dialogs()
    end

    mod_storage_save_bool("mirrorEnabled", value)
end

local function flip_c_buttons_checkbox(_, value)
    gFlipCButtons = value
    mod_storage_save_bool("flipCButtons", value)
end

hook_mod_menu_checkbox("Flip C buttons (VANILLA CAMERA ONLY)", gFlipCButtons, flip_c_buttons_checkbox)
hook_mod_menu_checkbox("Mirroring enabled", gMirrorEnabled, mirror_checkbox)
