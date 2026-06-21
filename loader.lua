-- Cresent System Engine (Clean & Optimized UI Framework)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

if CoreGui:FindFirstChild("CresentGUI") then
    CoreGui.CresentGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CresentGUI"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

local VERSION = "v4.3.0"
local ScriptDatabase = {
    {Name = "Demonology", Tag = "LATEST", Desc = "A Script Where Its For The Game Called "Demonology.", Loadstring = "loadstring(game:HttpGet('https://raw.githubusercontent.com/AeriqHelp/scripts/refs/heads/main/demonology.lua'))()"},
}

local TagStyles = {
    LATEST = {Color = Color3.fromRGB(46, 204, 113), Text = "LATEST"},
    UPDATED = {Color = Color3.fromRGB(52, 152, 219), Text = "UPDATED"},
    OLD = {Color = Color3.fromRGB(241, 196, 15), Text = "OLD"},
    PATCHED = {Color = Color3.fromRGB(231, 76, 60), Text = "PATCHED"},
    DISCONTINUED = {Color = Color3.fromRGB(149, 165, 166), Text = "DISCONTINUED"}
}

local SelectedScript = nil

-- ==========================================
-- 1. Main UI Window Framework
-- ==========================================
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 1.65
UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize
UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
UIAspectRatioConstraint.Parent = MainFrame

local UISizeConstraint = Instance.new("UISizeConstraint")
UISizeConstraint.MaxSize = Vector2.new(700, 424)
UISizeConstraint.MinSize = Vector2.new(500, 303)
UISizeConstraint.Parent = MainFrame

local function scaleToViewport()
    local size = Workspace.CurrentCamera.ViewportSize
    if size.X < 600 then
        MainFrame.Size = UDim2.new(0.92, 0, 0.92, 0)
    else
        MainFrame.Size = UDim2.new(0.62, 0, 0.62, 0)
    end
end
scaleToViewport()
Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(scaleToViewport)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(28, 28, 38)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- ==========================================
-- 2. Compact Sidebar Toggle Button
-- ==========================================
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 75, 0, 34)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
ToggleButton.Text = "CRESENT"
ToggleButton.TextColor3 = Color3.fromRGB(240, 240, 250)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 11
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(36, 36, 48)
ToggleStroke.Parent = ToggleButton

-- ==========================================
-- 3. Modern Header Module
-- ==========================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 48)
Header.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderLine = Instance.new("Frame")
HeaderLine.Size = UDim2.new(1, 0, 0, 1)
HeaderLine.Position = UDim2.new(0, 0, 1, -1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.4, 0, 1, 0)
Title.Position = UDim2.new(0, 16)
Title.Text = "CRESENT INTERACTIVE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = Header

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0.2, 0, 1, 0)
VersionLabel.Position = UDim2.new(0, 185, 0, 0)
VersionLabel.Text = VERSION
VersionLabel.TextColor3 = Color3.fromRGB(90, 90, 115)
VersionLabel.Font = Enum.Font.Code
VersionLabel.TextSize = 10
VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
VersionLabel.BackgroundTransparency = 1
VersionLabel.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Position = UDim2.new(1, -38, 0.5, -13)
CloseButton.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(150, 150, 165)
CloseButton.Font = Enum.Font.Gotham
CloseButton.TextSize = 22
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- ==========================================
-- 4. Left Panel Module (Search & Adaptive Scroll)
-- ==========================================
local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0.44, 0, 1, -48)
LeftPanel.Position = UDim2.new(0, 0, 0, 48)
LeftPanel.BackgroundTransparency = 1
LeftPanel.Parent = MainFrame

local PanelDivider = Instance.new("Frame")
PanelDivider.Size = UDim2.new(0, 1, 1, 0)
PanelDivider.Position = UDim2.new(1, -1, 0, 0)
PanelDivider.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
PanelDivider.BorderSizePixel = 0
PanelDivider.Parent = LeftPanel

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -24, 0, 32)
SearchFrame.Position = UDim2.new(0, 12, 0, 14)
SearchFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 12)
SearchFrame.Parent = LeftPanel

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 1, 0)
SearchBox.Position = UDim2.new(0, 8, 0, 0)
SearchBox.PlaceholderText = "Search module matrix..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(75, 75, 90)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(245, 245, 245)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 12
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.BackgroundTransparency = 1
SearchBox.Parent = SearchFrame

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -12, 1, -64)
ScrollFrame.Position = UDim2.new(0, 12, 0, 54)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 55)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = LeftPanel

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

