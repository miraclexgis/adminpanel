-- === ADMIN PANEL DENGAN TITLE TERLIHAT UNTUK SEMUA PEMAIN ===
-- Ditempatkan di StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Buat RemoteEvent di ReplicatedStorage (jika belum ada)
local event = ReplicatedStorage:FindFirstChild("SetTitleEvent")
if not event then
	event = Instance.new("RemoteEvent", ReplicatedStorage)
	event.Name = "SetTitleEvent"
end

local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AdminPanel"

local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(1, 0.5)
frame.Position = UDim2.new(1, -20, 0.5, 0)
frame.Size = UDim2.new(0, 200, 0, 320)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 6)
uilist.FillDirection = Enum.FillDirection.Vertical
uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Fungsi buat tombol
local function makeButton(name, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 35)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Tombol Ganti Title (minta input)
makeButton("🏷 Ganti Title", function()
	local inputFrame = Instance.new("Frame", gui)
	inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	inputFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	inputFrame.Size = UDim2.new(0, 250, 0, 120)
	inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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
		local newTitle = titleBox.Text
		inputFrame:Destroy()
		if newTitle ~= "" then
			event:FireServer(newTitle) -- kirim ke server
		end
	end)
end)

---------------------------------------------------------------------
-- Bagian server (dibuat otomatis lewat Script di ServerScriptService)
---------------------------------------------------------------------

if game:GetService("RunService"):IsServer() then
	event.OnServerEvent:Connect(function(playerWhoSent, newTitle)
		local char = playerWhoSent.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		-- Hapus title lama kalau ada
		local old = hrp:FindFirstChild("TitleBillboard")
		if old then old:Destroy() end

		-- Buat title baru yang bisa dilihat semua player
		local billboard = Instance.new("BillboardGui", hrp)
		billboard.Name = "TitleBillboard"
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true

		local label = Instance.new("TextLabel", billboard)
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = newTitle
		label.TextColor3 = Color3.fromRGB(255, 255, 0)
		label.Font = Enum.Font.GothamBold
		label.TextScaled = true
	end)
end
