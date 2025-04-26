--[[
    Vyn Hub - Aimbot Script
    Features: 
    - Wall Check
    - Team Check
    - Aimbot Toggle
    - Auto Fire Toggle
    - Silent Aim Toggle
    - Body Part Targeting (Head, Chest, Arms, Legs)
    - GUI Minimize Option
]]

--// Aimbot Script with GUI Controls for Wall Check, Team Check, Auto Fire, Silent Aim, Aim Part (Head/Chest/Legs/Arms), and Minimize Button

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = game.Workspace.CurrentCamera
local targetPartName = "Head"  -- Default to aiming at the "Head"

-- Variables for customization
local aimSpeed = 0.1
local aimFOV = 50
local wallCheckEnabled = true -- Wall check is enabled by default
local teamCheckEnabled = true -- Team check is enabled by default
local aimbotEnabled = false   -- Aimbot is off by default
local autoFireEnabled = false -- Auto Fire is off by default
local silentAimEnabled = false -- Silent Aim is off by default

-- Create the main GUI container (square box)
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AimbotGUI"

-- Square GUI Box (light black background)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 400) -- Increased size for extra options
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -200) -- Center on the screen
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Light black color
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Visible = true

-- Title for the GUI
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(0, 250, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "[Vyn Hub]"
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1

-- Minimize Button (Will turn the frame into a circle when clicked)
local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 50, 0, 50)
minimizeButton.Position = UDim2.new(0.5, -25, 0, -25)
minimizeButton.Text = "Minimize"
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Function to minimize the GUI into a small circle
local function minimizeGUI()
    mainFrame.Size = UDim2.new(0, 50, 0, 50)
    mainFrame.Position = UDim2.new(0.5, -25, 0, -25)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Name = "Minimized"

    -- Change to black-and-white divided circle
    local circle = Instance.new("Frame", mainFrame)
    circle.Size = UDim2.new(1, 0, 1, 0)
    circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    circle.BorderSizePixel = 0
    circle.ClipsDescendants = true

    -- Create the white half of the circle
    local whiteHalf = Instance.new("Frame", circle)
    whiteHalf.Size = UDim2.new(0.5, 0, 1, 0)
    whiteHalf.Position = UDim2.new(0.5, 0, 0, 0)
    whiteHalf.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    whiteHalf.BorderSizePixel = 0
end

minimizeButton.MouseButton1Click:Connect(minimizeGUI)

-- Function to restore the GUI to its original size
local function restoreGUI()
    if mainFrame.Name == "Minimized" then
        mainFrame.Size = UDim2.new(0, 250, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
        mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Light black color
        mainFrame.BorderSizePixel = 2
        mainFrame.Name = "AimbotGUI"
    end
end

-- Function to create a button with color change on toggle
local function createToggleButton(name, position, callback)
    local button = Instance.new("TextButton", mainFrame)
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Position = position
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Gray by default
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18

    button.MouseButton1Click:Connect(function()
        callback()
        if button.BackgroundColor3 == Color3.fromRGB(150, 150, 150) then
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Turn white when enabled
        else
            button.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Turn gray when disabled
        end
    end)

    return button
end

-- Toggle Wall Check
createToggleButton("Toggle Wall Check", UDim2.new(0.5, -100, 0, 60), function()
    wallCheckEnabled = not wallCheckEnabled
    print("Wall Check: " .. (wallCheckEnabled and "Enabled" or "Disabled"))
end)

-- Toggle Team Check
createToggleButton("Toggle Team Check", UDim2.new(0.5, -100, 0, 110), function()
    teamCheckEnabled = not teamCheckEnabled
    print("Team Check: " .. (teamCheckEnabled and "Enabled" or "Disabled"))
end)

-- Toggle Aimbot
createToggleButton("Toggle Aimbot", UDim2.new(0.5, -100, 0, 160), function()
    aimbotEnabled = not aimbotEnabled
    print("Aimbot: " .. (aimbotEnabled and "Enabled" or "Disabled"))
end)

-- Toggle Auto Fire
createToggleButton("Toggle Auto Fire", UDim2.new(0.5, -100, 0, 210), function()
    autoFireEnabled = not autoFireEnabled
    print("Auto Fire: " .. (autoFireEnabled and "Enabled" or "Disabled"))
end)

-- Toggle Silent Aim
createToggleButton("Toggle Silent Aim", UDim2.new(0.5, -100, 0, 260), function()
    silentAimEnabled = not silentAimEnabled
    print("Silent Aim: " .. (silentAimEnabled and "Enabled" or "Disabled"))
end)

-- Create button for selecting Aim Target (Head/Chest/Legs/Arms)
local function createAimPartButton(name, position)
    local button = Instance.new("TextButton", mainFrame)
    button.Size = UDim2.new(0, 200, 0, 40)
    button.Position = position
    button.Text = "Aim at " .. name
    button.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Gray by default
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18

    button.MouseButton1Click:Connect(function()
        targetPartName = name
        print("Aiming at: " .. name)
        if button.BackgroundColor3 == Color3.fromRGB(150, 150, 150) then
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Turn white when selected
        else
            button.BackgroundColor3 = Color3.fromRGB(150, 150, 150) -- Turn gray when unselected
        end
    end)
    
    return button
end

-- Add buttons for different body parts
createAimPartButton("Head", UDim2.new(0.5, -100, 0, 310))
createAimPartButton("Chest", UDim2.new(0.5, -100, 0, 360))
createAimPartButton("Legs", UDim2.new(0.5, -100, 0, 410))
createAimPartButton("Arms", UDim2.new(0.5, -100, 0, 460))

-- Aimbot Functionality
local function getClosestTarget()
    local closestTarget = nil
    local shortestDistance = aimFOV

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild(targetPartName) then
            if teamCheckEnabled and v.Team == player.Team then
                continue
            end

            local targetPart = v.Character[targetPartName]
            local distance = (camera.CFrame.Position - targetPart.Position).Magnitude

            -- Wall check (raycast)
            if wallCheckEnabled then
                local ray = workspace:Raycast(camera.CFrame.Position, targetPart.Position - camera.CFrame.Position)
                if ray and ray.Instance then
                    continue
                end
            end

            if distance < shortestDistance then
                shortestDistance = distance
                closestTarget = targetPart
            end
        end
    end

    return closestTarget
end