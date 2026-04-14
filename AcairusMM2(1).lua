-- Acairus MM2 | WindUI Script
-- Author: By Acairus

local WindUI
do
    local ok, result = pcall(function() return require("./src/Init") end)
    if ok then
        WindUI = result
    else
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end
end

-- Services
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")

local localplayer = Players.LocalPlayer

-- ============================================================
--  COLORS
-- ============================================================
local Red    = Color3.fromHex("#EF4F1D")
local Blue   = Color3.fromHex("#257AF7")
local Green  = Color3.fromHex("#10C550")
local Purple = Color3.fromHex("#7775F2")
local Yellow = Color3.fromHex("#ECA201")
local Grey   = Color3.fromHex("#83889E")
local Cyan   = Color3.fromHex("#00D4FF")

-- ============================================================
--  WINDOW
-- ============================================================
local Window = WindUI:CreateWindow({
    Title         = "Acairus MM2",
    Author        = "By Acairus",
    Icon          = "solar:shield-star-bold-duotone",
    Theme         = "Sky",
    Folder        = "AcairusMM2",
    NewElements   = true,
    HideSearchBar = false,
    Transparency  = 0.7,
    OpenButton    = {
        Title      = "Acairus MM2",
        Enabled    = true,
        Draggable  = true,
        OnlyMobile = false,
        Scale      = 1,
        Color      = ColorSequence.new(
            Color3.fromHex("#00D4FF"),
            Color3.fromHex("#7775F2")
        ),
    },
    Topbar = {
        Height      = 60,
        ButtonsType = "Mac",
    },
})

Window:Tag({
    Title  = "MM2 V1",
    Icon   = "solar:shield-bold",
    Color  = Color3.fromHex("#7775F2"),
    Border = true,
})

-- ============================================================
--  WINDOW SECTIONS
-- ============================================================
local AboutSection   = Window:Section({ Title = "About Acairus",   Icon = "solar:info-square-bold-duotone", Opened = true })
local MainSection    = Window:Section({ Title = "Main",    Icon = "solar:home-2-bold",               Opened = true })
local UtilitySection = Window:Section({ Title = "Utility", Icon = "solar:settings-bold-duotone",     Opened = true })

-- ============================================================
--  ABOUT TAB  (declared first so it opens on launch)
-- ============================================================
do
    local AboutTab = AboutSection:Tab({
        Title     = "About",
        Icon      = "solar:info-square-bold-duotone",
        IconColor = Cyan,
        Border    = true,
    })

    -- Header
    AboutTab:Section({
        Title      = "Acairus MM2",
        TextSize   = 22,
        FontWeight = Enum.FontWeight.Bold,
    })

    AboutTab:Section({
        Title            = "MM2 script made by Acairus. Has most of the stuff you'd need  ESP, combat tools, movement stuff, and more.",
        TextSize         = 14,
        TextTransparency = 0.3,
        FontWeight       = Enum.FontWeight.Medium,
    })

    AboutTab:Space({ Columns = 3 })

    -- Features
    local FeaturesBox = AboutTab:Section({
        Title     = "What's inside",
        Icon      = "solar:star-bold-duotone",
        Box       = true,
        BoxBorder = true,
        Opened    = true,
    })

    FeaturesBox:Section({
        Title            = "ESP Murderer, Sheriff, Innocent, Gun Drop highlights\nCombat  Kill Aura,Auto Shoot, Aimbot, Knife Throw\nMovement  Fly, Speed Glitch, Anti Fling\nGeneral Coin TP, Round Timer, Player Actions\nPlayer  Walk Speed, Jump Height, Anti AFK, God Mode\nUtility   Rejoin, Copy Game / Job ID",
        TextSize         = 13,
        TextTransparency = 0.25,
        FontWeight       = Enum.FontWeight.Medium,
    })

    AboutTab:Space({ Columns = 3 })

    -- Discord
    local DiscordBox = AboutTab:Section({
        Title     = "Discord",
        Icon      = "solar:chat-round-bold-duotone",
        Box       = true,
        BoxBorder = true,
        Opened    = true,
    })

    DiscordBox:Section({
        Title            = "Join the server if you want to keep up with updates, report bugs, or just hang. New stuff gets posted there first.",
        TextSize         = 13,
        TextTransparency = 0.3,
        FontWeight       = Enum.FontWeight.Medium,
    })

    DiscordBox:Space()

    DiscordBox:Button({
        Title   = "Copy Discord Invite Link",
        Desc    = "discord.gg/np4JVBYH6x",
        Icon    = "solar:link-bold-duotone",
        Color   = Color3.fromHex("#5865F2"),
        Justify = "Center",
        Callback = function()
            pcall(function() setclipboard("https://discord.gg/np4JVBYH6x") end)
            WindUI:Notify({
                Title   = "Discord",
                Content = "Copied! discord.gg/np4JVBYH6x",
                Icon    = "solar:link-bold-duotone",
            })
        end,
    })

    AboutTab:Space({ Columns = 3 })

    -- Credits
    AboutTab:Section({
        Title            = "made by Acairus",
        TextSize         = 12,
        TextTransparency = 0.45,
        FontWeight       = Enum.FontWeight.Medium,
    })

    -- Auto-open on launch
    task.defer(function()
        pcall(function() AboutTab:Select() end)
    end)
end

-- ============================================================
--  MM2 HELPERS
-- ============================================================
local playerData = {}

local function findMurderer()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Knife") then return i end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Character and i.Character:FindFirstChild("Knife") then return i end
    end
    if playerData then
        for player, data in pairs(playerData) do
            if data.Role == "Murderer" then
                local p = Players:FindFirstChild(player)
                if p then return p end
            end
        end
    end
    return nil
end

local function findSheriff()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Gun") then return i end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Character and i.Character:FindFirstChild("Gun") then return i end
    end
    if playerData then
        for player, data in pairs(playerData) do
            if data.Role == "Sheriff" then
                local p = Players:FindFirstChild(player)
                if p then return p end
            end
        end
    end
    return nil
end

local function getMap()
    for _, o in ipairs(workspace:GetChildren()) do
        if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then
            return o
        end
    end
    return nil
end

pcall(function()
    game.ReplicatedStorage:WaitForChild("Remotes", 5)
        :WaitForChild("Gameplay")
        :WaitForChild("PlayerDataChanged", 5)
        .OnClientEvent:Connect(function(data)
            playerData = data
        end)
end)

-- ============================================================
--  ESP SYSTEM
-- ============================================================
local ESPEnabled  = false
local ESPSelected = {}  -- { ["Murderer"] = true, ["Sheriff"] = true, ... }

local ESPColors = {
    Murderer = Color3.new(1, 0, 0.0156863),
    Sheriff  = Color3.new(0, 0.6, 1),
    Innocent = Color3.new(0, 1, 0.0313725),
    Hero     = Color3.new(0.952941, 1, 0.0745098),
    GunDrop  = Color3.new(0.952941, 1, 0.0745098),
}

local espHighlights = {}

local function removeESP(obj)
    if espHighlights[obj] then
        pcall(function() espHighlights[obj]:Destroy() end)
        espHighlights[obj] = nil
    end
end

local function addHighlight(obj, color)
    if not obj or not obj.Parent then return end
    if espHighlights[obj] then pcall(function() espHighlights[obj]:Destroy() end) end
    local h = Instance.new("Highlight")
    h.FillColor           = color or Color3.new(1,1,1)
    h.OutlineColor        = color or Color3.new(1,1,1)
    h.FillTransparency    = 0.45
    h.OutlineTransparency = 0
    h.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee             = obj
    h.Parent              = obj
    espHighlights[obj]    = h
end

local function clearAllESP()
    for obj, h in pairs(espHighlights) do
        pcall(function() h:Destroy() end)
    end
    espHighlights = {}
end

local function isSelected(role)
    local any = false
    for _, v in pairs(ESPSelected) do if v then any = true break end end
    if not any then return true end
    return ESPSelected[role] == true
end

local function reloadESP()
    clearAllESP()
    if not ESPEnabled then return end
    if isSelected("Gun Drop") then
        local map = getMap()
        if map then
            local gd = map:FindFirstChild("GunDrop")
            if gd then addHighlight(gd, ESPColors.GunDrop) end
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player == localplayer then continue end
        local char     = player.Character
        if not char    then continue end
        local isMurd   = (player == findMurderer())
        local isSher   = (player == findSheriff())
        if isMurd and isSelected("Murderer") then
            addHighlight(char, ESPColors.Murderer)
        elseif isSher and isSelected("Sheriff") then
            addHighlight(char, ESPColors.Sheriff)
        elseif isSher and isSelected("Hero") then
            addHighlight(char, ESPColors.Hero)
        elseif not isMurd and not isSher and isSelected("Innocent") then
            addHighlight(char, ESPColors.Innocent)
        end
    end
end

workspace.ChildAdded:Connect(function(ch)
    if ch == getMap() and ESPEnabled then task.wait(2); reloadESP() end
end)
workspace.ChildRemoved:Connect(function(ch)
    if ch == getMap() then clearAllESP() end
end)
workspace.DescendantAdded:Connect(function(ch)
    if ESPEnabled and ch.Name == "GunDrop" and isSelected("Gun Drop") then
        addHighlight(ch, ESPColors.GunDrop)
    end
end)
workspace.DescendantRemoving:Connect(function(ch)
    if ch.Name == "GunDrop" then removeESP(ch) end
end)

-- ============================================================
--  COIN TP
-- ============================================================
local coinTPEnabled  = false
local coinTPMode     = "Nearest"
local lastCoinTP     = 0
local coinTPInterval = 0.7
local lastCoinTPed   = nil

local function getCoinContainer()
    for _, o in ipairs(workspace:GetChildren()) do
        local c = o:FindFirstChild("CoinContainer")
        if c then return c end
    end
    return nil
end

local function getNearestCoin(hrp)
    local container = getCoinContainer()
    if not container then return nil end
    local nearest, minDist = nil, 50
    for _, coin in ipairs(container:GetChildren()) do
        if coin:IsA("BasePart") and coin ~= lastCoinTPed then
            local dist = (coin.Position - hrp.Position).Magnitude
            if dist < minDist then minDist = dist; nearest = coin end
        end
    end
    return nearest
end

