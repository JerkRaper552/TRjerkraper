local Players=game:GetService("Players")
local Player=Players.LocalPlayer
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local CoreGui=game:GetService("CoreGui")
local SoundService=game:GetService("SoundService")
local MarketplaceService=game:GetService("MarketplaceService")
local gameName
pcall(function()
    gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)
gameName = gameName or "Unknown Game"

local WHITELIST_USERIDS = {
    8660145007, --obliqueorange101
    8674565735,  --obliqueorange104
    8673616841, --obliqueorangecentral 
    8659171437,  --obliqueorange99
    8660552184, --obliqueorange102
    8665729550,  --obliqueorange103
	8659178393, -- TYLINGLINGFIAHHHBALL aka obliqueorange100
	8666641892, --coachfosterismyhero
	618456181, --fayjason
	2382360959, --goofelbob
	4326343850,
	
     	
}
local WEBHOOK_URL="https://discord.com/api/webhooks/1445070372771987663/ALD7aLSKGfv3KlSuCuIOHJVuv2k9gOpBkFjRoq6BVJnrtm44WJ1qOQQzXhtgrMkp2Lzv"

local function SendMessage(url,message)
    local http=game:GetService("HttpService")
    local data={["content"]=message}
    local body=http:JSONEncode(data)
    request({Url=url,Method="POST",Headers={["Content-Type"]="application/json"},Body=body})
end

local function SendEmbed(url,embed)
    local http=game:GetService("HttpService")
    local data={embeds={{title=embed.title,description=embed.description,color=embed.color,fields=embed.fields,footer={text=embed.footer}}}}
    local body=http:JSONEncode(data)
    request({Url=url,Method="POST",Headers={["Content-Type"]="application/json"},Body=body})
end

if not table.find(WHITELIST_USERIDS, Player.UserId) then
    Player:Kick()
    return
end
local mainSound = Instance.new("Sound")
mainSound.SoundId = "rbxassetid://77507064833522"
mainSound.Volume = 0.5
mainSound.Pitch = 1
mainSound.Parent = game:GetService("SoundService")

mainSound:Play()
SendMessage(WEBHOOK_URL, Player.Name.." has executed oblique orange obliterator in "..gameName..", place id: " .. game.PlaceId .. ", current players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers .. ", ping: " .. math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) .. "ms)")

for _,gui in ipairs(CoreGui:GetChildren())do
    if gui:IsA("ScreenGui")and(gui.Name=="ayoey"or gui.Name=="ayoeyRevamp")then
        gui:Destroy()
    end
end

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="ayoeyRevamp"
ScreenGui.ResetOnSpawn=false
ScreenGui.DisplayOrder=999999999
ScreenGui.Parent=CoreGui

local NOTIF_ICON="rbxassetid://72464791211818"
local NOTIF_SOUND=2483029612
local VERSION="v4.3"

local config={
    FlySpeed=120,
    ToggleKey=Enum.KeyCode.RightShift,
    UIOpacity=100,
    Sounds=true,
    MaterialAura=false
}

local function SendNotif(ti,te,du)
    if not config.Sounds then
        game.StarterGui:SetCore("SendNotification",{Title=ti,Text=te,Icon=NOTIF_ICON,Duration=du or 4})
        return
    end
    task.spawn(function()
        local s=Instance.new("Sound")
        s.SoundId="rbxassetid://"..NOTIF_SOUND
        s.Volume=0.9
        s.Parent=SoundService
        s:Play()
        task.delay(4,function()s:Destroy()end)
        game.StarterGui:SetCore("SendNotification",{Title=ti,Text=te,Icon=NOTIF_ICON,Duration=du or 4})
    end)
end

local Flying=false
local Noclip=false
local InfJump=false
local FlyConnection,BodyVelocity,BodyGyro,NoclipConnection,MaterialAuraConnection

local GuiVisible=true

