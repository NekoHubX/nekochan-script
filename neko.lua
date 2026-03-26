if game.PlaceId~=10169939430 then return end

local p=game.Players.LocalPlayer
local e=game:GetService("ReplicatedStorage").Events.Abilities
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")

-- GUI (CoreGui для Xeno)
local g=Instance.new("ScreenGui",game:FindFirstChild("CoreGui") or p.PlayerGui)
g.ResetOnSpawn=false

local f=Instance.new("Frame",g)
f.Size,f.Position=UDim2.new(0,300,0,320),UDim2.new(0.5,-150,0.5,-160)
f.BackgroundColor3=Color3.fromRGB(25,25,25)
f.Visible=false
Instance.new("UICorner",f)

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,0,0,30)
t.Text="NekoChan"
t.TextScaled=true
t.BackgroundTransparency=1

-- открытие как Orion
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.RightShift then
        f.Visible=not f.Visible
    end
end)

-- скиллы
local skills={
{"Meteor","Thanos","Meteor",CFrame.new(-354.94,323.93,136.61),Enum.KeyCode.Z},
{"Shield","Green Lantern","Shield",CFrame.new(-881.03,336.72,28.69)*CFrame.Angles(2.24,1.5,-2.24),Enum.KeyCode.X},
{"Eruption","Darkseid","Eruption",CFrame.new(-702.83,324.44,468.23),Enum.KeyCode.C},
{"Grab","Darkseid","Grab",CFrame.new(-403.56,324.44,209.98),Enum.KeyCode.V},
{"Hit","Darkseid","DoubleHit",CFrame.new(-708.59,323.93,423.6),Enum.KeyCode.B}
}

local state,btns={},{}
local bind=nil

for i,v in ipairs(skills)do
    state[i]=false

    local b=Instance.new("TextButton",f)
    b.Size,b.Position=UDim2.new(1,-20,0,30),UDim2.new(0,10,0,35+i*35)
    b.BackgroundColor3=Color3.fromRGB(40,40,40)
    b.Text=v[1].." [OFF] ("..v[5].Name..")"
    b.TextScaled=true
    Instance.new("UICorner",b)

    b.MouseButton1Click:Connect(function()
        bind=i
        b.Text="Press key..."
    end)

    btns[i]=b
end

-- бинды + включение
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end

    -- смена бинда
    if bind then
        skills[bind][5]=i.KeyCode
        btns[bind].Text=skills[bind][1].." [OFF] ("..i.KeyCode.Name..")"
        bind=nil
        return
    end

    -- включение скилла
    for k,v in ipairs(skills)do
        if i.KeyCode==v[5] then
            state[k]=not state[k]
            btns[k].Text=v[1].." ["..(state[k]and"ON"or"OFF").."] ("..v[5].Name..")"
        end
    end
end)

-- ESP
local esp=false
local eb=Instance.new("TextButton",f)
eb.Size,eb.Position=UDim2.new(1,-20,0,30),UDim2.new(0,10,0,260)
eb.Text="ESP [OFF]"
Instance.new("UICorner",eb)

eb.MouseButton1Click:Connect(function()
    esp=not esp
    eb.Text="ESP ["..(esp and"ON"or"OFF").."]"
end)

RS.RenderStepped:Connect(function()
    for _,plr in ipairs(game.Players:GetPlayers())do
        if plr~=p and plr.Character and plr.Character:FindFirstChild("Head")then
            local h=plr.Character.Head
            local tag=h:FindFirstChild("E")
            if esp and not tag then
                local b=Instance.new("BillboardGui",h)
                b.Name="E";b.Size=UDim2.new(0,100,0,20);b.AlwaysOnTop=true
                local t=Instance.new("TextLabel",b)
                t.Size=UDim2.new(1,0,1,0)
                t.Text=plr.Name
                t.BackgroundTransparency=1
                t.TextColor3=Color3.new(1,0,0)
            elseif not esp and tag then tag:Destroy() end
        end
    end
end)

-- ГЛАВНЫЙ ФИКС: правильный вызов
task.spawn(function()
    while task.wait(0.5) do
        if not p.Character then continue end
        for i,v in ipairs(skills)do
            if state[i] then
                pcall(function()
                    e:FireServer(p.Character, v[2], v[3], v[4])
                end)
            end
        end
    end
end)

-- подпись
local foot=Instance.new("TextLabel",f)
foot.Size,foot.Position=UDim2.new(1,0,0,20),UDim2.new(0,0,1,-20)
foot.Text="TG: @Neko_Chhan"
foot.TextScaled=true
foot.BackgroundTransparency=1
