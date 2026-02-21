--// PERC'S BRUTAL ANTI-LAG: HEADLESS CLIENT MODE
--// One-way, no toggle, use only on alts / farm clients.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer

--// 1. Kill 3D rendering entirely
pcall(function()
    RunService:Set3dRenderingEnabled(false)
end)

--// 2. Lowest possible quality
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

--// 3. Kill all sounds
pcall(function()
    SoundService.Volume = 0
    for _, s in ipairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then
            s.Volume = 0
            s.Playing = false
        end
    end
end)

--// 4. Destroy visual junk: particles, lights, decals, textures, trails, beams
local function brutalStripVisuals(root)
    for _, v in ipairs(root:GetDescendants()) do
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam")
        or v:IsA("Fire")
        or v:IsA("Smoke")
        or v:IsA("Sparkles")
        or v:IsA("PointLight")
        or v:IsA("SpotLight")
        or v:IsA("SurfaceLight")
        or v:IsA("Decal")
        or v:IsA("Texture")
        then
            v:Destroy()
        end
    end
end

brutalStripVisuals(workspace)
brutalStripVisuals(Lighting)

--// 5. Nuke post-processing effects
pcall(function()
    for _, eff in ipairs(Lighting:GetChildren()) do
        if eff:IsA("BlurEffect")
        or eff:IsA("BloomEffect")
        or eff:IsA("ColorCorrectionEffect")
        or eff:IsA("SunRaysEffect")
        or eff:IsA("DepthOfFieldEffect")
        then
            eff.Enabled = false
        end
    end
end)

--// 6. Hide all UI (except core system stuff)
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

pcall(function()
    for _, gui in ipairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.Enabled = false
        end
    end
end)


--// 8. Optional: cap FPS super low (executor-dependent)
pcall(function()
    if setfpscap then
        setfpscap(25) -- go lower if you want even less CPU
    end
end)

--// 9. Periodic cleanup of new junk that appears later
task.spawn(function()
    while true do
        task.wait(5)
        brutalStripVisuals(workspace)
    end
end)