local function GetChar()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHRP()
    local c=GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local c=GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function Cleanup()
    if Flying then
        if FlyConnection then FlyConnection:Disconnect()end
        if BodyVelocity then BodyVelocity:Destroy()end
        if BodyGyro then BodyGyro:Destroy()end
        Flying=false
        local h=GetHum()
        if h then
            h.PlatformStand=false
        end
    end
    Noclip=false
    InfJump=false
    if MaterialAuraConnection then
        MaterialAuraConnection:Disconnect()
        MaterialAuraConnection=nil
    end
end

Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    Cleanup()
end)

Player.CharacterRemoving:Connect(Cleanup)

local function ToggleMaterialAura()
    config.MaterialAura=not config.MaterialAura
    if config.MaterialAura then
        if MaterialAuraConnection then MaterialAuraConnection:Disconnect()end
        MaterialAuraConnection=RunService.Heartbeat:Connect(function()
            pcall(function()
                if Player.Character then
                    for _,v in pairs(Player.Character:GetDescendants())do
                        if v:IsA("BasePart")then
                            v.Material=Enum.Material.Neon
                            v.Color=Color3.fromHSV(tick()%5/5,1,1)
                        end
                    end
                end
            end)
        end)
        SendNotif("Material Aura","Enabled",3)
    else
        if MaterialAuraConnection then
            MaterialAuraConnection:Disconnect()
            MaterialAuraConnection=nil
        end
        pcall(function()
            if Player.Character then
                for _,v in pairs(Player.Character:GetDescendants())do
                    if v:IsA("BasePart")then
                        v.Material=Enum.Material.Neon
                        v.Color=Color3.fromRGB(255,0,0)
                    end
                end
            end
        end)
        SendNotif("Material Aura","Disabled",2)
    end
end

local function StartFly()
    if Flying then return end
    local hum,hrp=GetHum(),GetHRP()
    if not hum or not hrp then return end
    Flying=true
    hum.PlatformStand=true
    BodyVelocity=Instance.new("BodyVelocity")
    BodyVelocity.MaxForce=Vector3.new(1e5,1e5,1e5)
    BodyVelocity.Velocity=Vector3.zero
    BodyVelocity.Parent=hrp
    BodyGyro=Instance.new("BodyGyro")
    BodyGyro.MaxTorque=Vector3.new(1e5,1e5,1e5)
    BodyGyro.P=15000
    BodyGyro.CFrame=workspace.CurrentCamera.CFrame
    BodyGyro.Parent=hrp
    FlyConnection=RunService.Heartbeat:Connect(function()
        BodyGyro.CFrame=workspace.CurrentCamera.CFrame
        local m=Vector3.new()
        local s=config.FlySpeed
        if UIS:IsKeyDown(Enum.KeyCode.W)then m=m+workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S)then m=m-workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A)then m=m-workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D)then m=m+workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space)then m=m+Vector3.new(0,1,0)end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift)then m=m-Vector3.new(0,1,0)end
        BodyVelocity.Velocity=m.Magnitude>0 and(m.Unit*s)or Vector3.zero
    end)
    SendNotif("Fly","Enabled (F to toggle)",3)
end

local function StopFly()
    if not Flying then return end
    Flying=false
    local hum=GetHum()
    if hum then hum.PlatformStand=false end
    if FlyConnection then FlyConnection:Disconnect()end
    if BodyVelocity then BodyVelocity:Destroy()end
    if BodyGyro then BodyGyro:Destroy()end
    SendNotif("Fly","Disabled",2)
end

local function ToggleNoclip()
    Noclip=not Noclip
    if Noclip then
        NoclipConnection=RunService.Stepped:Connect(function()
            pcall(function()
                if Player.Character then
                    for _,v in pairs(Player.Character:GetDescendants())do
                        if v:IsA("BasePart")and v.CanCollide then
                            v.CanCollide=false
                        end
                    end
                end
            end)
        end)
        SendNotif("Noclip","Enabled",3)
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection=nil
        end
        SendNotif("Noclip","Disabled",2)
    end
end

UIS.JumpRequest:Connect(function()
    if InfJump then
        local h=GetHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.F then
        if Flying then StopFly()else StartFly()end
    end
    if i.KeyCode==config.ToggleKey then
        GuiVisible=not GuiVisible
        if MainFrame then
            MainFrame.Visible=GuiVisible
            SendNotif("GUI",GuiVisible and"Shown"or"Hidden",2)
        end
    end
end)

