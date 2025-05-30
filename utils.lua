-- Iterates through all objects in the scene
 -- Thanks kermeow for adding coroutines
 function iter_objects()
    return coroutine.wrap(function()
        for i = 0, NUM_OBJ_LISTS - 1 do
            local obj = obj_get_first(i)
            while obj do
                coroutine.yield(obj)
                obj = obj_get_next(obj)
            end
        end
    end)
end

-- Iterates through all siblings and children of a graphNode
function geo_traverse_nodes(firstNode, callback)
    local curGraphNode = firstNode

    repeat
        callback(curGraphNode)

        if curGraphNode.children then
            geo_traverse_nodes(curGraphNode.children, callback)
        end

        curGraphNode = curGraphNode.next
    until curGraphNode == firstNode
end

function graph_node_get_displaylist(node)
    if node.type == GRAPH_NODE_TYPE_ANIMATED_PART or node.type == GRAPH_NODE_TYPE_DISPLAY_LIST or node.type == GRAPH_NODE_TYPE_TRANSLATION_ROTATION or node.type == GRAPH_NODE_TYPE_TRANSLATION or node.type == GRAPH_NODE_TYPE_ROTATION or node.type == GRAPH_NODE_TYPE_BILLBOARD or node.type == GRAPH_NODE_TYPE_SCALE then
        return cast_graph_node(node).displayList
    end
end

function flip_matrix(matrix)
    matrix.m00 = -matrix.m00
    matrix.m10 = -matrix.m10
    matrix.m20 = -matrix.m20
    matrix.m30 = -matrix.m30
end
