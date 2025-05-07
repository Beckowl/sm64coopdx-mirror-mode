-- In mirror mode, the game world is flipped horizontally: Left becomes right, and right becomes left.
-- Without flipping the control stick, pushing it left still moves Mario left in world coordinates,
-- even though that appears as "right" on the mirrored screen.

local flipCButtons = mod_storage_load_bool("flipCButtons") or not mod_storage_exists("flipCButtons")

function swap_buttons(bitmask, button1, button2)
    local b1 = (bitmask & button1) ~= 0
    local b2 = (bitmask & button2) ~= 0

    if b1 ~= b2 then
        bitmask = bitmask ~ (button1 | button2)
    end

    return bitmask
end

local function flip_controls(controller)
    controller.stickX = -controller.stickX
    controller.rawStickX = -controller.rawStickX

    if flipCButtons then
        controller.buttonPressed = swap_buttons(controller.buttonPressed, L_CBUTTONS, R_CBUTTONS)
        controller.buttonReleased = swap_buttons(controller.buttonReleased, L_CBUTTONS, R_CBUTTONS)

        if gControllers[0].buttonDown & L_CBUTTONS ~= 0 then
            controller.buttonDown = (controller.buttonDown & ~R_CBUTTONS) | L_CBUTTONS
        elseif gControllers[0].buttonDown & R_CBUTTONS ~= 0 then
            controller.buttonDown = (controller.buttonDown & ~L_CBUTTONS) | R_CBUTTONS
        end
    end
end

local function before_mario_update(m)
    if m.playerIndex == 0 and gMirrorEnabled then
        flip_controls(m.controller)
    end
end

local function flip_c_buttons_checkbox(_, value)
    flipCButtons = value
    mod_storage_save_bool("flipCButtons", value)
end

hook_mod_menu_checkbox("Flip C buttons (VANILLA CAMERA ONLY)", flipCButtons, flip_c_buttons_checkbox)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
