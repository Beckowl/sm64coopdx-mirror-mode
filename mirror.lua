local G_CULL_BOTH = 0x00000200 | 0x00000400                         -- G_CULL_BACK | G_CULL_FRONT
local DEFAULT_GEOMETRY_MODE = 0x00000004 | 0x00200000 | 0x00020000  -- G_SHADE | G_SHADING_SMOOTH | G_LIGHTING

local G_RDPLOADSYNC = 0xe6
local G_RDPPIPESYNC = 0xe7
local G_RDPTILESYNC = 0xe8

local HOOK_RENDER_MARIO = 1
local HOOK_PROCESS_CAMERA = 1

local FLAG_CULLING_DISABLED = 16

local cullingFixed = {}

gMirrorEnabled = mod_storage_load_bool("mirrorEnabled") or not mod_storage_exists("mirrorEnabled")

local function disable_face_culling(firstNode)
    local clear = G_CULL_BOTH
    local set = DEFAULT_GEOMETRY_MODE

    geo_traverse_nodes(firstNode, function(node)
        local dl = graph_node_get_displaylist(node)

        if not dl or cullingFixed[dl] then
            return
        end

        gfx_parse(dl, function(cmd, op)
            if op == G_GEOMETRYMODE then
                clear = ~(cmd.w0 & 0xFFFFFF) | G_CULL_BOTH
                set = cmd.w1 & (~G_CULL_BOTH)

                gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
            elseif op == G_RDPLOADSYNC or op == G_RDPPIPESYNC or op == G_RDPTILESYNC then -- thank you cat for telling me this
                -- Some displaylists don't set the geometry mode, so we need to disable culling for those
                -- I'm using the last clear and set values to avoid glitched colors

                gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
            end
        end)

        cullingFixed[dl] = true
    end)
end

-- The modelID parameter of `HOOK_OBJECT_SET_MODEL` is NOT an extended model ID.
-- I opened a PR to add an extended model ID as a third parameter.
-- In hindsight, i'll add the param here so i won't need to update the code later.
local function disable_object_face_culling(o, modelID, modelExtendedId)
    local sharedChild = o.header.gfx.sharedChild
    modelExtendedId = modelExtendedId or obj_get_model_id_extended(o)

    if not cullingFixed[modelExtendedId] and sharedChild then
        disable_face_culling(sharedChild)

        cullingFixed[modelExtendedId] = true
    end
end

local function on_object_render(o)
    if o.hookRender == HOOK_RENDER_MARIO then
        local camera = geo_get_current_camera()
        camera.fnNode.node.hookProcess = HOOK_PROCESS_CAMERA
    end
end

local function mario_update(m)
    if m.playerIndex == 0 then
        m.marioObj.hookRender = HOOK_RENDER_MARIO
    end
end

local function on_geo_process(node)
    if node.type ~= GRAPH_NODE_TYPE_CAMERA then
        return
    end

    if node.extraFlags & FLAG_CULLING_DISABLED == 0 then
        disable_face_culling(node)

        for o in iter_objects() do
            disable_object_face_culling(o)
        end

        node.extraFlags = node.extraFlags | FLAG_CULLING_DISABLED
    end

    if gMirrorEnabled then
        local camera = cast_graph_node(node)

        flip_matrix(camera.matrixPtr)
        flip_matrix(camera.matrixPtrPrev)
    end
end

local function mirror_checkbox(_, value)
    gMirrorEnabled = value

    if value then
        replace_directional_dialogs()
    else
        restore_directional_dialogs()
    end

    mod_storage_save_bool("mirrorEnabled", value)
end

hook_mod_menu_checkbox("Mirroring enabled", gMirrorEnabled, mirror_checkbox)

hook_event(HOOK_ON_OBJECT_RENDER, on_object_render)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_GEO_PROCESS, on_geo_process)
hook_event(HOOK_OBJECT_SET_MODEL, disable_object_face_culling)
