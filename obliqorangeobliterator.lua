local mainSound = Instance.new("Sound")
mainSound.SoundId = "rbxassetid://77507064833522"
mainSound.Volume = 0.5
mainSound.Pitch = 0.97
mainSound.Parent = game:GetService("SoundService")

local backgroundSound = Instance.new("Sound")
backgroundSound.SoundId = "rbxassetid://9038268731"
backgroundSound.Volume = 0
backgroundSound.Pitch = 1.01
backgroundSound.Parent = game:GetService("SoundService")


mainSound:Play()
backgroundSound:Play() 

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ayoey"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = CoreGui

local NOTIF_ICON = "rbxassetid://72464791211818"
local NOTIF_SOUND = 2483029612

local function SendNotif(ti, te, du)
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://"..NOTIF_SOUND
    s.Volume = 0.9
    s.Parent = SoundService
    s:Play()
    task.delay(4, s.Destroy)
    game.StarterGui:SetCore("SendNotification", {
        Title = ti;
        Text = te;
        Icon = NOTIF_ICON;
        Duration = du or 4;
    })
end

local VERSION = "v3.5"
local Flying = false
local Noclip = false
local InfJump = false
local FlyConnection, BodyVelocity, BodyGyro, NoclipConnection

local TrollEnabled = false
local TrollTarget = nil 
local TrollConnection = nil

local function GetChar() return Player.Character or Player.CharacterAdded:Wait() end
local function GetHRP() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum() local c = GetChar() return c and c:FindFirstChild("Humanoid") end

local function Cleanup()
    if Flying then
        if FlyConnection then FlyConnection:Disconnect() end
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        Flying = false
        local h = GetHum() if h then h.PlatformStand = false end
    end
    Noclip = false
    InfJump = false
end

Player.CharacterAdded:Connect(function() task.wait(1) Cleanup() end)
Player.CharacterRemoving:Connect(Cleanup)

spawn(function()
    while task.wait(0.6) do
        pcall(function()
            if Player.Character then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.Material = Enum.Material.ForceField
                        task.wait()
                        v.Material = Enum.Material.Plastic
                    end
                end
            end
        end)
    end
end)

local function StartFly()
    if Flying then return end
    local hum, hrp = GetHum(), GetHRP() if not hum or not hrp then return end
    Flying = true hum.PlatformStand = true
    BodyVelocity = Instance.new("BodyVelocity") BodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5) BodyVelocity.Velocity = Vector3.zero BodyVelocity.Parent = hrp
    BodyGyro = Instance.new("BodyGyro") BodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5) BodyGyro.P = 15000 BodyGyro.CFrame = workspace.CurrentCamera.CFrame BodyGyro.Parent = hrp
    FlyConnection = RunService.Heartbeat:Connect(function()
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        local m = Vector3.new() local s = getgenv().FlySpeed or 120
        if UIS:IsKeyDown(Enum.KeyCode.W) then m += workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then m -= workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then m -= workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then m += workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then m += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then m -= Vector3.new(0,1,0) end
        BodyVelocity.Velocity = m.Magnitude > 0 and (m.Unit * s) or Vector3.zero
    end)
    SendNotif("fly","enabled, f to toggle",3)
end

local function StopFly()
    if not Flying then return end
    Flying = false
    local hum = GetHum() if hum then hum.PlatformStand = false end
    if FlyConnection then FlyConnection:Disconnect() end
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    SendNotif("Fly","Disabled",2)
end

local function ToggleNoclip()
    Noclip = not Noclip
    if Noclip then
        NoclipConnection = RunService.Stepped:Connect(function()
            if Player.Character then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                end
            end
        end)
        SendNotif("noclip","on",3)
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        SendNotif("noclip","off",2)
    end
end

UIS.JumpRequest:Connect(function()
    if InfJump then
        local h = GetHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.F then
        if Flying then StopFly() else StartFly() end
    end
end)

-- THE UGHHHHHHHHHHHHHHHH THE GUI THANG --
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,340,0,620)
MainFrame.Position = UDim2.new(0,20,0,20)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
MainFrame.Active = true MainFrame.Draggable = true MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,14)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,45) TitleBar.BackgroundColor3 = Color3.fromRGB(255,140,0) TitleBar.Parent = MainFrame
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-50,1,0) Title.Position = UDim2.new(0,15,0,0) Title.BackgroundTransparency = 1
Title.Text = " O_o_O "..VERSION Title.TextColor3 = Color3.new(1,1,1) Title.Font = Enum.Font.GothamBlack Title.TextSize = 20 Title.TextXAlignment = Enum.TextXAlignment.Left Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,45,0,45)
Close.Position = UDim2.new(1,-45,0,0)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.TextSize = 20
Close.Font = Enum.Font.GothamBold
Close.Parent = TitleBar

