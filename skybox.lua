local E_MODEL_SKYBOX = smlua_model_util_get_id("skybox_geo")

local useCustomSkybox = mod_storage_load_bool("useCustomSkybox") or not mod_storage_exists("useCustomSkybox")
local accumulatedRotation, prevYaw = 0, 0

function angle_diff(a, b)
    local diff = (b - a) & 0xFFFF

    if diff >= 0x8000 then
        diff = diff - 0x10000
    end

    return diff
end

local function bhv_skybox_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    set_override_far(math.maxinteger)
end

local function bhv_skybox_loop(o)
    if not useCustomSkybox then
        obj_mark_for_deletion(o)
    end

    obj_copy_pos(o, gMarioStates[0].marioObj)

    local cameraFaceX = gLakituState.focus.x - gLakituState.pos.x
    local cameraFaceZ = gLakituState.focus.z - gLakituState.pos.z

    local yaw = atan2s(cameraFaceX, cameraFaceZ)
    local delta = angle_diff(yaw, prevYaw)

    accumulatedRotation = accumulatedRotation + delta

    o.oFaceAngleYaw = (accumulatedRotation // 3) % 0x10000

    prevYaw = yaw
end

function geo_skybox_set_visibility(node)
    local switch = cast_graph_node(node)
    local skybox = get_skybox()
    switch.selectedCase = (skybox ~= -1 and skybox ~= BACKGROUND_CUSTOM) and 2 or 1
end

function geo_skybox_set_texture(node)
    local switch = cast_graph_node(node)
    switch.selectedCase = get_skybox() + 1
end

local id_bhvSkyBox = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_skybox_init, bhv_skybox_loop, "SkyBox")
local skyboxBehavior = get_behavior_from_id(id_bhvSkyBox)

local function on_update()
    if count_objects_with_behavior(skyboxBehavior) <= 0 and useCustomSkybox then
        spawn_non_sync_object(id_bhvSkyBox, E_MODEL_SKYBOX, 0, 0, 0, nil)
    end
end

local function custom_skybox_toggle(_, value)
    mod_storage_save_bool("useCustomSkybox", value)
    useCustomSkybox = value
end

hook_mod_menu_checkbox("Use custom skybox", useCustomSkybox, custom_skybox_toggle)
hook_event(HOOK_UPDATE, on_update)
