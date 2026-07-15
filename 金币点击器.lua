local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

WindUI:Localization({
    Enabled = true,
    Prefix = "loc:",
    DefaultLanguage = "en",
    Translations = {
        ["ru"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Пример",
            ["WELCOME"] = "Добро пожаловать в WindUI!",
            ["LIB_DESC"] = "Библиотека для создания красивых интерфейсов",
            ["SETTINGS"] = "Настройки",
            ["APPEARANCE"] = "Внешний вид",
            ["FEATURES"] = "Функционал",
            ["UTILITIES"] = "Инструменты",
            ["UI_ELEMENTS"] = "UI Элементы",
            ["CONFIGURATION"] = "Конфигурация",
            ["SAVE_CONFIG"] = "Сохранить конфигурацию",
            ["LOAD_CONFIG"] = "Загрузить конфигурацию",
            ["THEME_SELECT"] = "Выберите тему",
            ["TRANSPARENCY"] = "Прозрачность окна"
        },
        ["en"] = {
            ["WINDUI_EXAMPLE"] = "WindUI Example",
            ["WELCOME"] = "Welcome to WindUI!",
            ["LIB_DESC"] = "Beautiful UI library for Roblox",
            ["SETTINGS"] = "Settings",
            ["APPEARANCE"] = "Appearance",
            ["FEATURES"] = "Features",
            ["UTILITIES"] = "Utilities",
            ["UI_ELEMENTS"] = "UI Elements",
            ["CONFIGURATION"] = "Configuration",
            ["SAVE_CONFIG"] = "Save Configuration",
            ["LOAD_CONFIG"] = "Load Configuration",
            ["THEME_SELECT"] = "Select Theme",
            ["TRANSPARENCY"] = "Window Transparency"
        }
    }
})

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function gradient(text, startColor, endColor)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, text:sub(i, i))
    end
    return result
end

WindUI:Popup({
    Title = gradient("金币点击器", Color3.fromHex("#FFD700"), Color3.fromHex("#FF6B00")),
    Icon = "coins",
    Content = "欢迎使用培根盒子",
    Buttons = {
        {
            Title = "开始",
            Icon = "arrow-right",
            Variant = "Primary",
            Callback = function() end
        }
    }
})

local Window = WindUI:CreateWindow({
    Title = "金币点击器",
    Icon = "coins",
    Author = "培根盒子",
    Folder = "GoldClicker",
    Size = UDim2.fromOffset(700, 500),
    Theme = "Dark",
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "示例用户",
                Duration = 3
            })
        end
    },
    SideBarWidth = 220,
    ScrollBarEnabled = true
})

local borderAnimation
local animationSpeed = 5

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("EE82EE"))
    }), "palette"},

    ["绿黄渐变"] = {ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("30FF6A")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("a8ff00")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("e7ff2f"))
    }), "waves"},
}

local function createRainbowBorder(window, colorScheme)
    local mainFrame = window.WindowObject
    if not mainFrame then return nil end

    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then existingStroke:Destroy() end

    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end

    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 2
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Parent = mainFrame

    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    local schemeData = COLOR_SCHEMES[colorScheme or "彩虹颜色"]
    glowEffect.Color = schemeData and schemeData[1] or COLOR_SCHEMES["彩虹颜色"][1]
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke

    return rainbowStroke
end

local function startBorderAnimation(window, speed)
    local mainFrame = window.WindowObject
    if not mainFrame then return nil end
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke then return nil end
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then return nil end

    return game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil then return end
        glowEffect.Rotation = (tick() * speed * 10) % 360
    end)
end

local rainbowStroke = createRainbowBorder(Window, "彩虹颜色")
if rainbowStroke then
    borderAnimation = startBorderAnimation(Window, animationSpeed)
end

local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

local backgroundImageLabel = nil
local backgroundInput = nil

local function setBackgroundImage(imageUrl)
    for _, gui in pairs(game.CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            local oldBg = gui:FindFirstChild("CustomBackground")
            if oldBg then oldBg:Destroy() end
            
            local bg = Instance.new("ImageLabel")
            bg.Name = "CustomBackground"
            bg.Image = imageUrl
            bg.Size = UDim2.fromScale(1, 1)
            bg.Position = UDim2.fromOffset(0, 0)
            bg.BackgroundTransparency = 1
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 0
            bg.Parent = gui
            bg:MoveToFront()
            
            backgroundImageLabel = bg
            return true
        end
    end
    return false
end

task.spawn(function()
    task.wait(2)
    local defaultUrl = "https://raw.githubusercontent.com/dream77239/666/refs/heads/main/Image_1771753591613_471_1771755601425edit.jpg"
    setBackgroundImage(defaultUrl)
end)

Window:Tag({
    Title = "v1.0",
    Color = Color3.fromHex("#FFD700")
})
Window:Tag({
    Title = "点击器",
})

Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "主题切换",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventsFolder = ReplicatedStorage:WaitForChild("Events")

local ClickEvent = EventsFolder:WaitForChild("ClickMoney")
local UpgradeEvent = EventsFolder:WaitForChild("Upgrade")
local PrestigeEvent = EventsFolder:WaitForChild("Prestige")

local isNormalClicking = false 
local isViolentClicking = false
local isAutoUpgrading = false
local isAutoPrestige = false

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

CombatTab:Toggle({
    Title = "正常点击",
    Desc = "普通速度 (每帧1次)",
    Callback = function(Value)
        isNormalClicking = Value
    end
})

CombatTab:Toggle({
    Title = "暴力点击",
    Desc = "极快速度 (每帧50次, 可能掉线)",
    Callback = function(Value)
        isViolentClicking = Value
    end
})

CombatTab:Toggle({
    Title = "自动升级",
    Desc = "自动购买升级 1 和 2 (每0.5秒)",
    Callback = function(Value)
        isAutoUpgrading = Value
    end
})

CombatTab:Toggle({
    Title = "自动声誉",
    Desc = "自动进行声誉/重生 (每5秒)",
    Callback = function(Value)
        isAutoPrestige = Value
    end
})

task.spawn(function()
    while true do
        if isNormalClicking then
            ClickEvent:FireServer()
        end
        task.wait() 
    end
end)

task.spawn(function()
    while true do
        if isViolentClicking then
            for i = 1, 50 do 
                ClickEvent:FireServer()
            end
        end
        task.wait() 
    end
end)

task.spawn(function()
    while true do
        if isAutoUpgrading then
            local args1 = {1, true}
            UpgradeEvent:FireServer(unpack(args1))

            local args2 = {2, true}
            UpgradeEvent:FireServer(unpack(args2))
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if isAutoPrestige then
            PrestigeEvent:FireServer()
            task.wait(5)
        else
            task.wait(1)
        end
    end
end)

Window:OnClose(function()
    print("Window closed")
end)

Window:OnDestroy(function()
    print("Window destroyed")
end)

print("✅ 金币点击器已加载完成！")