Close.MouseEnter:Connect(function()
    Close.TextColor3 = Color3.fromRGB(255,100,100)
end)

Close.MouseLeave:Connect(function()
    Close.TextColor3 = Color3.new(1,1,1)
end)

Close.MouseButton1Click:Connect(function()
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name == "ayoey" then
            gui:Destroy()
        end
    end

    if FlyConnection and FlyConnection.Connected then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end

    if NoclipConnection and NoclipConnection.Connected then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    if TrollConnection and TrollConnection.Connected then
        TrollConnection:Disconnect()
        TrollConnection = nil
    end

    local character = game.Players.LocalPlayer.Character
    if character then
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        if BodyGyro then
            BodyGyro:Destroy()
            BodyGyro = nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.PlatformStand = false
            end)
        end
    end

    TrollEnabled = false

    if typeof(SendNotif) == "function" then
        pcall(function()
            SendNotif("O_o_O", "Menu destroyed", 3)
        end)
    end
end)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0,45,0,45) Minimize.Position = UDim2.new(1,-90,0,0) Minimize.BackgroundTransparency = 1
Minimize.Text = "-" Minimize.TextColor3 = Color3.new(1,1,1) Minimize.Font = Enum.Font.GothamBold Minimize.TextSize = 32 Minimize.Parent = TitleBar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,0,1,-45) Content.Position = UDim2.new(0,0,0,45) Content.BackgroundTransparency = 1 Content.Parent = MainFrame Content.Visible = true

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-20) Scroll.Position = UDim2.new(0,10,0,10) Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 8 Scroll.ScrollBarImageColor3 = Color3.fromRGB(255,140,0) Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y Scroll.Parent = Content
local Layout = Instance.new("UIListLayout",Scroll) Layout.Padding = UDim.new(0,12)

local function Btn(name, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,50) b.BackgroundColor3 = Color3.fromRGB(45,45,60) b.Text = name b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold b.TextSize = 18 b.AutoButtonColor = false b.Parent = Scroll
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(70,70,90) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(45,45,60) end)
    b.MouseButton1Click:Connect(callback)
    return b
end

Btn("Fly (F)", function() if Flying then StopFly() else StartFly() end end)
Btn("Noclip", ToggleNoclip)
Btn("Infinite Jump", function() InfJump = not InfJump SendNotif("infinite jump", InfJump and "on" or "off",2) end)
Btn("George Floyd Admin", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/JerkRaper552/TRjerkraper/refs/heads/main/floydlua.lua"))() end)

-- === TROLLING PLAYER(S) ===
local TrollFrame = Instance.new("Frame")
TrollFrame.Size = UDim2.new(1,-20,0,190) TrollFrame.BackgroundColor3 = Color3.fromRGB(45,45,60) TrollFrame.Parent = Scroll
Instance.new("UICorner", TrollFrame).CornerRadius = UDim.new(0,10)

local TrollTitle = Instance.new("TextLabel")
TrollTitle.Size = UDim2.new(1,0,0,36) TrollTitle.BackgroundTransparency = 1
TrollTitle.Text = " Troll Player" TrollTitle.TextColor3 = Color3.new(1,1,1)
TrollTitle.Font = Enum.Font.GothamBold TrollTitle.TextSize = 19 TrollTitle.TextXAlignment = Enum.TextXAlignment.Left
TrollTitle.Parent = TrollFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1,-20,0,36) SearchBox.Position = UDim2.new(0,10,0,40)
SearchBox.BackgroundColor3 = Color3.fromRGB(30,30,40) SearchBox.PlaceholderText = "Search players..."
SearchBox.Text = "" SearchBox.TextColor3 = Color3.new(1,1,1) SearchBox.Font = Enum.Font.Gotham SearchBox.TextSize = 15
SearchBox.Parent = TrollFrame
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0,8)

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(1,-20,0,80) PlayerListScroll.Position = UDim2.new(0,10,0,80)
PlayerListScroll.BackgroundColor3 = Color3.fromRGB(35,35,50) PlayerListScroll.ScrollBarThickness = 5
PlayerListScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y PlayerListScroll.Parent = TrollFrame
Instance.new("UICorner", PlayerListScroll).CornerRadius = UDim.new(0,8)
local PlayerListLayout = Instance.new("UIListLayout", PlayerListScroll)
PlayerListLayout.Padding = UDim.new(0,4)

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1,-20,0,30) SelectedLabel.Position = UDim2.new(0,10,0,165)
SelectedLabel.BackgroundTransparency = 1 SelectedLabel.Text = "Selected: None"
SelectedLabel.TextColor3 = Color3.fromRGB(200,200,200) SelectedLabel.Font = Enum.Font.Gotham SelectedLabel.TextSize = 14
SelectedLabel.Parent = TrollFrame

