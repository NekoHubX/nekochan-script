if game.PlaceId ~= 10169939430 then return end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local events
-- Авто-поиск RemoteEvent
for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and v.Name:lower():find("abil") then
        events = v
        break
    end
end
if not events then return end

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "NekoChan GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

-- Open/close toggle (like Orion)
local toggleKey = Enum.KeyCode.RightShift
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == toggleKey then
        frame.Visible = not frame.Visible
    end
end)

-- Skills
local skills = {
    {Name="Meteor", Hero="Thanos", Ability="Meteor", Pos=CFrame.new(-354.94,323.93,136.61), Key=Enum.KeyCode.Z},
    {Name="Shield", Hero="Green Lantern", Ability="Shield", Pos=CFrame.new(-881.03,336.72,28.69)*CFrame.Angles(2.24,1.5,-2.24), Key=Enum.KeyCode.X},
    {Name="Eruption", Hero="Darkseid", Ability="Eruption", Pos=CFrame.new(-702.83,324.44,468.23), Key=Enum.KeyCode.C},
    {Name="Grab", Hero="Darkseid", Ability="Grab", Pos=CFrame.new(-403.56,324.44,209.98), Key=Enum.KeyCode.V},
    {Name="DoubleHit", Hero="Darkseid", Ability="DoubleHit", Pos=CFrame.new(-708.59,323.93,423.6), Key=Enum.KeyCode.B},
}

local skillStates = {}
local buttons = {}

local function createButton(skill, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Text = skill.Name.." [OFF] ("..skill.Key.Name..")"
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        skillStates[skill.Name] = not skillStates[skill.Name]
        btn.Text = skill.Name.." ["..(skillStates[skill.Name] and "ON" or "OFF").."] ("..skill.Key.Name..")"
    end)
    table.insert(buttons, btn)
end

for i, skill in ipairs(skills) do
    skillStates[skill.Name] = false
    createButton(skill, 40 + i*40)
end

-- Keybind change
local currentBind
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if currentBind then
        currentBind.Key = input.KeyCode
        buttons[currentBind.Index].Text = currentBind.Skill.Name.." ["..(skillStates[currentBind.Skill.Name] and "ON" or "OFF").."] ("..input.KeyCode.Name..")"
        currentBind = nil
        return
    end
    for i, skill in ipairs(skills) do
        if input.KeyCode == skill.Key then
            skillStates[skill.Name] = not skillStates[skill.Name]
            buttons[i].Text = skill.Name.." ["..(skillStates[skill.Name] and "ON" or "OFF").."] ("..skill.Key.Name..")"
        end
    end
end)

-- ESP toggle
local esp = false
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(1, -20, 0, 30)
espBtn.Position = UDim2.new(0, 10, 0, 300)
espBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.TextScaled = true
espBtn.Font = Enum.Font.GothamBold
espBtn.Text = "ESP [OFF]"
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)

espBtn.MouseButton1Click:Connect(function()
    esp = not esp
    espBtn.Text = "ESP ["..(esp and "ON" or "OFF").."]"
end)

-- ESP update
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local tag = head:FindFirstChild("ESP_Tag")
            if esp and not tag then
                local b = Instance.new("BillboardGui", head)
                b.Name = "ESP_Tag"
                b.Size = UDim2.new(0, 100, 0, 20)
                b.AlwaysOnTop = true
                local t = Instance.new("TextLabel", b)
                t.Size = UDim2.new(1, 0, 1, 0)
                t.BackgroundTransparency = 1
                t.TextColor3 = Color3.new(1, 0, 0)
                t.Text = plr.Name
                t.TextScaled = true
                t.Font = Enum.Font.GothamBold
            elseif not esp and tag then
                tag:Destroy()
            end
        end
    end
end)

-- Fire skills loop
RunService.Heartbeat:Connect(function()
    if player.Character then
        for _, skill in ipairs(skills) do
            if skillStates[skill.Name] then
                pcall(function()
                    events:FireServer(player.Character, skill.Hero, skill.Ability, skill.Pos)
                end)
            end
        end
    end
end)

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.Text = "TG: @Neko_Chhan"
footer.TextColor3 = Color3.fromRGB(180, 180, 180)
footer.BackgroundTransparency = 1
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