-- ==========================================
-- 5. Right Panel Module (Details & Preview)
-- ==========================================
local RightPanel = Instance.new("Frame")
RightPanel.Name = "RightPanel"
RightPanel.Size = UDim2.new(0.56, -1, 1, -48)
RightPanel.Position = UDim2.new(0.44, 1, 0, 48)
RightPanel.BackgroundTransparency = 1
RightPanel.Parent = MainFrame

local WelcomeView = Instance.new("Frame")
WelcomeView.Size = UDim2.new(1, 0, 1, 0)
WelcomeView.BackgroundTransparency = 1
WelcomeView.Parent = RightPanel

local WelcomeLabel = Instance.new("TextLabel")
WelcomeLabel.Size = UDim2.new(1, -40, 1, 0)
WelcomeLabel.Position = UDim2.new(0, 20, 0, 0)
WelcomeLabel.Text = "Select a module to begin."
WelcomeLabel.TextColor3 = Color3.fromRGB(85, 85, 105)
WelcomeLabel.Font = Enum.Font.Code
WelcomeLabel.TextSize = 11
WelcomeLabel.TextWrapped = true
WelcomeLabel.BackgroundTransparency = 1
WelcomeLabel.Parent = WelcomeView

local DetailsView = Instance.new("Frame")
DetailsView.Size = UDim2.new(1, 0, 1, 0)
DetailsView.BackgroundTransparency = 1
DetailsView.Visible = false
DetailsView.Parent = RightPanel

local MetaName = Instance.new("TextLabel")
MetaName.Size = UDim2.new(1, -32, 0, 24)
MetaName.Position = UDim2.new(0, 16, 0, 14)
MetaName.Text = "System Module"
MetaName.TextColor3 = Color3.fromRGB(255, 255, 255)
MetaName.Font = Enum.Font.GothamBold
MetaName.TextSize = 15
MetaName.TextXAlignment = Enum.TextXAlignment.Left
MetaName.BackgroundTransparency = 1
MetaName.Parent = DetailsView

local MetaTag = Instance.new("TextLabel")
MetaTag.Size = UDim2.new(0, 85, 0, 18)
MetaTag.Position = UDim2.new(0, 16, 0, 42)
MetaTag.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MetaTag.Text = "STATUS"
MetaTag.TextColor3 = Color3.fromRGB(255, 255, 255)
MetaTag.Font = Enum.Font.GothamBold
MetaTag.TextSize = 9
MetaTag.Parent = DetailsView

local MetaTagCorner = Instance.new("UICorner")
MetaTagCorner.CornerRadius = UDim.new(0, 4)
MetaTagCorner.Parent = MetaTag

local MetaDesc = Instance.new("TextLabel")
MetaDesc.Size = UDim2.new(1, -32, 0, 42)
MetaDesc.Position = UDim2.new(0, 16, 0, 68)
MetaDesc.Text = ""
MetaDesc.TextColor3 = Color3.fromRGB(145, 145, 160)
MetaDesc.Font = Enum.Font.Gotham
MetaDesc.TextSize = 12
MetaDesc.TextWrapped = true
MetaDesc.TextXAlignment = Enum.TextXAlignment.Left
MetaDesc.TextYAlignment = Enum.TextYAlignment.Top
MetaDesc.BackgroundTransparency = 1
MetaDesc.Parent = DetailsView

local CodeBoxFrame = Instance.new("Frame")
CodeBoxFrame.Size = UDim2.new(1, -32, 0.32, -4)
CodeBoxFrame.Position = UDim2.new(0, 16, 0, 114)
CodeBoxFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
CodeBoxFrame.Parent = DetailsView

local CodeBoxStroke = Instance.new("UIStroke")
CodeBoxStroke.Color = Color3.fromRGB(22, 22, 30)
CodeBoxStroke.Parent = CodeBoxFrame

local CodeBoxCorner = Instance.new("UICorner")
CodeBoxCorner.CornerRadius = UDim.new(0, 5)
CodeBoxCorner.Parent = CodeBoxFrame

