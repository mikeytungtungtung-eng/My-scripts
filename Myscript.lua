-- CART3R.JAILBREAK
-- LocalScript for your own Roblox game

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local PASSWORD = "09636321"

local espEnabled = false
local espStyles = {
    Highlight = true,
    Wireframe = false,
    Name = false,
    Distance = false
}

local aimbotEnabled = false
local aimbotRange = 100
local aimSmoothness = 0.15
local aimPart = "Head"

local tracked = {}
local lastScan = 0
local aimTarget = nil
local lastAimScan = 0
local aimScanInterval = 0.25

local old = playerGui:FindFirstChild("CART3R_UI")
if old then old:Destroy() end

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(65,65,75)
    s.Thickness = 1
    s.Parent = obj
end

local function button(parent, text, pos, size)
    local b = make("TextButton", {
        Text = text,
        Position = pos,
        Size = size,
        BackgroundColor3 = Color3.fromRGB(42,42,52),
        TextColor3 = Color3.new(1,1,1),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        AutoButtonColor = true
    }, parent)

    corner(b,9)
    return b
end

local gui = make("ScreenGui", {
    Name = "CART3R_UI",
    ResetOnSpawn = false
}, playerGui)

-- LOGIN

local login = make("Frame", {
    Size = UDim2.fromOffset(270,175),
    Position = UDim2.new(0.5,-135,0.5,-87),
    BackgroundColor3 = Color3.fromRGB(20,20,26)
}, gui)

corner(login,16)
stroke(login)

make("TextLabel", {
    Text = "CART3R.JAILBREAK",
    Size = UDim2.new(1,0,0,42),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 17
}, login)

local pass = make("TextBox", {
    PlaceholderText = "Enter password",
    Text = "",
    Position = UDim2.new(0,20,0,55),
    Size = UDim2.new(1,-40,0,38),
    BackgroundColor3 = Color3.fromRGB(38,38,47),
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false
}, login)

corner(pass,9)

local enter = button(login,"LOGIN",
    UDim2.new(0,20,0,108),
    UDim2.new(1,-40,0,38))

local errorText = make("TextLabel", {
    Text = "",
    Position = UDim2.new(0,0,1,-25),
    Size = UDim2.new(1,0,0,20),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255,90,90),
    TextSize = 12,
    Font = Enum.Font.Gotham
}, login)

-- MAIN WINDOW

local main = make("Frame", {
    Size = UDim2.new(0.9,0,0.68,0),
    Position = UDim2.new(0.05,0,0.16,0),
    BackgroundColor3 = Color3.fromRGB(19,19,25),
    Visible = false,
    ClipsDescendants = true
}, gui)

corner(main,16)
stroke(main)

local top = make("Frame", {
    Size = UDim2.new(1,0,0,42),
    BackgroundColor3 = Color3.fromRGB(29,29,37)
}, main)

