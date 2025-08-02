-- In mirror mode, the game world is flipped horizontally: Left becomes right, and right becomes left.
-- Without flipping the control stick, pushing it left still moves Mario left in world coordinates,
-- even though that appears as "right" on the mirrored screen.

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

    if gFlipCButtons then
        controller.buttonPressed = swap_buttons(controller.buttonPressed, L_CBUTTONS, R_CBUTTONS)
        controller.buttonReleased = swap_buttons(controller.buttonReleased, L_CBUTTONS, R_CBUTTONS)    
    end
end

local function before_mario_update(m)
    if m.playerIndex == 0 and gMirrorEnabled then
        flip_controls(m.controller)
    end
end

hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
