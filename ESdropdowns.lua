local component = require("component")
local event = require("event")
local term = require("term")
local gpu = require("component").gpu

ddmenus = {}

function selectDropdowns(_, address, x, y, button, name)
    if button == 0 then
        for i = 1, #ddmenus do
            if ddmenus[i].active then
                if x >= ddmenus[i].x and ddmenus[i].x+ddmenus[i].w > x and math.ceil(y) >= ddmenus[i].y+ddmenus[i].h and ddmenus[i].y+ddmenus[i].h+(ddmenus[i].optionHeight*#ddmenus[i].options) > math.ceil(y) and ddmenus[i].clicked == true then
                    for j = 1, #ddmenus[i].options do
                        if math.ceil(y) >= ddmenus[i].y + ddmenus[i].h + ((j-1)*ddmenus[i].optionHeight) and ddmenus[i].y + ddmenus[i].h + ((j)*ddmenus[i].optionHeight) > math.ceil(y) then
                            ddmenus[i].selected = j
                            ddmenus[i].clicked = false
                            loadDropdown(i)
                        end
                    end
                elseif x >= ddmenus[i].x and ddmenus[i].x+ddmenus[i].w > x and math.ceil(y) >= ddmenus[i].y and ddmenus[i].y+ddmenus[i].h > math.ceil(y) then
                    if ddmenus[i].clicked == true then
                        ddmenus[i].clicked = false
                    else
                        ddmenus[i].clicked = true
                    end
                    loadDropdown(i)
                end
            end
        end
    end
end
function createDropdown(x, y, w, h, optionHeight, bkgnd, frgnd, mid, name, options)
    for i = 1, #ddmenus do
        if ddmenus[i].name == name then
            table.remove(ddmenus, i)
        end
    end
    table.insert(ddmenus, 
        {
            x = x*2,
            y = y,
            w = w*2,
            h = h,
            background = bkgnd,
            foreground = frgnd,
            middle = mid,
            name = name,
            options = options,
            selected = 0,
            clicked = false,
            optionHeight = optionHeight,
            buffer = nil,
            active = false
        }
    )
    return #ddmenus
end
function loadDropdown(pos)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    ddmenus[pos].active = true
    gpu.setForeground(ddmenus[pos].foreground)
    gpu.setBackground(ddmenus[pos].background)
    gpu.fill(ddmenus[pos].x, ddmenus[pos].y, ddmenus[pos].w, ddmenus[pos].h, " ")
    if ddmenus[pos].selected == 0 or ddmenus[pos].options[ddmenus[pos].selected] == "" then
        ddmenus[pos].selected = 0
        gpu.set(ddmenus[pos].x+1, ddmenus[pos].y+math.floor(ddmenus[pos].h/2), string.sub(ddmenus[pos].name, 1, ddmenus[pos].w-3))
    else
        gpu.set(ddmenus[pos].x+1, ddmenus[pos].y+math.floor(ddmenus[pos].h/2), string.sub(ddmenus[pos].options[ddmenus[pos].selected], 1, ddmenus[pos].w-4))
    end
    if ddmenus[pos].clicked == false then
        gpu.set(ddmenus[pos].x+ddmenus[pos].w-2, ddmenus[pos].y+math.floor(ddmenus[pos].h/2), "+")
        if ddmenus[pos].buffer ~= nil then
            gpu.bitblt(0, ddmenus[pos].x, ddmenus[pos].y+ddmenus[pos].h, 160, 50, ddmenus[pos].buffer, 1, 1)
        end
    else
        gpu.freeBuffer(ddmenus[pos].buffer)
        ddmenus[pos].buffer = gpu.allocateBuffer(ddmenus[pos].w, ddmenus[pos].optionHeight*#ddmenus[pos].options)
        gpu.bitblt(ddmenus[pos].buffer, 1, 1, ddmenus[pos].w, ddmenus[pos].optionHeight*#ddmenus[pos].options, 0, ddmenus[pos].y+ddmenus[pos].h, ddmenus[pos].x)
        gpu.set(ddmenus[pos].x+ddmenus[pos].w-2, ddmenus[pos].y+math.floor(ddmenus[pos].h/2), "-")
        gpu.setBackground(ddmenus[pos].middle)
        gpu.fill(ddmenus[pos].x, ddmenus[pos].y+ddmenus[pos].h, ddmenus[pos].w, ddmenus[pos].optionHeight*#ddmenus[pos].options, " ")
        for j = 1, #ddmenus[pos].options do
            if ddmenus[pos].optionHeight > 1 then
                gpu.fill(ddmenus[pos].x, ddmenus[pos].y+ddmenus[pos].h+((ddmenus[pos].optionHeight*j)-1), ddmenus[pos].w, 1, "_")
            end
            gpu.set(ddmenus[pos].x+1, ddmenus[pos].y+ddmenus[pos].h+(math.ceil(ddmenus[pos].optionHeight/2)-0.5)+((j-1)*ddmenus[pos].optionHeight), string.sub(ddmenus[pos].options[j], 1, ddmenus[pos].w-1))
        end
    end
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function loadAllDropdowns()
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    for i = 1, #ddmenus do
        gpu.setForeground(ddmenus[i].foreground)
        gpu.setBackground(ddmenus[i].background)
        gpu.fill(ddmenus[i].x, ddmenus[i].y, ddmenus[i].w, ddmenus[i].h, " ")
        if ddmenus[i].selected == 0 or ddmenus[i].options[ddmenus[i].selected] == "" then
            ddmenus[i].selected = 0
            gpu.set(ddmenus[i].x+1, ddmenus[i].y+math.floor(ddmenus[i].h/2), string.sub(ddmenus[i].name, 1, ddmenus[i].w-3))
        else
            gpu.set(ddmenus[i].x+1, ddmenus[i].y+math.floor(ddmenus[i].h/2), string.sub(ddmenus[i].options[ddmenus[i].selected], 1, ddmenus[i].w-3))
        end
        if ddmenus[i].clicked == false then
            gpu.set(ddmenus[i].x+ddmenus[i].w-2, ddmenus[i].y+math.floor(ddmenus[i].h/2), "+")
            if ddmenus[i].buffer ~= nil then
                gpu.bitblt(0, ddmenus[i].x, ddmenus[i].y+ddmenus[i].h, 160, 50, ddmenus[i].buffer, 1, 1)
            end
        else
            gpu.freeBuffer(ddmenus[i].buffer)
            ddmenus[i].buffer = gpu.allocateBuffer(ddmenus[i].w, ddmenus[i].optionHeight*#ddmenus[i].options)
            gpu.bitblt(ddmenus[i].buffer, 1, 1, ddmenus[i].w, ddmenus[i].optionHeight*#ddmenus[i].options, 0, ddmenus[i].y+ddmenus[i].h, ddmenus[i].x)
            gpu.set(ddmenus[i].x+ddmenus[i].w-2, ddmenus[i].y+math.floor(ddmenus[i].h/2), "-")
            gpu.setBackground(ddmenus[i].middle)
            gpu.fill(ddmenus[i].x, ddmenus[i].y+ddmenus[i].h, ddmenus[i].w, ddmenus[i].optionHeight*#ddmenus[i].options, " ")
            for j = 1, #ddmenus[i].options do
                if ddmenus[i].optionHeight > 1 then
                    gpu.fill(ddmenus[i].x, ddmenus[i].y+ddmenus[i].h+((ddmenus[i].optionHeight*j)-1), ddmenus[i].w, 1, "_")
                end
                gpu.set(ddmenus[i].x+2, ddmenus[i].y+ddmenus[i].h+(math.ceil(ddmenus[i].optionHeight/2)-0.5)+((j-1)*ddmenus[i].optionHeight), string.sub(ddmenus[i].options[j], 1, ddmenus[i].w-2))
            end
        end
        ddmenus[i].active = true
    end
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function getDropdown(pos)
    if ddmenus[pos].selected ~= nil then
        return ddmenus[pos].options[ddmenus[pos].selected]
    else
        return nil
    end
end
function toggleDropdown(pos, bool)
    ddmenus[pos].active = bool
end
function getDropdownLocation(name)
    local found = false
    for i = 1, #ddmenus do
        if ddmenus[i].name == name then
            found = true
            return i
        end
    end
    if found == false then
        return nil
    end
end
function setDropdownOptions(pos, options)
    ddmenus[pos].options = options
end
function ESDListen()
    event.listen("touch", selectDropdowns)
end