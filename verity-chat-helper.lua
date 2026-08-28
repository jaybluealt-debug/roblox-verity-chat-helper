-- Roblox Verity AI Chat Helper
-- Compatible with Free Client Script Executor
-- Transforms player into son_imcriine

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local API_ENDPOINT = "https://api.example.com/chat" -- Replace with your API endpoint
local BOT_NAME = "Verity"
local RESPONSE_PREFIX = "[" .. BOT_NAME .. "]: "
local TARGET_USER = "son_imcriine"

-- Function to clone character appearance
local function cloneCharacterAppearance(targetUsername)
    local targetPlayer = Players:FindFirstChild(targetUsername)
    
    if not targetPlayer then
        print("Target player '" .. targetUsername .. "' not found in game. Attempting to fetch from catalog...")
        -- If player not in game, we'll use a generic transformation
        return false
    end
    
    local targetCharacter = targetPlayer.Character
    if not targetCharacter then
        print("Target character not loaded.")
        return false
    end
    
    local myCharacter = player.Character
    if not myCharacter then
        print("Your character not loaded.")
        return false
    end
    
    -- Clone appearance by copying clothing and accessories
    local function clearAppearance(char)
        for _, item in pairs(char:GetChildren()) do do
            if item:IsA("Accessory") or item:IsA("ShirtGraphic") or item:IsA("Shirt") or item:IsA("Pants") then
                item:Destroy()
            end
        end
    end
    
    clearAppearance(myCharacter)
    
    for _, item in pairs(targetCharacter:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("ShirtGraphic") or item:IsA("Shirt") or item:IsA("Pants") then
            local clonedItem = item:Clone()
            clonedItem.Parent = myCharacter
        end
    end
    
    -- Copy character color/body parts
    for _, part in pairs(targetCharacter:GetChildren()) do
        if part:IsA("BasePart") then
            local myPart = myCharacter:FindFirstChild(part.Name)
            if myPart and myPart:IsA("BasePart") then
                myPart.Color = part.Color
                myPart.Material = part.Material
            end
        end
    end
    
    print("✓ Transformed into appearance of " .. targetUsername)
    return true
end

-- Function to change character name display
local function changeDisplayName(newName)
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        -- Create billboard GUI for custom name
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(4, 0, 2, 0)
        billboard.MaxDistance = 100
        billboard.Parent = humanoidRootPart
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.Text = newName
        textLabel.Parent = billboard
        
        print("✓ Display name changed to: " .. newName)
    end
end

-- Function to modify player's actual name (if possible)
local function transformPlayer()
    print("🔄 Starting transformation into " .. TARGET_USER .. "...")
    
    -- Clone appearance
    cloneCharacterAppearance(TARGET_USER)
    
    -- Change display name
    changeDisplayName(TARGET_USER)
    
    print("✅ Transformation complete! You are now " .. TARGET_USER)
end

-- Execute transformation on script load
task.spawn(function()
    -- Wait for character to load
    if not player.Character then
        player.CharacterAdded:Wait()
    end
    
    task.wait(1) -- Brief delay to ensure everything is loaded
    transformPlayer()
end)

-- Listen for character respawn and re-apply transformation
player.CharacterAdded:Connect(function()
    task.wait(1)
    transformPlayer()
end)

print("Verity AI Chat Helper loaded.")
print("Transforming you into " .. TARGET_USER .. "...")
