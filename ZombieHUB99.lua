--==================================================
-- ZOMBIE HUB ULTIMATE FINAL
-- SAFE ZONE + AIMBOT + ESP + AUTO E
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- REMOVE OLD UI
--==================================================

pcall(function()
    player.PlayerGui.ZombieHub:Destroy()
end)

pcall(function()
    player.PlayerGui.BearESP_UI:Destroy()
end)

pcall(function()
    workspace.SafePlatform:Destroy()
end)

--==================================================
-- SETTINGS
--==================================================

local AIMBOT = false
local AUTO_FIRE = false
local ESP_ENABLED = false
local AUTO_REWARD_HIDE = false
local AUTO_E = false
local AUTO_REEQUIP = false
local SAFE_ZONE = false

local FIRE_RATE = 0.01
local SHOT_COOLDOWN = 0.01

local MAX_DISTANCE = 200
local CLOSE_RANGE = 6

local NORMAL_SMOOTHNESS = 0.15
local CLOSE_SMOOTHNESS = 1

local AUTO_E_DISTANCE = 10

local SAFE_HEIGHT = 150

local SAFE_PLATFORM_SIZE =
    Vector3.new(8,1,8)

local holdingMouse = false

local TELEPORT_POS_1 = Vector3.new(1341.27392578125, 387.66168212890625, -2372.300048828125)

local TELEPORT_POS_2 = Vector3.new(1368.8114013671875, 832.8165893554688, -2335.286376953125)

local currentTarget = TELEPORT_POS_1

local isAutoEnabled = false

local SPEED_ENABLED = false

local WALK_SPEED_VALUE = 100

local NORMAL_SPEED = 16

local INF_JUMP = false

local NOCLIP = false

local AUTO_FOOD = false

local AUTO_SKIP = false

local DISABLE_REWARD_EVENTS = false

local ITEM_TWEEN = false
local ITEM_TWEEN_SPEED = 170
local ITEM_HOLD_E_TIME = 1.5
local ITEM_SELECTED_TYPE = "All"
local ITEM_AUTO_REFRESH = true
local ITEM_REFRESH_INTERVAL = 10
local ITEM_LAST_REFRESH = tick()
local itemCache = {}
local itemTween = nil
local itemTweening = false

--==================================================
-- CHARACTER
--==================================================

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHRP()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

--==================================================
-- MODIFY GUN
--==================================================

local function modifyGun()

    local char = getCharacter()

    for _,tool in ipairs(char:GetChildren()) do

        if tool:IsA("Tool") then

            for _,obj in ipairs(tool:GetDescendants()) do

                if obj:IsA("NumberValue")
                and obj.Name == "ShotCooldown" then

                    obj.Value = SHOT_COOLDOWN
                end
            end
        end
    end
end

task.spawn(function()

    while task.wait(0.5) do

        if AUTO_FIRE then
            pcall(modifyGun)
        end
    end
end)

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "ZombieHub"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")

frame.Parent = gui

frame.Size = UDim2.new(0,500,0,960)

frame.Position = UDim2.new(0,20,0.15,0)

frame.BackgroundColor3 =
    Color3.fromRGB(20,20,20)

frame.Active = true
frame.Draggable = true

frame.BorderSizePixel = 0

Instance.new("UICorner",frame)
    .CornerRadius = UDim.new(0,14)

--==================================================
-- TITLE
--==================================================

local title = Instance.new("TextLabel")

title.Parent = frame

title.Size = UDim2.new(1,0,0,45)

title.BackgroundTransparency = 1

title.Text = "MAMMOTHZ TH PROBOT"

title.Font = Enum.Font.GothamBold

title.TextSize = 20

title.TextColor3 = Color3.new(1,1,1)

--==================================================
-- BUTTON CREATOR
--==================================================

local function createButton(x,y,text)

    local btn = Instance.new("TextButton")

    btn.Parent = frame

    btn.Size = UDim2.new(0,200,0,42)

    btn.Position = UDim2.new(0,x,0,y)

    btn.Font = Enum.Font.GothamBold

    btn.TextSize = 14

    btn.TextColor3 = Color3.new(1,1,1)

    btn.BorderSizePixel = 0

    Instance.new("UICorner",btn)
        .CornerRadius = UDim.new(0,8)

    return btn
end

--==================================================
-- BUTTONS
--==================================================

local aimBtn =
    createButton(30,60,"AIMBOT")

local fireBtn =
    createButton(30,115,"AUTO FIRE")

local espBtn =
    createButton(30,170,"ESP")

local rewardBtn =
    createButton(30,225,"HIDE REWARD")

local autoEBtn =
    createButton(30,280,"AUTO E")

local reequipBtn =
    createButton(30,335,"AUTO RE-EQUIP")

local safeBtn =
    createButton(30,390,"SAFE ZONE")
	
local teleportBtn1 =
    createButton(30,445,"TELEPORT POINT 1")

