local Players=game:GetService("Players")
local Player=Players.LocalPlayer
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local CoreGui=game:GetService("CoreGui")

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="CheatMenu"
ScreenGui.ResetOnSpawn=false
ScreenGui.DisplayOrder=999999
ScreenGui.Parent=CoreGui

local NOTIF_ICON="rbxassetid://72464791211818"
local function SendNotif(ti,te,du)game.StarterGui:SetCore("SendNotification",{Title=ti,Text=te,Icon=NOTIF_ICON,Duration=du or 4})end

local Flying=false
local Noclip=false
local InfJump=false
local FlyConnection,BodyVelocity,BodyGyro,NoclipConnection

local function GetChar()return Player.Character or Player.CharacterAdded:Wait()end
local function GetHRP()local c=GetChar()return c and c:FindFirstChild("HumanoidRootPart")end
local function GetHum()local c=GetChar()return c and c:FindFirstChild("Humanoid")end

local function Cleanup()
	if Flying then if FlyConnection then FlyConnection:Disconnect()end if BodyVelocity then BodyVelocity:Destroy()end if BodyGyro then BodyGyro:Destroy()end Flying=false local h=GetHum()if h then h.PlatformStand=false end end
	Noclip=false InfJump=false
end
Player.CharacterAdded:Connect(function()task.wait(1)Cleanup()end)
Player.CharacterRemoving:Connect(Cleanup)

local function StartFly()
	if Flying then return end
	local hum,hrp=GetHum(),GetHRP()if not hum then return end
	Flying=true hum.PlatformStand=true
	BodyVelocity=Instance.new("BodyVelocity")BodyVelocity.MaxForce=Vector3.new(1e5,1e5,1e5)BodyVelocity.Velocity=Vector3.zero BodyVelocity.Parent=hrp
	BodyGyro=Instance.new("BodyGyro")BodyGyro.MaxTorque=Vector3.new(1e5,1e5,1e5)BodyGyro.P=15000 BodyGyro.CFrame=workspace.CurrentCamera.CFrame BodyGyro.Parent=hrp
	FlyConnection=RunService.Heartbeat:Connect(function()
		BodyGyro.CFrame=workspace.CurrentCamera.CFrame
		local m=Vector3.new()local s=getgenv().FlySpeed or 100
		if UIS:IsKeyDown(Enum.KeyCode.W)then m+=workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S)then m-=workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A)then m-=workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D)then m+=workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space)then m+=Vector3.new(0,1,0)end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift)then m-=Vector3.new(0,1,0)end
		BodyVelocity.Velocity=m.Magnitude>0 and(m.Unit*s)or Vector3.zero
	end)
	SendNotif("Fly","Enabled - F to toggle",3)
end

local function StopFly()
	if not Flying then return end
	Flying=false local h=GetHum()if h then h.PlatformStand=false end
	if FlyConnection then FlyConnection:Disconnect()end if BodyVelocity then BodyVelocity:Destroy()end if BodyGyro then BodyGyro:Destroy()end
end

local function ToggleNoclip()
	Noclip=not Noclip
	if Noclip then
		NoclipConnection=RunService.Stepped:Connect(function()
			if not Noclip or not Player.Character then return end
			for _,v in pairs(Player.Character:GetDescendants())do
				if v:IsA("BasePart")and v.CanCollide then v.CanCollide=false end
			end
		end)
		SendNotif("Noclip","ON",3)
	else
		if NoclipConnection then NoclipConnection:Disconnect()end
		local c=GetChar()if c then for _,v in pairs(c:GetDescendants())do if v:IsA("BasePart")and v.Name~="HumanoidRootPart"then v.CanCollide=true end end end
		SendNotif("Noclip","OFF",2)
	end
end

UIS.JumpRequest:Connect(function()if InfJump then local h=GetHum()if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end end)
UIS.InputBegan:Connect(function(i,gp)if gp then return end if i.KeyCode==Enum.KeyCode.F then if Flying then StopFly()else StartFly()end end end)

local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,300,0,560)
MainFrame.Position=UDim2.new(0,20,0,20)
MainFrame.BackgroundColor3=Color3.fromRGB(30,30,30)
MainFrame.Active=true MainFrame.Draggable=true MainFrame.Parent=ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,12)

