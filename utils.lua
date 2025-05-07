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

-- Implementations of the macros from gbi.h

function _SHIFTL(v, s, w)
    return ((v & ((1 << w) - 1)) << s) & 0xFFFFFFFF
end

function _SHIFTR(v, s, w)
    return ((v >> s) & ((1 << w) - 1)) & 0xFFFFFFFF
end
