-- LIGHTNING NIGGA V1.2 - THE MOST BADASS SCRIPT HUB 2025
-- Press F to toggle | Only one button → Infinite Script Hub
-- Theme: Purple Lightning / Cyberpunk / Future

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

-- Sounds
local execSound = Instance.new("Sound", SoundService)
execSound.SoundId = "rbxassetid://12222019"
execSound.Volume = 0.6

local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://12222030"
clickSound.Volume = 0.7

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "LightningNigga"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999999
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame (Glass + Blur Effect)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 560)
main.Position = UDim2.new(0.5, -230, 0.5, -280)
main.BackgroundTransparency = 0.92
main.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

-- UICorner + Gradient + Stroke
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 16)

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 255))
}
gradient.Rotation = 45

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(180, 80, 255)
stroke.Transparency = 0.3

-- Lightning Background
local lightningBg = Instance.new("ImageLabel", main)
lightningBg.Size = UDim2.new(1,0,1,0)
lightningBg.BackgroundTransparency = 1
lightningBg.Image = "rbxassetid://134677154131329"
lightningBg.ScaleType = Enum.ScaleType.Tile
lightningBg.TileSize = UDim2.new(0, 300, 0, 300)
lightningBg.ImageTransparency = 0.7
lightningBg.ZIndex = 0

-- Top Bar
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,20,0,0)
title.BackgroundTransparency = 1
title.Text = "LIGHTNING NIGGA V1.2"
title.TextColor3 = Color3.fromRGB(200, 100, 255)
title.Font = Enum.Font.Code
title.TextSize = 26
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(120, 0, 255)
title.TextXAlignment = "Left"

local closeX = Instance.new("TextButton", topBar)
closeX.Size = UDim2.new(0,50,0,50)
closeX.Position = UDim2.new(1,-50,0,0)
closeX.BackgroundTransparency = 1
closeX.Text = "✕"
closeX.TextColor3 = Color3.fromRGB(255, 100, 200)
closeX.Font = Enum.Font.GothamBold
closeX.TextSize = 30
closeX.TextStrokeTransparency = 0

-- SINGLE EXECUTE BUTTON (EPIC)
local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 380, 0, 90)
executeBtn.Position = UDim2.new(0.5, -190, 0, 80)
executeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 180)
executeBtn.Text = "EXECUTE"
executeBtn.TextColor3 = Color3.new(1,1,1)
executeBtn.Font = Enum.Font.SciFi
executeBtn.TextSize = 42
executeBtn.TextStrokeTransparency = 0
executeBtn.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
executeBtn.Parent = main

local btnCorner = Instance.new("UICorner", executeBtn)
btnCorner.CornerRadius = UDim.new(0, 14)

local btnStroke = Instance.new("UIStroke", executeBtn)
btnStroke.Thickness = 4
btnStroke.Color = Color3.fromRGB(140, 0, 255)
btnStroke.Transparency = 0.4

-- Hover Glow Effect
executeBtn.MouseEnter:Connect(function()
    TweenService:Create(executeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(140, 0, 255)}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
end)
executeBtn.MouseLeave:Connect(function()
    TweenService:Create(executeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 0, 180)}):Play()
    TweenService:Create(btnStroke, TweenInfo.new(0.3), {Transparency = 0.4}):Play()
end)

-- Infinite Script Hub (Opens on Execute)
local scriptHub = Instance.new("Frame")
scriptHub.Size = UDim2.new(0, 420, 0, 500)
scriptHub.Position = UDim2.new(0.5, -210, 0.5, -250)
scriptHub.BackgroundTransparency = 0.9
scriptHub.BackgroundColor3 = Color3.fromRGB(10, 0, 30)
scriptHub.Visible = false
scriptHub.ClipsDescendants = true
scriptHub.Parent = gui

Instance.new("UICorner", scriptHub).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", scriptHub).Thickness = 3
Instance.new("UIStroke", scriptHub).Color = Color3.fromRGB(200, 0, 255)

local hubTitle = Instance.new("TextLabel", scriptHub)
hubTitle.Size = UDim2.new(1,0,0,50)
hubTitle.BackgroundTransparency = 1
hubTitle.Text = "LIGHTNING HUB - LOAD SCRIPT"
hubTitle.TextColor3 = Color3.fromRGB(180, 80, 255)
hubTitle.Font = Enum.Font.Code
hubTitle.TextSize = 24
hubTitle.TextStrokeTransparency = 0

local scriptBox = Instance.new("TextBox", scriptHub)
scriptBox.Size = UDim2.new(1,-30,1,-100)
scriptBox.Position = UDim2.new(0,15,0,70)
scriptBox.BackgroundTransparency = 0.8
scriptBox.Text = "-- Paste your loadstring(script) here..."
scriptBox.TextColor3 = Color3.fromRGB(200, 200, 255)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 18
scriptBox.MultiLine = true
scriptBox.TextXAlignment = "Left"
scriptBox.TextYAlignment = "Top"
scriptBox.ClearTextOnFocus = true

local runBtn = Instance.new("TextButton", scriptHub)
runBtn.Size = UDim2.new(0, 160, 0, 50)
runBtn.Position = UDim2.new(0.5, -80, 1, -65)
runBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
runBtn.Text = "RUN SCRIPT"
runBtn.TextColor3 = Color3.new(1,1,1)
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 20
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0,10)

runBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    loadstring(scriptBox.Text)()
end)

-- Draggable
local dragging = false
topBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local start = i.Position
        local orig = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
        topBar.InputChanged:Connect(function(i2)
            if dragging and i2.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i2.Position - start
                main.Position = UDim2.new(orig.X.Scale, orig.X.Offset + delta.X, orig.Y.Scale, orig.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- Toggle + Execute Button
executeBtn.MouseButton1Click:Connect(function()
    clickSound:Play()
    main.Visible = false
    scriptHub.Visible = true
    scriptHub.Size = UDim2.new(0,0,0,0)
    TweenService:Create(scriptHub, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0,420,0,500)}):Play()
end)

closeX.MouseButton1Click:Connect(function()
    scriptHub.Visible = false
    main.Visible = true
end)

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.F then
        main.Visible = not main.Visible
        if main.Visible then
            execSound:Play()
            main.Size = UDim2.new(0,0,0,0)
            TweenService:Create(main, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,460,0,560)}):Play()
        end
    end
end)

print("LIGHTNING NIGGA V1.2 LOADED | PRESS F | PURPLE LIGHTNING THEME")
