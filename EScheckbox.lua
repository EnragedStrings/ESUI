local component = require("component")
local event = require("event")
local term = require("term")
local gpu = require("component").gpu
local screen = require("component").screen

--checkboxes
checkboxes = {}
function createCheckbox(x, y, w, name, background, foreground, mid, box_unchecked, box_checked, options)
    for i = 1, #checkboxes do
        if checkboxes[i].name == name then
            table.remove(checkboxes, i)
        end
    end
    local noptions = {}
    for i = 1, #options do
        table.insert(noptions, 
            {
                name = options[i],
                bool = false
            }
        )
    end
    table.insert(checkboxes, 
        {
            x = x*2,
            y = y,
            w = w*2,
            name = name,
            background = background,
            foreground = foreground,
            mid = mid,
            box_unchecked = box_unchecked,
            box_checked = box_checked,
            options = noptions,
            active = false
        }
    )
    return #checkboxes
end
function loadCheckbox(pos)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    checkboxes[pos].active = true
    gpu.setForeground(checkboxes[pos].foreground)
    gpu.setBackground(checkboxes[pos].background)
    if checkboxes[pos].name ~= "" then
        gpu.fill(checkboxes[pos].x, checkboxes[pos].y, checkboxes[pos].w, #checkboxes[pos].options + 1, " ")
        gpu.set(checkboxes[pos].x+1, checkboxes[pos].y, string.sub(checkboxes[pos].name, 1, checkboxes[pos].w-2))
        for i = 1, #checkboxes[pos].options do
            gpu.setForeground(checkboxes[pos].mid)
            if checkboxes[pos].options[i].bool then
                gpu.set(checkboxes[pos].x+1, checkboxes[pos].y+i, checkboxes[pos].box_checked)
            else
                gpu.set(checkboxes[pos].x+1, checkboxes[pos].y+i, checkboxes[pos].box_unchecked)
            end
            gpu.setForeground(checkboxes[pos].foreground)
            gpu.set(checkboxes[pos].x+4, checkboxes[pos].y+i, string.sub(checkboxes[pos].options[i].name, 1, checkboxes[pos].w-5))
        end
    else
        gpu.fill(checkboxes[pos].x, checkboxes[pos].y, checkboxes[pos].w, #checkboxes[pos].options, " ")
        for i = 1, #checkboxes[pos].options do
            gpu.setForeground(checkboxes[pos].mid)
            if checkboxes[pos].options[i].bool then
                gpu.set(checkboxes[pos].x+1, checkboxes[pos].y+i-1, checkboxes[pos].box_checked)
            else
                gpu.set(checkboxes[pos].x+1, checkboxes[pos].y+i-1, checkboxes[pos].box_unchecked)
            end
            gpu.setForeground(checkboxes[pos].foreground)
            gpu.set(checkboxes[pos].x+4, checkboxes[pos].y+i-1, string.sub(checkboxes[pos].options[i].name, 1, checkboxes[pos].w-5))
        end
    end
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function selectBox(event, address, x, y, button, name)
    for i = 1, #checkboxes do
        if x >= checkboxes[i].x and checkboxes[i].x + checkboxes[i].w > x and math.ceil(y) >= checkboxes[i].y and checkboxes[i].y + #checkboxes[i].options >= math.ceil(y) and checkboxes[i].active then
            for j = 1, #checkboxes[i].options do
                if checkboxes[i].name ~= "" then
                    if math.ceil(y) == j + checkboxes[i].y then
                        if checkboxes[i].options[j].bool == true then
                            checkboxes[i].options[j].bool = false
                        else
                            checkboxes[i].options[j].bool = true
                        end
                        loadCheckbox(i)
                    end
                else
                    if math.ceil(y+1) == j + checkboxes[i].y then
                        if checkboxes[i].options[j].bool == true then
                            checkboxes[i].options[j].bool = false
                        else
                            checkboxes[i].options[j].bool = true
                        end
                        loadCheckbox(i)
                    end
                end
            end
        end
    end
end
function ESCBListen()
    event.listen("touch", selectBox)
end
function toggleCheckbox(pos, bool)
    checkboxes[pos].active = bool
end
function getCheckbox(pos, option)
    if option == nil then
        return checkboxes[pos].options
    else
        for i = 1, #checkboxes[pos].options do
            if checkboxes[pos].options[i].name == option then
                return checkboxes[pos].options[i].bool
            end
        end
    end
end

--radio buttons
rbuttons = {}
function createRButton(x, y, seperator, name, background, foreground, mid, box_unchecked, box_checked, options)
    for i = 1, #rbuttons do
        if rbuttons[i].name == name then
            table.remove(rbuttons, i)
        end
    end
    local roptions = {}
    for i = 1, #options do
        table.insert(roptions, 
            {
                name = options[i],
                bool = false
            }
        )
    end
    table.insert(rbuttons, 
        {
            x = x*2,
            y = y,
            seperator = seperator,
            name = name,
            background = background,
            foreground = foreground,
            mid = mid,
            box_unchecked = box_unchecked,
            box_checked = box_checked,
            options = roptions,
            active = false,
            selected = nil
        }
    )
    return #rbuttons
end
function loadRButton(pos)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    gpu.setBackground(rbuttons[pos].background)
    gpu.fill(rbuttons[pos].x, rbuttons[pos].y, (rbuttons[pos].seperator * #rbuttons[pos].options), 1, " ")
    rbuttons[pos].active = true
    for i = 1, #rbuttons[pos].options do
        gpu.setForeground(rbuttons[pos].mid)
        if rbuttons[pos].options[i].bool then
            gpu.set(rbuttons[pos].x + (rbuttons[pos].seperator * (i-1)), rbuttons[pos].y, rbuttons[pos].box_checked)
        else
            gpu.set(rbuttons[pos].x + (rbuttons[pos].seperator * (i-1)), rbuttons[pos].y, rbuttons[pos].box_unchecked)
        end
        gpu.setForeground(rbuttons[pos].foreground)
        gpu.set(rbuttons[pos].x + (rbuttons[pos].seperator * (i-1)) + 2, rbuttons[pos].y, string.sub(rbuttons[pos].options[i].name, 1, rbuttons[pos].seperator-3))

    end
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function selectRButton(event, address, x, y, button, name)
    for i = 1, #rbuttons do
        if x >= rbuttons[i].x and rbuttons[i].x + (rbuttons[i].seperator * #rbuttons[i].options) > x and math.ceil(y) == rbuttons[i].y and rbuttons[i].active then
            for j = 1, #rbuttons[i].options do
                if x >= rbuttons[i].x + (rbuttons[i].seperator * (j-1)) and rbuttons[i].x + (rbuttons[i].seperator * (j)) > x then
                    rbuttons[i].options[j].bool = true
                else
                    rbuttons[i].options[j].bool = false
                end
            end
            loadRButton(i)
        end
    end
end
function ESRBListen()
    event.listen("touch", selectRButton)
end
function toggleRButton(pos, bool)
    rbuttons[pos].active = bool
end
function getRButton(pos)
    local found = false
    for i = 1, #rbuttons[pos].options do
        if rbuttons[pos].options[i].bool then
            found = true
            return rbuttons[pos].options[i].name
        end
    end
    if found == false then
        return nil
    end
end
--toggles
toggles = {}
function createToggle(x, y, w, name, background, foreground, mid_false, mid_true, bool_false, bool_true)
    for i = 1, #toggles do
        if toggles[i].name == name then
            table.remove(toggles, i)
        end
    end
    table.insert(toggles, 
        {
            x = x*2,
            y = y,
            w = w*2,
            name = name,
            background = background,
            foreground = foreground,
            mid1 = mid_false,
            mid2 = mid_true,
            bool_false = bool_false,
            bool_true = bool_true,
            bool = false,
            active = false
        }
    )
    return #toggles
end
function loadToggle(pos)
    local prevBkgnd = gpu.getBackground()
    local prevFrgnd = gpu.getForeground()
    toggles[pos].active = true
    gpu.setBackground(toggles[pos].background)
    gpu.setForeground(toggles[pos].foreground)
    gpu.fill(toggles[pos].x, toggles[pos].y, toggles[pos].w, 1, " ")
    if toggles[pos].bool then
        gpu.setBackground(toggles[pos].mid2)
        gpu.fill(toggles[pos].x+(toggles[pos].w/2), toggles[pos].y, toggles[pos].w/2, 1, " ")
        gpu.set(toggles[pos].x+((toggles[pos].w*0.75)-(#toggles[pos].bool_true/2)), toggles[pos].y, string.sub(toggles[pos].bool_true, 1, (toggles[pos].w/2)-2))
        gpu.setBackground(toggles[pos].background)
        gpu.set(toggles[pos].x+((toggles[pos].w*0.25)-(#toggles[pos].bool_false/2)), toggles[pos].y, string.sub(toggles[pos].bool_false, 1, (toggles[pos].w/2)-2))
    else
        gpu.setBackground(toggles[pos].mid1)
        gpu.fill(toggles[pos].x, toggles[pos].y, toggles[pos].w/2, 1, " ")
        gpu.set(toggles[pos].x+((toggles[pos].w*0.25)-(#toggles[pos].bool_false/2)), toggles[pos].y, string.sub(toggles[pos].bool_false, 1, (toggles[pos].w/2)-2))
        gpu.setBackground(toggles[pos].background)
        gpu.set(toggles[pos].x+((toggles[pos].w*0.75)-(#toggles[pos].bool_true/2)), toggles[pos].y, string.sub(toggles[pos].bool_true, 1, (toggles[pos].w/2)-2))
    end
    gpu.setBackground(prevBkgnd)
    gpu.setForeground(prevFrgnd)
end
function selectToggle(event, address, x, y, button, name)
    for i = 1, #toggles do
        if x >= toggles[i].x and toggles[i].x + toggles[i].w > x and math.ceil(y) == toggles[i].y and toggles[i].active then
            if toggles[i].bool then
                toggles[i].bool = false
            else
                toggles[i].bool = true
            end
            loadToggle(i)
        end
    end
end
function toggleToggle(pos, bool)
    toggles[pos].active = bool
end
function setToggle(pos, bool)
    toggles[pos].bool = bool
    loadToggle(pos)
end
function ESTBListen()
    event.listen("touch", selectToggle)
end