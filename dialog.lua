-- This code swaps "left" and "right" directions in some dialog boxes
-- to match the mirrored layout of the world, so the directions 
-- in the text remain correct from the player's POV.

local replacedDialogs = {}

-- Let's make sure we don't replace any romhack dialogs

local dialog_replace = smlua_text_utils_dialog_replace

_G.smlua_text_utils_dialog_replace = function(dialogID, ...)
    replacedDialogs[dialogID] = true
    dialog_replace(dialogID, ...)
end

local function dialog_replace_internal(dialogID,...)
    if not replacedDialogs[dialogID] then
        dialog_replace(dialogID, ...)
    end
end

-- "But Timber, why don't you do pattern matching?"
-- The words "left" and "right" aren't always directional.
-- And i'm not going to do freaking context analysis just for this

local function replace_dialogs()
    dialog_replace_internal(DIALOG_001, 1, 4, 95, 200, "Watch out! If you wander\naround here, you're liable\nto be plastered by a\nwater bomb!\nThose enemy Bob-ombs love\nto fight, and they're\nalways finding ways to\nattack.\nThis meadow has become\na battlefield ever since\nthe Big Bob-omb got his\npaws on the Power Star.\nCan you recover the Star\nfor us? Cross the bridge\nand go right up the path\nto find the Big Bob-omb.\nPlease come back to see\nme after you've retrieved\nthe Power Star!")
    dialog_replace_internal(DIALOG_088, 1, 5, 30, 200, "Work Elevator\nFor those who get off\nhere: Grab the pole to the\nright and slide carefully\ndown.")
    dialog_replace_internal(DIALOG_089, 1, 5, 95, 200, "Both ways fraught with\ndanger! Watch your feet!\nThose who can't do the\nLong Jump, tsk, tsk. Make\nyour way to the left.\nLeft: Work Elevator\n/// Cloudy Maze\nRight: Black Hole\n///Underground Lake\n\nRed Circle: Elevator 2\n//// Underground Lake\nArrow: You are here")
    dialog_replace_internal(DIALOG_122, 1, 4, 30, 200, "The Black Hole\nLeft: Work Elevator\n/// Cloudy Maze\nRight: Underground Lake")
    dialog_replace_internal(DIALOG_123, 1, 4, 30, 200, "Metal Cavern\nLeft: To Waterfall\nRight: Metal Cap Switch")
    dialog_replace_internal(DIALOG_127, 3, 4, 30, 200, "Underground Lake\nLeft: Metal Cave\nRight: Abandoned Mine\n///(Closed)\nA gentle sea dragon lives\nhere. Pound on his back to\nmake him lower his head.\nDon't become his lunch.")
    dialog_replace_internal(DIALOG_138, 1, 3, 30, 200, "Down: Underground Lake\nRight: Black Hole\nLeft: Hazy Maze (Closed)")
    dialog_replace_internal(DIALOG_140, 1, 6, 30, 200, "Elevator Area\nLeft: Hazy Maze\n/// Entrance\nRight: Black Hole\n///Elevator 1\nArrow: You are here")
end

hook_event(HOOK_ON_MODS_LOADED, replace_dialogs)