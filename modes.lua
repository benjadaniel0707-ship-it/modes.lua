-- Fly + animación random (Delta X)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Limpiar GUI anterior
local function getParent()
    local ok, ui = pcall(function() return gethui and gethui() end)
    if ok and ui then return ui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return player:WaitForChild("PlayerGui")
end
local parent = getParent()
if parent:FindFirstChild("FlyRandomGui") then parent.FlyRandomGui:Destroy() end

-- Animaciones R15 (idle/fall de packs oficiales)
local anims = {
    {"Levitación", 616006778},
    {"Astronauta", 891617961},
    {"Ninja", 656115606},
    {"Cartoony", 742637151},
    {"Robot", 616087089},
    {"Mago", 707829716},
    {"Juguete", 782846423},
    {"Zombie", 616158929},
    {"Bubbly", 910001910},
    {"Caballero", 657600338},
    {"Hombre lobo", 1083189019},
    {"Vampiro", 1083443587},
    {"Anciano", 845396048},
}

local flying, speed = false, 60
local up, down = false, false
local bv, bg, conn, currentTrack
local controls

pcall(function()
    local ps = player:FindFirstChild("PlayerScripts")
    local pm = ps and ps:FindFirstChild("PlayerModule")
    if pm then controls = require(pm):GetControls() end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyRandomGui"
gui.ResetOnSpawn = false
gui.Parent = parent

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 190, 0, 280)
frame.Position = UDim2.new(0.02, 0, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "✈ Fly Random"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local animLabel = Instance.new("TextLabel")
animLabel.Size = UDim2.new(1, 0, 0, 20)
animLabel.Position = UDim2.new(0, 0, 0, 28)
animLabel.BackgroundTransparency = 1
animLabel.Text = "Anim: ninguna"
animLabel.TextColor3 = Color3.fromRGB(170, 170, 255)
animLabel.Font = Enum.Font.Gotham
animLabel.TextSize = 13
animLabel.Parent = frame

local function makeButton(text, x, y, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, 36)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local flyBtn   = makeButton("Volar: OFF", 10, 55, 170)
local randBtn  = makeButton("🎲 Animación random", 10, 98, 170)
local upBtn    = makeButton("⬆ Subir", 10, 141, 82)
local downBtn  = makeButton("⬇ Bajar", 98, 141, 82)
local spdMinus = makeButton("Vel -", 10, 184, 82)
local spdPlus  =
