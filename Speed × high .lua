--// ULTRA BEAUTIFUL GUI

local player = game.Players.LocalPlayer
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- ตัวแปร
local speedOn = false
local jumpOn = false
local noclipOn = false

local defaultSpeed = 16
local defaultJump = 50

-- สีธีม
local bg = Color3.fromRGB(20,20,25)
local neon = Color3.fromRGB(0,170,255)

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- ปุ่มเปิด
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,120,0,40)
openBtn.Position = UDim2.new(0,20,0,150)
openBtn.Text = "OPEN"
openBtn.BackgroundColor3 = neon
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
Instance.new("UICorner", openBtn)

-- Frame หลัก
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,270,0,360)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = bg
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ขอบเรืองแสง
local stroke = Instance.new("UIStroke", frame)
stroke.Color = neon
stroke.Thickness = 2

-- หัวข้อ
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "⚡ PRO PANEL"
title.TextColor3 = neon
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- ปุ่มปิด
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,0)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,60,60)
Instance.new("UICorner", close)

-- ปิดถาวร
local destroy = Instance.new("TextButton", frame)
destroy.Size = UDim2.new(0,30,0,30)
destroy.Position = UDim2.new(1,-70,0,0)
destroy.Text = "-"
destroy.BackgroundColor3 = Color3.fromRGB(100,100,100)
Instance.new("UICorner", destroy)

-- ฟังก์ชันสร้างปุ่ม
local function createButton(y,text)
	local b = Instance.new("TextButton", frame)
	b.Position = UDim2.new(0,10,0,y)
	b.Size = UDim2.new(1,-20,0,35)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(35,35,40)
	b.TextColor3 = neon
	Instance.new("UICorner", b)
	return b
end

local function createBox(y,placeholder)
	local t = Instance.new("TextBox", frame)
	t.Position = UDim2.new(0,10,0,y)
	t.Size = UDim2.new(1,-20,0,30)
	t.PlaceholderText = placeholder
	t.BackgroundColor3 = Color3.fromRGB(30,30,35)
	t.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", t)
	return t
end

-- UI Elements
local speedBtn = createButton(40,"Speed: OFF")
local speedBox = createBox(80,"Speed")

local jumpBtn = createButton(120,"Jump: OFF")
local jumpBox = createBox(160,"Jump")

local noclipBtn = createButton(200,"Noclip: OFF")

local tpBox = createBox(240,"Player Name")
local tpBtn = createButton(280,"Teleport")

-- GUI control
close.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

destroy.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Speed
speedBtn.MouseButton1Click:Connect(function()
	local hum = getChar():FindFirstChildOfClass("Humanoid")
	if not hum then return end

	speedOn = not speedOn
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"

	if speedOn then
		defaultSpeed = hum.WalkSpeed
		hum.WalkSpeed = tonumber(speedBox.Text) or 50
	else
		hum.WalkSpeed = defaultSpeed
	end
end)

-- Jump
jumpBtn.MouseButton1Click:Connect(function()
	local hum = getChar():FindFirstChildOfClass("Humanoid")
	if not hum then return end

	jumpOn = not jumpOn
	jumpBtn.Text = jumpOn and "Jump: ON" or "Jump: OFF"

	if jumpOn then
		defaultJump = hum.JumpPower
		hum.JumpPower = tonumber(jumpBox.Text) or 100
	else
		hum.JumpPower = defaultJump
	end
end)

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
	if noclipOn then
		for _, v in pairs(getChar():GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclipOn = not noclipOn
	noclipBtn.Text = noclipOn and "Noclip: ON" or "Noclip: OFF"
end)

-- Teleport
tpBtn.MouseButton1Click:Connect(function()
	local name = tpBox.Text
	if name == "" then return end

	for _, plr in pairs(game.Players:GetPlayers()) do
		if string.lower(plr.Name):sub(1,#name) == string.lower(name) then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				getChar():MoveTo(plr.Character.HumanoidRootPart.Position)
				break
			end
		end
	end
end)