local teleportBtn2 =
    createButton(260,60,"TELEPORT POINT 2")

local toggleBtn =
    createButton(260,115,"AUTO TELEPORT")

local speedBtn =
    createButton(260,170, "SPEED")
	
local jumpBtn =
    createButton(260,225,"INF JUMP")
	
local noclipBtn =
    createButton(260,280,"NOCLIP")
	
local autoFoodBtn =
    createButton(260,335,"AUTO FOOD")
	
local skipBtn =
    createButton(260,390,"AUTO SKIP")
	
local disableEventsBtn =
    createButton(260,445,"DISABLE EVENTS")
	
local itemTweenBtn =
    createButton(30,500,"ITEM TWEEN")

local itemFilterBtn =
    createButton(260,500,"ITEM FILTER")

local itemRefreshBtn =
    createButton(30,555,"ITEM REFRESH")
local itemAutoRefreshBtn =
    createButton(260,555,"ITEM AUTO REFRESH")
	
local itemSpeedBox = Instance.new("TextBox")

itemSpeedBox.Parent = frame
itemSpeedBox.Size = UDim2.new(0,200,0,38)
itemSpeedBox.Position = UDim2.new(0,30,0,610)

itemSpeedBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
itemSpeedBox.TextColor3 = Color3.new(1,1,1)

itemSpeedBox.Text = tostring(ITEM_TWEEN_SPEED)
itemSpeedBox.PlaceholderText = "ITEM SPEED"

itemSpeedBox.Font = Enum.Font.GothamBold
itemSpeedBox.TextSize = 14
itemSpeedBox.ClearTextOnFocus = false

Instance.new("UICorner", itemSpeedBox)
	


--==================================================
-- SAFE HEIGHT BOX
--==================================================

local heightBox = Instance.new("TextBox")

heightBox.Parent = frame

heightBox.Size = UDim2.new(0,240,0,38)

heightBox.Position =
    UDim2.new(0,30,0,854)

heightBox.BackgroundColor3 =
    Color3.fromRGB(35,35,35)
heightBox.TextColor3 =
    Color3.new(1,1,1)

heightBox.PlaceholderText =
    "SAFE HEIGHT (ex : 150)"

heightBox.Text =
    tostring(SAFE_HEIGHT)

heightBox.Font =
    Enum.Font.GothamBold

heightBox.TextSize = 14

heightBox.ClearTextOnFocus = false

heightBox.BorderSizePixel = 0

Instance.new("UICorner",heightBox)
    .CornerRadius = UDim.new(0,8)

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")

status.Parent = frame

status.Size = UDim2.new(1,0,0,22)

status.Position =
    UDim2.new(0,0,0,935)

status.BackgroundTransparency = 1

status.Text = "Everything OFF"

status.Font = Enum.Font.Gotham

status.TextSize = 13

status.TextColor3 =
    Color3.new(1,1,1)
local function setStatus(text)
    status.Text = text
end

--==================================================
-- INFO
--==================================================

local info = Instance.new("TextLabel")

info.Parent = frame

info.Size = UDim2.new(1,0,0,18)

info.Position =
    UDim2.new(0,0,0,950)

info.BackgroundTransparency = 1

info.Text = "Right Ctrl = Hide UI"

info.Font = Enum.Font.Gotham

info.TextSize = 11

info.TextColor3 =
    Color3.fromRGB(180,180,180)

--==================================================
-- UPDATE UI
--==================================================

local function updateButton(btn,state,name)

    btn.Text =
        name.." : "
        ..(state and "ON" or "OFF")

    btn.BackgroundColor3 =
        state
        and Color3.fromRGB(60,120,60)
        or Color3.fromRGB(120,60,60)
end

local function updateUI()

    updateButton(
        aimBtn,
        AIMBOT,
        "AIMBOT"
    )

    updateButton(
        fireBtn,
        AUTO_FIRE,
        "AUTO FIRE"
    )

    updateButton(
        espBtn,
        ESP_ENABLED,
        "ESP"
    )

    updateButton(
        rewardBtn,
        AUTO_REWARD_HIDE,
        "HIDE REWARD"
    )

    updateButton(
        autoEBtn,
        AUTO_E,
        "AUTO E"
    )

    updateButton(
        reequipBtn,
        AUTO_REEQUIP,
        "AUTO RE-EQUIP"
    )

    updateButton(
        safeBtn,
        SAFE_ZONE,
        "SAFE ZONE"
    )
	teleportBtn1.BackgroundColor3 = Color3.fromRGB(40,120,255)
teleportBtn1.Text = "TELEPORT POINT 1"

teleportBtn2.BackgroundColor3 = Color3.fromRGB(40,120,255)
teleportBtn2.Text = "TELEPORT POINT 2"

toggleBtn.Text =
    "AUTO TELEPORT : "
    ..(isAutoEnabled and "ON" or "OFF")

