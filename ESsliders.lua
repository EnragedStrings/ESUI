local component = require("component")
local event = require("event")
local term = require("term")
local gpu = require("component").gpu
local screen = require("component").screen

sliders = {}

function createSlider(x, y, width, minVal, maxVal, startVal, bkgnd, frgnd, mid, name)
    screen.setPrecise(true)
    for i = 1, #sliders do
        if sliders[i].name == name then
            table.remove(sliders, i)
        end
    end
    if maxVal > minVal and maxVal >= startVal and startVal >= minVal then
        table.insert(sliders, 
            {
                x = x*2,
                y = y,
                w = width*2,
                minVal = minVal,
                maxVal = maxVal,
                value = startVal,
                background = bkgnd,
                foreground = frgnd,
                middle = mid,
                name = name,
                active = false
            }
        )
    end
    return #sliders
end
function loadSlider(pos)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    sliders[pos].active = true
    gpu.setBackground(sliders[pos].background)
    gpu.setForeground(sliders[pos].middle)
    local sliderPos = (((sliders[pos].value-sliders[pos].minVal) / (sliders[pos].maxVal-sliders[pos].minVal)) * sliders[pos].w)
    if sliderPos >= sliders[pos].w then
        sliderPos = sliders[pos].w - 1
    elseif 0 > sliderPos then
        sliderPos = 0
    end
    gpu.fill(sliders[pos].x, sliders[pos].y, sliderPos, 1, "─")
    gpu.setForeground(sliders[pos].foreground)
    gpu.fill(sliders[pos].x+math.ceil(sliderPos), sliders[pos].y, sliders[pos].w-math.ceil(sliderPos), 1, "─")
    gpu.set(sliders[pos].x+sliderPos, sliders[pos].y, "○")
    
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function selectSlider(event, address, x, y, button, name)
    for i = 1, #sliders do
        if x+1 >= sliders[i].x and sliders[i].x+sliders[i].w > x-1 and math.ceil(y) == math.floor(sliders[i].y) and sliders[i].active then
            local val = ((((x-sliders[i].x)/sliders[i].w)*((sliders[i].maxVal+0.5)-sliders[i].minVal))+sliders[i].minVal)
            if val > sliders[i].maxVal then
                val = sliders[i].maxVal 
            end
            if sliders[i].minVal > val then
                val = sliders[i].minVal
            end
            sliders[i].value = val
            loadSlider(i)
        end
    end
end
function ESSListen()
    event.listen("touch", selectSlider)
    event.listen("drag", selectSlider)
end
function getSliderVal(pos)
    if sliders[pos] ~= nil then
        return sliders[pos].value
    else
        return nil
    end
end
function getSliderPos(name)
    local found = false
    for i = 1, #sliders do
        if sliders[i].name == name then
            found = true
            return i
        end
    end
    if found == false then
        return nil
    end
end
function toggleActive(pos, bool)
    sliders[pos].active = bool
end