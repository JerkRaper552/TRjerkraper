-- Fake Exploit Menu GUI with Custom Background (Completely Safe - For Content/Trolling/Fun Only)
-- Background: rbxassetid://114018464243737
-- Made with love for Roblox Studio creators <3

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FakeExploitMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 500)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 1  -- Transparent to show background image
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Custom Background Image
local backgroundImage = Instance.new("ImageLabel")
backgroundImage.Name = "CustomBackground"
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.ZIndex = -1
backgroundImage.Image = "rbxassetid://114018464243737"
backgroundImage.ScaleType = Enum.ScaleType.Tile  -- Tiled for seamless background (change to Stretch/Crop if preferred)
backgroundImage.TileSize = UDim2.new(0, 128, 0, 128)  -- Adjust tile size for better fit (optional)
backgroundImage.Parent = mainFrame

-- Top Bar (Draggable)
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(30, 130, 255)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "GROK EXPLOIT v9.1"
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.Parent = topBar

-- ScrollingFrame for buttons
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -60)
scrollingFrame.Position = UDim2.new(0, 10, 0, 50)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 8
scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollingFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.Parent = scrollingFrame

-- Make draggable
local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Fake buttons
local fakeFunctions = {
	"Speed Hack (250)",
	"Fly Hack (UNDETECTED)",
	"Noclip",
	"ESP (All Players)",
	"Aimbot (Legit)",
	"Kill All",
	"Teleport to Spawn",
	"Infinite Jump",
	"God Mode",
	"Click TP",
	"Anti-AFK",
	"Fullbright",
	"X-Ray",
	"Player Finder",
	"Server Hop",
	"Rejoin Server",
	"Destroy GUI",
}

for _, name in pairs(fakeFunctions) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 45)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	button.BorderSizePixel = 0
	button.Text = " [OFF] " .. name
	button.TextColor3 = Color3.fromRGB(200, 200, 200)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Parent = scrollingFrame

	-- Hover effect
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 130, 255)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
	end)

	-- Fake toggle
	local toggled = false
	button.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			button.Text = " [ON] " .. name
			button.TextColor3 = Color3.fromRGB(0, 255, 0)
			-- Fake notification
			local notif = Instance.new("Frame")
			notif.Size = UDim2.new(0, 250, 0, 60)
			notif.Position = UDim2.new(0, 20, 0, -80)
			notif.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
			notif.BorderSizePixel = 0
			notif.Parent = screenGui

			local notifText = Instance.new("TextLabel")
			notifText.Size = UDim2.new(1,0,1,0)
			notifText.BackgroundTransparency = 1
			notifText.Text = name .. " Activated!"
			notifText.TextColor3 = Color3.new(1,1,1)
			notifText.Font = Enum.Font.GothamBold
			notifText.TextSize = 18
			notifText.Parent = notif

			TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0,20,0,20)}):Play()
			wait(2)
			TweenService:Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0,20,0,-80)}):Play()
			wait(0.5)
			notif:Destroy()
		else
			button.Text = " [OFF] " .. name
			button.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end)
end

-- Update canvas size
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end)

-- Toggle GUI with Insert key
local open = false
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		open = not open
		mainFrame.Visible = open
		
		if open then
			-- Cool opening animation
			mainFrame.Size = UDim2.new(0, 0, 0, 0)
			TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 420, 0, 500)
			}):Play()
		end
	end
end)

-- Close button
closeButton.MouseButton1Click:Connect(function()
	open = false
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	wait(0.3)
	mainFrame.Visible = false
	mainFrame.Size = UDim2.new(0, 420, 0, 500) -- reset size
end)

print("Fake Exploit Menu with Custom Background loaded! Press INSERT to toggle.")