toggleBtn.BackgroundColor3 =
    isAutoEnabled
    and Color3.fromRGB(60,120,60)
    or Color3.fromRGB(120,60,60)
	-- UPDATE UI
	updateButton(
    speedBtn,
    SPEED_ENABLED,
    "SPEED"
)
	updateButton(
    jumpBtn,
    INF_JUMP,
    "INF JUMP"
)
	updateButton(
    noclipBtn,
    NOCLIP,
    "NOCLIP"
)
	updateButton(
    autoFoodBtn,
    AUTO_FOOD,
    "AUTO FOOD"
)
	updateButton(
    skipBtn,
    AUTO_SKIP,
    "AUTO SKIP"
)
updateButton(
    disableEventsBtn,
    DISABLE_REWARD_EVENTS,
    "DISABLE EVENTS"
)
updateButton(
    itemTweenBtn,
    ITEM_TWEEN,
    "ITEM TWEEN"
)
updateButton(
    itemAutoRefreshBtn,
    ITEM_AUTO_REFRESH,
    "ITEM AUTO"
)

itemFilterBtn.Text = "ITEM : " .. ITEM_SELECTED_TYPE
itemFilterBtn.BackgroundColor3 = Color3.fromRGB(40,120,255)

itemRefreshBtn.Text = "ITEM REFRESH"
itemRefreshBtn.BackgroundColor3 = Color3.fromRGB(40,100,180)
end

local function doesItemMatchFilter(obj, filterType)
    local name = obj.Name:lower()
    local parentName = obj.Parent and obj.Parent.Name:lower() or ""
    local fullName = name .. " " .. parentName

    local isFuel = fullName:find("fuel") ~= nil

    local isPotion = fullName:find("potion") ~= nil
        or fullName:find("vitamin") ~= nil
        or fullName:find("sea") ~= nil

    local isHeroShard = fullName:find("heroshard") ~= nil
        or fullName:find("hero_shard") ~= nil
        or fullName:find("hero shard") ~= nil
        or fullName:find("shard") ~= nil
        or fullName:find("hero") ~= nil

    local isSpawn = fullName:find("_spawn") ~= nil

    -- blacklist เฉพาะมอน/ตัวละครจริง ๆ
    if fullName:find("zombie") or fullName:find("npc") or fullName:find("monster") or fullName:find("wolf") or fullName:find("bear") then
        return false
    end

    if filterType == "Fuel" then
        return isFuel
    elseif filterType == "Potion" then
        return isPotion
    elseif filterType == "HeroShard" then
        return isHeroShard
    elseif filterType == "All" then
        return isHeroShard or isPotion or isFuel or isSpawn
    end

    return false
end

local function isValidItemForCache(obj)
    return doesItemMatchFilter(obj, "All")
end

local function getItemPosition(obj)
    if obj:IsA("BasePart") then return obj.Position
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart.Position
        else
            local part = obj:FindFirstChildWhichIsA("BasePart", true)
            if part then return part.Position end
        end
    end
    return nil
end

