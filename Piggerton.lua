-- Lightning Nigga V1.6 - Fully Fixed & Cleaned
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

-- Sounds
local execSound = Instance.new("Sound", SoundService)
execSound.SoundId = "rbxassetid://12222019"
execSound.Volume = 0.6

local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://12222030"
clickSound.Volume = 0.7

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "LightningNigga"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999998
gui.Parent = player:WaitForChild("PlayerGui")

-- Notification Assets
local NOTIF_ICON = "rbxassetid://134677154131329"  -- Your purple icon
local NOTIF_SOUND = 12222019

-- Config
local config = {
    Sounds = true
}

-- Proper SendNotif (Roblox Core Style - Clean & Professional)
local function SendNotif(title, text, duration)
    duration = duration or 4

    StarterGui:SetCore("SendNotification", {
        Title = title or "Lightning Nigga",
        Text = text or "Action completed.",
        Icon = NOTIF_ICON,
        Duration = duration
    })

    if config.Sounds then
        task.spawn(function()
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://" .. NOTIF_SOUND
            s.Volume = 0.9
            s.Parent = SoundService
            s:Play()
            task.delay(5, function() s:Destroy() end)
        end)
    end
end

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 460, 0, 560)
main.Position = UDim2.new(0.5, -230, 0.5, -280)
main.BackgroundTransparency = 1
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

local background = Instance.new("ImageLabel")
background.Name = "Background"
background.Size = UDim2.new(1, 0, 1, 0)
background.Image = "rbxassetid://134677154131329"
background.ScaleType = Enum.ScaleType.Crop
background.BackgroundTransparency = 1
background.ImageTransparency = 0
background.ImageColor3 = Color3.fromRGB(255, 255, 255)
background.ZIndex = 0
background.Parent = main

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 4)
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 4
stroke.Color = Color3.fromRGB(180, 70, 255)
stroke.Transparency = 0.35

local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 5

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LIGHTNING NIGGA V1.8"
title.TextColor3 = Color3.fromRGB(100, 0, 200)
title.Font = Enum.Font.Code
title.TextSize = 28
title.TextStrokeTransparency = 1
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -50, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(100, 0, 200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30
closeBtn.ZIndex = 6

local scrollFrame = Instance.new("ScrollingFrame", main)
scrollFrame.Size = UDim2.new(1, -40, 1, -100)
scrollFrame.Position = UDim2.new(0, 20, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 70, 255)
scrollFrame.ZIndex = 5

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 15)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local BUTTONS_CONFIG = {
    { ButtonText = "EXECUTE MAIN",        ScriptURL = "https://globalexp.xyz/Mm22",                                      SuccessMessage = "MAIN SCRIPT EXECUTED" },
    { ButtonText = "INFINITE YIELD",      ScriptURL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", SuccessMessage = "INFINITE YIELD LOADED" },
    { ButtonText = "DEX EXPLORER",        ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua'))()", SuccessMessage = "DEX EXPLORER LOADED" },
    { ButtonText = "CMD-X",               ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source',true))()", SuccessMessage = "CMD-X LOADED" },
    { ButtonText = "REMOTE SPY",          ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua'))()", SuccessMessage = "REMOTE SPY LOADED" },
    
    { ButtonText = "DESTROY GUI",           Function = function()
        for _, obj in pairs(gui:GetChildren()) do
            if obj.Name ~= "LightningNigga" then obj:Destroy() end
        end
    end, SuccessMessage = "GUI CLEANED" },
}

local function createButton(cfg, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 60)
    button.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    button.BackgroundTransparency = 0.8
    button.Text = cfg.ButtonText
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SciFi
    button.TextSize = 24
    button.TextStrokeTransparency = 0.5
    button.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    button.ZIndex = 5
    button.LayoutOrder = index
    button.Parent = scrollFrame

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 3)
    local bStroke = Instance.new("UIStroke", button)
    bStroke.Thickness = 3
    bStroke.Color = Color3.fromRGB(170, 0, 255)
    bStroke.Transparency = 0.3

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 255)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 200)}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        clickSound:Play()

        if cfg.Function then
            pcall(cfg.Function)
            SendNotif("Lightning Nigga", cfg.SuccessMessage, 4)
        elseif cfg.ScriptURL then
            local success, err = pcall(function()
                if cfg.ScriptURL:find("loadstring") then
                    loadstring(cfg.ScriptURL)()
                else
                    loadstring(game:HttpGet(cfg.ScriptURL))()
                end
            end)

            if success then
                SendNotif("LIGHTNING NIGGA", cfg.SuccessMessage, 4)
            else
                SendNotif("LIGHTNING NIGGA", "failed to execute: " .. tostring(err):sub(1, 60), 6)
            end
        end
    end)
end

for i, cfg in ipairs(BUTTONS_CONFIG) do
    createButton(cfg, i)
end

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
end)

local dragging = false
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local startPos = input.Position
        local startFramePos = main.Position

        local moveConn, upConn
        moveConn = topBar.InputChanged:Connect(function(input2)
            if dragging and input2.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input2.Position - startPos
                main.Position = UDim2.new(
                    startFramePos.X.Scale,
                    startFramePos.X.Offset + delta.X,
                    startFramePos.Y.Scale,
                    startFramePos.Y.Offset + delta.Y
                )
            end
        end)

        upConn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                moveConn:Disconnect()
                upConn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Q then
        main.Visible = not main.Visible
        if main.Visible then
            execSound:Play()
            main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 460, 0, 560)
            }):Play()
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

SendNotif("LIGHTNING NIGGA", "loaded successfully.\npress 'q' to open menu", 6)
