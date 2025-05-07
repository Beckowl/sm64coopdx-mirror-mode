local HOOK_RENDER_MARIO = 1
local HOOK_RENDER_CAMERA = 2

local G_CULL_BOTH = 0x00000200 | 0x00000400  -- G_CULL_BACK | G_CULL_FRONT
local DEFAULT_GEOMETRY_MODE = 
    0x00000004 |   -- G_SHADE
    0x00200000 |   -- G_SHADING_SMOOTH
    0x00020000     -- G_LIGHTING

local G_RDPLOADSYNC = 0xe6
local G_RDPPIPESYNC = 0xe7
local G_RDPTILESYNC = 0xe8

local CULLING_DISABLED = 2 -- This flag will be applied to the camera once culling is fully disabled

gMirrorEnabled = mod_storage_load_bool("mirrorEnabled") or not mod_storage_exists("mirrorEnabled")

local camera
local cullingDisabledModels = {}

local function disable_face_culling(firstNode)
    local clear = G_CULL_BOTH
    local set = DEFAULT_GEOMETRY_MODE

    geo_traverse_nodes(firstNode, function(node)
        local dl = graph_node_get_displaylist(node)

        if not dl then
            return
        end

        gfx_parse(dl, function(cmd, op)
            if op == G_GEOMETRYMODE then
                clear = ~_SHIFTR(cmd.w0, 0, 24) | G_CULL_BOTH
                set = cmd.w1 & (~G_CULL_BOTH)

                gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
            elseif op == G_RDPLOADSYNC or op == G_RDPPIPESYNC or op == G_RDPTILESYNC then -- thank you cat for telling me this
                -- Some displaylists don't set the geometry mode, so we need to disable culling for those
                -- I'm using the last clear and set values to avoid glitched colors

                gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
            end
        end)
    end)
end

local function flip_camera(cameraNode)
    cameraNode.matrixPtr.m00 = -cameraNode.matrixPtr.m00
    cameraNode.matrixPtr.m10 = -cameraNode.matrixPtr.m10
    cameraNode.matrixPtr.m20 = -cameraNode.matrixPtr.m20
    cameraNode.matrixPtr.m30 = -cameraNode.matrixPtr.m30

    cameraNode.matrixPtrPrev.m00 = -cameraNode.matrixPtrPrev.m00
    cameraNode.matrixPtrPrev.m10 = -cameraNode.matrixPtrPrev.m10
    cameraNode.matrixPtrPrev.m20 = -cameraNode.matrixPtrPrev.m20
    cameraNode.matrixPtrPrev.m30 = -cameraNode.matrixPtrPrev.m30
end

local function on_mario_update(m)
    if m.playerIndex ~= 0 then
        return
    end

    m.marioObj.hookRender = HOOK_RENDER_MARIO
end

local function on_object_render(o)
    if o.hookRender == HOOK_RENDER_MARIO and not camera then
        -- Three parents up from Mario's node is always the camera (GraphNodeCamera).
        -- Some people call this the level node, but it's actually a camera.
        -- The level display list nodes are children of this node.

        camera = o.header.gfx.node.parent.parent.parent
        camera.hookProcess = HOOK_RENDER_CAMERA
    end
end

local function on_warp(warpType)
    if warpType == WARP_TYPE_CHANGE_AREA or warpType == WARP_TYPE_CHANGE_LEVEL then
        camera = nil
    end
end

local function on_instant_warp(area)
    if area ~= gMarioStates[0].area.index then
        camera = nil
    end
end

local function on_object_set_model(o, modelID)
    if not cullingDisabledModels[modelID] and o.header.gfx.sharedChild then
        disable_face_culling(o.header.gfx.sharedChild)

        cullingDisabledModels[modelID] = true
    end
end

local function on_geo_process(n)
    if n.hookProcess ~= HOOK_RENDER_CAMERA then
        return
    end

    if n.extraFlags & CULLING_DISABLED == 0 then
        disable_face_culling(n)

        -- If i don't do this, some models (skeeters, boxes in WWW) turn invisible/inside out
        -- isn't HOOK_OBJECT_SET_MODEL supposed to be called when an object spawns?
        for o in iter_objects() do
            local sharedChild = o.header.gfx.sharedChild

            if sharedChild then
                disable_face_culling(sharedChild)
            end
        end

        n.extraFlags = n.extraFlags | CULLING_DISABLED
    end

    local graphNodeCamera = cast_graph_node(n)

    if gMirrorEnabled then
        flip_camera(graphNodeCamera)
    end
end

local function mirror_checkbox(_, value)
    gMirrorEnabled = value

    if value == true then
        replace_directional_dialogs()
    else
        smlua_text_utils_reset_all()
    end
    
    mod_storage_save_bool("mirrorEnabled", value)
end

hook_mod_menu_checkbox("Mirroring enabled", gMirrorEnabled, mirror_checkbox)

hook_event(HOOK_ON_OBJECT_RENDER, on_object_render)
hook_event(HOOK_ON_GEO_PROCESS, on_geo_process)
hook_event(HOOK_MARIO_UPDATE, on_mario_update)
hook_event(HOOK_ON_INSTANT_WARP, on_instant_warp)
hook_event(HOOK_ON_WARP, on_warp)
hook_event(HOOK_OBJECT_SET_MODEL, on_object_set_model)