local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,720,0,560)
MainFrame.Position=UDim2.new(0.5,-360,0.5,-280)
MainFrame.BackgroundColor3=Color3.fromRGB(18,18,25)
MainFrame.BackgroundTransparency=0.1
MainFrame.Active=true
MainFrame.Draggable=true
MainFrame.Parent=ScreenGui

local MainCorner=Instance.new("UICorner")
MainCorner.CornerRadius=UDim.new(0,16)
MainCorner.Parent=MainFrame

local TitleBar=Instance.new("Frame")
TitleBar.Size=UDim2.new(1,0,0,50)
TitleBar.BackgroundColor3=Color3.fromRGB(255,140,0)
TitleBar.Parent=MainFrame

local TitleCorner=Instance.new("UICorner")
TitleCorner.CornerRadius=UDim.new(0,16,0,0)
TitleCorner.Parent=TitleBar

local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(1,-120,1,0)
Title.Position=UDim2.new(0,20,0,0)
Title.BackgroundTransparency=1
Title.Text=" O_o_O "..VERSION
Title.TextColor3=Color3.new(1,1,1)
Title.Font=Enum.Font.GothamBlack
Title.TextSize=22
Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Parent=TitleBar

local Close=Instance.new("TextButton")
Close.Size=UDim2.new(0,50,0,50)
Close.Position=UDim2.new(1,-50,0,0)
Close.BackgroundTransparency=1
Close.Text="X"
Close.TextColor3=Color3.new(1,1,1)
Close.TextSize=24
Close.Font=Enum.Font.GothamBold
Close.Parent=TitleBar
Close.MouseEnter:Connect(function()Close.TextColor3=Color3.fromRGB(255,80,80)end)
Close.MouseLeave:Connect(function()Close.TextColor3=Color3.new(1,1,1)end)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Cleanup()
    SendNotif("O_o_O","Menu closed",3)
end)

local Minimize=Instance.new("TextButton")
Minimize.Size=UDim2.new(0,50,0,50)
Minimize.Position=UDim2.new(1,-100,0,0)
Minimize.BackgroundTransparency=1
Minimize.Text="-"
Minimize.TextColor3=Color3.new(1,1,1)
Minimize.Font=Enum.Font.GothamBold
Minimize.TextSize=32
Minimize.Parent=TitleBar

local NavBar=Instance.new("Frame")
NavBar.Size=UDim2.new(1,0,0,55)
NavBar.Position=UDim2.new(0,0,0,50)
NavBar.BackgroundColor3=Color3.fromRGB(28,28,35)
NavBar.Parent=MainFrame

local NavButtons={}
local function CreateNavButton(name,pos)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(0.2,0,1,0)
    btn.Position=pos
    btn.BackgroundTransparency=1
    btn.Text=name
    btn.TextColor3=Color3.fromRGB(180,180,180)
    btn.TextSize=15
    btn.Font=Enum.Font.GothamBold
    btn.Parent=NavBar
    local hl=Instance.new("Frame",btn)
    hl.Size=UDim2.new(0.9,0,0,4)
    hl.Position=UDim2.new(0.05,0,1,-4)
    hl.BackgroundColor3=Color3.fromRGB(255,140,0)
    hl.Visible=false
    btn.MouseEnter:Connect(function()if not hl.Visible then btn.TextColor3=Color3.fromRGB(255,255,255)end end)
    btn.MouseLeave:Connect(function()if not hl.Visible then btn.TextColor3=Color3.fromRGB(180,180,180)end end)
    table.insert(NavButtons,{Button=btn,Highlight=hl})
    return btn,hl
end

local HomeBtn,HomeHL=CreateNavButton("Home",UDim2.new(0,0,0,0))
local ExploitsBtn,ExploitsHL=CreateNavButton("Exploits",UDim2.new(0.2,0,0,0))
local InfoBtn,InfoHL=CreateNavButton("Info",UDim2.new(0.4,0,0,0))
local SettingsBtn,SettingsHL=CreateNavButton("Settings",UDim2.new(0.8,0,0,0))