--====================================================
-- ระบบ Scan (รองรับทั้ง Manual และ Auto)
--====================================================
local function scanForItems(isAutoMode)
    -- แสดง Status ตามหมวดหมู่การเรียก
    if isAutoMode then
        setStatus("Auto Refreshing...")
    else
        setStatus("Scanning...")
    end
    
    local newCache = {}
    local foundFolder = false
    local targetFolders = {
    "Items",
    "Drops",
    "RuntimeItems",
    "FuelCans",
    "ActiveSupplyDrops",
    "ActiveGunCrates",
    "CrateSpawns",
    "BearSpawns"
}

    pcall(function()
        -- 1. พยายามหาโฟลเดอร์เฉพาะเจาะจงก่อน (เบากว่าหาทั้งแมพ)
        for _, folderName in ipairs(targetFolders) do
            local folder = workspace:FindFirstChild(folderName)
            if folder then
                foundFolder = true
                for _, obj in ipairs(folder:GetDescendants()) do
                    if isValidItemForCache(obj) then
                        table.insert(newCache, obj)
                    end
                end
            end
        end

        -- 2. ถ้าไม่เจอโฟลเดอร์เป้าหมาย ให้ใช้ GetChildren() แบบ V1 (ไม่มุดลงลึก)
        for _, obj in ipairs(workspace:GetChildren()) do
    if isValidItemForCache(obj) then
        table.insert(newCache, obj)
    end
end
    end)

    itemCache = newCache
    setStatus("Cache: " .. #itemCache .. " items")
    
    -- รีเซ็ตเวลาการสแกนล่าสุด
    ITEM_LAST_REFRESH = tick()
    
    task.delay(1.5, function()
        if not ITEM_TWEEN then 
            setStatus("Stopped") 
        elseif not itemTweening then 
            setStatus("Ready") 
        end
    end)
end

--====================================================
-- การทำงานของ Cache และ Tween
--====================================================

local function getClosestItemByType(typeName)
    local hrp = getHRP()
    if not hrp then return nil, nil, math.huge end

    local closestItem = nil
    local closestPos = nil
    local shortestDistance = math.huge

    for i = #itemCache, 1, -1 do
        local obj = itemCache[i]

        if obj and obj:IsDescendantOf(workspace) then
            if doesItemMatchFilter(obj, typeName) then
                local pos = getItemPosition(obj)
                if pos then
                    local distance = (hrp.Position - pos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestItem = obj
                        closestPos = pos
                    end
                end
            end
        else
            table.remove(itemCache, i)
        end
    end

    return closestItem, closestPos, shortestDistance
end

local function getClosestItem()
    if ITEM_SELECTED_TYPE ~= "All" then
        return getClosestItemByType(ITEM_SELECTED_TYPE)
    end

    local item, pos, dist

    item, pos, dist = getClosestItemByType("HeroShard")
    if item then return item, pos, dist end

    item, pos, dist = getClosestItemByType("Potion")
    if item then return item, pos, dist end

    item, pos, dist = getClosestItemByType("Fuel")
    if item then return item, pos, dist end

    return nil, nil, math.huge
end

local function stopitemTween()
    if itemTween then
        pcall(function() itemTween:Cancel() end)
        itemTween = nil
    end
    itemTweening = false
    currentTargetInstance = nil
end

local function tweenToPosition(targetObj, targetPos)
    local hrp = getHRP()
    if not hrp then return false end

    stopitemTween()
    currentTargetInstance = targetObj

    local offsetPos = targetPos + Vector3.new(0, 3, 0)
    local distance = (hrp.Position - offsetPos).Magnitude
    local tweenTime = distance / ITEM_TWEEN_SPEED

    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    setStatus("Tweening: " .. targetObj.Name)

    local success, twn = pcall(function()
        return TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(offsetPos)})
    end)

    if success and twn then
        itemTween = twn
        itemTweening = true
        itemTween:Play()

        local completed = false
        local connection
        connection = itemTween.Completed:Connect(function() completed = true end)

        while not completed and ITEM_TWEEN and itemTweening do
            if not targetObj or not targetObj:IsDescendantOf(workspace) then
                stopitemTween()
                if connection then connection:Disconnect() end
                return false
            end
            task.wait(0.05)
        end

        if connection then connection:Disconnect() end
        if not ITEM_TWEEN then stopitemTween() return false end

        itemTweening = false
        itemTween = nil
        return true
    else
        itemTweening = false
        return false
    end
end


updateUI()

--==================================================
-- BUTTON EVENTS
--==================================================

aimBtn.MouseButton1Click:Connect(function()

    AIMBOT = not AIMBOT

    updateUI()
end)

fireBtn.MouseButton1Click:Connect(function()

    AUTO_FIRE = not AUTO_FIRE

    updateUI()
end)

espBtn.MouseButton1Click:Connect(function()

    ESP_ENABLED = not ESP_ENABLED

    updateUI()

    for _,v in pairs(
        workspace:GetDescendants()
    ) do

        local hl =
            v:FindFirstChild(
                "ESP_HIGHLIGHT"
            )

        local bill =
            v:FindFirstChild(
                "ESP_BILLBOARD"
            )

        if hl then
            hl.Enabled = ESP_ENABLED
        end

        if bill then
            bill.Enabled = ESP_ENABLED
        end
    end
end)

rewardBtn.MouseButton1Click:Connect(function()

    AUTO_REWARD_HIDE =
        not AUTO_REWARD_HIDE

    updateUI()
end)

autoEBtn.MouseButton1Click:Connect(function()

    AUTO_E = not AUTO_E

    updateUI()
end)

reequipBtn.MouseButton1Click:Connect(function()

    AUTO_REEQUIP =
        not AUTO_REEQUIP

    updateUI()
end)

safeBtn.MouseButton1Click:Connect(function()

    SAFE_ZONE =
        not SAFE_ZONE

    updateUI()
end)
local function performTeleport(targetPosition)

    status.Text = "Teleporting..."

    local success, errorMessage = pcall(function()

        local char =
            player.Character
            or player.CharacterAdded:Wait()

        local hrp =
            char:WaitForChild(
                "HumanoidRootPart",
                5
            )

        if hrp then

            hrp.CFrame =
                CFrame.new(
                    targetPosition
                    + Vector3.new(0,3,0)
                )
        end
    end)

    if success then

        status.Text = "Teleported!"

    else

        status.Text = "Teleport Error"

        warn(
            "Teleport Error: "
            ..tostring(errorMessage)
        )
    end
end

teleportBtn1.MouseButton1Click:Connect(function()

    currentTarget = TELEPORT_POS_1

    performTeleport(currentTarget)
end)

