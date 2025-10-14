-- [ADMIN PANEL DENGAN FITUR GANTI TITLE DI ATAS KEPALA]
-- Script ini dibuat aman dan bisa digunakan langsung di Roblox Studio

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI utama
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"

local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(1, 0.5)
frame.Position = UDim2.new(1, -20, 0.5, 0)
frame.Size = UDim2.new(0, 200, 0, 320)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 6)
uilist.FillDirection = Enum.FillDirection.Vertical
uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
uilist.VerticalAlignment = Enum.VerticalAlignment.Top

-- Fungsi buat tombol
local function createButton(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.AutoButtonColor = true
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Variabel Fly
local flying = false
local speed = 60
local bg, bv

-- FLY BUTTON
createButton("🛫 Fly", function()
	flying = not flying
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")

	if flying then
		bg = Instance.new("BodyGyro", hrp)
		bv = Instance.new("BodyVelocity", hrp)
		bg.P = 9e4
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		RunService.RenderStepped:Connect(function()
			if flying then
				local move = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
				bv.Velocity = move * speed
				bg.CFrame = workspace.CurrentCamera.CFrame
			end
		end)
	else
		if bg then bg:Destroy() end
		if bv then bv:Destroy() end
	end
end)

-- SPEED BUTTON
createButton("⚡ Speed x2", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = hum.WalkSpeed * 2
	end
end)

-- JUMP BUTTON
createButton("🦘 Jump +50", function()
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.JumpPower = hum.JumpPower + 50
	end
end)

-- RESET BUTTON
createButton("🔄 Reset", function()
	player:LoadCharacter()
end)

-- FITUR GANTI TITLE (di atas kepala)
createButton("🏷 Ganti Title", function()
	local titleText = nil
	-- Buat prompt input sederhana
	local inputFrame = Instance.new("Frame", gui)
	inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	inputFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	inputFrame.Size = UDim2.new(0, 250, 0, 120)
	inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	inputFrame.BackgroundTransparency = 0.05
	inputFrame.BorderSizePixel = 0

	local titleBox = Instance.new("TextBox", inputFrame)
	titleBox.PlaceholderText = "Masukkan Title..."
	titleBox.Size = UDim2.new(1, -20, 0, 40)
	titleBox.Position = UDim2.new(0, 10, 0, 10)
	titleBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	titleBox.TextColor3 = Color3.new(1,1,1)
	titleBox.Font = Enum.Font.GothamBold
	titleBox.TextSize = 16

	local okButton = Instance.new("TextButton", inputFrame)
	okButton.Size = UDim2.new(1, -20, 0, 40)
	okButton.Position = UDim2.new(0, 10, 0, 60)
	okButton.Text = "OK"
	okButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	okButton.TextColor3 = Color3.new(1,1,1)
	okButton.Font = Enum.Font.GothamBold
	okButton.TextSize = 18

	okButton.MouseButton1Click:Connect(function()
		local title = titleBox.Text
		inputFrame:Destroy()

		if title ~= "" then
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart")

			-- Hapus title lama kalau ada
			local old = hrp:FindFirstChild("TitleBillboard")
			if old then old:Destroy() end

			-- Buat Billboard baru
			local billboard = Instance.new("BillboardGui", hrp)
			billboard.Name = "TitleBillboard"
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 3, 0)
			billboard.AlwaysOnTop = true

			local text = Instance.new("TextLabel", billboard)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.BackgroundTransparency = 1
			text.Text = title
			text.TextColor3 = Color3.fromRGB(255, 255, 0)
			text.Font = Enum.Font.GothamBold
			text.TextScaled = true
		end
	end)
end)
