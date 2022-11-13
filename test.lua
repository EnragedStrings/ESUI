local term = require("term")
require("ESdropdowns")
require("ESbuttons")
require("ESsliders")
require("ESprogress")
require("ESinput")
require("EScheckbox")
data = require("component").data
serialization = require("serialization")

createDropdown(20, 6, 7, 1, 1, 0xFFFFFF, 0x000000, 0x5A5A5A, "D1", {"", "Hello", "World"})
createDropdown(30, 6, 7, 1, 1, 0xFFFFFF, 0x000000, 0x5A5A5A, "D2", {"", "Yeet", "Sneet"})

opt = {}
for i = 1, #ddmenus do
    if ddmenus[i].name ~= "Dropdown" then
        table.insert(opt, ddmenus[i].name)
    end
end

createDropdown(5, 10, 7, 1, 3, 0xFFFFFF, 0x000000, 0x5A5A5A, "Dropdown", opt)

createButton(5, 6, 7, 1, 0xFFFFFF, "Button", false, true, 0x000000, function()
    pos = getDropdownLocation("Dropdown")
    pos2 = getDropdownLocation(getDropdown(pos))
    print(getDropdown(pos2).."            ")
end
)

local bar = createProgressBar(20, 8, 17, "TestBar", 0x000000, 0x00FF00, 0xFF0000, ">", ">")

createSlider(5, 15, 7, 0, 1, 0, 0xFFFFFF, 0xFF0000, 0x0000FF, "Slider")
sliderPos = getSliderPos("Slider")
createButton(5, 17, 7, 1, 0xFFFFFF, "Slider Value", false, true, 0x000000, function()
    print(getSliderVal(sliderPos).."      ")
    loadProgressBar(bar, getSliderVal(sliderPos))
end
)
local input = createInput(20, 10, 17, "Input", "Placeholder Text", 0xFFFFFF, 0xFF0000, 0x5A5A5A)

optlist = {"Test1", "Test2", "Test3", "Test4"}
local dropdown = createDropdown(13, 15, 6, 1, 1, 0xFFFFFF, 0x000000, 0x5A5A5A, "Options", optlist)
local box = createCheckbox(20, 15, 17, "Test Checkbox", 0xFFFFFF, 0x000000, 0xFF0000, "⬜", "⬛", optlist)
createButton(5, 19, 7, 1, 0xFFFFFF, "Checkbox Val", false, true, 0x000000, function()
    if getDropdown(dropdown) ~= nil then
        print(getDropdown(dropdown) .. " : " .. serialization.serialize(getCheckbox(box, getDropdown(dropdown))))
    else
        print(serialization.serialize(getCheckbox(box)))
    end
end
)

local rbutton = createRButton(20, 21, 10, "Radio Button", 0xFFFFFF, 0x000000, 0xFF0000, "○", "●", {"Opt1", "Opt2", "Opt3"})

createButton(5, 21, 7, 1, 0xFFFFFF, "Radio Val", false, true, 0x000000, function()
    print(getRButton(rbutton))
end
)

local toggle = createToggle(13, 21, 6, "Toggle", 0x5A5A5A, 0x000000, 0xFF0000, 0x00FF00, "OFF", "ON")

createButton(13, 17, 6, 1, 0xFFFFFF, "Get Text", false, true, 0x000000, function()
    print(getInput(input))
end
)

term.clear()

refreshButtons()
loadProgressBar(bar, 0)
loadAllDropdowns()
loadSlider(1)
loadInput(input)
loadCheckbox(box)
loadRButton(rbutton)
loadToggle(toggle)

ESDListen()
ESBListen()
ESSListen()
ESIListen()
ESCBListen()
ESRBListen()
ESTBListen()

while true do
    os.sleep()
end