teleportBtn2.MouseButton1Click:Connect(function()

    currentTarget = TELEPORT_POS_2

    performTeleport(currentTarget)
end)

toggleBtn.MouseButton1Click:Connect(function()

    isAutoEnabled = not isAutoEnabled

    updateUI()

    status.Text =
        isAutoEnabled
        and "Auto Teleporting..."
        or "Ready"
end)

speedBtn.MouseButton1Click:Connect(function()
    SPEED_ENABLED = not SPEED_ENABLED
    updateUI()
end)
	jumpBtn.MouseButton1Click:Connect(function()

    INF_JUMP = not INF_JUMP

    updateUI()
end)
noclipBtn.MouseButton1Click:Connect(function()

    NOCLIP = not NOCLIP

    updateUI()
end)
autoFoodBtn.MouseButton1Click:Connect(function()

    AUTO_FOOD = not AUTO_FOOD

    updateUI()

end)
skipBtn.MouseButton1Click:Connect(function()

    AUTO_SKIP = not AUTO_SKIP

    updateUI()

end)
local LAST_CLICK_TIME = 0
local CLICK_COOLDOWN = 2

local TargetNames = {
    "skip",
    "skipvote",
    "voteskip",
    "skipbutton"
}

local RemoteKeywords = {
    "skip",
    "vote",
    "choice",
    "skipvote",
    "voteskip"
}

local buttonHistory = {}

local function autoFireRemote()
    for _, item in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if item:IsA("RemoteEvent") then
            local nameLower = string.lower(item.Name)

            for _, keyword in ipairs(RemoteKeywords) do
                if string.find(nameLower, keyword) then
                    pcall(function()
                        item:FireServer()
                        item:FireServer(true)
                        item:FireServer("Skip")
                        item:FireServer(1)
                    end)
                end
            end
        end
    end
end

local function checkButtonMatch(obj)
    if not (obj:IsA("TextButton") or obj:IsA("ImageButton")) then
        return false
    end

    local nameLower = string.lower(obj.Name)

    for _, keyword in ipairs(TargetNames) do
        if string.find(nameLower, keyword) then
            return true
        end
    end

    local isGeometricMatch = false

    pcall(function()
        local screenSize = camera.ViewportSize
        local screenCenterX = screenSize.X / 2
        local btnCenterX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
        local btnCenterY = obj.AbsolutePosition.Y + (obj.AbsoluteSize.Y / 2)

        if math.abs(btnCenterX - screenCenterX) < 35
        and math.abs(btnCenterY - 84) < 35 then
            isGeometricMatch = true
        end
    end)

    return isGeometricMatch
end

local function isButtonReallyVisible(obj)
    if not obj or not obj.Parent then return false end
    if not obj.Visible then return false end
    if obj.AbsoluteSize.X == 0 or obj.AbsoluteSize.Y == 0 then return false end

    local current = obj.Parent

    while current and current ~= player.PlayerGui and current ~= game do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        elseif current:IsA("ScreenGui") and not current.Enabled then
            return false
        end

        current = current.Parent
    end

    return true
end

task.spawn(function()
    while true do
        task.wait(0.2)

        if AUTO_SKIP then
            local currentlyVisibleButtons = {}

            pcall(function()
                for _, obj in ipairs(player.PlayerGui:GetDescendants()) do
                    if checkButtonMatch(obj) and isButtonReallyVisible(obj) then
                        table.insert(currentlyVisibleButtons, obj)

                        if (os.clock() - LAST_CLICK_TIME > CLICK_COOLDOWN)
                        and (not buttonHistory[obj]) then

                            buttonHistory[obj] = true
                            LAST_CLICK_TIME = os.clock()

                            autoFireRemote()

                            pcall(function()
                                local btnCenterX = obj.AbsolutePosition.X + (obj.AbsoluteSize.X / 2)
                                local btnCenterY = obj.AbsolutePosition.Y + (obj.AbsoluteSize.Y / 2)

                                VirtualInputManager:SendMouseButtonEvent(
                                    btnCenterX,
                                    btnCenterY,
                                    0,
                                    true,
                                    game,
                                    1
                                )

                                task.wait(0.05)

                                VirtualInputManager:SendMouseButtonEvent(
                                    btnCenterX,
                                    btnCenterY,
                                    0,
                                    false,
                                    game,
                                    1
                                )
                            end)
                        end
                    end
                end

                for obj, _ in pairs(buttonHistory) do
                    if not table.find(currentlyVisibleButtons, obj)
                    or not isButtonReallyVisible(obj) then
                        buttonHistory[obj] = nil
                    end
                end
            end)
        end
    end
end)

disableEventsBtn.MouseButton1Click:Connect(function()

    DISABLE_REWARD_EVENTS = not DISABLE_REWARD_EVENTS

    updateUI()

end)
itemTweenBtn.MouseButton1Click:Connect(function()
    ITEM_TWEEN = not ITEM_TWEEN

    if ITEM_TWEEN and #itemCache == 0 then
        scanForItems(false)
    end

    if not ITEM_TWEEN then
        stopitemTween()
    end

    updateUI()
end)

