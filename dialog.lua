-- This code swaps "left" and "right" directions in some dialog boxes
-- to match the mirrored layout of the world, so the directions 
-- in the text remain correct from the player's POV.

local directionalDialogs = {
    DIALOG_001,
    DIALOG_088,
    DIALOG_089,
    DIALOG_122,
    DIALOG_123,
    DIALOG_127,
    DIALOG_138,
    DIALOG_140
}

local replacements = {
    left = "right",
    Left = "Right",
    right = "left",
    Right = "Left"
}

local replacedDialogs = {}

function replace_directional_dialogs()
    for _, v in ipairs(directionalDialogs) do
        if not smlua_text_utils_dialog_is_replaced(v) then
            local dialog = smlua_text_utils_dialog_get(v)
            local text = dialog.text:gsub("%w+", replacements)

            smlua_text_utils_dialog_replace(v, dialog.unused, dialog.linesPerBox, dialog.leftOffset, dialog.width, text)
            replacedDialogs[v] = true
        end
    end
end

function restore_directional_dialogs()
    for _, v in ipairs(directionalDialogs) do
        if replacedDialogs[v] then
            smlua_text_utils_dialog_restore(v)
        end
    end

    replacedDialogs = {}
end

hook_event(HOOK_ON_MODS_LOADED, replace_directional_dialogs)