make("TextLabel", {
    Text = "CART3R.JAILBREAK",
    Position = UDim2.new(0,12,0,0),
    Size = UDim2.new(0.7,0,1,0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = button(top,"X",
    UDim2.new(1,-42,0,6),
    UDim2.fromOffset(32,30))

-- MOVABLE SQUARE AIMER HUB BUTTON

local togglePanel = button(
    gui,
    "A",
    UDim2.new(0,15,0.5,-30),
    UDim2.fromOffset(60,60)
)

togglePanel.Visible = false
togglePanel.TextSize = 20
togglePanel.Font = Enum.Font.GothamBold
togglePanel.BackgroundColor3 = Color3.fromRGB(70,90,140)

local buttonCorner = togglePanel:FindFirstChildOfClass("UICorner")
if buttonCorner then
    buttonCorner.CornerRadius = UDim.new(0,5)
end

local draggingButton = false
local movedButton = false
local dragStart
local buttonStart

togglePanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingButton = true
        movedButton = false
        dragStart = input.Position
        buttonStart = togglePanel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingButton and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart

        if delta.Magnitude > 5 then
            movedButton = true
        end

        togglePanel.Position = UDim2.new(
            buttonStart.X.Scale,
            buttonStart.X.Offset + delta.X,
            buttonStart.Y.Scale,
            buttonStart.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if draggingButton then
            if not movedButton then
                main.Visible = not main.Visible
            end
            draggingButton = false
        end
    end
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

local sidebar = make("Frame", {
    Position = UDim2.new(0,8,0,50),
    Size = UDim2.new(0.32,-8,1,-58),
    BackgroundColor3 = Color3.fromRGB(27,27,35)
}, main)

corner(sidebar,12)

local content = make("Frame", {
    Position = UDim2.new(0.34,4,0,50),
    Size = UDim2.new(0.66,-12,1,-58),
    BackgroundColor3 = Color3.fromRGB(27,27,35)
}, main)

corner(content,12)

-- PAGES

local espPage = make("Frame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = true
}, content)

local aimbotPage = make("Frame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Visible = false
}, content)

-- SIDEBAR

local espTab = button(sidebar,"ESP",
    UDim2.new(0,7,0,10),
    UDim2.new(1,-14,0,38))

local aimbotTab = button(sidebar,"AIMBOT",
    UDim2.new(0,7,0,56),
    UDim2.new(1,-14,0,38))

espTab.BackgroundColor3 = Color3.fromRGB(70,90,140)

espTab.MouseButton1Click:Connect(function()
    espPage.Visible = true
    aimbotPage.Visible = false
    espTab.BackgroundColor3 = Color3.fromRGB(70,90,140)
    aimbotTab.BackgroundColor3 = Color3.fromRGB(42,42,52)
end)

aimbotTab.MouseButton1Click:Connect(function()
    espPage.Visible = false
    aimbotPage.Visible = true
    aimbotTab.BackgroundColor3 = Color3.fromRGB(70,90,140)
    espTab.BackgroundColor3 = Color3.fromRGB(42,42,52)
end)

-- NPC CHECK

local function isNPC(model)
    return model:IsA("Model")
        and model:FindFirstChildOfClass("Humanoid") ~= nil
        and Players:GetPlayerFromCharacter(model) == nil
end

-- ESP PAGE

make("TextLabel", {
    Text = "TRAINING NPC ESP",
    Position = UDim2.new(0,12,0,10),
    Size = UDim2.new(1,-24,0,28),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
}, espPage)

local toggle = button(espPage,"ESP: OFF",
    UDim2.new(0,12,0,48),
    UDim2.new(1,-24,0,36))

local function clearNPC(model)
    local data = tracked[model]
    if not data then return end

    for _,obj in ipairs(data.objects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end

    tracked[model] = nil
end

local function addNPC(model)
    if not espEnabled or not isNPC(model) then return end
    if tracked[model] then return end

    local part = model:FindFirstChild("Head")
        or model:FindFirstChild("HumanoidRootPart")
        or model.PrimaryPart

    if not part then return end

    local objects = {}
    local data = {
        objects = objects,
        part = part
    }

    if espStyles.Highlight then
        local h = Instance.new("Highlight")
        h.FillTransparency = 0.8
        h.OutlineColor = Color3.fromRGB(70,220,120)
        h.Adornee = model
        h.Parent = model
        table.insert(objects,h)
    end

    if espStyles.Wireframe then
        for _,p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                local box = Instance.new("SelectionBox")
                box.Adornee = p
                box.LineThickness = 0.04
                box.Color3 = Color3.fromRGB(70,220,120)
                box.Parent = p
                table.insert(objects,box)
            end
        end
    end

    if espStyles.Name or espStyles.Distance then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "CART3R_ESP"
        billboard.Adornee = part
        billboard.Size = UDim2.fromOffset(180,35)
        billboard.StudsOffset = Vector3.new(0,2.5,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = part

        local label = make("TextLabel", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(90,255,130),
            TextStrokeTransparency = 0.3,
            Font = Enum.Font.GothamBold,
            TextSize = 13
        }, billboard)

        data.label = label
        table.insert(objects,billboard)
    end

    tracked[model] = data
end

local function refreshESP()
    for model in pairs(tracked) do
        clearNPC(model)
    end

    if espEnabled then
        for _,obj in ipairs(workspace:GetDescendants()) do
            if isNPC(obj) then
                addNPC(obj)
            end
        end
    end
end

local styles = {"Highlight","Wireframe","Name","Distance"}

for i,style in ipairs(styles) do
    local b = button(espPage,style,
        UDim2.new(0,12,0,92+(i-1)*42),
        UDim2.new(1,-24,0,34))

    b.BackgroundColor3 = espStyles[style]
        and Color3.fromRGB(70,90,140)
        or Color3.fromRGB(42,42,52)

    b.MouseButton1Click:Connect(function()
        espStyles[style] = not espStyles[style]

        b.BackgroundColor3 = espStyles[style]
            and Color3.fromRGB(70,90,140)
            or Color3.fromRGB(42,42,52)

        refreshESP()
    end)
end

toggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    toggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    refreshESP()
end)

-- AIMBOT PAGE

make("TextLabel", {
    Text = "AIMBOT SETTINGS",
    Position = UDim2.new(0,12,0,10),
    Size = UDim2.new(1,-24,0,28),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
}, aimbotPage)

local botButton = button(aimbotPage,"BOT AIMBOT: OFF",
    UDim2.new(0,12,0,48),
    UDim2.new(1,-24,0,38))

local playerButton = button(aimbotPage,"PLAYERS: UNAVAILABLE",
    UDim2.new(0,12,0,96),
    UDim2.new(1,-24,0,38))

playerButton.BackgroundColor3 = Color3.fromRGB(65,35,35)

botButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled

    botButton.Text = aimbotEnabled
        and "BOT AIMBOT: ON"
        or "BOT AIMBOT: OFF"

    if not aimbotEnabled then
        aimTarget = nil
    end
end)

-- TARGET PART SELECTOR

local partButton = button(aimbotPage,"TARGET PART: HEAD",
    UDim2.new(0,12,0,144),
    UDim2.new(1,-24,0,36))

partButton.MouseButton1Click:Connect(function()
    aimPart = aimPart == "Head" and "Torso" or "Head"
    partButton.Text = "TARGET PART: "..string.upper(aimPart)
    aimTarget = nil
end)

-- AIMBOT RANGE

local rangeTitle = make("TextLabel", {
    Text = "AIMBOT RANGE: 100 STUDS",
    Position = UDim2.new(0,12,0,190),
    Size = UDim2.new(1,-24,0,25),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
}, aimbotPage)

local rangeInput = make("TextBox", {
    Text = "100",
    Position = UDim2.new(0,12,0,220),
    Size = UDim2.new(1,-24,0,38),
    BackgroundColor3 = Color3.fromRGB(42,42,52),
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    ClearTextOnFocus = false
}, aimbotPage)

corner(rangeInput,9)

rangeInput.FocusLost:Connect(function()
    local value = tonumber(rangeInput.Text)

    if value then
        aimbotRange = math.clamp(value,10,500)
    end

    rangeInput.Text = tostring(aimbotRange)
    rangeTitle.Text = "AIMBOT RANGE: "..aimbotRange.." STUDS"
end)

-- SMOOTHNESS SLIDER

local smoothTitle = make("TextLabel", {
    Text = "SMOOTHNESS: 15%",
    Position = UDim2.new(0,12,0,270),
    Size = UDim2.new(1,-24,0,25),
    BackgroundTransparency = 1,
    TextColor3 = Color3.new(1,1,1),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left
}, aimbotPage)

local smoothBar = make("TextButton", {
    Text = "",
    Position = UDim2.new(0,12,0,305),
    Size = UDim2.new(1,-24,0,12),
    BackgroundColor3 = Color3.fromRGB(55,55,65),
    AutoButtonColor = false
}, aimbotPage)

corner(smoothBar,8)

local smoothFill = make("Frame", {
    Size = UDim2.new(0.15,0,1,0),
    BackgroundColor3 = Color3.fromRGB(70,130,220)
}, smoothBar)

corner(smoothFill,8)

local smoothKnob = make("Frame", {
    Size = UDim2.fromOffset(18,18),
    Position = UDim2.new(0.15,-9,0.5,-9),
    BackgroundColor3 = Color3.new(1,1,1)
}, smoothBar)

corner(smoothKnob,20)

local draggingSmoothness = false

local function updateSmoothness(inputX)
    local percent = math.clamp(
        (inputX - smoothBar.AbsolutePosition.X)
        / smoothBar.AbsoluteSize.X,
        0,1
    )

    aimSmoothness = math.clamp(percent,0.05,0.5)

    smoothFill.Size = UDim2.new(percent,0,1,0)
    smoothKnob.Position = UDim2.new(percent,-9,0.5,-9)

    smoothTitle.Text = "SMOOTHNESS: "
        ..math.floor(aimSmoothness * 100).."%"
end

smoothBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSmoothness = true
        updateSmoothness(input.Position.X)
    end
end)

