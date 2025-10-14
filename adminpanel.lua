-- Admin Panel resmi (gabungan client + server aman untuk Roblox Studio)
-- Masukkan ke StarterPlayer > StarterPlayerScripts sebagai LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Buat GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AdminPanel"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(1, -220, 0.5, -150)
Frame.Size = UDim2.new(0, 200, 0, 300)
Frame.BackgroundTransparency = 0.2
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi pembuat tombol
local function makeButton(name, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Text = name
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Fitur: Fly
local flying = false
local speed = 50
local bodyGyro, bodyVel

makeButton("Fly", function()
	flying = not flying
	if flying then
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		bodyGyro = Instance.new("BodyGyro", hrp)
		bodyVel = Instance.new("BodyVelocity", hrp)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		game:GetService("RunService").RenderStepped:Connect(function()
			if flying then
				local move = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
				bodyVel.Velocity = move * speed
				bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			else
				bodyGyro:Destroy()
				bodyVel:Destroy()
			end
		end)
	else
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
	end
end)

-- Fitur: Rename
makeButton("Rename Title", function()
	local name = game:GetService("Players"):PromptGamePassPurchaseFinished("Masukkan nama baru:")
	if name and name ~= "" then
		player.DisplayName = name
	end
end)

-- Fitur: Speed
makeButton("Speed x2", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = hum.WalkSpeed * 2 end
end)

-- Fitur: Jump Power
makeButton("Jump Boost", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.JumpPower = hum.JumpPower + 50 end
end)

-- Fitur: Reset
makeButton("Reset", function()
	player:LoadCharacter()
end)
