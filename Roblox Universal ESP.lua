-- Create GUI elements
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_ToggleGui"
screenGui.Parent = playerGui

-- Create Draggable Frame with rounded corners
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 270) -- Adjusted height
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Create UI Corner for Rounded Edges
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- Create Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Universal ESP By Deccatron"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.Parent = mainFrame

-- Create Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 270, 0, 50)
toggleButton.Position = UDim2.new(0, 15, 0, 50)
toggleButton.Text = "Enable ESP"
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.Gotham
toggleButton.TextSize = 18
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

-- Add UI Corner to the Toggle Button
local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 8)
toggleButtonCorner.Parent = toggleButton

-- Create Color Cycle Button
local colorCycleButton = Instance.new("TextButton")
colorCycleButton.Size = UDim2.new(0, 270, 0, 50)
colorCycleButton.Position = UDim2.new(0, 15, 0, 110)
colorCycleButton.Text = "Cycle Colors"
colorCycleButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
colorCycleButton.TextColor3 = Color3.new(1, 1, 1)
colorCycleButton.Font = Enum.Font.Gotham
colorCycleButton.TextSize = 18
colorCycleButton.BorderSizePixel = 0
colorCycleButton.Parent = mainFrame

-- Add UI Corner to Color Cycle Button
local colorButtonCorner = Instance.new("UICorner")
colorButtonCorner.CornerRadius = UDim.new(0, 8)
colorButtonCorner.Parent = colorCycleButton

-- Create Rainbow Button (Default text "Gaybow")
local rainbowButton = Instance.new("TextButton")
rainbowButton.Size = UDim2.new(0, 270, 0, 50)
rainbowButton.Position = UDim2.new(0, 15, 0, 170)
rainbowButton.Text = "Gaybow" -- Default text set to "Gaybow"
rainbowButton.BackgroundColor3 = Color3.fromRGB(0, 128, 255)
rainbowButton.TextColor3 = Color3.new(1, 1, 1)
rainbowButton.Font = Enum.Font.Gotham
rainbowButton.TextSize = 18
rainbowButton.BorderSizePixel = 0
rainbowButton.Parent = mainFrame

-- Add UI Corner to Rainbow Button
local rainbowButtonCorner = Instance.new("UICorner")
rainbowButtonCorner.CornerRadius = UDim.new(0, 8)
rainbowButtonCorner.Parent = rainbowButton

-- Variables to control ESP
local espEnabled = false
local highlightedPlayers = {}
local boxColor = Color3.new(1, 0, 0) -- Default red
local highlightColor = Color3.new(1, 1, 0) -- Default yellow
local rainbowMode = false
local colorCycleIndex = 1
local colorCycleColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(128, 0, 128)    -- Purple
}
local fadeSpeed = 0.5 -- Speed of the color fade effect

-- Function to apply the highlight to a player's character
local function applyHighlightToPlayer(player)
    local function highlightCharacter(character)
        -- Remove existing highlight if present
        local existingHighlight = character:FindFirstChild("Highlight")
        if existingHighlight then
            existingHighlight:Destroy()
        end
        
        -- Create new highlight
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = highlightColor  -- Highlight color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = boxColor  -- Box color
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        highlightedPlayers[player] = highlight
        print("Highlight applied to " .. player.Name)
    end

    -- Apply the highlight to the character if it already exists
    if player.Character then
        highlightCharacter(player.Character)
    end

    -- Apply the highlight whenever the character respawns
    player.CharacterAdded:Connect(highlightCharacter)
end

-- Function to remove the highlight from a player's character
local function removeHighlightFromPlayer(player)
    if highlightedPlayers[player] then
        highlightedPlayers[player]:Destroy()
        highlightedPlayers[player] = nil
        print("Highlight removed from " .. player.Name)
    end
end

-- Function to toggle ESP on/off
local function toggleESP()
    espEnabled = not espEnabled

    if espEnabled then
        toggleButton.Text = "Disable ESP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(85, 0, 130) -- Active state color
        -- Apply highlights to all players
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            applyHighlightToPlayer(player)
        end
    else
        toggleButton.Text = "Enable ESP"
        toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Inactive state color
        -- Remove highlights from all players
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            removeHighlightFromPlayer(player)
        end
    end
end

-- Connect the button to toggle ESP on click
toggleButton.MouseButton1Click:Connect(toggleESP)

-- Handle players joining and leaving the game
game:GetService("Players").PlayerAdded:Connect(function(player)
    if espEnabled then
        applyHighlightToPlayer(player)
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if espEnabled then
        removeHighlightFromPlayer(player)
    end
end)

-- Cycle colors
local function cycleColors()
    colorCycleIndex = (colorCycleIndex % #colorCycleColors) + 1
    local newColor = colorCycleColors[colorCycleIndex]
    boxColor = newColor
    highlightColor = newColor
    
    if espEnabled then
        for _, highlight in pairs(highlightedPlayers) do
            highlight.FillColor = highlightColor
            highlight.OutlineColor = boxColor
        end
    end
end

colorCycleButton.MouseButton1Click:Connect(cycleColors)

-- Rainbow effect
local function startRainbowEffect()
    while rainbowMode do
        for hue = 0, 1, 0.01 do
            local color = Color3.fromHSV(hue, 1, 1)
            if espEnabled then
                for _, highlight in pairs(highlightedPlayers) do
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                end
            end
            wait(fadeSpeed)
        end
    end
end

rainbowButton.MouseButton1Click:Connect(function()
    rainbowMode = not rainbowMode
    rainbowButton.Text = rainbowMode and "Stop Gaybow" or "Gaybow"
    if rainbowMode then
        startRainbowEffect()
    else
        for _, highlight in pairs(highlightedPlayers) do
            highlight.FillColor = highlightColor
            highlight.OutlineColor = boxColor
        end
    end
end)
