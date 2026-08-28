-- Roblox Verity Chat Helper - Client (FE) Script
-- This script handles the client-side UI and communication with the server

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- Configuration
local CHAT_KEY = Enum.KeyCode.Slash -- Press "/" to open chat
local MAX_MESSAGE_LENGTH = 500
local UI_THEME = {
	BackgroundColor = Color3.fromRGB(20, 20, 20),
	TextColor = Color3.fromRGB(255, 255, 255),
	AccentColor = Color3.fromRGB(0, 150, 255),
	ErrorColor = Color3.fromRGB(255, 50, 50)
}

-- Create Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VerityChatHelper"
screenGui.ResetOnSpawn = false
screenGui.ZIndex = 100
screenGui.Parent = playerGui

-- Chat Container
local chatContainer = Instance.new("Frame")
chatContainer.Name = "ChatContainer"
chatContainer.Size = UDim2.new(0, 400, 0, 500)
chatContainer.Position = UDim2.new(0.5, -200, 1, -520)
chatContainer.BackgroundColor3 = UI_THEME.BackgroundColor
chatContainer.BorderSizePixel = 0
chatContainer.Visible = false
chatContainer.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = chatContainer

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = UI_THEME.AccentColor
titleBar.BorderSizePixel = 0
titleBar.Parent = chatContainer

local titleText = Instance.new("TextLabel")
titleText.Name = "Title"
titleText.Size = UDim2.new(1, -40, 1, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = UI_THEME.TextColor
titleText.TextSize = 16
titleText.Font = Enum.Font.GothamBold
titleText.Text = "Verity Chat Helper"
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = titleText

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = UI_THEME.TextColor
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
	chatContainer.Visible = false
end)

-- Messages Display Area
local messagesFrame = Instance.new("ScrollingFrame")
messagesFrame.Name = "MessagesFrame"
messagesFrame.Size = UDim2.new(1, -10, 1, -100)
messagesFrame.Position = UDim2.new(0, 5, 0, 45)
messagesFrame.BackgroundColor3 = UI_THEME.BackgroundColor
messagesFrame.BorderSizePixel = 0
messagesFrame.ScrollBarThickness = 6
messagesFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
messagesFrame.Parent = chatContainer

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = messagesFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingLeft = UDim.new(0, 8)
listPadding.PaddingRight = UDim.new(0, 8)
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.Parent = messagesFrame

-- Input Area
local inputContainer = Instance.new("Frame")
inputContainer.Name = "InputContainer"
inputContainer.Size = UDim2.new(1, 0, 0, 45)
inputContainer.Position = UDim2.new(0, 0, 1, -45)
inputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputContainer.BorderSizePixel = 0
inputContainer.Parent = chatContainer

-- Input TextBox
local inputTextBox = Instance.new("TextBox")
inputTextBox.Name = "InputTextBox"
inputTextBox.Size = UDim2.new(1, -50, 1, -8)
inputTextBox.Position = UDim2.new(0, 5, 0, 4)
inputTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputTextBox.TextColor3 = UI_THEME.TextColor
inputTextBox.TextSize = 14
inputTextBox.Font = Enum.Font.Gotham
inputTextBox.PlaceholderText = "Ask Verity..."
inputTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputTextBox.BorderSizePixel = 1
inputTextBox.BorderColor3 = UI_THEME.AccentColor
inputTextBox.TextWrapped = true
inputTextBox.Parent = inputContainer

-- Send Button
local sendButton = Instance.new("TextButton")
sendButton.Name = "SendButton"
sendButton.Size = UDim2.new(0, 40, 1, -8)
sendButton.Position = UDim2.new(1, -45, 0, 4)
sendButton.BackgroundColor3 = UI_THEME.AccentColor
sendButton.TextColor3 = UI_THEME.TextColor
sendButton.TextSize = 16
sendButton.Font = Enum.Font.GothamBold
sendButton.Text = "→"
sendButton.Parent = inputContainer

-- Function to add message to chat
local function addMessage(text, isBot)
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -16, 0, 0)
	messageLabel.BackgroundColor3 = isBot and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(0, 100, 200)
	messageLabel.TextColor3 = UI_THEME.TextColor
	messageLabel.TextSize = 13
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.Text = text
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.Parent = messagesFrame
	
	local msgPadding = Instance.new("UIPadding")
	msgPadding.PaddingLeft = UDim.new(0, 8)
	msgPadding.PaddingRight = UDim.new(0, 8)
	msgPadding.PaddingTop = UDim.new(0, 6)
	msgPadding.PaddingBottom = UDim.new(0, 6)
	msgPadding.Parent = messageLabel
	
	-- Auto-size the label
	local textSize = game:GetService("TextService"):GetTextSize(
		text,
		13,
		Enum.Font.Gotham,
		Vector2.new(messagesFrame.AbsoluteSize.X - 32, math.huge)
	)
	messageLabel.Size = UDim2.new(1, -16, 0, textSize.Y + 12)
	
	-- Add corner radius
	local msgCorner = Instance.new("UICorner")
	msgCorner.CornerRadius = UDim.new(0, 6)
	msgCorner.Parent = messageLabel
	
	-- Scroll to bottom
	messagesFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
	messagesFrame.CanvasPosition = Vector2.new(0, listLayout.AbsoluteContentSize.Y + 16)
end

-- Function to send message
local function sendMessage()
	local message = inputTextBox.Text:match("^%s*(.-)%s*$") -- Trim whitespace
	
	if message == "" or #message == 0 then
		return
	end
	
	if #message > MAX_MESSAGE_LENGTH then
		addMessage("Message too long! Max " .. MAX_MESSAGE_LENGTH .. " characters.", true)
		return
	end
	
	-- Add user message to chat
	addMessage(message, false)
	inputTextBox.Text = ""
	
	-- Send to server (implement your server communication here)
	-- For now, add a placeholder response
	task.wait(0.5)
	addMessage("Thanks for your question! I'm processing that...", true)
end

-- Connect button events
sendButton.MouseButton1Click:Connect(sendMessage)
inputTextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		sendMessage()
	end
end)

-- Toggle chat with "/" key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == CHAT_KEY then
		chatContainer.Visible = not chatContainer.Visible
		if chatContainer.Visible then
			inputTextBox:CaptureFocus()
		end
	end
end)

-- Prevent "/" from appearing in chat if used to toggle
inputTextBox.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == CHAT_KEY then
		inputTextBox.Text = ""
	end
end)

print("✓ Verity Chat Helper loaded successfully!")
