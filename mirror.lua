local G_CULL_BOTH = 0x00000200 | 0x00000400 -- G_CULL_BACK | G_CULL_FRONT

local G_RDPPIPESYNC = 0xe7

local HOOK_RENDER_MARIO = 1
local HOOK_PROCESS_CAMERA = 2

local FLAG_CULL_DISABLED = 16
local cullingDisabled = {}

local mirrorMatrix = {
    m00 = -1, m01 =  0, m02 =  0, m03 = 0,
    m10 =  0, m11 =  1, m12 =  0, m13 = 0,
    m20 =  0, m21 =  0, m22 =  1, m23 = 0,
    m30 =  0, m31 =  0, m32 =  0, m33 = 1
}

local function graph_node_get_dl(node)
    if node.type == GRAPH_NODE_TYPE_ANIMATED_PART or
        node.type == GRAPH_NODE_TYPE_DISPLAY_LIST or
        node.type == GRAPH_NODE_TYPE_TRANSLATION_ROTATION or
        node.type == GRAPH_NODE_TYPE_TRANSLATION or
        node.type == GRAPH_NODE_TYPE_ROTATION or
        node.type == GRAPH_NODE_TYPE_BILLBOARD or
        node.type == GRAPH_NODE_TYPE_SCALE then

        return cast_graph_node(node).displayList
    end
end

local function disable_dl_culling(dl, clear, set)
    if not dl or cullingDisabled[dl._pointer] then return end

    gfx_parse(dl, function(cmd, op)
        if op == G_RDPPIPESYNC then
            gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
        elseif op == G_GEOMETRYMODE then
            clear = ~(cmd.w0 & 0xFFFFFF) | G_CULL_BOTH
            set = cmd.w1 & (~G_CULL_BOTH)

            gfx_set_command(cmd, "gsSPGeometryMode(%i, %i)", clear, set)
        elseif op == G_DL then
            disable_dl_culling(gfx_get_display_list(cmd), clear, set)
        end
    end)

    cullingDisabled[dl._pointer] = true
end

local function disable_face_culling(firstNode)
    local curGraphNode = firstNode

    repeat
        local dl = graph_node_get_dl(curGraphNode)

        disable_dl_culling(dl, G_CULL_BOTH, 0)

        if curGraphNode.children then
            disable_face_culling(curGraphNode.children)
        end

        curGraphNode = curGraphNode.next
    until curGraphNode == firstNode
end

local function disable_object_face_culling(o, _, modelId)
    modelId = modelId or obj_get_model_id_extended(o)
    local sharedChild = o.header.gfx.sharedChild

    if sharedChild and o.header.gfx.node.extraFlags & FLAG_CULL_DISABLED == 0 then
        disable_face_culling(sharedChild)
        o.header.gfx.node.extraFlags = o.header.gfx.node.extraFlags | FLAG_CULL_DISABLED
    end
end

local function disable_all_culling(cameraNode)
    disable_face_culling(cameraNode)

    for i = 0, NUM_OBJ_LISTS - 1 do
        local o = obj_get_first(i)
        while o do
            disable_object_face_culling(o)
            o = obj_get_next(o)
        end
    end
end

local function on_mario_update(m)
    if m.playerIndex == 0 then
        m.marioObj.hookRender = HOOK_RENDER_MARIO
    end
end

local function on_object_render(o)
    if o.hookRender == HOOK_RENDER_MARIO then
        geo_get_current_camera().fnNode.node.hookProcess = HOOK_PROCESS_CAMERA
    end
end

local function on_geo_process(node)
    if gMirrorEnabled and node.type == GRAPH_NODE_TYPE_CAMERA and node.hookProcess == HOOK_PROCESS_CAMERA then
        local camera = cast_graph_node(node)

        mtxf_mul(camera.matrixPtr, camera.matrixPtr, mirrorMatrix)
        mtxf_mul(camera.matrixPtrPrev, camera.matrixPtrPrev, mirrorMatrix)

        if node.extraFlags & FLAG_CULL_DISABLED == 0 then
            disable_all_culling(node)

            node.extraFlags = node.extraFlags | FLAG_CULL_DISABLED
        end
    end
end

hook_event(HOOK_MARIO_UPDATE, on_mario_update)
hook_event(HOOK_ON_OBJECT_RENDER, on_object_render)
hook_event(HOOK_ON_GEO_PROCESS, on_geo_process)
hook_event(HOOK_OBJECT_SET_MODEL, disable_object_face_culling)
