--// SPIN MODE (SAFE)

local player = game.Players.LocalPlayer
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local spinning = false

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,160,0,50)
btn.Position = UDim2.new(0,20,0,200)
btn.Text = "Spin: OFF"
btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
btn.TextColor3 = Color3.new(1,1,1)
btn.Active = true
btn.Draggable = true
Instance.new("UICorner", btn)

-- หมุนตัวเราเอง
game:GetService("RunService").RenderStepped:Connect(function()
	if spinning then
		local char = getChar()
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(25), 0)
		end
	end
end)

btn.MouseButton1Click:Connect(function()
	spinning = not spinning
	btn.Text = spinning and "Spin: ON" or "Spin: OFF"
end)