itemFilterBtn.MouseButton1Click:Connect(function()
    if ITEM_SELECTED_TYPE == "All" then
        ITEM_SELECTED_TYPE = "Fuel"
    elseif ITEM_SELECTED_TYPE == "Fuel" then
        ITEM_SELECTED_TYPE = "Potion"
    elseif ITEM_SELECTED_TYPE == "Potion" then
        ITEM_SELECTED_TYPE = "HeroShard"
    else
        ITEM_SELECTED_TYPE = "All"
    end

    stopitemTween()
    updateUI()
end)

itemRefreshBtn.MouseButton1Click:Connect(function()
    scanForItems(false)
end)

itemAutoRefreshBtn.MouseButton1Click:Connect(function()
    ITEM_AUTO_REFRESH = not ITEM_AUTO_REFRESH
    updateUI()
end)
--==================================================
-- SAFE HEIGHT UPDATE
--==================================================

heightBox.FocusLost:Connect(function()

    local num =
        tonumber(heightBox.Text)

    if num then

        SAFE_HEIGHT = num

        status.Text =
            "Safe Height : "..num

    else

        heightBox.Text =
            tostring(SAFE_HEIGHT)

        status.Text =
            "Invalid Number"
    end
end)
itemSpeedBox.FocusLost:Connect(function()

    local num = tonumber(itemSpeedBox.Text)

    if num and num > 0 then
        ITEM_TWEEN_SPEED = num
        setStatus("Item Speed : "..num)
    else
        itemSpeedBox.Text = tostring(ITEM_TWEEN_SPEED)
    end

end)


--==================================================
-- RIGHT CTRL
--==================================================

UserInputService.InputBegan:Connect(function(input,gp)

    if gp then return end

    if input.KeyCode
    == Enum.KeyCode.RightControl then

        frame.Visible =
            not frame.Visible
    end
	if input.KeyCode
== Enum.KeyCode.Z then

    AIMBOT = not AIMBOT

    updateUI()

    status.Text =
        AIMBOT
        and "Aimbot ON"
        or "Aimbot OFF"
end

    if input.UserInputType
    == Enum.UserInputType.MouseButton1 then

        holdingMouse = true
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType
    == Enum.UserInputType.MouseButton1 then

        holdingMouse = false
    end
end)

--==================================================
-- ESP
--==================================================

local espCache = {}

local ESP_TARGETS = {

    ["BearModel"] =
        Color3.fromRGB(255,60,60),

    ["WolfModel"] =
        Color3.fromRGB(255,100,100),

    ["DamagePotion_Spawn"] =
        Color3.fromRGB(60,255,60),

    ["HeroShard_Spawn"] =
        Color3.fromRGB(255,120,255),

    ["MultPotion_Spawn"] =
        Color3.fromRGB(60,180,255),

    ["Fuel"] =
        Color3.fromRGB(255,255,60)
}

local function createESP(obj,color)

    if espCache[obj] then return end

    local root = nil

    if obj:IsA("Model") then

        root =
            obj:FindFirstChildWhichIsA(
                "BasePart",
                true
            )

    elseif obj:IsA("BasePart") then

        root = obj
    end

    if not root then return end

    local hl =
        Instance.new("Highlight")

    hl.Name = "ESP_HIGHLIGHT"

    hl.FillColor = color

    hl.OutlineColor =
        Color3.new(1,1,1)

    hl.FillTransparency = 0.5

    hl.DepthMode =
        Enum.HighlightDepthMode
        .AlwaysOnTop

    hl.Enabled = ESP_ENABLED

    hl.Parent = obj

    local bill =
        Instance.new("BillboardGui")

    bill.Name = "ESP_BILLBOARD"

    bill.Size =
        UDim2.new(0,150,0,40)

    bill.AlwaysOnTop = true

    bill.StudsOffset =
        Vector3.new(0,3,0)

    bill.Enabled = ESP_ENABLED

    bill.Parent = root

    local text =
        Instance.new("TextLabel")

    text.Parent = bill

    text.Size =
        UDim2.new(1,0,1,0)

    text.BackgroundTransparency = 1

    text.Font =
        Enum.Font.GothamBold

    text.TextScaled = true

    text.TextStrokeTransparency = 0

    text.TextColor3 = color

    RunService.RenderStepped:Connect(function()

        if root.Parent
        and player.Character
        and player.Character
        :FindFirstChild(
            "HumanoidRootPart"
        ) then

            local dist =
                (
                    player.Character
                    .HumanoidRootPart.Position
                    - root.Position
                ).Magnitude

            text.Text =
                obj.Name
                .." ["
                ..math.floor(dist)
                .."m]"
        end
    end)

    espCache[obj] = true
end

