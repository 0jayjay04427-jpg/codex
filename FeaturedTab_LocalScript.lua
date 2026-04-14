-- ============================================
-- FEATURED TAB — LocalScript
-- ============================================
-- Place this inside your existing MorphGui LocalScript,
-- or add it as a sibling LocalScript in the same ScreenGui.
--
-- This creates a "Featured" tab that displays the current
-- globally-featured morph (rotates every 12 hours, same for
-- all players across all servers).
-- ============================================

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for remotes
local remoteFolder       = ReplicatedStorage:WaitForChild("MorphGuiRemotes")
local getFeaturedFunc    = remoteFolder:WaitForChild("GetFeaturedMorph")
local featuredUpdatedEvt = remoteFolder:WaitForChild("FeaturedMorphUpdated")
local morphRequestEvent  = remoteFolder:WaitForChild("MorphRequest")

-- ============================================
-- UI CREATION
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FeaturedMorphGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.Parent = playerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "FeaturedFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0, 15, 0.5, -90)
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 200, 50)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.3
mainStroke.Parent = mainFrame

-- Header bar
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 36)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Bottom clip for header (square off the bottom corners)
local headerClip = Instance.new("Frame")
headerClip.Name = "HeaderClip"
headerClip.Size = UDim2.new(1, 0, 0, 12)
headerClip.Position = UDim2.new(0, 0, 1, -12)
headerClip.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
headerClip.BorderSizePixel = 0
headerClip.Parent = header

-- Star icon + title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⭐ FEATURED MORPH"
titleLabel.TextColor3 = Color3.fromRGB(20, 20, 30)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = header

-- Morph name label
local morphNameLabel = Instance.new("TextLabel")
morphNameLabel.Name = "MorphName"
morphNameLabel.Size = UDim2.new(1, -20, 0, 32)
morphNameLabel.Position = UDim2.new(0, 10, 0, 46)
morphNameLabel.BackgroundTransparency = 1
morphNameLabel.Text = "Loading..."
morphNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
morphNameLabel.Font = Enum.Font.GothamBold
morphNameLabel.TextSize = 20
morphNameLabel.TextXAlignment = Enum.TextXAlignment.Left
morphNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
morphNameLabel.Parent = mainFrame

-- Timer label
local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "Timer"
timerLabel.Size = UDim2.new(1, -20, 0, 20)
timerLabel.Position = UDim2.new(0, 10, 0, 80)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "Rotates in: --:--:--"
timerLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextSize = 13
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.Parent = mainFrame

-- "Morph Into" button
local morphButton = Instance.new("TextButton")
morphButton.Name = "MorphButton"
morphButton.Size = UDim2.new(1, -20, 0, 38)
morphButton.Position = UDim2.new(0, 10, 1, -48)
morphButton.AnchorPoint = Vector2.new(0, 0)
morphButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
morphButton.BorderSizePixel = 0
morphButton.Text = "⚡ MORPH INTO FEATURED"
morphButton.TextColor3 = Color3.fromRGB(20, 20, 30)
morphButton.Font = Enum.Font.GothamBold
morphButton.TextSize = 14
morphButton.AutoButtonColor = true
morphButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = morphButton

-- Toggle button (small tab on the side to show/hide)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleFeatured"
toggleBtn.Size = UDim2.new(0, 28, 0, 80)
toggleBtn.Position = UDim2.new(0, 0, 0.5, -40)
toggleBtn.AnchorPoint = Vector2.new(1, 0.5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "⭐"
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.AutoButtonColor = true
toggleBtn.Visible = false
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

-- ============================================
-- STATE
-- ============================================
local currentFeaturedName = ""
local timeRemaining       = 0
local panelOpen           = true
local cooldown            = false

-- ============================================
-- HELPERS
-- ============================================
local function formatTime(seconds)
	seconds = math.max(0, math.floor(seconds))
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = seconds % 60
	return string.format("%02d:%02d:%02d", h, m, s)
end

local function updateDisplay(morphName, secondsLeft)
	currentFeaturedName = morphName
	timeRemaining = secondsLeft
	morphNameLabel.Text = morphName
	timerLabel.Text = "Rotates in: " .. formatTime(secondsLeft)
end

-- Slide-in animation for new featured morph
local function playRevealAnimation()
	morphNameLabel.TextTransparency = 1
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local tween = TweenService:Create(morphNameLabel, tweenInfo, {TextTransparency = 0})
	tween:Play()

	-- Flash the border
	local flashInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 2, true)
	local flash = TweenService:Create(mainStroke, flashInfo, {
		Color = Color3.fromRGB(255, 255, 255),
		Transparency = 0
	})
	flash:Play()
	flash.Completed:Connect(function()
		mainStroke.Color = Color3.fromRGB(255, 200, 50)
		mainStroke.Transparency = 0.3
	end)
end

-- Panel open/close
local function togglePanel()
	panelOpen = not panelOpen
	if panelOpen then
		mainFrame.Visible = true
		toggleBtn.Visible = false
		local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Position = UDim2.new(0, 15, 0.5, -90)
		})
		tween:Play()
	else
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tween = TweenService:Create(mainFrame, tweenInfo, {
			Position = UDim2.new(0, -300, 0.5, -90)
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not panelOpen then
				mainFrame.Visible = false
				toggleBtn.Visible = true
			end
		end)
	end
end

-- ============================================
-- CLOSE BUTTON (top-right of header)
-- ============================================
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(20, 20, 30)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(togglePanel)
toggleBtn.MouseButton1Click:Connect(togglePanel)

-- ============================================
-- MORPH BUTTON HANDLER
-- ============================================
morphButton.MouseButton1Click:Connect(function()
	if cooldown or currentFeaturedName == "" then return end
	cooldown = true

	morphButton.Text = "Morphing..."
	morphButton.BackgroundColor3 = Color3.fromRGB(180, 150, 40)

	morphRequestEvent:FireServer(currentFeaturedName)

	task.wait(2)

	morphButton.Text = "⚡ MORPH INTO FEATURED"
	morphButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
	cooldown = false
end)

-- ============================================
-- FETCH INITIAL FEATURED MORPH
-- ============================================
task.spawn(function()
	local ok, name, secondsLeft = pcall(function()
		return getFeaturedFunc:InvokeServer()
	end)
	if ok and name then
		updateDisplay(name, secondsLeft)
		playRevealAnimation()
	else
		morphNameLabel.Text = "Unavailable"
		timerLabel.Text = ""
	end
end)

-- ============================================
-- LISTEN FOR ROTATION UPDATES FROM SERVER
-- ============================================
featuredUpdatedEvt.OnClientEvent:Connect(function(newName, newTimeLeft)
	updateDisplay(newName, newTimeLeft)
	playRevealAnimation()
end)

-- ============================================
-- COUNTDOWN TIMER (updates every second)
-- ============================================
task.spawn(function()
	while true do
		task.wait(1)
		if timeRemaining > 0 then
			timeRemaining = timeRemaining - 1
			timerLabel.Text = "Rotates in: " .. formatTime(timeRemaining)
		end
	end
end)