local CodeLabel = Instance.new("TextLabel")
CodeLabel.Size = UDim2.new(1, -16, 1, -10)
CodeLabel.Position = UDim2.new(0, 8, 0, 5)
CodeLabel.Text = ""
CodeLabel.TextColor3 = Color3.fromRGB(110, 190, 120)
CodeLabel.Font = Enum.Font.Code
CodeLabel.TextSize = 10
CodeLabel.TextWrapped = true
CodeLabel.TextXAlignment = Enum.TextXAlignment.Left
CodeLabel.TextYAlignment = Enum.TextYAlignment.Top
CodeLabel.BackgroundTransparency = 1
CodeLabel.Parent = CodeBoxFrame

local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(1, -32, 0, 40)
ExecuteBtn.Position = UDim2.new(0, 16, 1, -54)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(55, 115, 235)
ExecuteBtn.Text = "Execute"
ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 12
ExecuteBtn.AutoButtonColor = false
ExecuteBtn.Parent = DetailsView

local ExecuteCorner = Instance.new("UICorner")
ExecuteCorner.CornerRadius = UDim.new(0, 6)
ExecuteCorner.Parent = ExecuteBtn

-- ==========================================
-- 6. Clean Notification System
-- ==========================================
local NotifFrame = Instance.new("Frame")
NotifFrame.Name = "NotifFrame"
NotifFrame.Size = UDim2.new(1, -32, 0, 36)
NotifFrame.Position = UDim2.new(0, 16, 1, 45)
NotifFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
NotifFrame.ZIndex = 5
NotifFrame.Parent = MainFrame

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 6)
NotifCorner.Parent = NotifFrame

local NotifStroke = Instance.new("UIStroke")
NotifStroke.Color = Color3.fromRGB(45, 105, 225)
NotifStroke.Thickness = 1
NotifStroke.Parent = NotifFrame

local NotifText = Instance.new("TextLabel")
NotifText.Size = UDim2.new(1, -20, 1, 0)
NotifText.Position = UDim2.new(0, 10, 0, 0)
NotifText.Text = ""
NotifText.TextColor3 = Color3.fromRGB(240, 240, 250)
NotifText.Font = Enum.Font.GothamBold
NotifText.TextSize = 11
NotifText.TextXAlignment = Enum.TextXAlignment.Left
NotifText.BackgroundTransparency = 1
NotifText.ZIndex = 5
NotifText.Parent = NotifFrame

local notifQueueActive = false
local function showNotification(message, accentColor)
    if notifQueueActive then return end
    notifQueueActive = true
    
    NotifText.Text = message
    NotifStroke.Color = accentColor or Color3.fromRGB(45, 105, 225)
    
    local slideIn = TweenService:Create(NotifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 16, 1, -54)})
    slideIn:Play()
    slideIn.Completed:Connect(function()
        task.wait(2.2)
        local slideOut = TweenService:Create(NotifFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0, 16, 1, 45)})
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notifQueueActive = false
        end)
    end)
end

-- ==========================================
-- 7. Core Interface Logic & Animations
-- ==========================================
local function fastColorTween(object, time, targetColor)
    TweenService:Create(object, TweenInfo.new(time, Enum.EasingStyle.Quad), {BackgroundColor3 = targetColor}):Play()
end

local cardInstances = {}