local function scanESP(obj)

    -- Bear
    if obj.Name == "BearModel" then
        createESP(obj, Color3.fromRGB(255,60,60))
        return
    end

    -- Wolf
    if obj.Name == "WolfModel" then
        createESP(obj, Color3.fromRGB(255,120,120))
        return
    end

    -- ของดรอปทุกชนิด
    if obj.Name:find("_Spawn") then
        createESP(obj, Color3.fromRGB(60,255,60))
        return
    end

end

for _,v in pairs(
    workspace:GetDescendants()
) do

    scanESP(v)
end

workspace.DescendantAdded
:Connect(function(v)

    task.wait()

    scanESP(v)
end)

--==================================================
-- HIDE REWARD
--==================================================

task.spawn(function()

    while task.wait(0.1) do

        if AUTO_REWARD_HIDE then

            local reward =
                player.PlayerGui
                :FindFirstChild(
                    "PostWavePickerCombined",
                    true
                )

            if reward then

                for _,v in pairs(
                    reward:GetDescendants()
                ) do

                    if v:IsA("Frame")
                    or v:IsA("TextLabel")
                    or v:IsA("TextButton")
                    or v:IsA("ImageLabel")
                    or v:IsA("ImageButton") then

                        v.Visible = false
                    end
                end
            end
        end
    end
end)

--==================================================
-- AUTO RE-EQUIP
--==================================================

local function equipGun()

    local char =
        player.Character

    if not char then return end

    local hum =
        char:FindFirstChildOfClass(
            "Humanoid"
        )

    if not hum then return end

    local holding =
        char:FindFirstChildWhichIsA(
            "Tool"
        )

    if not holding then

        local tool =
            player.Backpack
            :FindFirstChildWhichIsA(
                "Tool"
            )

        if tool then

            hum:EquipTool(tool)
        end
    end
end

task.spawn(function()

    while task.wait(0.1) do

        if AUTO_REEQUIP then
            pcall(equipGun)
        end
    end
end)

--==================================================
-- AUTO E
--==================================================