UIS.InputChanged:Connect(function(input)
    if draggingSmoothness and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        updateSmoothness(input.Position.X)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingSmoothness = false
    end
end)

-- UPDATE ESP

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end

    for model,data in pairs(tracked) do
        if not model.Parent then
            clearNPC(model)

        elseif data.label and data.part and data.part.Parent then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")

            if root then
                local distance = math.floor(
                    (root.Position-data.part.Position).Magnitude
                )

                local textParts = {}

                if espStyles.Name then
                    table.insert(textParts,model.Name)
                end

                if espStyles.Distance then
                    table.insert(textParts,distance.." studs")
                end

                data.label.Text = table.concat(textParts," | ")
            end
        end
    end

    if os.clock()-lastScan >= 1 then
        lastScan = os.clock()

        for _,obj in ipairs(workspace:GetDescendants()) do
            if isNPC(obj) and not tracked[obj] then
                addNPC(obj)
            end
        end
    end
end)

-- NPC AIM ASSIST

RunService:BindToRenderStep(
    "CART3R_BotAim",
    Enum.RenderPriority.Camera.Value + 1,
    function(deltaTime)
        if not aimbotEnabled then
            aimTarget = nil
            return
        end

        local camera = workspace.CurrentCamera
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not camera or not root then
            aimTarget = nil
            return
        end

        if os.clock()-lastAimScan >= aimScanInterval then
            lastAimScan = os.clock()
            aimTarget = nil

            local nearestDistance = aimbotRange

            for _,model in ipairs(workspace:GetDescendants()) do
                if isNPC(model) then
                    local humanoid = model:FindFirstChildOfClass("Humanoid")

                    local targetPart

                    if aimPart == "Head" then
                        targetPart = model:FindFirstChild("Head")
                    else
                        targetPart = model:FindFirstChild("UpperTorso")
                            or model:FindFirstChild("Torso")
                            or model:FindFirstChild("LowerTorso")
                            or model:FindFirstChild("HumanoidRootPart")
                    end

                    if humanoid and humanoid.Health > 0
                    and targetPart and targetPart:IsA("BasePart") then
                        local distance =
                            (root.Position-targetPart.Position).Magnitude

                        if distance < nearestDistance then
                            nearestDistance = distance
                            aimTarget = targetPart
                        end
                    end
                end
            end
        end

        if aimTarget and aimTarget.Parent then
            local targetCFrame = CFrame.lookAt(
                camera.CFrame.Position,
                aimTarget.Position
            )

            -- SLOWER, SMOOTHER CAMERA MOVEMENT
            local speed = aimSmoothness * 25
            local alpha = 1 - math.exp(-speed * deltaTime)

            camera.CFrame = camera.CFrame:Lerp(
                targetCFrame,
                alpha
            )
        else
            aimTarget = nil
        end
    end
)

-- LOGIN

enter.MouseButton1Click:Connect(function()
    if pass.Text == PASSWORD then
        login.Visible = false
        main.Visible = true
        togglePanel.Visible = true
    else
        errorText.Text = "Wrong password"
    end
end)

-- DRAG WINDOW

local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position-dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset+delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