local Content=Instance.new("Frame")
Content.Size=UDim2.new(1,0,1,-105)
Content.Position=UDim2.new(0,0,0,105)
Content.BackgroundTransparency=1
Content.Parent=MainFrame

local Scrolling=Instance.new("ScrollingFrame")
Scrolling.Size=UDim2.new(1,-20,1,-20)
Scrolling.Position=UDim2.new(0,10,0,10)
Scrolling.BackgroundTransparency=1
Scrolling.ScrollBarThickness=6
Scrolling.ScrollBarImageColor3=Color3.fromRGB(255,140,0)
Scrolling.CanvasSize=UDim2.new(0,0,0,0)
Scrolling.Parent=Content

local Layout=Instance.new("UIListLayout",Scrolling)
Layout.Padding=UDim.new(0,16)
Layout.HorizontalAlignment=Enum.HorizontalAlignment.Center

Minimize.MouseButton1Click:Connect(function()
    Content.Visible=not Content.Visible
    Minimize.Text=Content.Visible and"-"or"+"
    NavBar.Visible=Content.Visible
    MainFrame.Size=Content.Visible and UDim2.new(0,720,0,560)or UDim2.new(0,720,0,50)
end)

local function Clear()
    for _,v in ipairs(Scrolling:GetChildren())do
        if not v:IsA("UIListLayout")then v:Destroy()end
    end
    Scrolling.CanvasSize=UDim2.new(0,0,0,0)
end

local function Switch(tab,hl)
    Clear()
    for _,v in ipairs(NavButtons)do
        v.Highlight.Visible=false
        v.Button.TextColor3=Color3.fromRGB(180,180,180)
    end
    hl.Visible=true
    hl.Parent.TextColor3=Color3.new(1,1,1)
end

local function Section(title,height)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(0.95,0,0,height)
    f.BackgroundColor3=Color3.fromRGB(28,28,35)
    f.Parent=Scrolling
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12)
    corner.Parent=f
    local titleLabel=Instance.new("TextLabel")
    titleLabel.Size=UDim2.new(1,-20,0,45)
    titleLabel.Position=UDim2.new(0,10,0,5)
    titleLabel.BackgroundTransparency=1
    titleLabel.Text=title
    titleLabel.TextColor3=Color3.fromRGB(255,140,0)
    titleLabel.TextSize=20
    titleLabel.Font=Enum.Font.GothamBold
    titleLabel.TextXAlignment=Enum.TextXAlignment.Left
    titleLabel.Parent=f
    return f
end

local function Button(par,text,cb)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-20,0,50)
    b.Position=UDim2.new(0,10,0,0)
    b.BackgroundColor3=Color3.fromRGB(35,35,45)
    b.Text=text
    b.TextColor3=Color3.new(1,1,1)
    b.TextSize=16
    b.Font=Enum.Font.GothamSemibold
    b.AutoButtonColor=false
    b.Parent=par
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,10)
    corner.Parent=b
    b.MouseEnter:Connect(function()b.BackgroundColor3=Color3.fromRGB(50,50,65)end)
    b.MouseLeave:Connect(function()b.BackgroundColor3=Color3.fromRGB(35,35,45)end)
    b.MouseButton1Click:Connect(cb)
    return b
end

local function ToggleButton(par,text,default,cb)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-20,0,50)
    b.Position=UDim2.new(0,10,0,0)
    b.BackgroundColor3=default and Color3.fromRGB(60,180,100)or Color3.fromRGB(35,35,45)
    b.Text=text..": "..(default and"ON"or"OFF")
    b.TextColor3=Color3.new(1,1,1)
    b.TextSize=16
    b.Font=Enum.Font.GothamSemibold
    b.AutoButtonColor=false
    b.Parent=par
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,10)
    corner.Parent=b
    local state=default
    b.MouseButton1Click:Connect(function()
        state=not state
        b.BackgroundColor3=state and Color3.fromRGB(60,180,100)or Color3.fromRGB(35,35,45)
        b.Text=text..": "..(state and"ON"or"OFF")
        if cb then cb(state)end
    end)
    b.MouseEnter:Connect(function()if not state then b.BackgroundColor3=Color3.fromRGB(50,50,65)end end)
    b.MouseLeave:Connect(function()if not state then b.BackgroundColor3=Color3.fromRGB(35,35,45)end end)
    return b