local ToggleTrollBtn = Instance.new("TextButton")
ToggleTrollBtn.Size = UDim2.new(1,-20,0,40) ToggleTrollBtn.Position = UDim2.new(0,10,0,200)
ToggleTrollBtn.BackgroundColor3 = Color3.fromRGB(180,50,50) ToggleTrollBtn.Text = "Start Trolling (OFF)"
ToggleTrollBtn.TextColor3 = Color3.new(1,1,1) ToggleTrollBtn.Font = Enum.Font.GothamBold ToggleTrollBtn.TextSize = 16
ToggleTrollBtn.Parent = TrollFrame
Instance.new("UICorner", ToggleTrollBtn).CornerRadius = UDim.new(0,8)

local function UpdateTrollPlayerList()
    for _, v in pairs(PlayerListScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    local query = string.lower(SearchBox.Text)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player then
            local display = plr.DisplayName
            local name = plr.Name
            if query == "" or string.find(string.lower(display), query, 1, true) or string.find(string.lower(name), query, 1, true) then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,32)
                btn.BackgroundColor3 = Color3.fromRGB(50,50,70)
                btn.Text = display.." (@"..name..")"
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = PlayerListScroll
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

                btn.MouseButton1Click:Connect(function()
                    TrollTarget = plr
                    SelectedLabel.Text = "Selected: "..display.." (@"..name..")"
                    SelectedLabel.TextColor3 = Color3.fromRGB(100,255,100)
                    SendNotif("troller", "selected: "..display, 2)
                end)
            end
        end
    end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(UpdateTrollPlayerList)
Players.PlayerAdded:Connect(UpdateTrollPlayerList)
Players.PlayerRemoving:Connect(UpdateTrollPlayerList)
UpdateTrollPlayerList()

ToggleTrollBtn.MouseButton1Click:Connect(function()
    if not TrollTarget or not TrollTarget.Character or not TrollTarget.Character:FindFirstChild("HumanoidRootPart") then
        SendNotif("troller", "invalid player", 4)
        return
    end

    TrollEnabled = not TrollEnabled
    ToggleTrollBtn.Text = TrollEnabled and "Quit Looptele (ON)" or "Start Looptele (OFF)"
    ToggleTrollBtn.BackgroundColor3 = TrollEnabled and Color3.fromRGB(50,180,50) or Color3.fromRGB(180,50,50)

    if TrollEnabled then
        if not Noclip then ToggleNoclip() end
        TrollConnection = RunService.Heartbeat:Connect(function()
            if not TrollEnabled then return end
            local hrp = GetHRP()
            local targetHRP = TrollTarget.Character and TrollTarget.Character:FindFirstChild("HumanoidRootPart")
            if hrp and targetHRP then
                hrp.CFrame = targetHRP.CFrame * CFrame.new(0, -7, 0) 
            end
        end)
        SendNotif("Looptele", "looping teleport for "..TrollTarget.DisplayName.."!", 3)
    else
        if TrollConnection then TrollConnection:Disconnect() TrollConnection = nil end
        SendNotif("Looptele", "stopped looping teleport", 2)
    end
end)

local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1,-20,0,50) SpeedFrame.BackgroundColor3 = Color3.fromRGB(45,45,60) SpeedFrame.Parent = Scroll
Instance.new("UICorner",SpeedFrame).CornerRadius = UDim.new(0,10)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.55,0,1,0) SpeedLabel.BackgroundTransparency = 1 SpeedLabel.Text = " WalkSpeed" SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.GothamSemibold SpeedLabel.TextSize = 18 SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left SpeedLabel.Parent = SpeedFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0.4,0,0.7,0) SpeedBox.Position = UDim2.new(0.58,0,0.15,0)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30,30,40) SpeedBox.Text = "16" SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.Gotham SpeedBox.TextSize = 16 SpeedBox.ClearTextOnFocus = false SpeedBox.Parent = SpeedFrame
Instance.new("UICorner",SpeedBox).CornerRadius = UDim.new(0,8)

SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(SpeedBox.Text)
        if num and num > 0 then
            local hum = GetHum()
            if hum then hum.WalkSpeed = num end
        else
            SpeedBox.Text = "16"
        end
    end
end)

