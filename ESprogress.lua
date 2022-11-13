local component = require("component")
local event = require("event")
local term = require("term")
local gpu = require("component").gpu
local screen = require("component").screen

bars = {}

function loadProgressBar(bar, value)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    gpu.setBackground(bars[bar].background)
    gpu.setForeground(bars[bar].mid)
    gpu.fill(bars[bar].x, bars[bar].y, bars[bar].w, 1, bars[bar].unloaded)
    gpu.setForeground(bars[bar].foreground)
    gpu.fill(bars[bar].x, bars[bar].y, bars[bar].w*value, 1, bars[bar].loaded)
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function createProgressBar(x, y, w, name, bkgnd, frgnd, mid, char1, char2)
    for i = 1, #bars do
        if bars[i].name == name then
            table.remove(bars, i)
        end
    end
    table.insert(bars, 
        {
            x = x*2,
            y = y,
            w = w*2,
            name = name,
            background = bkgnd,
            foreground = frgnd,
            mid = mid,
            value = 0,
            unloaded = char1,
            loaded = char2
        }
    )
    return #bars
end
function getProgressBar(name)
    local found = false
    for i = 1, #bars do
        if bars[i].name == name then
            found = true
            return i
        end
    end
    if found == false then
        return nil
    end
end