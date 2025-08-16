local E_MODEL_SKYBOX = smlua_model_util_get_id("skybox_geo")
local useCustomSkybox = mod_storage_load_bool("useCustomSkybox") or not mod_storage_exists("useCustomSkybox")

local function bhv_skybox_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.skipInViewCheck = true
    cur_obj_hide()
end

local function bhv_skybox_loop(o)
    if not useCustomSkybox then
        obj_mark_for_deletion(o)
    end

    o.oPosX = gLakituState.pos.x
    o.oPosY = gLakituState.pos.y
    o.oPosZ = gLakituState.pos.z

    local skybox = get_skybox()

    if skybox == -1 or skybox >= BACKGROUND_CUSTOM then
        cur_obj_hide()
    else
        cur_obj_unhide()
    end
end

function geo_skybox_set_texture(node)
    local switch = cast_graph_node(node)
    switch.selectedCase = get_skybox()
end

function geo_skybox_set_color(node)
    local dl = cast_graph_node(node.next).displayList

    local r, g, b

    if get_skybox() == 8 and save_file_get_star_flags(get_current_save_file_num() - 1, COURSE_JRB - 1) & (1 << 0) == 0 then
        r, g, b = 0x50, 0x64, 0x5A
    else
        r = get_skybox_color(0)
        g = get_skybox_color(1)
        b = get_skybox_color(2)
    end

    gfx_set_command(dl, "gsDPSetEnvColor(%i, %i, %i, 255)", r, g, b)
end

local id_bhvSkyBox = hook_behavior(nil, OBJ_LIST_DEFAULT, true, bhv_skybox_init, bhv_skybox_loop, "SkyBox")
local skyboxBehavior = get_behavior_from_id(id_bhvSkyBox)
local actSelectBehavior = get_behavior_from_id(id_bhvActSelector)

local function on_update()
    if count_objects_with_behavior(skyboxBehavior) <= 0 and count_objects_with_behavior(actSelectBehavior) <= 0 and useCustomSkybox then
        spawn_non_sync_object(id_bhvSkyBox, E_MODEL_SKYBOX, 0, 0, 0, nil)
    end
end

local function custom_skybox_toggle(_, value)
    mod_storage_save_bool("useCustomSkybox", value)
    useCustomSkybox = value
end

hook_mod_menu_checkbox("Use custom skybox", useCustomSkybox, custom_skybox_toggle)
hook_event(HOOK_UPDATE, on_update)