local function selectScript(data, cardFrame)
    SelectedScript = data
    WelcomeView.Visible = false
    DetailsView.Visible = true
    
    MetaName.Text = data.Name:upper()
    MetaDesc.Text = data.Desc
    CodeLabel.Text = data.Loadstring
    
    local style = TagStyles[data.Tag] or {Color = Color3.fromRGB(100,100,100), Text = "UNKNOWN"}
    MetaTag.BackgroundColor3 = style.Color
    MetaTag.Text = style.Text
    
    if data.Tag == "PATCHED" or data.Tag == "DISCONTINUED" then
        ExecuteBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
        ExecuteBtn.Text = "LOCKED"
    else
        ExecuteBtn.BackgroundColor3 = Color3.fromRGB(55, 115, 235)
        ExecuteBtn.Text = "Execute"
    end
    
    for _, item in ipairs(cardInstances) do
        TweenService:Create(item.Stroke, TweenInfo.new(0.12), {Color = Color3.fromRGB(24, 24, 32), Thickness = 1}):Play()
        TweenService:Create(item.Frame, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(18, 18, 24)}):Play()
    end
    TweenService:Create(cardFrame:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.12), {Color = Color3.fromRGB(55, 115, 235), Thickness = 1.5}):Play()
    TweenService:Create(cardFrame, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
end

local function generateCards()
    for _, data in ipairs(ScriptDatabase) do
        local Card = Instance.new("TextButton")
        Card.Size = UDim2.new(1, -6, 0, 46)
        Card.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        Card.Text = ""
        Card.AutoButtonColor = false
        Card.Parent = ScrollFrame

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 6)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = Color3.fromRGB(24, 24, 32)
        CardStroke.Thickness = 1
        CardStroke.Parent = Card

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -95, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.Text = data.Name
        Label.TextColor3 = Color3.fromRGB(230, 230, 240)
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.BackgroundTransparency = 1
        Label.Parent = Card

        local MiniTag = Instance.new("TextLabel")
        MiniTag.Size = UDim2.new(0, 74, 0, 16)
        MiniTag.Position = UDim2.new(1, -80, 0.5, -8)
        local style = TagStyles[data.Tag] or {Color = Color3.fromRGB(100,100,100), Text = "UNK"}
        MiniTag.BackgroundColor3 = style.Color
        MiniTag.Text = style.Text
        MiniTag.TextColor3 = Color3.fromRGB(255, 255, 255)
        MiniTag.Font = Enum.Font.GothamBold
        MiniTag.TextSize = 8
        MiniTag.Parent = Card

        local MiniTagCorner = Instance.new("UICorner")
        MiniTagCorner.CornerRadius = UDim.new(0, 4)
        MiniTagCorner.Parent = MiniTag

        table.insert(cardInstances, {Frame = Card, Stroke = CardStroke, Data = data})

        Card.MouseEnter:Connect(function()
            if SelectedScript ~= data then fastColorTween(Card, 0.1, Color3.fromRGB(22, 22, 30)) end
        end)
        Card.MouseLeave:Connect(function()
            if SelectedScript ~= data then fastColorTween(Card, 0.1, Color3.fromRGB(18, 18, 24)) end
        end)
        Card.MouseButton1Click:Connect(function()
            selectScript(data, Card)
        end)
    end
end
generateCards()

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local input = SearchBox.Text:lower()
    for _, item in ipairs(cardInstances) do
        if input == "" or item.Data.Name:lower():find(input) or item.Data.Tag:lower():find(input) then
            item.Frame.Visible = true
        else
            item.Frame.Visible = false
        end
    end
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    if SelectedScript then
        if SelectedScript.Tag == "PATCHED" or SelectedScript.Tag == "DISCONTINUED" then 
            return 
        end
        
        task.spawn(function()
            local success, fault = pcall(function()
                local compilationUnit = loadstring(SelectedScript.Loadstring)
                if compilationUnit then compilationUnit() end
            end)
            if success then
                showNotification("Success", Color3.fromRGB(46, 204, 113))
            else
                showNotification("Error", Color3.fromRGB(231, 76, 60))
                warn("[Cresent Error]: " .. tostring(fault))
            end
        end)
    end
end)

-- ==========================================
-- 8. High-Response Visibility Logic (Instant Close)
-- ==========================================
local isUIActive = true
MainFrame.GroupTransparency = 0

local function toggleCresentUI()
    isUIActive = not isUIActive
    if isUIActive then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {GroupTransparency = 0}):Play()
    else
        MainFrame.Visible = false
        MainFrame.GroupTransparency = 1
    end
end

CloseButton.MouseButton1Click:Connect(toggleCresentUI)
ToggleButton.MouseButton1Click:Connect(toggleCresentUI)

CloseButton.MouseEnter:Connect(function() TweenService:Create(CloseButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(231, 76, 60), TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
CloseButton.MouseLeave:Connect(function() TweenService:Create(CloseButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 24, 34), TextColor3 = Color3.fromRGB(150, 150, 165)}):Play() end)
ToggleButton.MouseEnter:Connect(function() TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(26, 26, 38)}):Play() end)
ToggleButton.MouseLeave:Connect(function() TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 20, 26)}):Play() end)

-- Smooth Mobile/Desktop Canvas Dragging System
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseBehavior or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
