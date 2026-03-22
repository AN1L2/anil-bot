local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
local SELECTED_MASTER_NAME = nil 
local saying = false
local targetName = "TMX" 
local delayTime = 1.0
local pattern = "_"

-- [[ PERMANENT SUPERIORS ]]
local SUPERIORS = {
    [8318041345] = {Name = "akj20095", Nick = "anil"},
    [7224046803] = {Name = "god_ofgame99920", Nick = "ayu"}
}

local roMessages = {
    "TMX MEH FIRE 🔥","FYTER BNEGA?🤣","BCHE Anil ON TOP👑","TMX MEH Rocket 🚀",
    "TMX MEH electricity ⚡","TMX meh SURF 😆","Leave marde 🤣","ANIL ON TOP BOL 🔥",
    "TMX MEH BOOK 📚","Pil gya itni jaldi 🤣","Itna lallu fyter🤧","ANIL PAPA👑",
    "Tmx meh petroleum","Dffn?😔","Bhag ja bache😹","Tmx meh dino 😈",
    "TMX MEH MAJDOOR","TMX MEH SCRIPT","TMX MEH TREE🌴","TMX MEH CLIP",
    "Tmx Allu🥔","TMX MEH GOAT","TMX MEH BLAZE","TMX MEH SALT",
    "TMX MEH ROD","TMX MEH UNIVERSE","TMX MEH SOFA",
    "TMX MEH KEYBOARD","TMX MEH SNIPER","ANIL ON TOP👑"
}

-- [[ STATES ]]
local FLYING, NOSIT, SPINNING, BANGING, HEADSITTING, FORCESIT = false, false, false, false, false, false
local FOLLOW_TARGET = nil
local BG, BV = nil, nil

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function sendChat(msg)
    pcall(function()
        TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end)
end

local function generateLine()
    return string.rep(pattern, 150)
end

-- [[ TOTAL RESET ]]
local function stopAll()
    if saying then sendChat("spam stoppedddddddddddd") end
    saying = false; FLYING = false; FOLLOW_TARGET = nil; SPINNING = false; 
    BANGING = false; HEADSITTING = false; NOSIT = false; FORCESIT = false
    if BG then BG:Destroy() BG = nil end
    if BV then BV:Destroy() BV = nil end
    local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false; hum.Sit = false end
end

-- [[ AUTO-WBB ]]
local function checkWBB(p)
    if SUPERIORS[p.UserId] then
        task.spawn(function()
            repeat task.wait(0.5) until p.Character and getRoot(p.Character)
            task.wait(1.5) 
            sendChat("wbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb master " .. SUPERIORS[p.UserId].Nick)
        end)
    end
end

-- [[ COMMAND HANDLER ]]
local function handleCommand(speaker, message)
    local isMaster = SUPERIORS[speaker.UserId] or (SELECTED_MASTER_NAME and speaker.Name == SELECTED_MASTER_NAME)
    if not isMaster then return end

    local args = message:split(" ")
    local cmd = args[1]:lower()
    
    local function getPlr(name)
        if not name then return nil end
        for _, v in pairs(Players:GetPlayers()) do
            if v.Name:lower():sub(1, #name) == name:lower() or v.DisplayName:lower():sub(1, #name) == name:lower() then return v end
        end
        return nil
    end

    -- SPAM COMMANDS
    if cmd == "!ro" then
        targetName = args[2] or "TMX"
        if saying then return end
        saying = true
        task.spawn(function()
            while saying do
                task.spawn(function()
                    local msgText = roMessages[math.random(1, #roMessages)]
                    sendChat(generateLine().."\n"..targetName.."\n"..msgText)
                end)
                task.wait(delayTime)
            end
        end)
    elseif cmd == "!delay" then
        local newDelay = tonumber(args[2])
        if newDelay then
            delayTime = newDelay
            sendChat("!!!!!!!delay set to " .. tostring(delayTime) .. " !!!!!!!!")
        end
    elseif cmd == "!stop" then 
        stopAll()

    -- TELEPORT & MOVEMENT
    elseif cmd == "!to" then
        local target = getPlr(args[2])
        if target and target.Character and getRoot(target.Character) then
            getRoot(lp.Character).CFrame = getRoot(target.Character).CFrame
        end
    elseif cmd == "!follow" then FOLLOW_TARGET = getPlr(args[2])
    elseif cmd == "!unfollow" then FOLLOW_TARGET = nil
    elseif cmd == "!fly" then FLYING = true
    elseif cmd == "!unfly" then FLYING = false; if BG then BG:Destroy() BG = nil end; if BV then BV:Destroy() BV = nil end; if lp.Character then lp.Character.Humanoid.PlatformStand = false end

    -- DEMON / FUN
    elseif cmd == "!bang" then FOLLOW_TARGET = getPlr(args[2]); BANGING = true
    elseif cmd == "!unbang" then BANGING = false; FOLLOW_TARGET = nil
    elseif cmd == "!headsit" then FOLLOW_TARGET = getPlr(args[2]); HEADSITTING = true
    elseif cmd == "!unheadsit" then HEADSITTING = false; FOLLOW_TARGET = nil
    elseif cmd == "!spin" then SPINNING = true
    elseif cmd == "!unspin" then SPINNING = false

    -- SIT SYSTEM
    elseif cmd == "!sit" then FORCESIT = true
    elseif cmd == "!unsit" then FORCESIT = false; if lp.Character then lp.Character:FindFirstChildOfClass("Humanoid").Sit = false end
    elseif cmd == "!nosit" then NOSIT = true
    elseif cmd == "!unnosit" then NOSIT = false

    -- UTILS
    elseif cmd == "!rejoin" then TeleportService:Teleport(game.PlaceId, lp)
    elseif cmd == "!say" then sendChat(message:sub(6))
    elseif cmd == "!cmds" then
        sendChat("V18: !ro, !to, !stop, !delay, !sit/!unsit, !bang/!unbang, !headsit/!unheadsit, !follow/!unfollow, !fly/!unfly, !spin/!unspin, !nosit/!unnosit, !rejoin")
    end
end

-- LISTENERS
Players.PlayerAdded:Connect(function(p) checkWBB(p); p.Chatted:Connect(function(m) handleCommand(p, m) end) end)
for _, p in pairs(Players:GetPlayers()) do checkWBB(p); p.Chatted:Connect(function(m) handleCommand(p, m) end) end

-- ENGINE (HEARTBEAT)
RunService.Heartbeat:Connect(function()
    if not lp.Character or not lp.Character:FindFirstChildOfClass("Humanoid") then return end
    local root = getRoot(lp.Character)
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")

    if FORCESIT then hum.Sit = true end

    if FOLLOW_TARGET and FOLLOW_TARGET.Character then
        local tRoot = getRoot(FOLLOW_TARGET.Character)
        if tRoot then
            if BANGING then
                root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1 + (math.sin(tick() * 12) * 1.2))
            elseif HEADSITTING then
                root.CFrame = tRoot.CFrame * CFrame.new(0, 1.7, 0); hum.Sit = true
            else
                root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
    if FLYING then
        hum.PlatformStand = true 
        if not BG or BG.Parent ~= root then BG = Instance.new('BodyGyro', root) BG.P = 9e4 BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9) end
        if not BV or BV.Parent ~= root then BV = Instance.new('BodyVelocity', root) BV.MaxForce = Vector3.new(9e9, 9e9, 9e9) end
        BV.Velocity = workspace.CurrentCamera.CFrame.LookVector * 80; BG.CFrame = workspace.CurrentCamera.CFrame
    end
    if SPINNING then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0) end
    if NOSIT then hum.Sit = false end
end)

