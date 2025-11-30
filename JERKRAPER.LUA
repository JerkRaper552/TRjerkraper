--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

--// Variables
local Player = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = CoreGui

local NOTIF_ICON = "rbxassetid://72464791211818"

--// Notification Function
local function SendNotif(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Icon = NOTIF_ICON;
        Duration = duration or 4;
    })
end

--// Fly Variables
local Flying = false
local Noclip = false
local InfJump = false
local FlyConnection, BodyVelocity, BodyGyro, NoclipConnection
local FlyAnimTrack = nil -- For custom fly animation

--// Helper Functions
local function GetChar() return Player.Character or Player.CharacterAdded:Wait() end
local function GetHRP() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum() local c = GetChar() return c and c:FindFirstChild("Humanoid") end

--// Cleanup on death/respawn
local function Cleanup()
    if Flying then
        if FlyConnection then FlyConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        if FlyAnimTrack then FlyAnimTrack:Stop() FlyAnimTrack = nil end
        Flying = false
        local hum = GetHum()
        if hum then hum.PlatformStand = false end
    end
    Noclip = false
    InfJump = false
end

Player.CharacterAdded:Connect(function() task.wait(1) Cleanup() end)
Player.CharacterRemoving:Connect(Cleanup)

--// Custom Fly Animation (R6 & R15 Compatible)
local function PlayFlyAnimation()
    local char = GetChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Stop default animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = true end

    -- Create floating idle animation
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://891621366" -- Popular floating idle (T-Pose float style)

    FlyAnimTrack = hum:LoadAnimation(anim)
    FlyAnimTrack.Priority = Enum.AnimationPriority.Action
    FlyAnimTrack.Looped = true
    FlyAnimTrack:Play()
end

local function StopFlyAnimation()
    local char = GetChar()
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate then animate.Disabled = false end -- Re-enable default animations
    if FlyAnimTrack then
        FlyAnimTrack:Stop()
        FlyAnimTrack = nil
    end
end

--// Fly Logic
local function StartFly()
    if Flying then return end
    local hum, hrp = GetHum(), GetHRP()
    if not hum or not hrp then return end

    Flying = true
    hum.PlatformStand = true

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = hrp

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    BodyGyro.P = 15000
    BodyGyro.CFrame = workspace.CurrentCamera.CFrame
    BodyGyro.Parent = hrp

    PlayFlyAnimation() -- ← NEW: Play floating animation

    FlyConnection = RunService.Heartbeat:Connect(function()
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame

        local move = Vector3.new()
        local speed = getgenv().FlySpeed or 100

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        BodyVelocity.Velocity = move.Magnitude > 0 and (move.Unit * speed) or Vector3.zero
    end)

    SendNotif("Fly", "Enabled - Press F to toggle", 3)
end

local function StopFly()
    if not Flying then return end
    Flying = false

    local hum = GetHum()
    if hum then hum.PlatformStand = false end

    if FlyConnection then FlyConnection:Disconnect() end
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end

    StopFlyAnimation() -- ← NEW: Stop custom fly animation

    SendNotif("Fly", "Disabled", 2)
end

--// Noclip Toggle
local function ToggleNoclip()
    Noclip = not Noclip
    if Noclip then
        NoclipConnection = RunService.Stepped:Connect(function()
            if not Noclip or not Player.Character then return end
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        SendNotif("Noclip", "ON", 3)
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        local char = GetChar()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        SendNotif("Noclip", "OFF", 2)
    end
end

--// Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfJump then
        local hum = GetHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

--// Toggle Fly with F
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F then
        if Flying then StopFly() else StartFly() end
    end
end)

--// GUI Creation (Clean & Modern)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 580)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 14)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "  O_o_O v2.3"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Buttons
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 45, 0, 45)
Close.Position = UDim2.new(1, -45, 0, 0)
Close.BackgroundTransparency = Color3.fromRGB(255, 140, 0)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 24
Close.Parent = TitleBar
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 45, 0, 45)
Minimize.Position = UDim2.new(1, -90, 0, 0)
Minimize.BackgroundTransparency = 1
Minimize.Text = "−"
Minimize.TextColor3 = Color3.new(1,1,1)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 32
Minimize.Parent = TitleBar

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame
Content.Visible = true

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 8
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.Parent = Content

local ListLayout = Instance.new("UIListLayout", Scroll)
ListLayout.Padding = UDim.new(0, 12)
ListLayout.FillDirection = Enum.FillDirection.Vertical

-- Button Creator
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 17
    btn.AutoButtonColor = false
    btn.Parent = Scroll

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(70, 70, 90) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60) end)
    btn.MouseButton1Click:Connect(callback)

    return btn