local TitleBar=Instance.new("Frame")
TitleBar.Size=UDim2.new(1,0,0,40)
TitleBar.BackgroundColor3=Color3.fromRGB(255,140,0)
TitleBar.Parent=MainFrame
Instance.new("UICorner",TitleBar).CornerRadius=UDim.new(0,12)

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,-100,1,0)
Title.Position=UDim2.new(0,10,0,0)
Title.BackgroundTransparency=1
Title.Text=" O_o_O v2.3"
Title.TextColor3=Color3.new(1,1,1)
Title.Font=Enum.Font.GothamBold
Title.TextSize=19
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Parent=TitleBar

local Minimize=Instance.new("TextButton")
Minimize.Size=UDim2.new(0,40,0,40)
Minimize.BackgroundTransparency=1
Minimize.Text="-"
Minimize.TextColor3=Color3.new(1,1,1)
Minimize.Font=Enum.Font.GothamBold
Minimize.TextSize=28
Minimize.Position=UDim2.new(1,-80,0,0)
Minimize.Parent=TitleBar

local Close=Instance.new("TextButton")
Close.Size=UDim2.new(0,40,0,40)
Close.BackgroundTransparency=1
Close.Text="X"
Close.TextColor3=Color3.new(1,1,1)
Close.Font=Enum.Font.GothamBold
Close.TextSize=22
Close.Position=UDim2.new(1,-40,0,0)
Close.Parent=TitleBar
Close.MouseButton1Click:Connect(function()ScreenGui:Destroy()end)

local Content=Instance.new("Frame")
Content.Size=UDim2.new(1,0,1,-40,0)
Content.Position=UDim2.new(0,0,0,40)
Content.BackgroundTransparency=1
Content.Parent=MainFrame
Content.Visible=true

local Scroll=Instance.new("ScrollingFrame")
Scroll.Size=UDim2.new(1,-20,1,-20)
Scroll.Position=UDim2.new(0,10,0,10)
Scroll.BackgroundTransparency=1
Scroll.ScrollBarThickness=8
Scroll.ScrollBarImageColor3=Color3.fromRGB(255,140,0)
Scroll.CanvasSize=UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Scroll.Parent=Content
Instance.new("UIListLayout",Scroll).Padding=UDim.new(0,12)

local function Btn(txt,cb)
	local b=Instance.new("TextButton")
	b.Size=UDim2.new(1,-20,0,45)
	b.BackgroundColor3=Color3.fromRGB(50,50,50)
	b.Text=txt
	b.TextColor3=Color3.new(1,1,1)
	b.Font=Enum.Font.Gotham
	b.TextSize=17
	b.Parent=Scroll
	Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
	b.MouseEnter:Connect(function()b.BackgroundColor3=Color3.fromRGB(70,70,70)end)
	b.MouseLeave:Connect(function()b.BackgroundColor3=Color3.fromRGB(50,50,50)end)
	b.MouseButton1Click:Connect(cb)
end

Btn("Toggle Fly (F)",function()if Flying then StopFly()else StartFly()end end)
Btn("Toggle Noclip",ToggleNoclip)
Btn("Infinite Jump",function()InfJump=not InfJump SendNotif("Infinite Jump",InfJump and"ON"or"OFF",2)end)

-- Search Bar
local SearchBar=Instance.new("TextBox")
SearchBar.Size=UDim2.new(1,-20,0,35)
SearchBar.BackgroundColor3=Color3.fromRGB(40,40,50)
SearchBar.PlaceholderText="Search players..."
SearchBar.PlaceholderColor3=Color3.fromRGB(180,180,180)
SearchBar.Text=""
SearchBar.TextColor3=Color3.new(1,1,1)
SearchBar.Font=Enum.Font.Gotham
SearchBar.TextSize=14
SearchBar.Parent=Scroll
Instance.new("UICorner",SearchBar).CornerRadius=UDim.new(0,8)

-- Player List Frame
local PlayerListFrame=Instance.new("Frame")
PlayerListFrame.Size=UDim2.new(1,-20,0,300)
PlayerListFrame.BackgroundColor3=Color3.fromRGB(40,40,50)
PlayerListFrame.Parent=Scroll
Instance.new("UICorner",PlayerListFrame).CornerRadius=UDim.new(0,10)

local ListTitle=Instance.new("TextLabel")
ListTitle.Size=UDim2.new(1,0,0,35)
ListTitle.BackgroundTransparency=1
ListTitle.Text=" Players"
ListTitle.TextColor3=Color3.new(1,1,1)
ListTitle.Font=Enum.Font.GothamBold
ListTitle.TextSize=16
ListTitle.TextXAlignment=Enum.TextXAlignment.Left
ListTitle.Position=UDim2.new(0,12,0,0)
ListTitle.Parent=PlayerListFrame