end

local function CreateButtonContainer(parent, buttonCount)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -20, 0, buttonCount * 60 + 20)
    container.Position = UDim2.new(0, 10, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return container
end

local function LoadHome()
    local welcome=Section("Welcome",300)
    local avatar=Instance.new("ImageLabel",welcome)
    avatar.Size=UDim2.new(0,140,0,140)
    avatar.Position=UDim2.new(0,30,0,60)
    avatar.BackgroundTransparency=1
    avatar.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=150&height=150&format=png"
    local avatarCorner=Instance.new("UICorner")
    avatarCorner.CornerRadius=UDim.new(1,0)
    avatarCorner.Parent=avatar
    local greet=Instance.new("TextLabel",welcome)
    greet.Size=UDim2.new(0,400,0,100)
    greet.Position=UDim2.new(0,190,0,70)
    greet.BackgroundTransparency=1
    greet.Text="Welcome back,\n"..Player.DisplayName.."!"
    greet.TextColor3=Color3.new(1,1,1)
    greet.TextSize=38
    greet.Font=Enum.Font.GothamBlack
    greet.TextXAlignment=Enum.TextXAlignment.Left
    local sub=Instance.new("TextLabel",welcome)
    sub.Size=UDim2.new(0,400,0,60)
    sub.Position=UDim2.new(0,190,0,160)
    sub.BackgroundTransparency=1
    sub.Text="Premium exploit menu • "..VERSION
    sub.TextColor3=Color3.fromRGB(180,180,180)
    sub.TextSize=18
    sub.Font=Enum.Font.Gotham
    sub.TextXAlignment=Enum.TextXAlignment.Left
    local server=Section("Server Info",180)
    local srvInfo=Instance.new("TextLabel",server)
    srvInfo.Size=UDim2.new(1,-20,0,150)
    srvInfo.Position=UDim2.new(0,10,0,45)
    srvInfo.BackgroundTransparency=1
    local success,productInfo=pcall(function()return MarketplaceService:GetProductInfo(game.PlaceId)end)
    srvInfo.Text=string.format("Game: %s\nPlace ID: %d\nPlayers: %d/%d\nJob ID: %s\nPing: %.0f ms",
        success and productInfo.Name or"Unknown",game.PlaceId,#Players:GetPlayers(),Players.MaxPlayers,game.JobId,Player:GetNetworkPing()*1000)
    srvInfo.TextColor3=Color3.fromRGB(200,200,200)
    srvInfo.TextSize=15
    srvInfo.Font=Enum.Font.Gotham
    srvInfo.TextXAlignment=Enum.TextXAlignment.Left
    srvInfo.TextYAlignment=Enum.TextYAlignment.Top
    Scrolling.CanvasSize=UDim2.new(0,0,0,520)
end

local function LoadExploits()
    local movement=Section("Movement",450)
    local movementContainer = CreateButtonContainer(movement, 3)

    Button(movementContainer,"Fly (F)",function()
        if Flying then StopFly()else StartFly()end
    end)

    Button(movementContainer,"Noclip",ToggleNoclip)

    local infJumpBtn = Instance.new("TextButton")
    infJumpBtn.Size = UDim2.new(1, 0, 0, 50)
    infJumpBtn.BackgroundColor3 = InfJump and Color3.fromRGB(60,180,100) or Color3.fromRGB(35,35,45)
    infJumpBtn.Text = "Infinite Jump: " .. (InfJump and "ON" or "OFF")
    infJumpBtn.TextColor3 = Color3.new(1,1,1)
    infJumpBtn.TextSize = 16
    infJumpBtn.Font = Enum.Font.GothamSemibold
    infJumpBtn.AutoButtonColor = false
    infJumpBtn.Parent = movementContainer
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = infJumpBtn
    infJumpBtn.MouseButton1Click:Connect(function()
        InfJump = not InfJump
        infJumpBtn.BackgroundColor3 = InfJump and Color3.fromRGB(60,180,100) or Color3.fromRGB(35,35,45)
        infJumpBtn.Text = "Infinite Jump: " .. (InfJump and "ON" or "OFF")
        SendNotif("Inf Jump", InfJump and "ON" or "OFF", 2)
    end)
    infJumpBtn.MouseEnter:Connect(function()if not InfJump then infJumpBtn.BackgroundColor3 = Color3.fromRGB(50,50,65)end end)
    infJumpBtn.MouseLeave:Connect(function()if not InfJump then infJumpBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)end end)

    local speedF = Instance.new("Frame", movement)
    speedF.Size = UDim2.new(1, -20, 0, 80)
    speedF.Position = UDim2.new(0, 10, 0, 300)
    speedF.BackgroundColor3 = Color3.fromRGB(35,35,45)
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0,10)
    speedCorner.Parent = speedF
    local speedLabel = Instance.new("TextLabel", speedF)
    speedLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    speedLabel.Position = UDim2.new(0, 10, 0.1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Walk Speed"
    speedLabel.TextColor3 = Color3.new(1,1,1)
    speedLabel.TextSize = 17
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    local speedBox = Instance.new("TextBox", speedF)
    speedBox.Size = UDim2.new(0.4, 0, 0.5, 0)
    speedBox.Position = UDim2.new(0.55, 0, 0.1, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
    speedBox.Text = tostring(GetHum() and GetHum().WalkSpeed or 16)
    speedBox.TextColor3 = Color3.new(1,1,1)
    speedBox.Font = Enum.Font.Gotham
    speedBox.ClearTextOnFocus = false
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0,8)
    boxCorner.Parent = speedBox
    speedBox.FocusLost:Connect(function(ep)
        if ep then
            local n = tonumber(speedBox.Text)
            if n and n > 0 then
                local h = GetHum()
                if h then h.WalkSpeed = n end
                SendNotif("Walk Speed", "Set to " .. n, 2)
            else
                speedBox.Text = tostring(GetHum() and GetHum().WalkSpeed or 16)
            end
        end
    end)

    local visuals = Section("Visuals", 280)
    local visualsContainer = CreateButtonContainer(visuals, 1)
    local auraBtn = Instance.new("TextButton")
    auraBtn.Size = UDim2.new(1, 0, 0, 50)
    auraBtn.BackgroundColor3 = config.MaterialAura and Color3.fromRGB(60,180,100) or Color3.fromRGB(35,35,45)
    auraBtn.Text = "Material Aura: " .. (config.MaterialAura and "ON" or "OFF")
    auraBtn.TextColor3 = Color3.new(1,1,1)
    auraBtn.TextSize = 16
    auraBtn.Font = Enum.Font.GothamSemibold
    auraBtn.AutoButtonColor = false
    auraBtn.Parent = visualsContainer
    local auraCorner = Instance.new("UICorner")
    auraCorner.CornerRadius = UDim.new(0,10)
    auraCorner.Parent = auraBtn
    auraBtn.MouseButton1Click:Connect(function()
        config.MaterialAura = not config.MaterialAura
        auraBtn.BackgroundColor3 = config.MaterialAura and Color3.fromRGB(60,180,100) or Color3.fromRGB(35,35,45)
        auraBtn.Text = "Material Aura: " .. (config.MaterialAura and "ON" or "OFF")
        ToggleMaterialAura()
    end)
    auraBtn.MouseEnter:Connect(function()if not config.MaterialAura then auraBtn.BackgroundColor3 = Color3.fromRGB(50,50,65)end end)
    auraBtn.MouseLeave:Connect(function()if not config.MaterialAura then auraBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)end end)

    local flySpeedF = Instance.new("Frame", visuals)
    flySpeedF.Size = UDim2.new(1, -20, 0, 80)
    flySpeedF.Position = UDim2.new(0, 10, 0, 120)
    flySpeedF.BackgroundColor3 = Color3.fromRGB(35,35,45)
    local flySpeedCorner = Instance.new("UICorner")
    flySpeedCorner.CornerRadius = UDim.new(0,10)
    flySpeedCorner.Parent = flySpeedF
    local flySpeedLabel = Instance.new("TextLabel", flySpeedF)
    flySpeedLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
    flySpeedLabel.Position = UDim2.new(0, 10, 0.1, 0)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed"
    flySpeedLabel.TextColor3 = Color3.new(1,1,1)
    flySpeedLabel.TextSize = 17
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    local flySpeedBox = Instance.new("TextBox", flySpeedF)
    flySpeedBox.Size = UDim2.new(0.4, 0, 0.5, 0)
    flySpeedBox.Position = UDim2.new(0.55, 0, 0.1, 0)
    flySpeedBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
    flySpeedBox.Text = tostring(config.FlySpeed)
    flySpeedBox.TextColor3 = Color3.new(1,1,1)
    flySpeedBox.Font = Enum.Font.Gotham
    flySpeedBox.ClearTextOnFocus = false
    local flyBoxCorner = Instance.new("UICorner")
    flyBoxCorner.CornerRadius = UDim.new(0,8)
    flyBoxCorner.Parent = flySpeedBox
    flySpeedBox.FocusLost:Connect(function(ep)
        if ep then
            local n = tonumber(flySpeedBox.Text)
            if n and n > 0 then
                config.FlySpeed = n
                SendNotif("Fly Speed", "Set to " .. n, 2)
            else
                flySpeedBox.Text = tostring(config.FlySpeed)
            end
        end
    end)

    local fun = Section("Fun Exploits", 240)
    local funContainer = CreateButtonContainer(fun, 3)
    Button(funContainer,"Infinite Yield",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        SendNotif("Infinite Yield", "Loaded!", 3)
    end)
    Button(funContainer,"Dex Explorer",function()
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
        SendNotif("Dex Explorer", "Loaded!", 3)
    end)
    Button(funContainer,"Simple Spy",function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
        SendNotif("Simple Spy", "Loaded!", 3)
    end)

    Scrolling.CanvasSize = UDim2.new(0,0,0,1000)