end

-- Buttons
CreateButton("Toggle Fly (F)", function()
    if Flying then StopFly() else StartFly() end
end)

CreateButton("Toggle Noclip", ToggleNoclip)

CreateButton("Infinite Jump", function()
    InfJump = not InfJump
    SendNotif("Infinite Jump", InfJump and "Enabled" or "Disabled", 2)
end)

-- Search Bar
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1, -20, 0, 40)
SearchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SearchBar.PlaceholderText = "Search players..."
SearchBar.PlaceholderColor3 = Color3.fromRGB(150,150,170)
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.new(1,1,1)
SearchBar.Font = Enum.Font.Gotham
SearchBar.TextSize = 15
SearchBar.ClearTextOnFocus = false
SearchBar.Parent = Scroll

local sbCorner = Instance.new("UICorner", SearchBar)
sbCorner.CornerRadius = UDim.new(0, 10)

-- Player List
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1, -20, 0, 340)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
PlayerListFrame.Parent = Scroll

local plCorner = Instance.new("UICorner", PlayerListFrame)
plCorner.CornerRadius = UDim.new(0, 12)

local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(1, 0, 0, 40)
ListTitle.BackgroundTransparency = 1
ListTitle.Text = "  Players"
ListTitle.TextColor3 = Color3.new(1,1,1)
ListTitle.Font = Enum.Font.GothamBold
ListTitle.TextSize = 17
ListTitle.TextXAlignment = Enum.TextXAlignment.Left
ListTitle.Parent = PlayerListFrame

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -10, 1, -45)
PlayerScroll.Position = UDim2.new(0, 5, 0, 40)
PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.CanvasSize = UDim2.new(0,0,0,0)
PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerScroll.Parent = PlayerListFrame

local PlayerLayout = Instance.new("UIListLayout", PlayerScroll)
PlayerLayout.Padding = UDim.new(0, 6)

-- Info Box
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 120)
InfoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
InfoLabel.Text = "Select a player for info"
InfoLabel.TextColor3 = Color3.new(0.9,0.9,0.9)
InfoLabel.TextScaled = true
InfoLabel.TextWrapped = true
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Parent = Scroll

local infoCorner = Instance.new("UICorner", InfoLabel)
infoCorner.CornerRadius = UDim.new(0, 12)

-- Player Info Function
local function GetPlayerInfo(p)
    local info = string.format(
        "Name: %s\nDisplay: %s\nUserID: %d\nAge: %d days\nType: %s",
        p.Name,
        p.DisplayName,
        p.UserId,
        p.AccountAge,
        tostring(p.MembershipType):match("[^%.]+$") or "None"
    )

    if p.Character then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")

        if hum then
            info = info .. string.format(
                "\n\nHealth: %.0f/%.0f\nWalkSpeed: %.0f\nJumpPower: %.0f",
                hum.Health, hum.MaxHealth, hum.WalkSpeed, hum.JumpPower
            )
        end

        if hrp then
            local pos = hrp.Position
            info = info .. string.format("\nPosition: %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
        end
    else
        info = info .. "\n\nCharacter: Not loaded"
    end

    return info
end

-- Update Player List
local function UpdatePlayerList()
    for _, v in pairs(PlayerScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    local query = string.lower(SearchBar.Text)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local dname = string.lower(plr.DisplayName)
            local uname = string.lower(plr.Name)

            if query == "" or string.find(dname, query, 1, true) or string.find(uname, query, 1, true) then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 36)
                btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                btn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 15
                btn.Parent = PlayerScroll

                local c = Instance.new("UICorner", btn)
                c.CornerRadius = UDim.new(0, 8)

                btn.MouseButton1Click:Connect(function()
                    InfoLabel.Text = GetPlayerInfo(plr)
                end)
            end
        end
    end
end

-- Events
SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdatePlayerList)
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Auto-update selected player info
RunService.Heartbeat:Connect(function()
    if InfoLabel.Text ~= "Select a player for info" then
        local name = InfoLabel.Text:match("Name: ([^\n]+)")
        if name then
            local p = Players:FindFirstChild(name)
            if p then
                InfoLabel.Text = GetPlayerInfo(p)
            end
        end
    end
end)

UpdatePlayerList()

-- Minimize Button
Minimize.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    Minimize.Text = Content.Visible and "−" or "+"
    MainFrame.Size = Content.Visible and UDim2.new(0, 320, 0, 580) or UDim2.new(0, 320, 0, 45)
end)

-- Load Notification
SendNotif("O_o_O v2.3", "Loaded successfully! Press − to minimize", 6)