-- GUI SYSTEM
local gui = Instance.new("ScreenGui", lp.PlayerGui); gui.ResetOnSpawn = false; gui.Name = "AnilBotUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 380); frame.Position = UDim2.new(0.5, -125, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); frame.Active = true; frame.Draggable = true; frame.Visible = false; Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "👑 ANIL DEMON V18"; title.TextColor3 = Color3.new(1, 1, 1); title.BackgroundColor3 = Color3.fromRGB(45, 0, 90); Instance.new("UICorner", title)

local targetLabel = Instance.new("TextLabel", frame)
targetLabel.Size = UDim2.new(1, 0, 0, 30); targetLabel.Position = UDim2.new(0, 0, 0, 45); targetLabel.Text = "MASTER: NONE"; targetLabel.TextColor3 = Color3.new(1, 1, 0); targetLabel.BackgroundTransparency = 1

local releaseBtn = Instance.new("TextButton", frame)
releaseBtn.Size = UDim2.new(0.5, -10, 0, 30); releaseBtn.Position = UDim2.new(0, 5, 0, 75); releaseBtn.Text = "RELEASE"; releaseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0); releaseBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", releaseBtn)

local refreshBtn = Instance.new("TextButton", frame)
refreshBtn.Size = UDim2.new(0.5, -10, 0, 30); refreshBtn.Position = UDim2.new(0.5, 5, 0, 75); refreshBtn.Text = "REFRESH"; refreshBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0); refreshBtn.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", refreshBtn)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -115); scroll.Position = UDim2.new(0, 5, 0, 110); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 3

local toggle = Instance.new("ImageButton", gui)
toggle.Size = UDim2.new(0, 65, 0, 65); toggle.Position = UDim2.new(0, 10, 0.5, -32)
toggle.Image = "rbxassetid://6035145364"; toggle.BackgroundColor3 = Color3.fromRGB(45, 0, 90); toggle.Active = true; toggle.Draggable = true; toggle.ZIndex = 10; Instance.new("UICorner", toggle)

local fallback = Instance.new("TextLabel", toggle)
fallback.Size = UDim2.new(1, 0, 1, 0); fallback.Text = "A"; fallback.TextColor3 = Color3.new(1,1,1); fallback.BackgroundTransparency = 1; fallback.Font = Enum.Font.GothamBold; fallback.TextSize = 25

local function updateList()
    scroll:ClearAllChildren()
    local y = 0
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, -5, 0, 30); btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = p.Name; btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function() SELECTED_MASTER_NAME = p.Name; targetLabel.Text = "MASTER: " .. p.Name:upper(); sendChat(generateLine().."\nMaster set to: " .. p.Name) end)
            y = y + 35
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, y)
end

toggle.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible; if frame.Visible then updateList() end end)
refreshBtn.MouseButton1Click:Connect(updateList)
releaseBtn.MouseButton1Click:Connect(function() SELECTED_MASTER_NAME = nil; targetLabel.Text = "MASTER: NONE"; stopAll() end)
updateList()
