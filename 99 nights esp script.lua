local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local run = game:GetService("RunService")

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

-- ===== ตัวแปร =====
local followOn = false
local followTarget = nil
local espOn = false
local savedPoints = {}

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- ปุ่มเปิด GUI
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,120,0,40)
openBtn.Position = UDim2.new(0,20,0,150)
openBtn.Text = "OPEN PANEL"
openBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Visible = false
Instance.new("UICorner", openBtn)

-- Frame หลัก
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,300,0,450)
frame.Position = UDim2.new(0,20,0,200)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- ขอบเรืองแสง
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "🔥 ULTRA PANEL V2"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.BackgroundTransparency = 1

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
destroy.BackgroundColor3 = Color3.fromRGB(120,120,120)
Instance.new("UICorner", destroy)

-- ฟังก์ชัน UI
local function makeBtn(y,text)
	local b = Instance.new("TextButton", frame)
	b.Position = UDim2.new(0,10,0,y)
	b.Size = UDim2.new(1,-20,0,35)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,45)
	b.TextColor3 = Color3.fromRGB(0,170,255)
	Instance.new("UICorner", b)
	return b
end

local function makeBox(y,ph)
	local t = Instance.new("TextBox", frame)
	t.Position = UDim2.new(0,10,0,y)
	t.Size = UDim2.new(1,-20,0,30)
	t.PlaceholderText = ph
	t.BackgroundColor3 = Color3.fromRGB(30,30,35)
	t.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", t)
	return t
end

-- ===== ESP =====
local espBtn = makeBtn(40,"ESP: OFF")

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"

	for _,plr in pairs(players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local old = plr.Character:FindFirstChild("ESP")
			if old then old:Destroy() end

			if espOn then
				local h = Instance.new("Highlight")
				h.Name = "ESP"
				h.FillColor = Color3.fromRGB(0,255,0)
				h.Parent = plr.Character
			end
		end
	end
end)

-- ===== FOLLOW =====
local followBox = makeBox(90,"ชื่อผู้เล่น")
local followBtn = makeBtn(130,"Follow: OFF")

followBtn.MouseButton1Click:Connect(function()
	local name = followBox.Text
	if name == "" then return end

	for _,plr in pairs(players:GetPlayers()) do
		if string.lower(plr.Name):sub(1,#name) == string.lower(name) then
			followTarget = plr
			followOn = not followOn
			followBtn.Text = followOn and "Follow: ON" or "Follow: OFF"
			break
		end
	end
end)

-- ===== TELEPORT =====
local saveBtn = makeBtn(180,"📍 Save Point")
local tpBtn = makeBtn(220,"🚀 Teleport Saved")

saveBtn.MouseButton1Click:Connect(function()
	local char = getChar()
	if char and char:FindFirstChild("HumanoidRootPart") then
		table.insert(savedPoints, char.HumanoidRootPart.Position)
	end
end)

tpBtn.MouseButton1Click:Connect(function()
	if #savedPoints > 0 then
		getChar():MoveTo(savedPoints[#savedPoints])
	end
end)

-- ===== MINI MAP =====
local map = Instance.new("Frame", frame)
map.Size = UDim2.new(0,130,0,130)
map.Position = UDim2.new(1,-140,0,300)
map.BackgroundColor3 = Color3.fromRGB(10,10,10)
Instance.new("UICorner", map)

run.RenderStepped:Connect(function()
	map:ClearAllChildren()

	for _,plr in pairs(players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dot = Instance.new("Frame", map)
			dot.Size = UDim2.new(0,6,0,6)
			dot.BackgroundColor3 = Color3.fromRGB(0,255,0)

			local pos = plr.Character.HumanoidRootPart.Position
			dot.Position = UDim2.new(0,(pos.X%120),0,(pos.Z%120))
		end
	end
end)

-- ===== FOLLOW SYSTEM =====
run.RenderStepped:Connect(function()
	if followOn and followTarget and followTarget.Character then
		local hrp = followTarget.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			getChar():MoveTo(hrp.Position + Vector3.new(2,0,2))
		end
	end
end)

-- ===== GUI CONTROL =====
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
