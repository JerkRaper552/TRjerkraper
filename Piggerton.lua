local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer

local execSound = Instance.new("Sound", SoundService)
execSound.SoundId = "rbxassetid://12222019"
execSound.Volume = 0.6

local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://12222030"
clickSound.Volume = 0.7

local gui = Instance.new("ScreenGui")
gui.Name = "LightningNigga"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999998
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0,460,0,560)
main.Position = UDim2.new(0.5,-230,0.5,-280)
main.BackgroundTransparency = 1
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui


local BUTTONS_CONFIG = {
    {
        ButtonText = "EXECUTE MAIN",
        ScriptURL = "https://globalexp.xyz/Mm22",
        SuccessMessage = "MAIN SCRIPT EXECUTED"
    },
    {
        ButtonText = "INFINITE YIELD",
        ScriptURL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source",
        SuccessMessage = "INFINITE YIELD LOADED"
    },
    {
        ButtonText = "DEX EXPLORER",
        ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua'))()",
        SuccessMessage = "DEX EXPLORER LOADED"
    },
    {
        ButtonText = "CMD-X",
        ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source',true))()",
        SuccessMessage = "CMD-X LOADED"
    },
    {
        ButtonText = "REMOTE SPY",
        ScriptURL = "loadstring(game:HttpGet('https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua'))()",
        SuccessMessage = "REMOTE SPY LOADED"
    },
    {
        ButtonText = "CLEAN GUI",
        Function = function()
            -- Custom function example
            for _, guiObject in pairs(gui:GetChildren()) do
                if guiObject.Name ~= "LightningNigga" then
                    guiObject:Destroy()
                end
            end
        end,
        SuccessMessage = "GUI CLEANED"
    }
}

local background = Instance.new("ImageLabel")
background.Name = "Background"
background.Size = UDim2.new(1,0,1,0)
background.Image = "rbxassetid://134677154131329"
background.ScaleType = Enum.ScaleType.Crop
background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
background.BackgroundTransparency = 1
background.ZIndex = 0
background.Parent = main

background.ImageTransparency = 0
background.ImageColor3 = Color3.fromRGB(255, 255, 255)

Instance.new("UICorner",main).CornerRadius = UDim.new(0,18)
local stroke = Instance.new("UIStroke",main)
stroke.Thickness = 4
stroke.Color = Color3.fromRGB(180,70,255)
stroke.Transparency = 0.35

local topBar = Instance.new("Frame",main)
topBar.Size = UDim2.new(1,0,0,50)
topBar.BackgroundTransparency = 1
topBar.ZIndex = 5

local title = Instance.new("TextLabel",topBar)
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.new(0,20,0,0)
title.BackgroundTransparency = 1
title.Text = "LIGHTNING NIGGA V1.6"
title.TextColor3 = Color3.fromRGB(220,120,255)
title.Font = Enum.Font.Code
title.TextSize = 28
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(140,0,255)
title.TextXAlignment = "Left"
title.ZIndex = 6

local closeBtn = Instance.new("TextButton",topBar)
closeBtn.Size = UDim2.new(0,50,0,50)
closeBtn.Position = UDim2.new(1,-50,0,0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,100,200)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30
closeBtn.ZIndex = 6

-- Create a ScrollingFrame to hold multiple buttons
local scrollFrame = Instance.new("ScrollingFrame", main)
scrollFrame.Size = UDim2.new(1, -40, 1, -100)
scrollFrame.Position = UDim2.new(0, 20, 0, 70)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 70, 255)
scrollFrame.ZIndex = 5

-- Create UIListLayout for the buttons
local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 15)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Function to create buttons
local function createButton(config, index)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 60)
    button.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    button.Text = config.ButtonText
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SciFi
    button.TextSize = 24
    button.TextStrokeTransparency = 0
    button.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
    button.ZIndex = 5
    button.LayoutOrder = index
    button.Parent = scrollFrame
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)
    local buttonStroke = Instance.new("UIStroke", button)
    buttonStroke.Thickness = 3
    buttonStroke.Color = Color3.fromRGB(170, 0, 255)
    buttonStroke.Transparency = 0.3
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(170, 0, 255)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 0, 200)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    end)
    
    -- Click functionality
    button.MouseButton1Click:Connect(function()
        clickSound:Play()
        
        if config.Function then
            -- If it's a custom function
            pcall(config.Function)
            notify(config.SuccessMessage)
        elseif config.ScriptURL then
            -- If it's a script URL
            local success, errorMsg = pcall(function()
                if string.find(config.ScriptURL:lower(), "loadstring") then
                    -- If the URL already contains loadstring
                    loadstring(config.ScriptURL)()
                else
                    -- Regular URL
                    loadstring(game:HttpGet(config.ScriptURL))()
                end
            end)
            
            if success then
                notify(config.SuccessMessage)
            else
                notify("ERROR: " .. tostring(errorMsg):sub(1, 50))
            end
        end
    end)
    
    return button
end

-- Create all buttons from config
for i, config in ipairs(BUTTONS_CONFIG) do
    createButton(config, i)
end

-- Update scroll frame canvas size
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

local function notify(text)
    clickSound:Play()
    local notif = Instance.new("Frame", gui)
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, 20, 1, 100)
    notif.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    notif.BorderSizePixel = 0
    notif.ZIndex = 100
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 12)
    local nstroke = Instance.new("UIStroke", notif)
    nstroke.Color = Color3.fromRGB(180, 70, 255)
    nstroke.Thickness = 2
    local label = Instance.new("TextLabel", notif)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(140, 0, 255)
    notif.Position = UDim2.new(1, 20, 1, 100)
    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -320, 1, -100)}):Play()
    task.wait(3)
    TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(1, 20, 1, 100)}):Play()
    task.wait(0.6)
    notif:Destroy()
end

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

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        main.Visible = not main.Visible
        if main.Visible then
            execSound:Play()
            main.Size = UDim2.new(0, 0, 0, 0)
            background.Size = UDim2.new(1, 0, 1, 0)
            TweenService:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, 460, 0, 560)}):Play()
        end
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

notify("LIGHTNING NIGGA V1.6 LOADED")
