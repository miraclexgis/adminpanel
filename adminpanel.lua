--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Semua connection disimpan biar gampang dihapus
local Connections = {}
local AirWalkPart
local AirSwimConnection
local spinConnection
local noclipConn
local infJumpConn

-- Cleanup fungsi
local function CleanupAll()
    for _, conn in ipairs(Connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    Connections = {}
    
    if AirWalkPart then AirWalkPart:Destroy() AirWalkPart = nil end
    if AirSwimConnection then AirSwimConnection:Disconnect() AirSwimConnection = nil end
    if spinConnection then spinConnection:Disconnect() spinConnection = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
end

-- Fungsi utama GUI
local function CreateGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Rainbow Border
    local function RainbowStroke(uiStroke)
        task.spawn(function()
            local hue = 0
            while uiStroke.Parent do
                hue = (hue + 1) % 360
                uiStroke.Color = Color3.fromHSV(hue/360, 1, 1)
                task.wait(0.05)
            end
        end)
    end
    
    -- Notification
    local NotifyHolder = Instance.new("Frame", ScreenGui)
    NotifyHolder.Size = UDim2.new(1,0,1,0)
    NotifyHolder.BackgroundTransparency = 1
    local NotifyList = Instance.new("UIListLayout", NotifyHolder)
    NotifyList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifyList.Padding = UDim.new(0,5)
    NotifyList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifyList.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local function ShowNotification(msg)
        local Notify = Instance.new("Frame")
        Notify.Size = UDim2.new(0, 250, 0, 45)
        Notify.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Notify.BackgroundTransparency = 1
        Notify.AnchorPoint = Vector2.new(0, 1)
        Notify.Parent = NotifyHolder
        Instance.new("UICorner", Notify).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", Notify)
        stroke.Thickness = 2
        RainbowStroke(stroke)
        
        local Label = Instance.new("TextLabel", Notify)
        Label.Size = UDim2.new(1,-20,1,-10)
        Label.Position = UDim2.new(0,10,0,5)
        Label.BackgroundTransparency = 1
        Label.Text = msg
        Label.TextColor3 = Color3.new(1,1,1)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 14
        Label.TextWrapped = true
        
        TweenService:Create(Notify, TweenInfo.new(0.4, Enum.EasingStyle.Back), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(Label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        
        task.delay(4, function()
            TweenService:Create(Notify, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            task.wait(0.6)
            Notify:Destroy()
        end)
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 320, 0, 380)
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active, MainFrame.Draggable = true, true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Thickness = 2
    RainbowStroke(stroke)
    
    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, -60, 0, 30)
    Title.Text = "Admin Panel"
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font, Title.TextSize = Enum.Font.GothamBold, 18
    
    -- Tombol minimize & close
    local MinBtn = Instance.new("TextButton", MainFrame)
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -60, 0, 0)
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255,255,255)
    MinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,8)
    
    local CloseBtn = Instance.new("TextButton", MainFrame)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)
    
    -- Scroll Frame
    local Scroll = Instance.new("ScrollingFrame", MainFrame)
    Scroll.Size = UDim2.new(1, -10, 1, -40)
    Scroll.Position = UDim2.new(0, 5, 0, 35)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 6
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
    Scroll.ScrollBarImageTransparency = 0.2
    Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    Scroll.ElasticBehavior = Enum.ElasticBehavior.Always
    
    local layout = Instance.new("UIListLayout", Scroll)
    layout.Padding = UDim.new(0,5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Buat tombol
    local function makeButton(name, callback)
        local Btn = Instance.new("TextButton", Scroll)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        Btn.Text = name
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font, Btn.TextSize = Enum.Font.Gotham, 14
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)
        
        Btn.MouseButton1Click:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
            task.wait(0.1)
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
            ShowNotification("Executing: " .. name)
            callback()
        end)
    end
    
    --== LIST BUTTONS ==--
    makeButton("Heal Player", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end)
    
    makeButton("Infinity Jump", function()
        if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        infJumpConn = UIS.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        table.insert(Connections, infJumpConn)
    end)
    
    makeButton("Invisible", function()
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                    if part:FindFirstChild("face") then part.face.Transparency = 1 end
                end
            end
        end
    end)
    
    makeButton("Visible", function()
        if player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 0
                    if part:FindFirstChild("face") then part.face.Transparency = 0 end
                end
            end
        end
    end)
    
    -- ESP
    local function addESP(plr)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not plr.Character.HumanoidRootPart:FindFirstChild("ESP") then
                local billboard = Instance.new("BillboardGui", plr.Character.HumanoidRootPart)
                billboard.Name = "ESP"
                billboard.Size = UDim2.new(0,100,0,50)
                billboard.AlwaysOnTop = true
                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1,0,1,0)
                label.BackgroundTransparency = 1
                label.Text = plr.Name
                label.TextColor3 = Color3.new(1,1,1)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
            end
        end
    end
    
    makeButton("ESP Tool", function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                addESP(plr)
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(1)
                addESP(plr)
            end)
        end)
    end)
    
    makeButton("Walk Underwater", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false) end
    end)
    
    makeButton("Walk on Air", function()
        if not AirWalkPart then
            AirWalkPart = Instance.new("Part", workspace)
            AirWalkPart.Size = Vector3.new(100,1,100)
            AirWalkPart.Anchored = true
            AirWalkPart.Transparency = 1
            local conn = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    AirWalkPart.Position = player.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)
                end
            end)
            table.insert(Connections, conn)
        end
    end)
    
    local AirSwimEnabled = false
    makeButton("Toggle Air Swim", function()
        AirSwimEnabled = not AirSwimEnabled
        if AirSwimEnabled then
            local hum = player.Character and player.Character:FindFirstChild("Humanoid")
            if hum then
                AirSwimConnection = RunService.Stepped:Connect(function()
                    if hum and hum.Parent then
                        hum:ChangeState(Enum.HumanoidStateType.Swimming)
                    end
                end)
                table.insert(Connections, AirSwimConnection)
            end
            ShowNotification("Air Swim: ON")
        else
            if AirSwimConnection then AirSwimConnection:Disconnect() AirSwimConnection = nil end
            ShowNotification("Air Swim: OFF")
        end
    end)
    
    makeButton("Immune", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.Health = math.huge
            hum.MaxHealth = math.huge
        end
    end)
    
    local spinning = false
    makeButton("Toggle Spin", function()
        spinning = not spinning
        if spinning then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                spinConnection = RunService.RenderStepped:Connect(function()
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
                end)
                table.insert(Connections, spinConnection)
            end
            ShowNotification("Spin: ON")
        else
            if spinConnection then spinConnection:Disconnect() spinConnection = nil end
            ShowNotification("Spin: OFF")
        end
    end)
    
    -- WalkSpeed
    makeButton("Set WalkSpeed", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            local speed = tonumber(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AdminPanel"):FindFirstChild("TextBoxInput") and 0) -- dummy
            local box = Instance.new("TextBox", MainFrame)
            box.Size = UDim2.new(0, 120, 0, 30)
            box.Position = UDim2.new(0.5,-60,0.5,-15)
            box.BackgroundColor3 = Color3.fromRGB(40,40,40)
            box.PlaceholderText = "Enter WalkSpeed"
            box.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
            box.FocusLost:Connect(function(enter)
                if enter then
                    local val = tonumber(box.Text)
                    if val then
                        hum.WalkSpeed = val
                        ShowNotification("WalkSpeed set to "..val)
                    end
                end
                box:Destroy()
            end)
        end
    end)
    
    -- JumpPower
    makeButton("Set JumpPower", function()
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            local box = Instance.new("TextBox", MainFrame)
            box.Size = UDim2.new(0, 120, 0, 30)
            box.Position = UDim2.new(0.5,-60,0.5,-15)
            box.BackgroundColor3 = Color3.fromRGB(40,40,40)
            box.PlaceholderText = "Enter JumpPower"
            box.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
            box.FocusLost:Connect(function(enter)
                if enter then
                    local val = tonumber(box.Text)
                    if val then
                        hum.UseJumpPower = true
                        hum.JumpPower = val
                        ShowNotification("JumpPower set to "..val)
                    end
                end
                box:Destroy()
            end)
        end
    end)
    
    -- Noclip
    makeButton("Toggle Noclip", function()
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
            ShowNotification("Noclip OFF")
        else
            noclipConn = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            table.insert(Connections, noclipConn)
            ShowNotification("Noclip ON")
        end
    end)
    
    -- Minimize
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0,320,0,380)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0,320,0,30)}):Play()
        end
        minimized = not minimized
    end)
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        CleanupAll()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1
        }):Play()
        for _, child in ipairs(MainFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                TweenService:Create(child, TweenInfo.new(0.2), {Transparency = 1, TextTransparency = 1}):Play()
            end
        end
        task.wait(0.35)
        ScreenGui:Destroy()
    end)
    
    ShowNotification("Admin Panel Loaded Successfully!")
end

-- Pertama dijalankan
CreateGui()

-- Respawn Handler
player.CharacterAdded:Connect(function()
    task.wait(1)
    CleanupAll()
    if player:FindFirstChild("PlayerGui") and not player.PlayerGui:FindFirstChild("AdminPanel") then
        CreateGui()
    end
end)
