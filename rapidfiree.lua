--============================================================--
-- ⚡ Δ RAPID FIRE + TOGGLE GUI ⚡
-- Made by Suttann
--============================================================--

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Rapid Fire Settings
local toggleEnabled = false
local fireRateValue = 0.147 -- semakin kecil makin cepat (macro style)

-- Fungsi aktifkan rapid fire
local function enableRapidFire(tool)
    if tool:IsA("Tool") then
        local settingModule = tool:FindFirstChild("Setting")
        if settingModule and settingModule:IsA("ModuleScript") then
            local success, settings = pcall(require, settingModule)
            if success and type(settings) == "table" then
                if settings.FireRate ~= nil then
                    settings.FireRate = fireRateValue
                end
                if settings.Auto ~= nil then
                    settings.Auto = true
                end
            end
        end
    end
end

-- Fungsi reset rapid fire
local function disableRapidFire(tool)
    if tool:IsA("Tool") then
        local settingModule = tool:FindFirstChild("Setting")
        if settingModule and settingModule:IsA("ModuleScript") then
            local success, settings = pcall(require, settingModule)
            if success and type(settings) == "table" then
                if settings.FireRate ~= nil then
                    settings.FireRate = 0.147 -- default
                end
                if settings.Auto ~= nil then
                    settings.Auto = false
                end
            end
        end
    end
end

-- Aktif saat equip senjata
local function onCharacterAdded(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            if toggleEnabled then
                enableRapidFire(child)
            else
                disableRapidFire(child)
            end
        end
    end)
end

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- ━━ UI SETUP ━━
local gui = Instance.new("ScreenGui")
gui.Name = "RapidFireGUI"
gui.Parent = playerGui
gui.ResetOnSpawn = false
gui.DisplayOrder = 999

-- Watermark
local watermark = Instance.new("TextLabel", gui)
watermark.AnchorPoint = Vector2.new(0.5,0)
watermark.Position = UDim2.new(0.5,0,0,8)
watermark.Size = UDim2.new(0,180,0,20)
watermark.BackgroundTransparency = 1
watermark.Text = "Made by Suttann"
watermark.Font = Enum.Font.Arcade
watermark.TextScaled = true
watermark.TextColor3 = Color3.new(1,1,1)
watermark.TextStrokeColor3 = Color3.new(0,0,0)
watermark.TextStrokeTransparency = 0

-- Toggle Button
local ToggleButton = Instance.new("TextButton", gui)
ToggleButton.Size = UDim2.new(0, 120, 0, 50)
ToggleButton.Position = UDim2.new(0.8, 0, 0.8, 0) -- kanan bawah
ToggleButton.Text = "Rapid Fire: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextScaled = true
ToggleButton.Visible = true
local corner = Instance.new("UICorner", ToggleButton)
corner.CornerRadius = UDim.new(0,8)

-- Dragging Logic
local dragging, startPos, startInput
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        startPos = ToggleButton.Position
        startInput = input.Position
        local conn; conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - startInput
        ToggleButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Toggle Logic
ToggleButton.MouseButton1Click:Connect(function()
    toggleEnabled = not toggleEnabled
    ToggleButton.Text = toggleEnabled and "Rapid Fire: ON" or "Rapid Fire: OFF"

    if LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
            if child:IsA("Tool") then
                if toggleEnabled then
                    enableRapidFire(child)
                else
                    disableRapidFire(child)
                end
            end
        end
    end
end)

print("[Δ Rapid Fire GUI] ✅ Loaded with draggable toggle & watermark!")
