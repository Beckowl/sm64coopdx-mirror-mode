local showHealth = gNametagsSettings.showHealth
local showHealthSaved = false
local nametagInterp = {}

function djui_hud_print_outlined_text_interpolated(text, prevX, prevY, prevScale, x, y, scale, r, g, b, a, outlineDarkness)
    offset = 1 * (scale * 2);
    prevOffset = 1 * (prevScale * 2);

    djui_hud_set_color(r * outlineDarkness, g * outlineDarkness, b * outlineDarkness, a)
    djui_hud_print_text_interpolated(text, prevX - prevOffset, prevY, prevScale, x - offset, y, scale)
    djui_hud_print_text_interpolated(text, prevX + prevOffset, prevY, prevScale, x + offset, y, scale)
    djui_hud_print_text_interpolated(text, prevX, prevY - prevOffset, prevScale, x, y - offset, scale)
    djui_hud_print_text_interpolated(text, prevX, prevY + prevOffset, prevScale, x, y + offset, scale)

    djui_hud_set_color(r, g, b, a)
    djui_hud_print_text_interpolated(text, prevX, prevY, prevScale, x, y, scale)
    djui_hud_set_color(255, 255, 255, 255)
end

local function network_get_player_text_color(localIndex)
    if localIndex >= MAX_PLAYERS then
        localIndex = 0
    end

    local np = gNetworkPlayers[localIndex]
    local color = network_player_get_override_palette_color(np, CAP)

    color.r = 127 + color.r // 2
    color.g = 127 + color.g // 2
    color.b = 127 + color.b // 2

    return color.r, color.g, color.b
end

hook_event(HOOK_ON_NAMETAGS_RENDER, function(playerIndex, pos)
    if not gMirrorEnabled then return end

    if not showHealthSaved then
        showHealth = gNametagsSettings.showHealth
        gNametagsSettings.showHealth = false
        showHealthSaved = true
    end

    local screenPos = gVec3fZero()
    local result = nil

    if djui_hud_world_pos_to_screen_pos(pos, screenPos) then
        local np = gNetworkPlayers[playerIndex]
        local text = get_uncolored_string(np.name)

        screenPos.x = djui_hud_get_screen_width() - screenPos.x
        local scale = -300 / screenPos.z * djui_hud_get_fov_coeff()
        screenPos.y = screenPos.y - 16 * scale

        local x = screenPos.x - djui_hud_measure_text(text) * scale * 0.5
        local y = screenPos.y

        local r, g, b = network_get_player_text_color(playerIndex)
        local alpha = playerIndex == 0 and 255 or math.min(np.fadeOpacity << 3, 255) * math.clamp(4 - scale, 0, 1)

        local prev = nametagInterp[playerIndex] or {
            x = x,
            y = y,
            scale = scale,
            healthX = x,
            healthY = y,
            healthW = 90 * scale,
            healthH = 90 * scale,
        }

        djui_hud_print_outlined_text_interpolated(text, prev.x, prev.y, prev.scale, x, y, scale, r, g, b, alpha, 0.25)

        if playerIndex ~= 0 and showHealth then
            local healthScale = 90 * scale
            local healthX = screenPos.x - (healthScale * 0.5)
            local healthY = screenPos.y - 72 * scale

            djui_hud_set_color(255, 255, 255, alpha)
            hud_render_power_meter_interpolated(
                gMarioStates[playerIndex].health,
                prev.healthX, prev.healthY, prev.healthW, prev.healthH,
                healthX, healthY, healthScale, healthScale
            )

            prev.healthX = healthX
            prev.healthY = healthY
            prev.healthW = healthScale
            prev.healthH = healthScale
        end

        prev.x = x
        prev.y = y
        prev.scale = scale
        nametagInterp[playerIndex] = prev

        result = { name = "" }
    end

    return result
end)

hook_event(HOOK_ON_HUD_RENDER_BEHIND, function()
    if gMirrorEnabled and showHealthSaved then
        gNametagsSettings.showHealth = showHealth
        showHealthSaved = false
    end
end)

hook_event(HOOK_ON_PLAYER_DISCONNECTED, function(playerIndex)
    nametagInterp[playerIndex] = nil
end)
