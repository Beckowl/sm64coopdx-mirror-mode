local function is_mirrored()
    return gMirrorEnabled
end

_G.mirrorMode = {
    is_mirrored = is_mirrored
}