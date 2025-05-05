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

-- Iterates through all children of a graphNode
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
