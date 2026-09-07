--==================================================
-- SUESA FPS BOOSTER
-- Otimizado para dispositivos Android de baixo desempenho
-- Target: 40 FPS | FOV: Original
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local TARGET_FPS = 40

local Config = {
    NETWORK_OPTIMIZATION = true,
    REDUCE_REPLICATION = true,
    THROTTLE_REMOTE_EVENTS = true,
    OPTIMIZE_CHAT = true,
    DISABLE_UNNECESSARY_GUI = false,
    STREAMING_ENABLED = true,
    REDUCE_PLAYER_REPLICATION_DISTANCE = 100,
    THROTTLE_SOUNDS = true,
    DESTROY_EMITTERS = true,
    REMOVE_GRASS = true,
    CORE = true,
    FPS_MONITOR = false,
    OPTIZ = true,
    OPTIMIZATION_INTERVAL = 10,
    SHOW_UPDATELOG = false,
    MIN_INTERVAL = 3,
    MAX_DISTANCE = 50,
    PERFORMANCE_MONITORING = true,
    FPS_THRESHOLD = 40,
    GRAY_SKY_ENABLED = true,
    GRAY_SKY_ID = "rbxassetid://114666145996289",
    FULL_BRIGHT_ENABLED = false,
    SMOOTH_PLASTIC_ENABLED = true,
    OPTIMIZE_PHYSICS = true,
    DISABLE_CONSTRAINTS = false,
    THROTTLE_PARTICLES = true,
    THROTTLE_TEXTURES = true,
    REMOVE_ANIMATIONS = false,
    LOW_POLY_CONVERSION = true,
    SELECTIVE_TEXTURE_REMOVAL = true,
    PRESERVE_IMPORTANT_TEXTURES = false,
    IMPORTANT_TEXTURE_KEYWORDS = {"sign","ui","hud","menu","button","fence"},
    QUALITY_LEVEL = 1,
    FPS_CAP = TARGET_FPS,
    MEMORY_CLEANUP_THRESHOLD = 500
}

pcall(function()
    if typeof(setfpscap) == "function" then setfpscap(TARGET_FPS) end
end)

pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

pcall(function()
    local Optiz = loadstring(game:HttpGet(
        "https://raw.githubusercontent.com/hm5650/Optiz/refs/heads/main/Optiz.lua"
    ))
    if Optiz then Optiz()(Config) end
end)

local function GraySky()
    pcall(function()
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                v:Destroy()
            elseif v:IsA("PostEffect") then
                v.Enabled = false
            end
        end

        local Sky = Instance.new("Sky")
        Sky.SkyboxBk = Config.GRAY_SKY_ID
        Sky.SkyboxDn = Config.GRAY_SKY_ID
        Sky.SkyboxFt = Config.GRAY_SKY_ID
        Sky.SkyboxLf = Config.GRAY_SKY_ID
        Sky.SkyboxRt = Config.GRAY_SKY_ID
        Sky.SkyboxUp = Config.GRAY_SKY_ID
        Sky.SunAngularSize = 0
        Sky.MoonAngularSize = 0
        Sky.StarCount = 0
        Sky.Parent = Lighting

        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogEnd = 1000000
        Lighting.FogColor = Color3.fromRGB(150,150,150)
    end)
end

GraySky()

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    pcall(function() Terrain.Decoration = false end)
    pcall(function()
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end)
end

local function Optimize(Object)
    pcall(function()
        if Object:IsA("ParticleEmitter") or Object:IsA("Trail")
        or Object:IsA("Beam") or Object:IsA("Smoke")
        or Object:IsA("Fire") or Object:IsA("Sparkles") then
            Object.Enabled = false
            return
        end

        if Object:IsA("PointLight") or Object:IsA("SpotLight")
        or Object:IsA("SurfaceLight") then
            Object.Enabled = false
            return
        end

        if Object:IsA("Decal") or Object:IsA("Texture") then
            Object.Transparency = 1
            return
        end

        if Object:IsA("SurfaceAppearance") then
            Object:Destroy()
            return
        end

        if Object:IsA("MeshPart") then
            Object.Material = Enum.Material.SmoothPlastic
            Object.CastShadow = false
            Object.Reflectance = 0
            pcall(function() Object.TextureID = "" end)
            return
        end

        if Object:IsA("BasePart") then
            Object.Material = Enum.Material.SmoothPlastic
            Object.CastShadow = false
            Object.Reflectance = 0
        end
    end)
end

for _,Object in ipairs(Workspace:GetDescendants()) do
    Optimize(Object)
end

Workspace.DescendantAdded:Connect(function(Object)
    task.defer(function() Optimize(Object) end)
end)

local PlayerGui = Player:WaitForChild("PlayerGui")
local Old = PlayerGui:FindFirstChild("FPS_BOOSTER")
if Old then Old:Destroy() end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FPS_BOOSTER"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

local Label = Instance.new("TextLabel")
Label.Name = "FPS"
Label.AnchorPoint = Vector2.new(1,0)
Label.Position = UDim2.new(1,-10,0,8)
Label.Size = UDim2.new(0,130,0,42)
Label.BackgroundTransparency = 1
Label.Text = "FPS: --"
Label.TextSize = 25
Label.Font = Enum.Font.GothamBold
Label.TextColor3 = Color3.new(1,1,1)
Label.TextStrokeTransparency = 0.15
Label.TextXAlignment = Enum.TextXAlignment.Right
Label.Parent = Gui

local Frames = 0
local LastTime = os.clock()

RunService.RenderStepped:Connect(function()
    Frames += 1
    local Now = os.clock()
    if Now - LastTime >= 0.5 then
        local CurrentFPS = math.floor(Frames / (Now - LastTime) + 0.5)
        Label.Text = "FPS: " .. CurrentFPS
        Frames = 0
        LastTime = Now
    end
end)

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            if typeof(setfpscap) == "function" then setfpscap(TARGET_FPS) end
        end)
    end
end)

print("OPTIZ + FPS BOOSTER | TARGET: 40 FPS | GRAY SKY: ON | TEXTURES: OFF | SHADOWS: OFF | FOV: ORIGINAL")