local function getRandomCoin()
    local container = getCoinContainer()
    if not container then return nil end
    local coins = {}
    for _, coin in ipairs(container:GetChildren()) do
        if coin:IsA("BasePart") and coin ~= lastCoinTPed then
            table.insert(coins, coin)
        end
    end
    if #coins == 0 then return nil end
    return coins[math.random(1, #coins)]
end

RunService.Heartbeat:Connect(function()
    if not coinTPEnabled then return end
    if tick() - lastCoinTP < coinTPInterval then return end
    local char = localplayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = coinTPMode == "Nearest" and getNearestCoin(hrp) or getRandomCoin()
    if target then
        hrp.CFrame   = target.CFrame
        lastCoinTPed = target
        lastCoinTP   = tick()
    end
end)

-- ============================================================
--  MISC STATE
-- ============================================================
local antiAfkConn    = nil
local spinConn       = nil
local walkSpeedConn  = nil
local walkSpeedVal   = 16
local jumpHeightConn = nil
local jumpHeightVal  = 50
local timerLabel     = nil
local timerTask      = nil
local spectateConn   = nil

-- ============================================================
--  HITBOX EXPANDER STATE
-- ============================================================
local hitboxEnabled   = false
local hitboxSize      = 2
local hitboxColor     = Color3.fromRGB(255, 50, 50)
local hitboxParts     = {}   -- [BasePart] = { original size, original material, original color, part ref }
local hitboxShowConn  = nil

local function clearHitboxes()
    for part, data in pairs(hitboxParts) do
        pcall(function()
            if part and part.Parent then
                part.Size         = data.originalSize
                part.Material     = data.originalMaterial
                part.Color        = data.originalColor
                part.Transparency = data.originalTransparency
                part.CanCollide   = data.originalCanCollide  -- restore original collision
            end
        end)
    end
    hitboxParts = {}
end

local function applyHitbox(player)
    if player == localplayer then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or hitboxParts[hrp] then return end
    hitboxParts[hrp] = {
        originalSize         = hrp.Size,
        originalMaterial     = hrp.Material,
        originalColor        = hrp.Color,
        originalTransparency = hrp.Transparency,
        originalCanCollide   = hrp.CanCollide,
    }
    hrp.Size        = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
    hrp.CanCollide  = false  -- always non-collidable so expanded hitbox doesn't block local player
    if hitboxEnabled then
        -- visible mode
        hrp.Material     = Enum.Material.Neon
        hrp.Color        = hitboxColor
        hrp.Transparency = 0.35
    else
        -- invisible expanded hitbox
        hrp.Material     = Enum.Material.SmoothPlastic
        hrp.Transparency = 1
    end
end

local function reloadHitboxes()
    clearHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        applyHitbox(player)
    end
end

-- Auto-reapply hitboxes on new characters
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if hitboxSize > 1 then applyHitbox(player) end
    end)
end)
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if hitboxSize > 1 then applyHitbox(player) end
    end)
end

-- ============================================================
--  FLY MODULE  (YARHM-style BodyGyro / BodyVelocity fly)
-- ============================================================
local FlyModule = (function()
    local m        = {}
    local RS       = RunService
    local flying   = false
    local maxSpeed = 20
    local accel    = 2
    local curSpeed = 0
    local curDir   = Vector3.new()
    local bodyGyro = nil
    local bodyVel  = nil
    local flyConn  = nil

    local function cleanup()
        if flyConn  then flyConn:Disconnect();  flyConn  = nil end
        if bodyGyro then bodyGyro:Destroy();     bodyGyro = nil end
        if bodyVel  then bodyVel:Destroy();      bodyVel  = nil end
        local char = localplayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
        flying   = false
        curSpeed = 0
    end

    local function onHeartbeat()
        local char = localplayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = hum and hum.RootPart
        local cam  = workspace.CurrentCamera
        if not flying or not char or not hum or not hrp or not cam then
            m:Stop(); return
        end
        if hum.Health <= 0 then m:Stop(); return end

        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0.01 then
            curSpeed = math.min(maxSpeed, curSpeed + accel)
            curDir   = moveDir.Unit
        else
            curSpeed = math.max(0, curSpeed - accel)
        end

        local hDir    = Vector3.new(curDir.X, 0, curDir.Z)
        local vel     = Vector3.zero
        if hDir.Magnitude > 0 then vel = hDir.Unit * curSpeed end

        local look   = cam.CFrame.LookVector.Unit
        local dot    = curDir:Dot(look)
        local sign   = dot < 0 and -1 or 1
        local hLook  = Vector3.new(look.X, 0, look.Z)
        local tiltAmt = hLook.Magnitude > 0 and math.abs(curDir:Dot(hLook.Unit)) or 0
        local tiltY  = look.Y * sign * tiltAmt
        local tiltVel = tiltY * curSpeed

        bodyVel.Velocity  = Vector3.new(vel.X, tiltVel, vel.Z)
        local tiltAngle   = -math.rad(dot * (curSpeed / maxSpeed) * 30)
        bodyGyro.CFrame   = CFrame.new(hrp.Position, hrp.Position + look) * CFrame.Angles(tiltAngle, 0, 0)
    end

    function m:Start()
        if flying then return end
        local char = localplayer.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = hum and hum.RootPart
        if not char or not hum or not hrp then return end
        flying = true

        bodyGyro           = Instance.new("BodyGyro")
        bodyGyro.P         = 100000
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.CFrame    = hrp.CFrame
        bodyGyro.Parent    = hrp

        bodyVel            = Instance.new("BodyVelocity")
        bodyVel.P          = 10000
        bodyVel.MaxForce   = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity   = Vector3.zero
        bodyVel.Parent     = hrp

        hum.PlatformStand  = true
        flyConn = RS.Heartbeat:Connect(onHeartbeat)
    end

    function m:Stop()
        if not flying then return end
        cleanup()
    end

    function m:SetMaxSpeed(spd)
        if type(spd) == "number" and spd >= 0 then maxSpeed = spd end
    end

    function m:IsFlying() return flying end

    localplayer.CharacterRemoving:Connect(function()
        if flying then cleanup() end
    end)

    return m
end)()

local function secondsToMinutes(s)
    if s == -1 then return "" end
    return string.format("%dm %ds", math.floor(s / 60), s % 60)
end

local function spectatePlayer(player)
    if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
    if not player or not player.Character then return end
    workspace.CurrentCamera.CameraSubject =
        player.Character:FindFirstChildOfClass("Humanoid")
        or player.Character:FindFirstChild("HumanoidRootPart")
    spectateConn = player.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        workspace.CurrentCamera.CameraSubject = char:WaitForChild("Humanoid")
    end)
end

local function stopSpectate()
    if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
    local char = localplayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    end
end

local function getOtherPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localplayer then table.insert(names, p.Name) end
    end
    if #names == 0 then table.insert(names, "(No players)") end
    return names
end

local function teleportToPlayer(player)
    local hrp  = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
    local tHRP = player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then hrp.CFrame = tHRP.CFrame + Vector3.new(2, 0, 0) end
end

