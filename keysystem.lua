local KeySystem = {}

function KeySystem.Create(correctKey, onSuccess)
    -- Core Utilities & Services
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    
    local player = Players.LocalPlayer
    
    -- Parent Configuration (Supports CoreGui for executors, fallbacks to PlayerGui)
    local targetParent
    local success, _ = pcall(function() targetParent = CoreGui end)
    if not success or not targetParent then
        targetParent = player:WaitForChild("PlayerGui")
    end

    -- Clean up any existing instances of this UI
    if targetParent:FindFirstChild("CresentKeySystem") then
        targetParent.CresentKeySystem:Destroy()
    end

    -- Root ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CresentKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = targetParent

    -- Canvas Group for Smooth Global Opacity Tweens
    local CanvasGroup = Instance.new("CanvasGroup")
    CanvasGroup.Name = "MainFrame"
    CanvasGroup.Size = UDim2.new(0, 360, 0, 240)
    CanvasGroup.Position = UDim2.new(0.5, -180, 0.5, -120)
    CanvasGroup.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Deep Obsidian Black
    CanvasGroup.BorderSizePixel = 0
    CanvasGroup.Active = true
    CanvasGroup.GroupTransparency = 1 -- Start transparent for opening animation
    CanvasGroup.Size = UDim2.new(0, 340, 0, 220) -- Start slightly smaller for scale-pop effect
    CanvasGroup.Position = UDim2.new(0.5, -170, 0.5, -110)
    CanvasGroup.Parent = ScreenGui

    -- UI Corner for Smooth Edges
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = CanvasGroup

    -- Elegant Subtle White Border
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 1
    UIStroke.Color = Color3.fromRGB(45, 45, 45)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = CanvasGroup

    -- ==========================================
    -- ULTRA-SMOOTH DRAGGING LOGIC
    -- ==========================================
    local dragging = false
    local dragInput, dragStart, startPos
    local dragTargetPos = CanvasGroup.Position

    CanvasGroup.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = CanvasGroup.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    CanvasGroup.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            dragTargetPos = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Interpolate position every frame for a beautiful, responsive float effect
    local dragConnection
    dragConnection = RunService.RenderStepped:Connect(function(dt)
        if not ScreenGui or not ScreenGui.Parent then
            dragConnection:Disconnect()
            return
        end
        -- Smooth lerp calculation (25 frame speed factor)
        CanvasGroup.Position = CanvasGroup.Position:Lerp(dragTargetPos, math.clamp(dt * 25, 0, 1))
    end)

    -- Header Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "CRESENT KEY SYSTEM"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = CanvasGroup

    -- Close Button (X) - FIXED [] BUG BY USING STANDARD STRING CHARACTERS WITH OUTLINES
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "X" -- Clean cross asset alternative compatibility
    CloseBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.Parent = CanvasGroup

    -- Input Text Box Frame (64px Height)
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Name = "TextBoxFrame"
    TextBoxFrame.Size = UDim2.new(1, -30, 0, 64)
    TextBoxFrame.Position = UDim2.new(0, 15, 0, 55)
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Parent = CanvasGroup

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = TextBoxFrame

    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Thickness = 1
    BoxStroke.Color = Color3.fromRGB(40, 40, 40)
    BoxStroke.Parent = TextBoxFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Name = "KeyInput"
    KeyInput.Size = UDim2.new(1, -20, 1, 0)
    KeyInput.Position = UDim2.new(0, 10, 0, 0)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter premium security key here..."
    KeyInput.PlaceholderColor3 = Color3.fromRGB(90, 90, 90)
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 13
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.Parent = TextBoxFrame

    -- Focus animations for TextBox Frame
    KeyInput.Focused:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    KeyInput.FocusLost:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color3 = Color3.fromRGB(40, 40, 40)}):Play()
    end)

    -- Status Message Label
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Size = UDim2.new(1, -30, 0, 20)
    StatusLabel.Position = UDim2.new(0, 15, 0, 125)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Status: Waiting for verification..."
    StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    StatusLabel.Font = Enum.Font.GothamSemibold
    StatusLabel.TextSize = 11
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.Parent = CanvasGroup

    -- Action Buttons Layout Structure
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -30, 0, 45)
    ButtonContainer.Position = UDim2.new(0, 15, 0, 165)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = CanvasGroup

    local UIGridLayout = Instance.new("UIGridLayout")
    UIGridLayout.FillDirection = Enum.FillDirection.Horizontal
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 10, 0, 0)
    UIGridLayout.CellSize = UDim2.new(0.5, -5, 1, 0)
    UIGridLayout.Parent = ButtonContainer

    -- Get Key Button (White styling)
    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.TextSize = 13
    GetKeyBtn.Parent = ButtonContainer

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    -- Submit Button (Black/Dark Premium styling)
    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Name = "SubmitBtn"
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SubmitBtn.Text = "Submit Key"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    SubmitBtn.Parent = ButtonContainer

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    local SubmitStroke = Instance.new("UIStroke")
    SubmitStroke.Thickness = 1
    SubmitStroke.Color = Color3.fromRGB(60, 60, 60)
    SubmitStroke.Parent = SubmitBtn

    -- ==========================================
    -- ANIMATION DRIVERS (Transitions & Fades)
    -- ==========================================
    
    local function closeUI()
        local closeTime = 0.25
        -- Target out to slightly smaller box size + full transparency drop
        local targetSize = UDim2.new(0, 340, 0, 220)
        local targetPos = UDim2.new(dragTargetPos.X.Scale, dragTargetPos.X.Offset + 10, dragTargetPos.Y.Scale, dragTargetPos.Y.Offset + 10)
        
        TweenService:Create(CanvasGroup, TweenInfo.new(closeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1,
            Size = targetSize,
            Position = targetPos
        }):Play()
        
        task.wait(closeTime)
        ScreenGui:Destroy()
    end

    -- Close Button Interactions
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255, 75, 75)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(140, 140, 140)}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(closeUI)

    -- Get Key Button Hover Interactions
    GetKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)}):Play()
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    -- Submit Button Hover Interactions
    SubmitBtn.MouseEnter:Connect(function()
        TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        TweenService:Create(SubmitStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(100, 100, 100)}):Play()
    end)
    SubmitBtn.MouseLeave:Connect(function()
        TweenService:Create(SubmitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        TweenService:Create(SubmitStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)

    -- Action Implementations
    GetKeyBtn.MouseButton1Click:Connect(function()
        setclipboard("https://cresent-key-system.example.com/getkey") 
        StatusLabel.Text = "Status: Link copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(3)
        StatusLabel.Text = "Status: Waiting for verification..."
        StatusLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    end)

    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == correctKey then
            StatusLabel.Text = "Status: Key Approved! Launching..."
            StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color3 = Color3.fromRGB(100, 255, 100)}):Play()
            task.wait(1)
            closeUI()
            
            if onSuccess and typeof(onSuccess) == "function" then
                local execSuccess, err = pcall(onSuccess)
                if not execSuccess then
                    warn("[Cresent Error]: Failed to execute protected script code: " .. tostring(err))
                end
            end
        else
            StatusLabel.Text = "Status: Invalid Key. Try again!"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            TweenService:Create(BoxStroke, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 3, true), {Color3 = Color3.fromRGB(255, 50, 50)}):Play()
        end
    end)

    -- Dynamic Opening Pop Transition Setup
    dragTargetPos = UDim2.new(0.5, -180, 0.5, -120)
    TweenService:Create(CanvasGroup, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        GroupTransparency = 0,
        Size = UDim2.new(0, 360, 0, 240)
    }):Play()
end

-- ==========================================
-- SCRIPT EXECUTION SAMPLE
-- ==========================================
local mySecretKey = "CRESENTNEW"

local function MainScript()
    print("Access Granted! Main script logic running safely.")
end

KeySystem.Create(mySecretKey, MainScript)