-- === PLAYER SEARCH AND INFO DISPLAY ===
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(1,-20,0,40) SearchBar.BackgroundColor3 = Color3.fromRGB(40,40,55) SearchBar.PlaceholderText = "Search players..." SearchBar.Text = ""
SearchBar.TextColor3 = Color3.new(1,1,1) SearchBar.Font = Enum.Font.Gotham SearchBar.TextSize = 15 SearchBar.Parent = Scroll
Instance.new("UICorner",SearchBar).CornerRadius = UDim.new(0,10)

local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(1,-20,0,300) PlayerListFrame.BackgroundColor3 = Color3.fromRGB(35,35,50) PlayerListFrame.Parent = Scroll
Instance.new("UICorner",PlayerListFrame).CornerRadius = UDim.new(0,12)

local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(1,0,0,40) ListTitle.BackgroundTransparency = 1 ListTitle.Text = "  Players" ListTitle.TextColor3 = Color3.new(1,1,1)
ListTitle.Font = Enum.Font.GothamBold ListTitle.TextSize = 17 ListTitle.TextXAlignment = Enum.TextXAlignment.Left ListTitle.Parent = PlayerListFrame

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1,-10,1,-45) PlayerScroll.Position = UDim2.new(0,5,0,40) PlayerScroll.BackgroundTransparency = 1
PlayerScroll.ScrollBarThickness = 6 PlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y PlayerScroll.Parent = PlayerListFrame
Instance.new("UIListLayout",PlayerScroll).Padding = UDim.new(0,6)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1,-20,0,120) InfoLabel.BackgroundColor3 = Color3.fromRGB(30,30,45) InfoLabel.Text = "Select a player for info"
InfoLabel.TextColor3 = Color3.new(0.9,0.9,0.9) InfoLabel.TextScaled = true InfoLabel.TextWrapped = true InfoLabel.Font = Enum.Font.Gotham InfoLabel.Parent = Scroll
Instance.new("UICorner",InfoLabel).CornerRadius = UDim.new(0,12)

local function GetPlayerInfo(p)
	return string.format(
		"Name: %s\nDisplay: %s\nUserID: %d\nAge: %d days\nType: %s%s%s",
		p.Name, p.DisplayName, p.UserId, p.AccountAge,
		tostring(p.MembershipType):match("[^%.]+$") or "None",
		p.Character and p.Character:FindFirstChildOfClass("Humanoid") and string.format(
			"\n\nHealth: %.0f/%.0f\nWalkSpeed: %.0f\nJumpPower: %.0f",
			p.Character:FindFirstChildOfClass("Humanoid").Health,
			p.Character:FindFirstChildOfClass("Humanoid").MaxHealth,
			p.Character:FindFirstChildOfClass("Humanoid").WalkSpeed,
			p.Character:FindFirstChildOfClass("Humanoid").JumpPower
		) or "",
		p.Character and p.Character:FindFirstChild("HumanoidRootPart") and string.format(
			"\nPosition: %.0f, %.0f, %.0f",
			p.Character.HumanoidRootPart.Position.X,
			p.Character.HumanoidRootPart.Position.Y,
			p.Character.HumanoidRootPart.Position.Z
		) or "\n\nCharacter: Not loaded"
	)
end

local function UpdatePlayerList()
	for _,v in pairs(PlayerScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	local q = string.lower(SearchBar.Text)
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= Player then
			local dn = string.lower(plr.DisplayName)
			local un = string.lower(plr.Name)
			if q == "" or string.find(dn,q,1,true) or string.find(un,q,1,true) then
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1,0,0,36) b.BackgroundColor3 = Color3.fromRGB(50,50,70)
				b.Text = plr.DisplayName.." (@"..plr.Name..")"
				b.TextColor3 = Color3.new(1,1,1) b.Font = Enum.Font.Gotham b.TextSize = 15 b.Parent = PlayerScroll
				Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
				b.MouseButton1Click:Connect(function() InfoLabel.Text = GetPlayerInfo(plr) end)
			end
		end
	end
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdatePlayerList)
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

RunService.Heartbeat:Connect(function()
	if InfoLabel.Text ~= "select a player for info" then
		local name = InfoLabel.Text:match("Name: ([^\n]+)")
		if name then
			local p = Players:FindFirstChild(name)
			if p then InfoLabel.Text = GetPlayerInfo(p) end
		end
	end
end)

UpdatePlayerList()

Minimize.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    Minimize.Text = Content.Visible and "-" or "+"
    MainFrame.Size = Content.Visible and UDim2.new(0,340,0,620) or UDim2.new(0,340,0,45)
end)

SendNotif("O_o_O "..VERSION,"OoO loaded successfully, have fun.",6)

local function notify(title, text, duration, icon)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title or "Notification";
        Text = text or "";
        Duration = duration or 5;
        Icon = icon or "";
    })
end
