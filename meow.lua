local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("AttachRemote")

-- Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LootLabUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame background
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- UI corner for rounded look
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "LootLab Verification"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Button creator
local function makeButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 220, 0, 40)
	btn.Position = UDim2.new(0.5, -110, 0, 40 + (order * 50))
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.AutoButtonColor = true
	btn.Parent = frame

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = btn

	btn.Active = false
	btn.AutoButtonColor = false
	btn.TextTransparency = 0.5

	return btn
end

-- Buttons
local copyBtn = makeButton("Copy Discord", 0)
local captchaBtn = makeButton("Capcha", 1)
local bypassBtn = makeButton("Ban Bypass", 2)
local remoteBtn = makeButton("Makeing RemoteExist", 3)

local buttons = {copyBtn, captchaBtn, bypassBtn, remoteBtn}

-- Enable first button
copyBtn.Active = true
copyBtn.AutoButtonColor = true
copyBtn.TextTransparency = 0

-- Logic
local function activateNextButton(currentIndex)
	if buttons[currentIndex + 1] then
		local btn = buttons[currentIndex + 1]
		btn.Active = true
		btn.AutoButtonColor = true
		btn.TextTransparency = 0
	end
end

local function waitAndEnable(btn, index, callback)
	btn.MouseButton1Click:Connect(function()
		btn.Active = false
		btn.Text = btn.Text .. " (Wait 10s...)"
		task.wait(10)
		btn.Text = btn.Text .. " âœ“"
		if callback then callback() end
		activateNextButton(index)
	end)
end

-- Button logic
waitAndEnable(copyBtn, 1, function()
	if setclipboard then
		setclipboard("https://discord.gg/YourInviteHere")
	end
end)

waitAndEnable(captchaBtn, 2)
waitAndEnable(bypassBtn, 3)

waitAndEnable(remoteBtn, 4, function()
	gui:Destroy() -- remove LootLab screen

	-- Attach button GUI
	local attachGui = Instance.new("ScreenGui")
	attachGui.Name = "AttachUI"
	attachGui.Parent = player:WaitForChild("PlayerGui")

	local attachBtn = Instance.new("TextButton")
	attachBtn.Size = UDim2.new(0, 200, 0, 50)
	attachBtn.Position = UDim2.new(0.5, -100, 0.5, -25)
	attachBtn.Text = "Attach"
	attachBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	attachBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
	attachBtn.Font = Enum.Font.GothamBold
	attachBtn.TextSize = 18
	attachBtn.Parent = attachGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = attachBtn

	attachBtn.MouseButton1Click:Connect(function()
		remote:FireServer()
		attachBtn.Visible = false
	end)
end)