local function flingPlayer(player)
    local myChar = localplayer.Character
    local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local myHRP  = myHum and myHum.RootPart
    if not myChar or not myHum or not myHRP then return end

    local tChar = player and player.Character
    if not tChar then return end
    local tHum  = tChar:FindFirstChildOfClass("Humanoid")
    local tHRP  = tHum and tHum.RootPart
    local tHead = tChar:FindFirstChild("Head")
    local tAccessory = tChar:FindFirstChildOfClass("Accessory")
    local tHandle = tAccessory and tAccessory:FindFirstChild("Handle")

    local targetPart = tHRP or tHead or tHandle
    if not targetPart then return end

    -- Save our old position so we can return after flinging
    local oldCFrame = myHRP.CFrame

    local function applyFlingForce(basePart, offsetPos, offsetAng)
        myHRP.CFrame = CFrame.new(basePart.Position) * offsetPos * offsetAng
        myChar:SetPrimaryPartCFrame(CFrame.new(basePart.Position) * offsetPos * offsetAng)
        myHRP.Velocity    = Vector3.new(9e7, 9e7 * 10, 9e7)
        myHRP.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    local angle = 0
    local startTime = tick()
    local timeLimit = 2

    repeat
        if not (myHRP and tHum) then break end
        if targetPart.Velocity.Magnitude < 50 then
            angle = angle + 100
            applyFlingForce(targetPart, CFrame.new(0, 1.5, 0) + tHum.MoveDirection * math.max(targetPart.Velocity.Magnitude, 1) / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            applyFlingForce(targetPart, CFrame.new(0, -1.5, 0) + tHum.MoveDirection * math.max(targetPart.Velocity.Magnitude, 1) / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            applyFlingForce(targetPart, CFrame.new(2.25, 1.5, -2.25) + tHum.MoveDirection * math.max(targetPart.Velocity.Magnitude, 1) / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
            applyFlingForce(targetPart, CFrame.new(-2.25, -1.5, 2.25) + tHum.MoveDirection * math.max(targetPart.Velocity.Magnitude, 1) / 1.25, CFrame.Angles(math.rad(angle), 0, 0))
            task.wait()
        else
            applyFlingForce(targetPart, CFrame.new(0, 1.5, tHum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
            task.wait()
            applyFlingForce(targetPart, CFrame.new(0, -1.5, -tHum.WalkSpeed), CFrame.new())
            task.wait()
        end
    until (targetPart.Velocity.Magnitude > 500) or (tick() - startTime >= timeLimit)

    -- Snap back to original position
    task.wait(0.1)
    pcall(function()
        if myHRP and myHRP.Parent then
            myHRP.CFrame = oldCFrame
            myChar:SetPrimaryPartCFrame(oldCFrame)
        end
    end)
end

local function teleportToPlace(place)
    local char = localplayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if place == "Lobby" then
        local lobby = workspace:FindFirstChild("Lobby")
        if lobby then
            local sf    = lobby:FindFirstChild("Spawns")
            local spawn = sf and sf:FindFirstChildWhichIsA("SpawnLocation")
                       or lobby:FindFirstChildWhichIsA("SpawnLocation")
            if spawn then hrp.CFrame = spawn.CFrame
            else char:MoveTo(Vector3.new(-350, 522, -4)) end
        end
    elseif place == "Map" then
        local map = getMap()
        if map then
            local sf = map:FindFirstChild("Spawns")
            if sf then
                local spawns = sf:GetChildren()
                if #spawns > 0 then char:MoveTo(spawns[math.random(1, #spawns)].Position) end
            end
        end
    elseif place == "Murderer" then
        local murd = findMurderer()
        local mHRP = murd and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart")
        if mHRP then hrp.CFrame = mHRP.CFrame + Vector3.new(2, 0, 0) end
    elseif place == "Sheriff" then
        local sher = findSheriff()
        local sHRP = sher and sher.Character and sher.Character:FindFirstChild("HumanoidRootPart")
        if sHRP then hrp.CFrame = sHRP.CFrame + Vector3.new(2, 0, 0) end
    end
end

local function activateGodmode()
    local Cam  = workspace.CurrentCamera
    local Pos  = Cam.CFrame
    local Char = localplayer.Character
    if not Char then return end
    local Human = Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    local nH = Human:Clone()
    nH.Parent = Char
    localplayer.Character = nil
    nH:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    nH:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    nH:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    nH.BreakJointsOnDeath = true
    Human:Destroy()
    localplayer.Character = Char
    Cam.CameraSubject = nH
    task.wait()
    Cam.CFrame = Pos
    nH.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    local Anim = Char:FindFirstChild("Animate")
    if Anim then Anim.Disabled = true; task.wait(); Anim.Disabled = false end
    nH.Health = nH.MaxHealth
end

local function killEveryone()
    if findMurderer() ~= localplayer then
        WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the murderer!", Icon = "solar:skull-bold" })
        return
    end
    local char = localplayer.Character
    if not char then return end
    if not char:FindFirstChild("Knife") then
        local hum = char:FindFirstChild("Humanoid")
        if localplayer.Backpack:FindFirstChild("Knife") then
            hum:EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
        else
            WindUI:Notify({ Title = "Acairus MM2", Content = "No knife found!" })
            return
        end
    end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localplayer then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            hrp.Anchored = true
            hrp.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 1
        end
    end
    char.Knife.Stab:FireServer("Slash")
    task.delay(2, function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:FindFirstChild("HumanoidRootPart").Anchored = false
            end
        end
    end)
end

-- ============================================================
--  COMBAT HELPERS
-- ============================================================
local killAuraConn      = nil
local killAuraDist      = 10
local autoKillEveryoneConn = nil
local autoKillSheriffConn  = nil
local autoKnifeThrowConn   = nil
local loopKnifeThrow       = false
local autoShootConn        = nil
local shootOffset          = 2.8  -- kept for knife throw compat
local BULLET_SPEED         = 200  -- studs/s approximate MM2 gun projectile speed

local function findNearestPlayer()
    local nearestPlayer  = nil
    local shortestDistance = math.huge
    local localHRP = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
    if not localHRP then return nil end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localplayer and player.Character then
            local otherHRP = player.Character:FindFirstChild("HumanoidRootPart")
            if otherHRP then
                local dist = (localHRP.Position - otherHRP.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

local function getPredictedPosition(player, offset)
    local playerHRP = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local playerHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not playerHRP or not playerHum then
        return playerHRP and playerHRP.Position or Vector3.new()
    end

    -- Aim at upper torso (slightly above HRP center) for better hit reg
    local aimBase = playerHRP.Position + Vector3.new(0, 0.5, 0)

    local myHRP = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
    local dist  = myHRP and (aimBase - myHRP.Position).Magnitude or 20

    -- Calculate lead time based on actual distance and bullet travel speed
    -- Small damping so we don't over-lead at close range
    local leadTime = (dist / BULLET_SPEED) * 0.85

    local vel     = playerHRP.AssemblyLinearVelocity
    local moveDir = playerHum.MoveDirection

    -- Blend velocity-based lead with movement direction for accuracy at all ranges
    local velLead  = Vector3.new(vel.X, vel.Y * 0.3, vel.Z) * leadTime
    local dirLead  = moveDir * (playerHum.WalkSpeed * leadTime * 0.6)

    return aimBase + velLead + dirLead
end

local function ensureKnifeEquipped()
    local char = localplayer.Character
    if not char then return false end
    if not char:FindFirstChild("Knife") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if localplayer.Backpack:FindFirstChild("Knife") then
            hum:EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
            task.wait(0.1)
        else
            WindUI:Notify({ Title = "Acairus MM2", Content = "You don't have the knife!", Icon = "triangle-alert" })
            return false
        end
    end
    return true
end

local function ensureGunEquipped()
    local char = localplayer.Character
    if not char then return false end
    if not char:FindFirstChild("Gun") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if localplayer.Backpack:FindFirstChild("Gun") then
            hum:EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
            task.wait(0.1)
        else
            WindUI:Notify({ Title = "Acairus MM2", Content = "You don't have the gun!", Icon = "triangle-alert" })
            return false
        end
    end
    return true
end

local function throwKnifeToClosest()
    if findMurderer() ~= localplayer then
        WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the murderer!", Icon = "triangle-alert" })
        return
    end
    if not ensureKnifeEquipped() then return end
    local nearest = findNearestPlayer()
    if not nearest or not nearest.Character then
        WindUI:Notify({ Title = "Acairus MM2", Content = "No player found nearby!", Icon = "triangle-alert" })
        return
    end
    local nearestHRP = nearest.Character:FindFirstChild("HumanoidRootPart")
    if not nearestHRP then return end
    local char = localplayer.Character
    local myHRP = char and char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local argsThrow = {
        CFrame.new(char.RightHand.Position),
        CFrame.new(getPredictedPosition(nearest, shootOffset + 1)),
    }
    char:WaitForChild("Knife"):WaitForChild("Events"):WaitForChild("KnifeThrown"):FireServer(unpack(argsThrow))
end

local function killSheriff()
    if findMurderer() ~= localplayer then
        WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the murderer!", Icon = "triangle-alert" })
        return
    end
    if not ensureKnifeEquipped() then return end
    local sheriff = findSheriff()
    if not sheriff then
        WindUI:Notify({ Title = "Acairus MM2", Content = "No sheriff found!", Icon = "triangle-alert" })
        return
    end
    local sherHRP = sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart")
    if not sherHRP then return end
    local myHRP = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    sherHRP.Anchored = true
    sherHRP.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 1
    localplayer.Character.Knife.Stab:FireServer("Slash")
    task.delay(2, function()
        if sherHRP and sherHRP.Parent then sherHRP.Anchored = false end
    end)
end

-- Kill Aura heartbeat loop
-- ensureKnifeEquipped() yields (task.wait inside), so we never call it inside Heartbeat.
-- Instead we check synchronously; if no knife, skip this tick.
local killAuraDebounce = false
RunService.Heartbeat:Connect(function()
    if not killAuraConn then return end
    if killAuraDebounce then return end
    if findMurderer() ~= localplayer then return end
    local char = localplayer.Character
    if not char then return end
    -- Only act if knife is already equipped (no yielding calls inside Heartbeat)
    local knife = char:FindFirstChild("Knife")
    if not knife then
        -- Try to equip from backpack in a separate thread so Heartbeat doesn't stall
        task.spawn(function()
            local bp = localplayer.Backpack:FindFirstChild("Knife")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if bp and hum then hum:EquipTool(bp) end
        end)
        return
    end
    local myHRP = char:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localplayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - myHRP.Position).Magnitude <= killAuraDist then
                killAuraDebounce = true
                hrp.Anchored = true
                hrp.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 2
                knife.Stab:FireServer("Slash")
                task.delay(1, function()
                    if hrp and hrp.Parent then hrp.Anchored = false end
                    killAuraDebounce = false
                end)
                return
            end
        end
    end
end)

-- Auto Knife Throw loop
task.spawn(function()
    while task.wait(1.5) do
        if loopKnifeThrow then
            pcall(throwKnifeToClosest)
        end
    end
end)

-- Auto Shoot Murderer loop (throttled to avoid freezing)
local lastAutoShot = 0
RunService.Heartbeat:Connect(function()
    if not autoShootConn then return end
    if findSheriff() ~= localplayer then return end
    local now = tick()
    if now - lastAutoShot < 0.35 then return end  -- max ~3 shots/sec, not 20
    lastAutoShot = now
    local murderer = findMurderer()
    if not murderer then return end
    local murdHRP = murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart")
    local myHRP   = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
    if not murdHRP or not myHRP then return end
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = { localplayer.Character, murderer.Character }
    local dir = murdHRP.Position - myHRP.Position
    local hit = workspace:Raycast(myHRP.Position, dir, rayParams)
    if not hit then
        local myChar = localplayer.Character
        if myChar and myChar:FindFirstChild("Gun") then
            local predicted = getPredictedPosition(murderer, shootOffset)
            pcall(function()
                myChar.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, predicted, "AH2")
            end)
        end
    end
end)


-- ╔══════════════════════════════════════════════════════════╗
-- ║  GENERAL TAB                                             ║
-- ╚══════════════════════════════════════════════════════════╝
local GeneralTab = MainSection:Tab({
    Title     = "General",
    Icon      = "solar:home-2-bold",
    IconColor = Cyan,
    Border    = true,
})

-- ── Section header label ──────────────────────────────────────
GeneralTab:Section({
    Title      = "General Settings",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

-- ── Section: General ─────────────────────────────────────────
local GenSection = GeneralTab:Section({
    Title     = "General",
    Icon      = "users",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

local selectedRole = nil

GenSection:Dropdown({
    Title     = "Role Selection",
    Desc      = "Which role to spectate",
    Values    = { "Sheriff", "Murderer" },
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        selectedRole = value
    end,
})

GenSection:Space()

GenSection:Toggle({
    Title = "Spectate Selected",
    Desc  = "Spectate the chosen role",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            local target = nil
            if selectedRole == "Sheriff"  then target = findSheriff()  end
            if selectedRole == "Murderer" then target = findMurderer() end
            if target then
                spectatePlayer(target)
                WindUI:Notify({ Title = "Spectating", Content = target.Name, Icon = "solar:eye-bold" })
            else
                WindUI:Notify({ Title = "Acairus MM2", Content = "No " .. (selectedRole or "target") .. " found." })
            end
        else
            stopSpectate()
        end
    end,
})

GeneralTab:Space({ Columns = 3 })

-- ── Section: World ────────────────────────────────────────────
local WorldSection = GeneralTab:Section({
    Title     = "World",
    Icon      = "globe",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

WorldSection:Toggle({
    Title = "Round Timer",
    Desc  = "Displays a live round countdown on screen",
    Icon  = "clock",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            -- destroy any old gui first
            local old = game:GetService("CoreGui"):FindFirstChild("AcairusRoundTimer")
            if old then old:Destroy() end

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name           = "AcairusRoundTimer"
            screenGui.ResetOnSpawn   = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.IgnoreGuiInset = true
            pcall(function() screenGui.Parent = game:GetService("CoreGui") end)

            -- stroke for readability
            local stroke = Instance.new("UIStroke")
            stroke.Color       = Color3.fromRGB(0, 0, 0)
            stroke.Thickness   = 1.5
            stroke.Transparency = 0.4

            timerLabel = Instance.new("TextLabel")
            timerLabel.BackgroundTransparency = 1
            timerLabel.TextColor3  = Color3.fromHex("#10C550") -- green while loading
            timerLabel.TextScaled  = false
            timerLabel.TextSize    = 18
            timerLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            timerLabel.Position    = UDim2.fromScale(0.5, 0.08)
            timerLabel.Size        = UDim2.fromOffset(160, 28)
            timerLabel.Font        = Enum.Font.GothamBold
            timerLabel.Text        = "Loading..."
            timerLabel.ZIndex      = 10
            stroke.Parent    = timerLabel
            timerLabel.Parent = screenGui

            timerTask = task.spawn(function()
                while timerLabel and timerLabel.Parent do
                    task.wait(0.5)
                    pcall(function()
                        local part = workspace:FindFirstChild("RoundTimerPart")
                        local t = part and part:GetAttribute("Time")
                        if t and type(t) == "number" and t >= 0 then
                            local mins = math.floor(t / 60)
                            local secs = t % 60
                            timerLabel.Text       = string.format("%d:%02d", mins, secs)
                            timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            timerLabel.Text       = "Loading..."
                            timerLabel.TextColor3 = Color3.fromHex("#10C550")
                        end
                    end)
                end
            end)
        else
            if timerTask then task.cancel(timerTask); timerTask = nil end
            if timerLabel then
                local gui = timerLabel.Parent
                if gui then gui:Destroy() end
                timerLabel = nil
            end
            local old = game:GetService("CoreGui"):FindFirstChild("AcairusRoundTimer")
            if old then old:Destroy() end
        end
    end,
})

WorldSection:Space()

local selectedTargetName = nil
local selectedAction     = nil

local playerSelDropdown = WorldSection:Dropdown({
    Title     = "Player Selection",
    Desc      = "Pick a player to act on",
    Values    = getOtherPlayerNames(),
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        selectedTargetName = value
    end,
})

task.spawn(function()
    while task.wait(5) do
        pcall(function() playerSelDropdown:Refresh(getOtherPlayerNames()) end)
    end
end)

WorldSection:Dropdown({
    Title     = "Do to Player",
    Desc      = "Action to perform on the selected player",
    Values    = { "Teleport", "View" },
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        selectedAction = value
    end,
})

WorldSection:Space()

WorldSection:Toggle({
    Title = "Do to Selected Player",
    Desc  = "Execute the chosen action on the selected player",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        -- View: toggle on = start spectating, toggle off = stop spectating
        if selectedAction == "View" then
            if state then
                local target = Players:FindFirstChild(selectedTargetName or "")
                if not target then
                    WindUI:Notify({ Title = "Acairus MM2", Content = "Player not found." })
                    return
                end
                spectatePlayer(target)
                WindUI:Notify({ Title = "Viewing", Content = target.Name, Icon = "solar:eye-bold" })
            else
                stopSpectate()
            end
            return
        end

        -- For all other actions, only act on toggle ON
        if not state then return end
        if not selectedTargetName or not selectedAction then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Select a player and action first." })
            return
        end
        local target = Players:FindFirstChild(selectedTargetName)
        if not target then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Player not found." })
            return
        end
        if selectedAction == "Teleport" then
            teleportToPlayer(target)
        end
    end,
})

GeneralTab:Space({ Columns = 3 })

-- ── Section: Hitbox Expander ──────────────────────────────────
local HitboxSection = GeneralTab:Section({
    Title     = "Hitbox Expander",
    Icon      = "box",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

HitboxSection:Toggle({
    Title = "Hitbox Expander",
    Desc  = "Expands the HumanoidRootPart hitbox of all other players",
    Icon  = "maximize-2",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            reloadHitboxes()
        else
            clearHitboxes()
        end
    end,
})

HitboxSection:Space()

HitboxSection:Slider({
    Title     = "Size",
    Desc      = "Hitbox size — Min: 1 | Default: 2 | Max: 20",
    Icon      = "move-3d",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 1, Max = 20, Default = 2 },
    Callback  = function(val)
        hitboxSize = val
        if hitboxSize <= 1 then
            clearHitboxes()
        else
            reloadHitboxes()
        end
    end,
})

HitboxSection:Space()

HitboxSection:Colorpicker({
    Title    = "Hitbox Color",
    Desc     = "Color used when Show Hitbox is active",
    Icon     = "palette",
    Default  = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        hitboxColor = color
        -- update already-applied visible hitboxes
        for part, _ in pairs(hitboxParts) do
            pcall(function()
                if part and part.Parent then
                    part.Color = hitboxColor
                end
            end)
        end
    end,
})

HitboxSection:Space()

HitboxSection:Toggle({
    Title = "Show Hitbox",
    Desc  = "Makes expanded hitboxes visible (Neon material)",
    Icon  = "eye",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        hitboxEnabled = state
        for part, data in pairs(hitboxParts) do
            pcall(function()
                if part and part.Parent then
                    if state then
                        part.Material     = Enum.Material.Neon
                        part.Color        = hitboxColor
                        part.Transparency = 0.35
                    else
                        part.Material     = Enum.Material.SmoothPlastic
                        part.Color        = data.originalColor
                        part.Transparency = 1
                    end
                end
            end)
        end
    end,
})

GeneralTab:Space({ Columns = 3 })

-- ── Section: Things ───────────────────────────────────────────
local ThingsSection = GeneralTab:Section({
    Title     = "Things",
    Icon      = "coins",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

ThingsSection:Dropdown({
    Title    = "Coin TP Mode",
    Desc     = "How coins are selected for teleport",
    Values   = { "Nearest", "Random" },
    Value    = "Nearest",
    Callback = function(value)
        coinTPMode = value
    end,
})

ThingsSection:Space()

ThingsSection:Toggle({
    Title = "Coin TP",
    Desc  = "Automatically teleport to coins",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        coinTPEnabled = state
    end,
})

GeneralTab:Space({ Columns = 3 })

-- ── Section: Teleport ─────────────────────────────────────────
local TeleportSection = GeneralTab:Section({
    Title     = "Teleport",
    Icon      = "map-pin",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

local selectedTeleportPlace = nil

TeleportSection:Dropdown({
    Title     = "Teleport to",
    Desc      = "Select your destination",
    Values    = { "Map", "Lobby", "Murderer", "Sheriff" },
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        selectedTeleportPlace = value
    end,
})

TeleportSection:Space()

TeleportSection:Button({
    Title   = "Teleport",
    Desc    = "Teleport to selected destination",
    Icon    = "solar:arrow-right-bold",
    Color   = Cyan,
    Justify = "Center",
    Callback = function()
        if not selectedTeleportPlace then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Select a destination first." })
            return
        end
        teleportToPlace(selectedTeleportPlace)
        WindUI:Notify({
            Title   = "Teleported",
            Content = "→ " .. selectedTeleportPlace,
            Icon    = "solar:arrow-right-bold",
        })
    end,
})


-- ╔══════════════════════════════════════════════════════════╗
-- ║  PLAYER TAB                                              ║
-- ╚══════════════════════════════════════════════════════════╝
local PlayerTab = MainSection:Tab({
    Title     = "Player",
    Icon      = "solar:user-bold",
    IconColor = Green,
    Border    = true,
})

PlayerTab:Section({
    Title      = "Local Player Settings",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

local LocalSection = PlayerTab:Section({
    Title     = "Local Player",
    Icon      = "user",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

-- Spin
LocalSection:Toggle({
    Title = "Spin",
    Desc  = "Rapidly rotates your character in a circle",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            spinConn = RunService.RenderStepped:Connect(function()
                local hrp = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(8), 0) end
            end)
        else
            if spinConn then spinConn:Disconnect(); spinConn = nil end
        end
    end,
})

LocalSection:Space()

-- Walk Speed in its own Box section
local WalkSpeedSection = PlayerTab:Section({
    Title     = "Walk Speed",
    Icon      = "gauge",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

WalkSpeedSection:Toggle({
    Title = "Walk Speed",
    Desc  = "Override walk speed",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            walkSpeedConn = RunService.Heartbeat:Connect(function()
                local hum = localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = walkSpeedVal end
            end)
        else
            if walkSpeedConn then walkSpeedConn:Disconnect(); walkSpeedConn = nil end
            local hum = localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end,
})

WalkSpeedSection:Space()

WalkSpeedSection:Slider({
    Title     = "Speed Value",
    Desc      = "Min: 16  Max: 100",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 16, Max = 100, Default = 16 },
    Callback  = function(val) walkSpeedVal = val end,
})

PlayerTab:Space({ Columns = 3 })

-- Jump Height in its own Box section
local JumpHeightSection = PlayerTab:Section({
    Title     = "Jump Height",
    Icon      = "arrow-up",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

JumpHeightSection:Toggle({
    Title = "Jump Height",
    Desc  = "Jump height",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            jumpHeightConn = RunService.Heartbeat:Connect(function()
                local hum = localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.JumpPower = jumpHeightVal end
            end)
        else
            if jumpHeightConn then jumpHeightConn:Disconnect(); jumpHeightConn = nil end
            local hum = localplayer.Character and localplayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = 50 end
        end
    end,
})

JumpHeightSection:Space()

JumpHeightSection:Slider({
    Title     = "Height Value",
    Desc      = "Min: 10 Max: 300",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 10, Max = 300, Default = 50 },
    Callback  = function(val) jumpHeightVal = val end,
})

PlayerTab:Space({ Columns = 3 })

-- Anti AFK + Godmode in a Box section
local UtilSection = PlayerTab:Section({
    Title     = "Utilities",
    Icon      = "shield",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

UtilSection:Toggle({
    Title = "Anti AFK",
    Desc  = "Prevents automatic kick for inactivity",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            antiAfkConn = localplayer.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(10)
                VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end)
        else
            if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
        end
    end,
})

PlayerTab:Space({ Columns = 3 })

-- ── Section: Movement ─────────────────────────────────────────
local MovementSection = PlayerTab:Section({
    Title     = "Movement",
    Icon      = "ghost",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

-- Anti Fling
local antiFlingLastPos       = Vector3.zero
local antiFlingDetectionConn = nil
local antiFlingNeutralConn   = nil
local antiFlingDetected      = {}

MovementSection:Toggle({
    Title = "Anti Fling",
    Desc  = "Neutralizes fling velocity and teleports you back",
    Icon  = "shield-check",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            antiFlingDetected = {}
            -- detect and neutralize other players flinging
            -- Throttled to every 0.1s; GetDescendants every frame was causing freezes
            local _antiFlingThrottle = 0
            antiFlingDetectionConn = RunService.Heartbeat:Connect(function()
                local _now = tick()
                if _now - _antiFlingThrottle < 0.1 then return end
                _antiFlingThrottle = _now
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl == localplayer then continue end
                    local char = pl.Character
                    local pp   = char and char.PrimaryPart
                    if not pp then continue end
                    if pp.AssemblyAngularVelocity.Magnitude > 50
                    or pp.AssemblyLinearVelocity.Magnitude  > 100 then
                        if not antiFlingDetected[pl.Name] then
                            antiFlingDetected[pl.Name] = true
                            WindUI:Notify({ Title = "Anti Fling", Content = "Flinger detected: " .. pl.Name, Icon = "shield-check" })
                        end
                        -- Only zero primary part instead of all descendants (was very expensive)
                        pp.CanCollide = false
                        pp.AssemblyAngularVelocity = Vector3.zero
                        pp.AssemblyLinearVelocity  = Vector3.zero
                    end
                end
            end)
            -- neutralize self if flung (throttled; notifying every frame caused freezes)
            local _antiFlingNotifCooldown = 0
            antiFlingNeutralConn = RunService.Heartbeat:Connect(function()
                local char = localplayer.Character
                local pp   = char and char.PrimaryPart
                if not pp then return end
                if pp.AssemblyLinearVelocity.Magnitude  > 250
                or pp.AssemblyAngularVelocity.Magnitude > 250 then
                    pp.AssemblyLinearVelocity  = Vector3.zero
                    pp.AssemblyAngularVelocity = Vector3.zero
                    if antiFlingLastPos ~= Vector3.zero then
                        pp.CFrame = CFrame.new(antiFlingLastPos)
                    end
                    -- Only notify once per fling event (not every frame)
                    local _n = tick()
                    if _n - _antiFlingNotifCooldown > 2 then
                        _antiFlingNotifCooldown = _n
                        WindUI:Notify({ Title = "Anti Fling", Content = "You were flung! Neutralizing...", Icon = "shield-check" })
                    end
                else
                    antiFlingLastPos = pp.Position
                end
            end)
            WindUI:Notify({ Title = "Anti Fling", Content = "Enabled", Icon = "shield-check" })
        else
            if antiFlingDetectionConn then antiFlingDetectionConn:Disconnect(); antiFlingDetectionConn = nil end
            if antiFlingNeutralConn   then antiFlingNeutralConn:Disconnect();   antiFlingNeutralConn   = nil end
            antiFlingDetected = {}
            antiFlingLastPos  = Vector3.zero
        end
    end,
})

MovementSection:Space()

-- ── Fly ───────────────────────────────────────────────────────
MovementSection:Toggle({
    Title = "Fly",
    Desc  = "Fly around freely",
    Icon  = "navigation",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            FlyModule:Start()
            WindUI:Notify({ Title = "Fly", Content = "Enabled — use movement keys to fly", Icon = "navigation" })
        else
            FlyModule:Stop()
        end
    end,
})

MovementSection:Space()

MovementSection:Slider({
    Title     = "Fly Speed",
    Desc      = "Min: 5  Max: 100",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 5, Max = 100, Default = 20 },
    Callback  = function(val)
        FlyModule:SetMaxSpeed(val)
    end,
})


-- ╔══════════════════════════════════════════════════════════╗
-- ║  VISUALS TAB                                             ║
-- ╚══════════════════════════════════════════════════════════╝
local VisualsTab = MainSection:Tab({
    Title     = "Visuals",
    Icon      = "solar:eye-bold",
    IconColor = Yellow,
    Border    = true,
})

VisualsTab:Section({
    Title      = "ESP & Visual Options",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

local EspSection = VisualsTab:Section({
    Title     = "Visuals",
    Icon      = "eye",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

-- Multi-select dropdown for ESP roles
EspSection:Dropdown({
    Title     = "Selection",
    Desc      = "Choose which roles to highlight (multi-select)",
    Values    = { "Murderer", "Sheriff", "Innocent", "Hero", "Gun Drop" },
    Value     = nil,
    Multi     = true,
    AllowNone = true,
    Callback  = function(selectedValues)
        ESPSelected = {}
        if type(selectedValues) == "table" then
            for _, v in ipairs(selectedValues) do
                ESPSelected[v] = true
            end
        elseif type(selectedValues) == "string" then
            ESPSelected[selectedValues] = true
        end
        if ESPEnabled then reloadESP() end
    end,
})

EspSection:Space()

EspSection:Toggle({
    Title = "ESP",
    Desc  = "Show role highlights on players",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        ESPEnabled = state
        if state then reloadESP() else clearAllESP() end
    end,
})

-- Auto-refresh ESP every 8 seconds (was 3s — too frequent, caused freezes)
task.spawn(function()
    while true do
        task.wait(8)
        if ESPEnabled then
            pcall(reloadESP)
        end
    end
end)

VisualsTab:Space({ Columns = 3 })

-- Settings section with colorpickers
local ColSection = VisualsTab:Section({
    Title     = "Settings",
    Icon      = "palette",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

ColSection:Section({
    Title      = "ESP Color Configuration",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

ColSection:Space()

-- Murderer + Sheriff side by side
local cpRow1 = VisualsTab:Group({})

cpRow1:Colorpicker({
    Title    = "Murderer Color",
    Default  = ESPColors.Murderer,
    Callback = function(color)
        ESPColors.Murderer = color
        if ESPEnabled then reloadESP() end
    end,
})

cpRow1:Space()

cpRow1:Colorpicker({
    Title    = "Sheriff Color",
    Default  = ESPColors.Sheriff,
    Callback = function(color)
        ESPColors.Sheriff = color
        if ESPEnabled then reloadESP() end
    end,
})

VisualsTab:Space()

-- Innocent + Hero side by side
local cpRow2 = VisualsTab:Group({})

cpRow2:Colorpicker({
    Title    = "Innocent Color",
    Default  = ESPColors.Innocent,
    Callback = function(color)
        ESPColors.Innocent = color
        if ESPEnabled then reloadESP() end
    end,
})

cpRow2:Space()

cpRow2:Colorpicker({
    Title    = "Hero Color",
    Default  = ESPColors.Hero,
    Callback = function(color)
        ESPColors.Hero = color
        if ESPEnabled then reloadESP() end
    end,
})

VisualsTab:Space()

-- Gun Drop alone
VisualsTab:Colorpicker({
    Title    = "Gun Drop Color",
    Default  = ESPColors.GunDrop,
    Callback = function(color)
        ESPColors.GunDrop = color
        if ESPEnabled then reloadESP() end
    end,
})


-- ╔══════════════════════════════════════════════════════════╗
-- ║  COMBAT TAB                                              ║
-- ╚══════════════════════════════════════════════════════════╝
local CombatTab = MainSection:Tab({
    Title     = "Combat",
    Icon      = "swords",
    IconColor = Red,
    Border    = true,
})

-- ============================================================
--  INNOCENT SECTION (top of Combat)
-- ============================================================
CombatTab:Section({
    Title      = "Innocent Features",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

local InnocentSection = CombatTab:Section({
    Title     = "Innocent",
    Icon      = "person-standing",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

-- state for auto get gun
local autoGetGunEnabled = false
local gunDropNotifEnabled = false

-- workspace listener for dropped gun (set up once)
local autoGetGunSetup = false
local function setupAutoGetGun()
    if autoGetGunSetup then return end
    autoGetGunSetup = true
    workspace.DescendantAdded:Connect(function(ch)
        if ch.Name ~= "GunDrop" then return end
        -- Gun drop notification (independent of auto get gun)
        if gunDropNotifEnabled then
            WindUI:Notify({
                Title   = "Gun Dropped!",
                Content = "The gun has been dropped — go grab it.",
                Icon    = "gun",
            })
        end
        if not autoGetGunEnabled then return end
        task.spawn(function()
            task.wait(0.5) -- brief cooldown
            local map = getMap()
            local drop = map and map:FindFirstChild("GunDrop")
            if not drop then return end
            local char = localplayer.Character
            if not char then return end
            local prevCF = char:GetPivot()
            char:PivotTo(drop:GetPivot())
            localplayer.Backpack.ChildAdded:Wait()
            char:PivotTo(prevCF)
            WindUI:Notify({ Title = "Auto Get Gun", Content = "Grabbed the dropped gun!", Icon = "gun" })
        end)
    end)
end

-- helper: find gun drop in map
local function findGunDrop()
    local map = getMap()
    return map and map:FindFirstChild("GunDrop")
end

InnocentSection:Button({
    Title   = "Get Gun",
    Desc    = "Teleports to the dropped gun and picks it up",
    Icon    = "gun",
    Color   = Blue,
    Justify = "Center",
    Callback = function()
        local drop = findGunDrop()
        if not drop then
            WindUI:Notify({ Title = "Acairus MM2", Content = "No dropped gun found!", Icon = "triangle-alert" })
            return
        end
        local char = localplayer.Character
        if not char then return end
        local prevCF = char:GetPivot()
        char:PivotTo(drop:GetPivot())
        local conn
        conn = localplayer.Backpack.ChildAdded:Connect(function(item)
            if item:IsA("Tool") then
                conn:Disconnect()
                char:PivotTo(prevCF)
                WindUI:Notify({ Title = "Get Gun", Content = "Picked up: " .. item.Name, Icon = "gun" })
            end
        end)
        task.delay(3, function()
            if conn then conn:Disconnect() end
        end)
    end,
})

InnocentSection:Space()

InnocentSection:Toggle({
    Title = "Auto Get Gun",
    Desc  = "Automatically grabs the gun when it is dropped",
    Icon  = "zap",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        autoGetGunEnabled = state
        if state then
            setupAutoGetGun()
            WindUI:Notify({ Title = "Auto Get Gun", Content = "Enabled — watching for gun drop", Icon = "zap" })
        end
    end,
})


InnocentSection:Space()

InnocentSection:Toggle({
    Title = "GunDrop Notification",
    Desc  = "Notifies you when the gun gets dropped",
    Icon  = "bell",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        gunDropNotifEnabled = state
        if state then
            setupAutoGetGun() -- ensures the listener is active
        end
    end,
})

InnocentSection:Space()

-- ── God Mode (moved from Player tab) ─────────────────────────
InnocentSection:Button({
    Title   = "God Mode (BETA)",
    Desc    = "Makes you invincible",
    Icon    = "solar:shield-bold",
    Color   = Purple,
    Justify = "Center",
    Callback = function()
        activateGodmode()
        WindUI:Notify({
            Title   = "God Mode",
            Content = "Activated",
            Icon    = "solar:shield-bold",
        })
    end,
})

InnocentSection:Space()

-- ── Speed Glitch ──────────────────────────────────────────────
local speedGlitchEnabled = false
local speedGlitchPower   = 25
local speedGlitchConn    = nil

InnocentSection:Toggle({
    Title = "Speed Glitch",
    Desc  = "Boosts speed while freefall",
    Icon  = "zap",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        speedGlitchEnabled = state
        if state then
            speedGlitchConn = RunService.RenderStepped:Connect(function()
                local char = localplayer.Character
                local hum  = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                if hum:GetState() == Enum.HumanoidStateType.Freefall then
                    hum.WalkSpeed = speedGlitchPower
                else
                    hum.WalkSpeed = walkSpeedConn and walkSpeedVal or 16
                end
            end)
        else
            if speedGlitchConn then speedGlitchConn:Disconnect(); speedGlitchConn = nil end
            local char = localplayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = walkSpeedConn and walkSpeedVal or 16 end
        end
    end,
})

InnocentSection:Space()

InnocentSection:Slider({
    Title     = "Speed Glitch Power",
    Desc      = "Min: 16  Max: 100",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 16, Max = 100, Default = 16 },
    Callback  = function(val) speedGlitchPower = val end,
})

CombatTab:Space({ Columns = 3 })

CombatTab:Section({
    Title      = "Murderer Features",
    TextSize   = 13,
    TextTransparency = 0.35,
    FontWeight = Enum.FontWeight.SemiBold,
})

-- ── Section: Murderer ─────────────────────────────────────────
local MurdSection = CombatTab:Section({
    Title     = "Murderer",
    Icon      = "skull",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

MurdSection:Space()

MurdSection:Button({
    Title   = "Kill Everyone",
    Desc    = "Instantly kills all players (you must be murderer)",
    Icon    = "skull",
    Color   = Red,
    Justify = "Center",
    Callback = function()
        killEveryone()
    end,
})

MurdSection:Space()

MurdSection:Toggle({
    Title = "Auto Kill Everyone",
    Desc  = "Automatically kills everyone if you are the murderer",
    Icon  = "repeat",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            local autoKillDebounce = false
            autoKillEveryoneConn = RunService.Heartbeat:Connect(function()
                if autoKillDebounce then return end
                if findMurderer() ~= localplayer then return end
                local char = localplayer.Character
                if not char then return end
                if not char:FindFirstChild("Knife") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if localplayer.Backpack:FindFirstChild("Knife") then
                        hum:EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
                    else return end
                end
                local myHRP = char:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                autoKillDebounce = true
                local anchored = {}
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= localplayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Anchored = true
                            hrp.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 1
                            table.insert(anchored, hrp)
                        end
                    end
                end
                char.Knife.Stab:FireServer("Slash")
                task.delay(2, function()
                    for _, hrp in ipairs(anchored) do
                        if hrp and hrp.Parent then hrp.Anchored = false end
                    end
                    autoKillDebounce = false
                end)
            end)
        else
            if autoKillEveryoneConn then autoKillEveryoneConn:Disconnect(); autoKillEveryoneConn = nil end
        end
    end,
})

MurdSection:Space()

MurdSection:Toggle({
    Title = "Kill Aura",
    Desc  = "Automatically kills nearby players within the set distance",
    Icon  = "zap",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        killAuraConn = state or nil
    end,
})

MurdSection:Space()

MurdSection:Slider({
    Title     = "Kill Aura Distance",
    Desc      = "Min: 1  Max: 25",
    Icon      = "ruler",
    IsTooltip = true,
    Step      = 1,
    Value     = { Min = 1, Max = 25, Default = 10 },
    Callback  = function(val) killAuraDist = val end,
})

MurdSection:Space()

MurdSection:Button({
    Title   = "Throw Knife To Closest Player",
    Desc    = "Throws your knife at the nearest player",
    Icon    = "send",
    Color   = Red,
    Justify = "Center",
    Callback = function()
        throwKnifeToClosest()
    end,
})

MurdSection:Space()

-- ── Knife Throw GUI ───────────────────────────────────────────
local knifeGuiEnabled = false
local knifeGuiFrame   = nil
local knifeGuiConn    = nil

local function buildKnifeGui()
    local coreGui = game:GetService("CoreGui")
    local old = coreGui:FindFirstChild("AcairusKnifeGui")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name           = "AcairusKnifeGui"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = coreGui end)

    -- Main rounded frame
    local frame = Instance.new("Frame")
    frame.Name                   = "KnifeThrowFrame"
    frame.Size                   = UDim2.fromOffset(68, 68)
    frame.Position               = UDim2.fromOffset(80, 280)
    frame.BackgroundColor3       = Color3.fromRGB(10, 10, 16)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel        = 0
    frame.ZIndex                 = 20
    frame.Parent                 = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent       = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color        = Color3.fromHex("#EF4F1D")
    stroke.Thickness    = 2
    stroke.Transparency = 0.1
    stroke.Parent       = frame

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#2a0a00")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#0d0505")),
    })
    grad.Rotation = 135
    grad.Parent   = frame

    -- Knife icon drawn with Frames:
    -- blade: a thin diagonal rectangle (rotated via UIGradient trick — use a tall thin bar)
    -- handle: a shorter wider bar perpendicular at the bottom

    -- Blade — long thin diagonal bar
    local blade = Instance.new("Frame")
    blade.Size                   = UDim2.fromOffset(5, 36)
    blade.Position               = UDim2.fromOffset(34 - 2, 34 - 22)
    blade.BackgroundColor3       = Color3.fromHex("#EF4F1D")
    blade.BackgroundTransparency = 0
    blade.BorderSizePixel        = 0
    blade.ZIndex                 = 22
    blade.Rotation               = 35
    blade.Parent                 = frame
    local bladeCorner = Instance.new("UICorner")
    bladeCorner.CornerRadius = UDim.new(0, 2)
    bladeCorner.Parent = blade

    -- Guard — short horizontal crossguard
    local guard = Instance.new("Frame")
    guard.Size                   = UDim2.fromOffset(18, 3)
    guard.Position               = UDim2.fromOffset(34 - 9, 34 + 4)
    guard.BackgroundColor3       = Color3.fromHex("#FF7755")
    guard.BackgroundTransparency = 0
    guard.BorderSizePixel        = 0
    guard.ZIndex                 = 22
    guard.Rotation               = 35
    guard.Parent                 = frame
    local guardCorner = Instance.new("UICorner")
    guardCorner.CornerRadius = UDim.new(1, 0)
    guardCorner.Parent = guard

    -- Handle — thicker shorter bar below guard
    local handle = Instance.new("Frame")
    handle.Size                   = UDim2.fromOffset(5, 16)
    handle.Position               = UDim2.fromOffset(34 - 2, 34 + 6)
    handle.BackgroundColor3       = Color3.fromHex("#AA3311")
    handle.BackgroundTransparency = 0
    handle.BorderSizePixel        = 0
    handle.ZIndex                 = 22
    handle.Rotation               = 35
    handle.Parent                 = frame
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0, 2)
    handleCorner.Parent = handle

    -- Outer ring
    local ring = Instance.new("Frame")
    ring.Size                   = UDim2.fromOffset(52, 52)
    ring.Position               = UDim2.fromOffset(8, 8)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel        = 0
    ring.ZIndex                 = 21
    ring.Parent                 = frame
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color        = Color3.fromHex("#EF4F1D")
    ringStroke.Thickness    = 1
    ringStroke.Transparency = 0.55
    ringStroke.Parent       = ring
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent       = ring

    -- Invisible click/drag button
    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                   = ""
    btn.ZIndex                 = 24
    btn.Parent                 = frame

    local UserInputService = game:GetService("UserInputService")
    local dragging      = false
    local dragStart     = nil
    local startPos      = nil
    local didDrag       = false
    local knifeGuiLocked = false
    local DRAG_THRESHOLD = 8

    getgenv()._acairusKnifeGuiLock = function(locked)
        knifeGuiLocked = locked
    end

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            didDrag   = false
            dragStart = Vector2.new(inp.Position.X, inp.Position.Y)
            startPos  = frame.Position
        end
    end)

    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            if not didDrag then
                -- tap = throw knife
                if findMurderer() == localplayer then
                    task.spawn(throwKnifeToClosest)
                else
                    WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the murderer!", Icon = "triangle-alert" })
                end
            end
            dragging = false
            didDrag  = false
        end
    end)

    knifeGuiConn = UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if knifeGuiLocked then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local cur   = Vector2.new(inp.Position.X, inp.Position.Y)
        local delta = cur - dragStart
        if delta.Magnitude >= DRAG_THRESHOLD then
            didDrag = true
        end
        if didDrag then
            frame.Position = UDim2.fromOffset(
                startPos.X.Offset + delta.X,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    knifeGuiFrame = sg
end

local function destroyKnifeGui()
    if knifeGuiConn  then knifeGuiConn:Disconnect();  knifeGuiConn  = nil end
    if knifeGuiFrame then knifeGuiFrame:Destroy();     knifeGuiFrame = nil end
    local old = game:GetService("CoreGui"):FindFirstChild("AcairusKnifeGui")
    if old then old:Destroy() end
    if getgenv()._acairusKnifeGuiLock then
        getgenv()._acairusKnifeGuiLock = nil
    end
end

MurdSection:Toggle({
    Title = "Show Knife Throw to Closest GUI",
    Desc  = "Floating knife button tap it to throw your knife at the nearest player",
    Icon  = "send",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        knifeGuiEnabled = state
        if state then
            buildKnifeGui()
        else
            destroyKnifeGui()
        end
    end,
})

MurdSection:Space()

MurdSection:Toggle({
    Title = "Lock Knife GUI",
    Desc  = "Locks the knife GUI in place makes it non-draggable",
    Icon  = "lock",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if getgenv()._acairusKnifeGuiLock then
            getgenv()._acairusKnifeGuiLock(state)
        end
    end,
})

MurdSection:Space()

MurdSection:Toggle({
    Title = "Auto Knife Throw to Closest",
    Desc  = "Automatically throws knife at the nearest player every 1.5s",
    Icon  = "timer",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        loopKnifeThrow = state
    end,
})

MurdSection:Space()

MurdSection:Button({
    Title   = "Kill Sheriff",
    Desc    = "Instantly kills the sheriff (you must be murderer)",
    Icon    = "shield-off",
    Color   = Red,
    Justify = "Center",
    Callback = function()
        killSheriff()
    end,
})

MurdSection:Space()

MurdSection:Toggle({
    Title = "Auto Kill Sheriff",
    Desc  = "Automatically kills the sheriff if you are the murderer",
    Icon  = "shield-x",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if state then
            local autoKillSheriffDebounce = false
            autoKillSheriffConn = RunService.Heartbeat:Connect(function()
                if autoKillSheriffDebounce then return end
                if findMurderer() ~= localplayer then return end
                local sheriff = findSheriff()
                if not sheriff then return end
                local sherHRP = sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart")
                local myHRP   = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
                if not sherHRP or not myHRP then return end
                if not localplayer.Character:FindFirstChild("Knife") then
                    local hum = localplayer.Character:FindFirstChildOfClass("Humanoid")
                    if localplayer.Backpack:FindFirstChild("Knife") then
                        hum:EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
                    else return end
                end
                autoKillSheriffDebounce = true
                sherHRP.Anchored = true
                sherHRP.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 1
                localplayer.Character.Knife.Stab:FireServer("Slash")
                task.delay(2, function()
                    if sherHRP and sherHRP.Parent then sherHRP.Anchored = false end
                    autoKillSheriffDebounce = false
                end)
            end)
        else
            if autoKillSheriffConn then autoKillSheriffConn:Disconnect(); autoKillSheriffConn = nil end
        end
    end,
})

MurdSection:Space()

local killTargetName = nil

local killTargetDropdown = MurdSection:Dropdown({
    Title     = "Kill Selection",
    Desc      = "Select a player to kill",
    Icon      = "user-x",
    Values    = getOtherPlayerNames(),
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        killTargetName = value
    end,
})

task.spawn(function()
    while task.wait(5) do
        pcall(function() killTargetDropdown:Refresh(getOtherPlayerNames()) end)
    end
end)

MurdSection:Space()

MurdSection:Button({
    Title   = "Kill",
    Desc    = "Kills the selected player (you must be murderer)",
    Icon    = "crosshair",
    Color   = Red,
    Justify = "Center",
    Callback = function()
        if findMurderer() ~= localplayer then
            WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the murderer!", Icon = "triangle-alert" })
            return
        end
        if not killTargetName then
            WindUI:Notify({ Title = "Acairus MM2", Content = "No player selected!", Icon = "triangle-alert" })
            return
        end
        local target = Players:FindFirstChild(killTargetName)
        if not target or not target.Character then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Player not found or has no character.", Icon = "triangle-alert" })
            return
        end
        if not ensureKnifeEquipped() then return end
        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP     = localplayer.Character and localplayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not myHRP then return end
        targetHRP.Anchored = true
        targetHRP.CFrame   = myHRP.CFrame + myHRP.CFrame.LookVector * 1
        localplayer.Character.Knife.Stab:FireServer("Slash")
        task.delay(2, function()
            if targetHRP and targetHRP.Parent then targetHRP.Anchored = false end
        end)
        WindUI:Notify({ Title = "Acairus MM2", Content = "Killed " .. killTargetName, Icon = "crosshair" })
    end,
})

CombatTab:Space({ Columns = 3 })

-- ── Section: Sheriff ─────────────────────────────────────────
local SheriffSection = CombatTab:Section({
    Title     = "Sheriff",
    Icon      = "crosshair",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

SheriffSection:Toggle({
    Title = "Auto Shoot Murderer",
    Desc  = "Automatically shoots the murderer when you are the sheriff",
    Icon  = "crosshair",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        autoShootConn = state or nil
        if state then
            WindUI:Notify({
                Title   = "Auto Shoot",
                Content = "Enabled — watching for murderer",
                Icon    = "crosshair",
            })
        end
    end,
})

SheriffSection:Space()

-- ── Shoot Murderer Button ─────────────────────────────────────
local shootMurdererMode = "Normal"

SheriffSection:Button({
    Title   = "Shoot Murderer",
    Desc    = "Fires your gun at the murderer's predicted position",
    Icon    = "gun",
    Color   = Blue,
    Justify = "Center",
    Callback = function()
        if findSheriff() ~= localplayer then
            WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the sheriff!", Icon = "triangle-alert" })
            return
        end
        local murderer = findMurderer()
        if not murderer then
            WindUI:Notify({ Title = "Acairus MM2", Content = "No murderer found!", Icon = "triangle-alert" })
            return
        end
        if not ensureGunEquipped() then return end
        local murdChar = murderer.Character
        if not murdChar then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Murderer has no character!", Icon = "triangle-alert" })
            return
        end
        local murdHRP = murdChar:FindFirstChild("HumanoidRootPart")
        if not murdHRP then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Could not find murderer's HumanoidRootPart.", Icon = "triangle-alert" })
            return
        end
        local myChar = localplayer.Character
        if not myChar then return end
        local predicted = getPredictedPosition(murderer, shootOffset)
        local args = {
            CFrame.new(myChar.RightHand.Position),
            CFrame.new(predicted),
        }
        pcall(function()
            myChar:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(args))
        end)
        WindUI:Notify({ Title = "Shoot Murderer", Content = "Shot fired at " .. murderer.Name, Icon = "gun" })
    end,
})

SheriffSection:Space()

-- ── Show Shoot Murderer GUI Toggle ───────────────────────────
local shootGuiEnabled   = false
local shootGuiFrame     = nil
local shootGuiConn      = nil
local wallCheckEnabled  = false

local function doShootMurdererAction()
    if findSheriff() ~= localplayer then return end
    local murderer = findMurderer()
    if not murderer or not murderer.Character then return end
    local murdHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
    if not murdHRP then return end
    local myChar = localplayer.Character
    if not myChar then return end

    -- wall check
    if wallCheckEnabled then
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if myHRP then
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = { myChar, murderer.Character }
            local dir = (murdHRP.Position - myHRP.Position)
            local hit = workspace:Raycast(myHRP.Position, dir, rayParams)
            if hit then return end
        end
    end

    if not ensureGunEquipped() then return end
    local predicted = getPredictedPosition(murderer, shootOffset)
    pcall(function()
        myChar:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(
            CFrame.new(myChar.RightHand.Position),
            CFrame.new(predicted)
        )
    end)
end

local function buildShootGui()
    local coreGui = game:GetService("CoreGui")
    local old = coreGui:FindFirstChild("AcairusShootGui")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name           = "AcairusShootGui"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    pcall(function() sg.Parent = coreGui end)

    -- Main rounded frame
    local frame = Instance.new("Frame")
    frame.Name                   = "ShootMurdFrame"
    frame.Size                   = UDim2.fromOffset(68, 68)
    frame.Position               = UDim2.fromOffset(80, 200)
    frame.BackgroundColor3       = Color3.fromRGB(10, 10, 16)
    frame.BackgroundTransparency = 0.18
    frame.BorderSizePixel        = 0
    frame.ZIndex                 = 20
    frame.Parent                 = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent       = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color        = Color3.fromHex("#00D4FF")
    stroke.Thickness    = 2
    stroke.Transparency = 0.1
    stroke.Parent       = frame

    -- Gradient overlay for style
    local grad = Instance.new("UIGradient")
    grad.Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("#1a1a2e")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("#0d0d18")),
    })
    grad.Rotation = 135
    grad.Parent   = frame

    -- Crosshair drawn with 4 Lines + center dot using Frames (no asset needed)
    local function makeLine(w, h, x, y)
        local l = Instance.new("Frame")
        l.Size                   = UDim2.fromOffset(w, h)
        l.Position               = UDim2.fromOffset(x, y)
        l.BackgroundColor3       = Color3.fromHex("#00D4FF")
        l.BackgroundTransparency = 0
        l.BorderSizePixel        = 0
        l.ZIndex                 = 22
        l.Parent                 = frame
        local lc = Instance.new("UICorner")
        lc.CornerRadius = UDim.new(1, 0)
        lc.Parent = l
        return l
    end
    -- center of 68x68 = (34,34); lines are 14px long, 2px wide, gap of 5px from center
    -- horizontal left
    makeLine(12, 2, 34 - 5 - 12, 34 - 1)
    -- horizontal right
    makeLine(12, 2, 34 + 5,      34 - 1)
    -- vertical top
    makeLine(2, 12, 34 - 1, 34 - 5 - 12)
    -- vertical bottom
    makeLine(2, 12, 34 - 1, 34 + 5)
    -- center dot
    local dot = Instance.new("Frame")
    dot.Size                   = UDim2.fromOffset(4, 4)
    dot.Position               = UDim2.fromOffset(34 - 2, 34 - 2)
    dot.BackgroundColor3       = Color3.fromHex("#FF4444")
    dot.BackgroundTransparency = 0
    dot.BorderSizePixel        = 0
    dot.ZIndex                 = 23
    dot.Parent                 = frame
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    -- Outer ring circles (top-left / bottom-right corner arcs via rotated stroke frames)
    local ring = Instance.new("Frame")
    ring.Size                   = UDim2.fromOffset(52, 52)
    ring.Position               = UDim2.fromOffset(8, 8)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel        = 0
    ring.ZIndex                 = 21
    ring.Parent                 = frame
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color        = Color3.fromHex("#00D4FF")
    ringStroke.Thickness    = 1
    ringStroke.Transparency = 0.55
    ringStroke.Parent       = ring
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent       = ring

    -- invisible click/drag button
    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text                   = ""
    btn.ZIndex                 = 24
    btn.Parent                 = frame

    local UserInputService = game:GetService("UserInputService")
    local dragging   = false
    local dragStart  = nil
    local startPos   = nil
    local didDrag    = false
    local shootGuiLocked = false
    local DRAG_THRESHOLD = 8

    -- expose lock state so the toggle below can control it
    getgenv()._acairusShootGuiLock = function(locked)
        shootGuiLocked = locked
    end

    btn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            didDrag   = false
            dragStart = Vector2.new(inp.Position.X, inp.Position.Y)
            startPos  = frame.Position
        end
    end)

    btn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            if not didDrag then
                doShootMurdererAction()
            end
            dragging = false
            didDrag  = false
        end
    end)

    shootGuiConn = UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if shootGuiLocked then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement
        and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local cur   = Vector2.new(inp.Position.X, inp.Position.Y)
        local delta = cur - dragStart
        if delta.Magnitude >= DRAG_THRESHOLD then
            didDrag = true
        end
        if didDrag then
            frame.Position = UDim2.fromOffset(
                startPos.X.Offset + delta.X,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    shootGuiFrame = sg
end

local function destroyShootGui()
    if shootGuiConn then shootGuiConn:Disconnect(); shootGuiConn = nil end
    if shootGuiFrame then shootGuiFrame:Destroy(); shootGuiFrame = nil end
    local old = game:GetService("CoreGui"):FindFirstChild("AcairusShootGui")
    if old then old:Destroy() end
end

SheriffSection:Toggle({
    Title = "Show Shoot Murderer GUI",
    Desc  = "Floating crosshair button click it to shoot the murderer",
    Icon  = "crosshair",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        shootGuiEnabled = state
        if state then
            buildShootGui()
        else
            destroyShootGui()
        end
    end,
})

SheriffSection:Space()

-- ── Lock Shoot Gui Toggle ─────────────────────────────────────
SheriffSection:Toggle({
    Title = "Lock Shoot Gui",
    Desc  = "Locks the floating GUI in place makes it non-draggable",
    Icon  = "lock",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        if getgenv()._acairusShootGuiLock then
            getgenv()._acairusShootGuiLock(state)
        end
    end,
})

SheriffSection:Space()

-- ── Shoot Murderer WallCheck Toggle ──────────────────────────
SheriffSection:Toggle({
    Title = "Shoot Murderer WallCheck",
    Desc  = "Won't shoot if a wall is blocking the path to the murderer",
    Icon  = "wall",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        wallCheckEnabled = state
    end,
})

SheriffSection:Space()

-- ── Shoot Murderer Mode Dropdown ──────────────────────────────
SheriffSection:Dropdown({
    Title     = "Shoot Murderer Mode",
    Desc      = "Normal is active. Better is coming soon.",
    Icon      = "settings-2",
    Values    = { "Normal", "Better (Coming Soon)" },
    Value     = "Normal",
    Callback  = function(value)
        if value == "Better (Coming Soon)" then
            WindUI:Notify({
                Title   = "Coming Soon",
                Content = "Better mode is locked — stay tuned!",
                Icon    = "lock",
            })
            shootMurdererMode = "Normal"
        else
            shootMurdererMode = "Normal"
        end
    end,
})

SheriffSection:Space()

-- ── Aimbot Murderer Toggle ────────────────────────────────────
local aimbotMurdererConn    = nil
local aimbotMurdererEnabled = false

local function getMurdPredictedTarget(murd)
    local char = murd and murd.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    return hrp.Position + hrp.AssemblyLinearVelocity * 0.125
end

SheriffSection:Toggle({
    Title = "Aimbot Murderer",
    Desc  = "Camera auto-aims toward the murderer's predicted position",
    Icon  = "crosshair",
    Value = false,
    Type  = "Checkbox",
    Callback = function(state)
        aimbotMurdererEnabled = state
        if state then
            if findSheriff() ~= localplayer then
                WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the sheriff!", Icon = "triangle-alert" })
                aimbotMurdererEnabled = false
                return
            end
            aimbotMurdererConn = RunService.RenderStepped:Connect(function()
                if findSheriff() ~= localplayer then return end
                local murd   = findMurderer()
                local target = getMurdPredictedTarget(murd)
                if target then
                    local cam = workspace.CurrentCamera
                    cam.CFrame = CFrame.new(cam.CFrame.Position, target)
                end
            end)
            WindUI:Notify({ Title = "Aimbot Murderer", Content = "Enabled — camera locking onto murderer", Icon = "crosshair" })
        else
            if aimbotMurdererConn then aimbotMurdererConn:Disconnect(); aimbotMurdererConn = nil end
        end
    end,
})

SheriffSection:Space()

-- ── Shoot (Troll) Dropdown ────────────────────────────────────
local function getNonMurdNonLocalNames()
    local murderer = findMurderer()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= localplayer and p ~= murderer then
            table.insert(names, p.Name)
        end
    end
    if #names == 0 then table.insert(names, "(No players)") end
    return names
end

local trollShootTarget = nil

local trollDropdown = SheriffSection:Dropdown({
    Title     = "Shoot (Troll)",
    Desc      = "Pick a non-murderer player to shoot at (use the button below)",
    Icon      = "laugh",
    Values    = getNonMurdNonLocalNames(),
    Value     = nil,
    AllowNone = true,
    Callback  = function(value)
        -- just store the selection, no action here to avoid spam
        trollShootTarget = (value ~= "(No players)") and value or nil
    end,
})

-- Keep troll dropdown player list fresh every 5 seconds
task.spawn(function()
    while task.wait(5) do
        pcall(function() trollDropdown:Refresh(getNonMurdNonLocalNames()) end)
    end
end)

SheriffSection:Space()

SheriffSection:Button({
    Title   = "Shoot Player",
    Desc    = "Teleports to selected player and shoots them",
    Icon    = "gun",
    Color   = Blue,
    Justify = "Center",
    Callback = function()
        if findSheriff() ~= localplayer then
            WindUI:Notify({ Title = "Acairus MM2", Content = "You're not the sheriff!", Icon = "triangle-alert" })
            return
        end
        if not trollShootTarget then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Select a player from the dropdown first!", Icon = "triangle-alert" })
            return
        end
        local target = Players:FindFirstChild(trollShootTarget)
        if not target or not target.Character then
            WindUI:Notify({ Title = "Acairus MM2", Content = "Player not found or has no character.", Icon = "triangle-alert" })
            return
        end
        if not ensureGunEquipped() then return end
        local myChar = localplayer.Character
        local myHRP  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        local tChar = target.Character
        local tHRP  = tChar and tChar:FindFirstChild("HumanoidRootPart")
        if not tHRP then return end
        -- teleport right next to the target first
        myHRP.CFrame = tHRP.CFrame + Vector3.new(2, 0, 0)
        task.wait(0.1)
        -- re-fetch after teleport
        local tHRP2 = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if not tHRP2 then return end
        local predicted = tHRP2.Position + tHRP2.AssemblyLinearVelocity * 0.125
        local args = {
            CFrame.new(myChar.RightHand.Position),
            CFrame.new(predicted),
        }
        pcall(function()
            myChar:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(args))
        end)
        WindUI:Notify({ Title = "Troll Shot", Content = "Teleported and shot " .. trollShootTarget, Icon = "laugh" })
    end,
})

-- ╔══════════════════════════════════════════════════════════╗
-- ║  UTILITY TAB  (inside UtilitySection)                    ║
-- ╚══════════════════════════════════════════════════════════╝
local UtilityTab = UtilitySection:Tab({
    Title     = "Utility",
    Icon      = "solar:settings-bold-duotone",
    IconColor = Grey,
    Border    = true,
})

UtilityTab:Section({
    Title          = "Utility Tools",
    TextSize       = 13,
    TextTransparency = 0.35,
    FontWeight     = Enum.FontWeight.SemiBold,
})

-- ── Section: Server ───────────────────────────────────────────
local ServerUtilSection = UtilityTab:Section({
    Title     = "Server",
    Icon      = "server",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

ServerUtilSection:Button({
    Title   = "Rejoin Server",
    Desc    = "Quickly reconnects you to the same server",
    Icon    = "refresh-cw",
    Color   = Cyan,
    Justify = "Center",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localplayer)
        end)
    end,
})

UtilityTab:Space({ Columns = 3 })

-- ── Section: Clipboard ────────────────────────────────────────
local ClipSection = UtilityTab:Section({
    Title     = "Clipboard",
    Icon      = "clipboard",
    Box       = true,
    BoxBorder = true,
    Opened    = true,
})

ClipSection:Button({
    Title   = "Copy Game ID",
    Desc    = "Copies the current Place ID to clipboard",
    Icon    = "copy",
    Justify = "Center",
    Callback = function()
        pcall(function() setclipboard(tostring(game.PlaceId)) end)
        WindUI:Notify({ Title = "Copied", Content = "Place ID: " .. tostring(game.PlaceId), Icon = "copy" })
    end,
})

ClipSection:Space()

ClipSection:Button({
    Title   = "Copy Job ID",
    Desc    = "Copies the current server Job ID to clipboard",
    Icon    = "server",
    Justify = "Center",
    Callback = function()
        pcall(function() setclipboard(tostring(game.JobId)) end)
        WindUI:Notify({ Title = "Copied", Content = "Job ID copied!", Icon = "server" })
    end,
})
