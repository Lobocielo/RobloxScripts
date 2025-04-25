-- Cargar UI de Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("ZENIHT MultiHack", "DarkTheme")

-- Tabs
local MainTab = Window:NewTab("Main")
local CombatTab = Window:NewTab("Combat")
local VisualsTab = Window:NewTab("Visuals")

-- Secciones
local MainSection = MainTab:NewSection("Player Cheats")
local CombatSection = CombatTab:NewSection("Combat")
local VisualSection = VisualsTab:NewSection("ESP")

-- 📌 Fly
MainSection:NewToggle("Fly (E)", "Presiona E para volar", function(state)
    local flying = state
    local plr = game.Players.LocalPlayer
    local mouse = plr:GetMouse()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local UIS = game:GetService("UserInputService")
    local flySpeed = 50
    local flyingConn = nil

    if flying then
        flyingConn = game:GetService("RunService").RenderStepped:Connect(function()
            if UIS:IsKeyDown(Enum.KeyCode.E) then
                humanoidRootPart.Velocity = plr:GetMouse().Hit.LookVector * flySpeed
            end
        end)
    else
        if flyingConn then flyingConn:Disconnect() end
    end
end)

-- 📌 NoClip
MainSection:NewToggle("NoClip (Hold N)", "Atravesar paredes", function(state)
    local noclip = state
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local RunService = game:GetService("RunService")

    RunService.Stepped:Connect(function()
        if noclip and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.N) then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end)
end)

-- 📌 ESP
VisualSection:NewToggle("ESP Boxes", "Muestra cajas en los jugadores", function(state)
    if state then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = player.Character
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.Parent = player.Character
                highlight.Name = "ZENIHT_ESP"
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character:FindFirstChild("ZENIHT_ESP") then
                player.Character:FindFirstChild("ZENIHT_ESP"):Destroy()
            end
        end
    end
end)

-- 🎯 Aimbot Avanzado (Clic derecho)
CombatSection:NewToggle("Aimbot (Hold Right Click)", "Auto apunta al jugador más cercano", function(state)
    getgenv().AimbotActive = state
end)

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    if getgenv().AimbotActive and game:GetService("UserInputService"):IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local plr = game.Players.LocalPlayer
        local cam = workspace.CurrentCamera
        local closest = nil
        local closestDist = math.huge

        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head.Position
                local dist = (head - cam.CFrame.Position).magnitude
                if dist < closestDist then
                    closest = player
                    closestDist = dist
                end
            end
        end

        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Character.Head.Position)
        end
    end
end)

-- Notificación de carga
game.StarterGui:SetCore("SendNotification", {
	Title = "ZENIHT HACK v1",
	Text = "Script cargado correctamente",
	Duration = 5
})