local PlayerScroll=Instance.new("ScrollingFrame")
PlayerScroll.Size=UDim2.new(1,-10,1,-40)
PlayerScroll.Position=UDim2.new(0,5,0,35)
PlayerScroll.BackgroundTransparency=1
PlayerScroll.ScrollBarThickness=6
PlayerScroll.CanvasSize=UDim2.new(0,0,0,0)
PlayerScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
PlayerScroll.Parent=PlayerListFrame
local PL=Instance.new("UIListLayout",PlayerScroll)PL.Padding=UDim.new(0,4)

-- Info Label
local InfoLabel=Instance.new("TextLabel")
InfoLabel.Size=UDim2.new(1,-20,0,100)
InfoLabel.BackgroundColor3=Color3.fromRGB(35,35,45)
InfoLabel.Text="Select a player for info"
InfoLabel.TextColor3=Color3.new(0.9,0.9,0.9)
InfoLabel.TextScaled=true
InfoLabel.TextWrapped=true
InfoLabel.Font=Enum.Font.Gotham
InfoLabel.Parent=Scroll
Instance.new("UICorner",InfoLabel).CornerRadius=UDim.new(0,10)

local function GetPlayerInfo(p)
    local info="Name: "..p.Name.."\nDisplay: "..p.DisplayName.."\nUserID: "..p.UserId.."\nAge: "..p.AccountAge.." days\nType: "..tostring(p.MembershipType):match("([^%.]+)$")or"None"
    
    if p.Character then
        local hum=p.Character:FindFirstChildOfClass("Humanoid")
        local hrp=p.Character:FindFirstChild("HumanoidRootPart")
        
        if hum then
            info=info.."\n\nHealth: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)
            info=info.."\nWalkSpeed: "..math.floor(hum.WalkSpeed)
            info=info.."\nJumpPower: "..math.floor(hum.JumpPower)
        end
        
        if hrp then
            info=info.."\nPosition: "..math.floor(hrp.Position.X)..", "..math.floor(hrp.Position.Y)..", "..math.floor(hrp.Position.Z)
        end
    else
        info=info.."\n\nCharacter: Not loaded"
    end
    
    return info
end

local function UpdatePlayerList()
	for _,v in pairs(PlayerScroll:GetChildren())do if v:IsA("TextButton")then v:Destroy()end end
	
	local searchText=string.lower(SearchBar.Text)
	
	for _,p in ipairs(Players:GetPlayers())do
		if p~=Player then
			local displayName=string.lower(p.DisplayName)
			local userName=string.lower(p.Name)
			
			if searchText==""or string.find(displayName,searchText,1,true)or string.find(userName,searchText,1,true)then
				local b=Instance.new("TextButton")
				b.Size=UDim2.new(1,0,0,34)
				b.BackgroundColor3=Color3.fromRGB(55,55,70)
				b.Text=p.DisplayName.." (@"..p.Name..")"
				b.TextColor3=Color3.new(1,1,1)
				b.Font=Enum.Font.Gotham
				b.TextSize=15
				b.Parent=PlayerScroll
				Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
				b.MouseButton1Click:Connect(function()
					InfoLabel.Text=GetPlayerInfo(p)
				end)
			end
		end
	end
end

SearchBar:GetPropertyChangedSignal("Text"):Connect(UpdatePlayerList)

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Auto-refresh player info
RunService.Heartbeat:Connect(function()
    if InfoLabel.Text~="Select a player for info"then
        local currentText=InfoLabel.Text
        local playerName=string.match(currentText,"Name: ([^\n]+)")
        if playerName then
            local p=Players:FindFirstChild(playerName)
            if p then
                InfoLabel.Text=GetPlayerInfo(p)
            end
        end
    end
end)

UpdatePlayerList()

Minimize.MouseButton1Click:Connect(function()
	Content.Visible=not Content.Visible
	Minimize.Text=Content.Visible and"-"or"+"
	if Content.Visible then MainFrame.Size=UDim2.new(0,300,0,560)else MainFrame.Size=UDim2.new(0,300,0,40)end
end)

SendNotif("O_o_O v2.3","Loaded - Click - to minimize",5)
