if game.PlaceId~=10169939430 then return end
local p=game.Players.LocalPlayer;local UIS=game:GetService("UserInputService")
local e;for _,v in ipairs(game:GetDescendants())do if v:IsA("RemoteEvent")and v.Name:lower():find("abil")then e=v break end end if not e then return end
local g=Instance.new("ScreenGui",game:FindFirstChild("CoreGui")or p.PlayerGui);g.ResetOnSpawn=false
local f=Instance.new("Frame",g);f.Size,f.Position=UDim2.new(0,260,0,340),UDim2.new(0,100,0,100);Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
local grad=Instance.new("UIGradient",f)
local top=Instance.new("TextLabel",f);top.Size,top.Text,top.TextColor3,top.TextScaled,top.Font=UDim2.new(1,0,0,35),"NekoChan",Color3.new(1,1,1),true,Enum.Font.GothamBold
local cont=Instance.new("Frame",f);cont.Size,cont.Position,cont.BackgroundTransparency=UDim2.new(1,0,1,-60),UDim2.new(0,0,0,35),1
local foot=Instance.new("TextLabel",f);foot.Size,foot.Position,foot.Text,foot.TextColor3,foot.TextScaled,foot.BackgroundTransparency=UDim2.new(1,0,0,25),UDim2.new(0,0,1,-25),"TG: @Neko_Chhan",Color3.fromRGB(180,180,180),true,1
local d,s,p0
top.InputBegan:Connect(function(i)if i.UserInputType==1 then d=true s=i.Position p0=f.Position end end)
UIS.InputChanged:Connect(function(i)if d and i.UserInputType==0 then local m=i.Position-s;f.Position=UDim2.new(p0.X.Scale,p0.X.Offset+m.X,p0.Y.Scale,p0.Y.Offset+m.Y)end end)
UIS.InputEnded:Connect(function(i)if i.UserInputType==1 then d=false end end)
local themes={Dark={20,20,20,40,40,40},Purple={40,0,60,120,0,120},Blue={0,40,60,0,120,200},Red={60,0,0,200,0,0}};local cur="Dark"
local function apply(t)grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(t[1],t[2],t[3])),ColorSequenceKeypoint.new(1,Color3.fromRGB(t[4],t[5],t[6]))}end;apply(themes[cur])
local function newBtn(txt,y)local b=Instance.new("TextButton",cont)b.Size,b.Position,b.BackgroundColor3,b.TextColor3,b.TextScaled,b.Font=UDim2.new(1,-20,0,30),UDim2.new(0,10,0,y),Color3.fromRGB(50,50,50),Color3.new(1,1,1),true,Enum.Font.Gotham;b.Text=txt;Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)return b end
local esp=false
local espBtn=newBtn("ESP [OFF]",5)
espBtn.MouseButton1Click:Connect(function()esp=not esp;espBtn.Text="ESP ["..(esp and"ON"or"OFF").."]"end)
game:GetService("RunService").RenderStepped:Connect(function()
for _,plr in ipairs(game.Players:GetPlayers())do
if plr~=p and plr.Character and plr.Character:FindFirstChild("Head")then
local h=plr.Character.Head;local tag=h:FindFirstChild("E")
if esp and not tag then local b=Instance.new("BillboardGui",h);b.Name="E";b.Size=UDim2.new(0,100,0,20);b.AlwaysOnTop=true;local t=Instance.new("TextLabel",b);t.Size=UDim2.new(1,0,1,0);t.Text=plr.Name;t.BackgroundTransparency=1;t.TextColor3=Color3.new(1,0,0)
elseif not esp and tag then tag:Destroy()end end end end)
local skills={
{"Meteor","Thanos","Meteor",CFrame.new(-354.94,323.93,136.61),Enum.KeyCode.Z},
{"Shield","Green Lantern","Shield",CFrame.new(-881.03,336.72,28.69)*CFrame.Angles(2.24,1.5,-2.24),Enum.KeyCode.X},
{"Eruption","Darkseid","Eruption",CFrame.new(-702.83,324.44,468.23),Enum.KeyCode.C},
{"Grab","Darkseid","Grab",CFrame.new(-403.56,324.44,209.98),Enum.KeyCode.V},
{"Hit","Darkseid","DoubleHit",CFrame.new(-708.59,323.93,423.6),Enum.KeyCode.B}
}
local state,btns,bind={}, {},nil
for i,v in ipairs(skills)do
state[i]=false
local b=newBtn(v[1].." [OFF] ("..v[5].Name..")",35+i*35)
btns[i]=b
b.MouseButton1Click:Connect(function()bind=i;b.Text="Press key..."end)
end
UIS.InputBegan:Connect(function(i,gp)
if gp then return end
if bind then skills[bind][5]=i.KeyCode;btns[bind].Text=skills[bind][1].." [OFF] ("..i.KeyCode.Name..")";bind=nil return end
for k,v in ipairs(skills)do
if i.KeyCode==v[5]then state[k]=not state[k];btns[k].Text=v[1].." ["..(state[k]and"ON"or"OFF").."] ("..v[5].Name..")"end
end end)
local themeBtn=newBtn("Theme: "..cur,35+#skills*35+10)
themeBtn.MouseButton1Click:Connect(function()
local t={}for k in pairs(themes)do table.insert(t,k)end
cur=t[(table.find(t,cur)%#t)+1]
apply(themes[cur])
themeBtn.Text="Theme: "..cur end)
task.spawn(function()
while task.wait(0.3)do
for i,v in ipairs(skills)do
if state[i]and p.Character then pcall(function()e:FireServer(p.Character,v[2],v[3],v[4])end)end
end end end)