task.spawn(function()

    while task.wait(0.1) do

        if AUTO_E then

            local hrp = getHRP()

            for _,v in pairs(
                workspace:GetDescendants()
            ) do

                if v:IsA(
                    "ProximityPrompt"
                ) then

                    v.HoldDuration = 0

                    local part =
                        v.Parent

                    if part
                    and part:IsA(
                        "BasePart"
                    ) then

                        local dist =
                            (
                                hrp.Position
                                - part.Position
                            ).Magnitude

                        if dist
                        <= AUTO_E_DISTANCE then

                            pcall(function()

                                fireproximityprompt(v)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

--==================================================
-- SAFE ZONE
--==================================================

local safePart = nil

local function createSafePlatform()

    if safePart then
        safePart:Destroy()
    end

    local char =
        player.Character

    if not char then return end

    local hrp =
        char:FindFirstChild(
            "HumanoidRootPart"
        )

    if not hrp then return end

    safePart =
        Instance.new("Part")

    safePart.Name = "SafePlatform"

    safePart.Size =
        SAFE_PLATFORM_SIZE

    safePart.Anchored = true

    safePart.CanCollide = true

    safePart.Transparency = 0.3

    safePart.Material =
        Enum.Material.ForceField

    safePart.Color =
        Color3.fromRGB(0,255,170)

    safePart.Parent = workspace

    safePart.Position =
        hrp.Position
        + Vector3.new(
            0,
            SAFE_HEIGHT,
            0
        )

    hrp.CFrame =
        CFrame.new(
            safePart.Position
            + Vector3.new(0,3,0)
        )
end

local function removeSafePlatform()

    if safePart then

        safePart:Destroy()

        safePart = nil
    end
end

task.spawn(function()

    while task.wait(0.2) do

        if SAFE_ZONE then

            if not safePart then
                createSafePlatform()
            end

            local char =
                player.Character

            if char then

                local hrp =
                    char
                    :FindFirstChild(
                        "HumanoidRootPart"
                    )

                if hrp and safePart then

                    safePart.Position =
                        Vector3.new(
                            hrp.Position.X,
                            SAFE_HEIGHT,
                            hrp.Position.Z
                        )
                end
            end

        else

            removeSafePlatform()
        end
    end
end)

--==================================================
-- CLOSEST ZOMBIE
--==================================================

local function getClosestZombie()

    local folder =
        workspace
        :FindFirstChild(
            "ZombiesAlive"
        )

    if not folder then
        return nil,nil
    end

    local hrp = getHRP()

    local closest = nil
    local shortest = math.huge

    for _,mob in ipairs(
        folder:GetChildren()
    ) do

        local humanoid =
            mob
            :FindFirstChildOfClass(
                "Humanoid"
            )

        if humanoid
        and humanoid.Health > 0 then

            local target =
                mob
                :FindFirstChild(
                    "Head"
                )

            if target then

                local dist =
                    (
                        hrp.Position
                        - target.Position
                    ).Magnitude

                if dist < shortest
                and dist <= MAX_DISTANCE then

                    shortest = dist
                    closest = target
                end
            end
        end
    end

    return closest,shortest
end

--==================================================
-- AIMBOT
--==================================================

RunService.RenderStepped
:Connect(function()

    if not AIMBOT then return end

    local target,distance =
        getClosestZombie()

    if target then

        status.Text =
            "Target : "
            ..target.Parent.Name
            .." ["
            ..math.floor(distance)
            .."]"

        local camPos =
            camera.CFrame.Position

        local targetPos =
            target.Position

        local smoothness =
            distance < CLOSE_RANGE
            and CLOSE_SMOOTHNESS
            or NORMAL_SMOOTHNESS

        local lookCF =
            CFrame.lookAt(
                camPos,
                targetPos
            )

        camera.CFrame =
            camera.CFrame:Lerp(
                lookCF,
                smoothness
            )

    else

        status.Text =
            "Everything OFF"
    end
end)

--==================================================
-- AUTO FIRE
--==================================================

task.spawn(function()

    while true do

        if AUTO_FIRE
        and holdingMouse then

            VirtualInputManager
            :SendMouseButtonEvent(
                0,
                0,
                0,
                true,
                game,
                0
            )

            task.wait()

            VirtualInputManager
            :SendMouseButtonEvent(
                0,
                0,
                0,
                false,
                game,
                0
            )

            task.wait(FIRE_RATE)

        else

            task.wait(0.01)
        end
    end
end)
task.spawn(function()

    while task.wait(0.5) do

        if isAutoEnabled then

            performTeleport(currentTarget)
        end
    end
end)

RunService.Heartbeat:Connect(function()

    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if SPEED_ENABLED then
        hum.WalkSpeed = WALK_SPEED_VALUE
		print("Current Speed:", hum.WalkSpeed)
    else
        hum.WalkSpeed = NORMAL_SPEED
    end

    if NOCLIP then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end

end)
UserInputService.JumpRequest:Connect(function()

    if INF_JUMP then

        local char = player.Character

        if not char then return end

        local hum =
            char:FindFirstChildOfClass(
                "Humanoid"
            )

        if hum then

            hum:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)
task.spawn(function()
    while true do
        task.wait(600)

        if AUTO_FOOD then

            VirtualInputManager:SendKeyEvent(
                true,
                Enum.KeyCode.Five,
                false,
                game
            )

            task.wait(0.1)

            VirtualInputManager:SendKeyEvent(
                false,
                Enum.KeyCode.Five,
                false,
                game
            )

            task.wait(0.3)

            VirtualInputManager:SendMouseButtonEvent(
                workspace.CurrentCamera.ViewportSize.X/2,
                workspace.CurrentCamera.ViewportSize.Y/2,
                0,
                true,
                game,
                0
            )

            task.wait(0.05)

            VirtualInputManager:SendMouseButtonEvent(
                workspace.CurrentCamera.ViewportSize.X/2,
                workspace.CurrentCamera.ViewportSize.Y/2,
                0,
                false,
                game,
                0
            )

            task.wait(0.5)

            VirtualInputManager:SendKeyEvent(
                true,
                Enum.KeyCode.One,
                false,
                game
            )

            task.wait(0.1)

            VirtualInputManager:SendKeyEvent(
                false,
                Enum.KeyCode.One,
                false,
                game
            )
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if DISABLE_REWARD_EVENTS then
            local eventsFolder =
                player:FindFirstChild("PlayerScripts")
                and player.PlayerScripts:FindFirstChild("Events")

            if eventsFolder then
                for _, name in ipairs({"EndRewards", "WaveRewards"}) do
                    local obj = eventsFolder:FindFirstChild(name)

                    if obj then
                        pcall(function()
                            obj.Disabled = true
                        end)

                        pcall(function()
                            obj.Enabled = false
                        end)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if ITEM_TWEEN and not itemTweening then
            local success, err = pcall(function()
                local item, pos, dist = getClosestItem()

                if item and pos then
                    local arrived = tweenToPosition(item, pos)

                    if arrived and ITEM_TWEEN then
                        setStatus("Holding E...")

                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(ITEM_HOLD_E_TIME)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)

                        task.wait(0.3)
                    end
                else
                    setStatus("No " .. ITEM_SELECTED_TYPE .. " found")
                    task.wait(0.5)
                end
            end)

            if not success then
                warn("Item Tween Error:", err)
                itemTweening = false
                task.wait(1)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if ITEM_TWEEN and ITEM_AUTO_REFRESH and not itemTweening then
            if tick() - ITEM_LAST_REFRESH >= ITEM_REFRESH_INTERVAL then
                scanForItems(true)
            end
        end
    end
end)

updateUI()

status.Text = "Everything OFF"