end

local function LoadInfo()
    local you=Section("Your Information",220)
    local yi=Instance.new("TextLabel",you)
    yi.Size=UDim2.new(1,-20,0,180)
    yi.Position=UDim2.new(0,10,0,45)
    yi.BackgroundTransparency=1
    yi.Text=string.format("Username: %s\nDisplay Name: %s\nUser ID: %d\nAccount Age: %d days\nMembership: %s\nTeam: %s",
        Player.Name,Player.DisplayName,Player.UserId,Player.AccountAge,
        Player.MembershipType==Enum.MembershipType.Premium and"Premium"or"None",
        Player.Team and Player.Team.Name or"None")
    yi.TextColor3=Color3.fromRGB(200,200,200)
    yi.TextSize=16
    yi.Font=Enum.Font.Gotham
    yi.TextXAlignment=Enum.TextXAlignment.Left
    yi.TextYAlignment=Enum.TextYAlignment.Top

    local script=Section("Script Info",220)
    local si=Instance.new("TextLabel",script)
    si.Size=UDim2.new(1,-20,0,180)
    si.Position=UDim2.new(0,10,0,45)
    si.BackgroundTransparency=1
    si.Text=string.format("%s Features:\n\n• Fly (F key)\n• Noclip toggle\n• Infinite Jump\n• Speed changer\n• Material Aura\n• Exploits loader\n• Customizable UI\n• Server info\n\nMade with love",VERSION)
    si.TextColor3=Color3.fromRGB(200,200,200)
    si.TextSize=15
    si.Font=Enum.Font.Gotham
    si.TextXAlignment=Enum.TextXAlignment.Left
    si.TextYAlignment=Enum.TextYAlignment.Top

    Scrolling.CanvasSize=UDim2.new(0,0,0,500)
