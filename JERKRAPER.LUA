local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "jerkraper"
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
	game.StarterGui:SetCore("SendNotification", {Title = ti, Text = te, Icon = NOTIF_ICON, Duration = du or 4})
end

local VERSION = "v2.9"

local Flying = false
local Noclip = false
local InfJump = false
local FlyConnection, BodyVelocity, BodyGyro, NoclipConnection

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

-- Anti-Anticheat loop
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

-- Fly
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
	SendNotif("Fly","Enabled - F to toggle",3)
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

-- Noclip
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
		SendNotif("Noclip","ON",3)
	else
		if NoclipConnection then NoclipConnection:Disconnect() end
		SendNotif("Noclip","OFF",2)
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

-- GUI
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
Title.Text = "  O_o_O "..VERSION Title.TextColor3 = Color3.new(1,1,1) Title.Font = Enum.Font.GothamBlack Title.TextSize = 20 Title.TextXAlignment = Enum.TextXAlignment.Left Title.Parent = TitleBar

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0,45,0,45) Close.Position = UDim2.new(1,-45,0,0) Close.BackgroundTransparency = 1 Close.Text = "" Close.Parent = TitleBar
local CloseIcon = Instance.new("ImageLabel")
CloseIcon.Size = UDim2.new(0,28,0,28) CloseIcon.Position = UDim2.new(0.5,-14,0.5,-14) CloseIcon.BackgroundTransparency = 1
CloseIcon.Image = "rbxassetid://7072720872" CloseIcon.ImageColor3 = Color3.new(1,1,1) CloseIcon.Parent = Close
Close.MouseEnter:Connect(function() CloseIcon.ImageColor3 = Color3.fromRGB(255,80,80) end)
Close.MouseLeave:Connect(function() CloseIcon.ImageColor3 = Color3.new(1,1,1) end)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

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

Btn("Toggle Fly (F)", function() if Flying then StopFly() else StartFly() end end)
Btn("Toggle Noclip", ToggleNoclip)
Btn("Infinite Jump", function() InfJump = not InfJump SendNotif("Inf Jump", InfJump and "ON" or "OFF",2) end)
Btn("Admin Commands", function() loadstring(game:HttpGet(https://raw.githubusercontent.com/JerkRaper552/TRjerkraper/refs/heads/main/floydlua?token=GHSAT0AAAAAADQKOV42YBZUNPQWXB633SVQ2JMUK4A"))() SendNotif("Admin","Floyd loaded",5) end)

-- Speed control
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1,-20,0,50) SpeedFrame.BackgroundColor3 = Color3.fromRGB(45,45,60) SpeedFrame.Parent = Scroll
Instance.new("UICorner",SpeedFrame).CornerRadius = UDim.new(0,10)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.55,0,1,0) SpeedLabel.BackgroundTransparency = 1 SpeedLabel.Text = "  WalkSpeed" SpeedLabel.TextColor3 = Color3.new(1,1,1)
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

-- Player list + info (fully restored)
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
	if InfoLabel.Text ~= "Select a player for info" then
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

SendNotif("O_o_O "..VERSION,"Loaded - Clean & Powerful",6)