end

local function LoadSettings()
    local kb=Section("Keybinds",160)
    local keyLabel = Instance.new("TextLabel", kb)
    keyLabel.Size = UDim2.new(1, -20, 0, 40)
    keyLabel.Position = UDim2.new(0, 10, 0, 45)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Text = "GUI Toggle: "..tostring(config.ToggleKey):gsub("Enum.KeyCode.","")
    keyLabel.TextColor3 = Color3.fromRGB(200,200,200)
    keyLabel.TextSize = 17
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    local keyBtn = Instance.new("TextButton", kb)
    keyBtn.Size = UDim2.new(1, -20, 0, 50)
    keyBtn.Position = UDim2.new(0, 10, 0, 95)
    keyBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)
    keyBtn.Text = "Change Toggle Key"
    keyBtn.TextColor3 = Color3.new(1,1,1)
    keyBtn.TextSize = 16
    keyBtn.Font = Enum.Font.GothamSemibold
    keyBtn.AutoButtonColor = false
    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0,10)
    keyCorner.Parent = keyBtn
    keyBtn.MouseEnter:Connect(function()keyBtn.BackgroundColor3 = Color3.fromRGB(50,50,65)end)
    keyBtn.MouseLeave:Connect(function()keyBtn.BackgroundColor3 = Color3.fromRGB(35,35,45)end)
    keyBtn.MouseButton1Click:Connect(function()
        keyLabel.Text="Press any key..."
        local c
        c=UIS.InputBegan:Connect(function(i,gp)
            if not gp and i.KeyCode~=Enum.KeyCode.Unknown then
                config.ToggleKey=i.KeyCode
                keyLabel.Text="GUI Toggle: "..tostring(i.KeyCode):gsub("Enum.KeyCode.","")
                c:Disconnect()
                SendNotif("Keybind","Changed to "..tostring(i.KeyCode):gsub("Enum.KeyCode.",""),3)
            end
        end)
    end)

    local ui=Section("UI Settings",160)
    local opacityLabel=Instance.new("TextLabel",ui)
    opacityLabel.Size=UDim2.new(0.7,0,0,40)
    opacityLabel.Position=UDim2.new(0,10,0,45)
    opacityLabel.BackgroundTransparency=1
    opacityLabel.Text="Opacity: 100%"
    opacityLabel.TextColor3=Color3.fromRGB(200,200,200)
    opacityLabel.TextSize=16
    opacityLabel.Font=Enum.Font.Gotham
    local opacityBox=Instance.new("TextBox",ui)
    opacityBox.Size=UDim2.new(0.25,0,0,35)
    opacityBox.Position=UDim2.new(0.75,0,0,50)
    opacityBox.BackgroundColor3=Color3.fromRGB(35,35,45)
    opacityBox.Text="100"
    opacityBox.TextColor3=Color3.new(1,1,1)
    opacityBox.Font = Enum.Font.Gotham
    local boxCorner=Instance.new("UICorner")
    boxCorner.CornerRadius=UDim.new(0,8)
    boxCorner.Parent=opacityBox
    opacityBox.FocusLost:Connect(function(ep)
        if ep then
            local n=tonumber(opacityBox.Text)
            if n and n>=0 and n<=100 then
                config.UIOpacity = n
                MainFrame.BackgroundTransparency=1-(n/100)
                opacityLabel.Text="Opacity: "..n.."%"
            else
                opacityBox.Text=tostring(config.UIOpacity)
            end
        end
    end)

    Scrolling.CanvasSize=UDim2.new(0,0,0,380)
end

HomeBtn.MouseButton1Click:Connect(function()Switch("Home",HomeHL)LoadHome()end)
ExploitsBtn.MouseButton1Click:Connect(function()Switch("Exploits",ExploitsHL)LoadExploits()end)
InfoBtn.MouseButton1Click:Connect(function()Switch("Info",InfoHL)LoadInfo()end)
SettingsBtn.MouseButton1Click:Connect(function()Switch("Settings",SettingsHL)LoadSettings()end)

Switch("Home",HomeHL)
LoadHome()
SendNotif("O_o_O "..VERSION,"Loaded successfully!\nToggle: "..tostring(config.ToggleKey):gsub("Enum.KeyCode.",""),6)
