--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                    NEBULA UI LIBRARY                       ║
    ║                     Version 2.0                            ║
    ╚═══════════════════════════════════════════════════════════╝
]]

local NebulaUI = {}
NebulaUI.__index = NebulaUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local Config = {
    -- Main Colors
    Primary = Color3.fromRGB(88, 101, 242),      -- Discord-like blue
    Secondary = Color3.fromRGB(47, 49, 54),       -- Dark gray
    Background = Color3.fromRGB(32, 34, 37),      -- Darker background
    Surface = Color3.fromRGB(54, 57, 63),         -- Surface color
    Accent = Color3.fromRGB(114, 137, 218),       -- Accent
    Success = Color3.fromRGB(67, 181, 129),       -- Green
    Warning = Color3.fromRGB(250, 166, 26),       -- Orange
    Error = Color3.fromRGB(240, 71, 71),          -- Red
    Text = Color3.fromRGB(255, 255, 255),         -- White
    TextDark = Color3.fromRGB(185, 187, 190),     -- Gray text
    
    -- Fonts
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
    
    -- Animations
    TweenSpeed = 0.2,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out
}

-- Utility Functions
local function Create(className, properties, children)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    return instance
end

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or Config.TweenSpeed, Config.EasingStyle, Config.EasingDirection),
        properties
    )
    tween:Play()
    return tween
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Config.Primary,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = parent
    })
end

local function AddGradient(parent, colors)
    return Create("UIGradient", {
        Color = ColorSequence.new(colors or {
            ColorSequenceKeypoint.new(0, Config.Primary),
            ColorSequenceKeypoint.new(1, Config.Accent)
        }),
        Rotation = 45,
        Parent = parent
    })
end

local function AddShadow(parent)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        ZIndex = -1,
        Parent = parent
    })
    return shadow
end

local function Ripple(button)
    button.ClipsDescendants = true
    
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        Parent = button
    })
    AddCorner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Main Library
function NebulaUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Nebula UI"
    local size = config.Size or UDim2.new(0, 550, 0, 400)
    local theme = config.Theme or "Dark"
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "NebulaUI_" .. tostring(math.random(1000, 9999)),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Try to parent to CoreGui
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.Background,
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddShadow(MainFrame)
    
    -- Opening Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Tween(MainFrame, {Size = size, BackgroundTransparency = 0}, 0.4)
    
    -- Glow Effect
    local Glow = Create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Config.Primary,
        ImageTransparency = 0.85,
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.new(0, -30, 0, -30),
        ZIndex = -2,
        Parent = MainFrame
    })
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.Secondary,
        Size = UDim2.new(1, 0, 0, 45),
        Parent = MainFrame
    })
    AddCorner(TitleBar, 12)
    
    -- Fix bottom corners of title bar
    local TitleBarFix = Create("Frame", {
        Name = "Fix",
        BackgroundColor3 = Config.Secondary,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    -- Logo
    local Logo = Create("Frame", {
        Name = "Logo",
        BackgroundColor3 = Config.Primary,
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 12, 0.5, -14),
        Parent = TitleBar
    })
    AddCorner(Logo, 6)
    AddGradient(Logo)
    
    local LogoIcon = Create("TextLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "N",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Parent = Logo
    })
    
    -- Title
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 50, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Config.Font,
        Text = title,
        TextColor3 = Config.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleBar
    })
    
    -- Window Controls
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Parent = TitleBar
    })
    
    local ControlsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = Controls
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Config.Warning,
        Size = UDim2.new(0, 22, 0, 22),
        Font = Config.Font,
        Text = "−",
        TextColor3 = Config.Background,
        TextSize = 18,
        Parent = Controls
    })
    AddCorner(MinimizeBtn, 6)
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Config.Error,
        Size = UDim2.new(0, 22, 0, 22),
        Font = Config.Font,
        Text = "×",
        TextColor3 = Config.Background,
        TextSize = 18,
        Parent = Controls
    })
    AddCorner(CloseBtn, 6)
    
    -- Button Hover Effects
    for _, btn in pairs({MinimizeBtn, CloseBtn}) do
        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundTransparency = 0.2})
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundTransparency = 0})
        end)
        btn.MouseButton1Click:Connect(function()
            Ripple(btn)
        end)
    end
    
    -- Close Functionality
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Minimize Functionality
    local minimized = false
    local originalSize = size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 45)}, 0.3)
        else
            Tween(MainFrame, {Size = originalSize}, 0.3)
        end
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Tab Container
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.Secondary,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 140, 1, -45),
        Parent = MainFrame
    })
    
    local TabList = Create("ScrollingFrame", {
        Name = "TabList",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 8),
        Size = UDim2.new(1, -16, 1, -16),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Config.Primary,
        Parent = TabContainer
    })
    
    local TabListLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = TabList
    })
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 145, 0, 50),
        Size = UDim2.new(1, -155, 1, -60),
        ClipsDescendants = true,
        Parent = MainFrame
    })
    
    -- Window Object
    local Window = {
        Gui = ScreenGui,
        Main = MainFrame,
        Tabs = {},
        ActiveTab = nil
    }
    
    -- Create Tab Function
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://7733960981"
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Config.Surface,
            Size = UDim2.new(1, 0, 0, 36),
            Font = Config.FontLight,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })
        AddCorner(TabButton, 8)
        
        -- Tab Icon
        local TabIcon = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = tabIcon,
            ImageColor3 = Config.TextDark,
            Parent = TabButton
        })
        
        -- Tab Name
        local TabName = Create("TextLabel", {
            Name = "Name",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 38, 0, 0),
            Size = UDim2.new(1, -45, 1, 0),
            Font = Config.FontLight,
            Text = tabName,
            TextColor3 = Config.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        -- Indicator
        local Indicator = Create("Frame", {
            Name = "Indicator",
            BackgroundColor3 = Config.Primary,
            Position = UDim2.new(0, 0, 0.15, 0),
            Size = UDim2.new(0, 3, 0.7, 0),
            Parent = TabButton
        })
        AddCorner(Indicator, 2)
        Indicator.BackgroundTransparency = 1
        
        -- Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = tabName .. "Content",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Config.Primary,
            Visible = false,
            Parent = ContentContainer
        })
        
        local ContentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = TabContent
        })
        
        local ContentPadding = Create("UIPadding", {
            PaddingRight = UDim.new(0, 8),
            Parent = TabContent
        })
        
        -- Update canvas size
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Object
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Name = tabName
        }
        
        -- Select Tab Function
        local function SelectTab()
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundColor3 = Config.Surface})
                Tween(tab.Button.Icon, {ImageColor3 = Config.TextDark})
                Tween(tab.Button.Name, {TextColor3 = Config.TextDark})
                Tween(tab.Button.Indicator, {BackgroundTransparency = 1})
                tab.Content.Visible = false
            end
            
            -- Select this tab
            Tween(TabButton, {BackgroundColor3 = Config.Background})
            Tween(TabIcon, {ImageColor3 = Config.Primary})
            Tween(TabName, {TextColor3 = Config.Text})
            Tween(Indicator, {BackgroundTransparency = 0})
            TabContent.Visible = true
            Window.ActiveTab = Tab
            
            Ripple(TabButton)
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Config.Background})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Config.Surface})
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Select first tab by default
        if #Window.Tabs == 1 then
            SelectTab()
        end
        
        -- Update tab list canvas size
        TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabList.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
        end)
        
        -- Section Function
        function Tab:CreateSection(name)
            local Section = Create("Frame", {
                Name = name or "Section",
                BackgroundColor3 = Config.Surface,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = TabContent
            })
            AddCorner(Section, 10)
            
            local SectionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = Section
            })
            
            local SectionPadding = Create("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                Parent = Section
            })
            
            -- Section Header
            if name then
                local Header = Create("TextLabel", {
                    Name = "Header",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Config.Font,
                    Text = name,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Section
                })
            end
            
            local SectionObj = {
                Frame = Section
            }
            
            -- Button Element
            function SectionObj:CreateButton(config)
                config = config or {}
                local btnName = config.Name or "Button"
                local callback = config.Callback or function() end
                
                local Button = Create("TextButton", {
                    Name = btnName,
                    BackgroundColor3 = Config.Primary,
                    Size = UDim2.new(1, 0, 0, 36),
                    Font = Config.Font,
                    Text = btnName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    AutoButtonColor = false,
                    Parent = Section
                })
                AddCorner(Button, 8)
                AddGradient(Button)
                
                Button.MouseEnter:Connect(function()
                    Tween(Button, {BackgroundTransparency = 0.1})
                end)
                
                Button.MouseLeave:Connect(function()
                    Tween(Button, {BackgroundTransparency = 0})
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Ripple(Button)
                    callback()
                end)
                
                return Button
            end
            
            -- Toggle Element
            function SectionObj:CreateToggle(config)
                config = config or {}
                local toggleName = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback or function() end
                
                local ToggleFrame = Create("Frame", {
                    Name = toggleName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = Section
                })
                
                local ToggleLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -55, 1, 0),
                    Font = Config.FontLight,
                    Text = toggleName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    Name = "Toggle",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(1, -50, 0.5, -12),
                    Size = UDim2.new(0, 46, 0, 24),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, 12)
                
                local ToggleIndicator = Create("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = Config.TextDark,
                    Position = UDim2.new(0, 4, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Parent = ToggleButton
                })
                AddCorner(ToggleIndicator, 8)
                
                local toggled = default
                
                local function UpdateToggle()
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Config.Primary})
                        Tween(ToggleIndicator, {
                            Position = UDim2.new(1, -20, 0.5, -8),
                            BackgroundColor3 = Config.Text
                        })
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Config.Secondary})
                        Tween(ToggleIndicator, {
                            Position = UDim2.new(0, 4, 0.5, -8),
                            BackgroundColor3 = Config.TextDark
                        })
                    end
                    callback(toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                if default then
                    UpdateToggle()
                end
                
                local ToggleObj = {}
                function ToggleObj:Set(value)
                    toggled = value
                    UpdateToggle()
                end
                
                return ToggleObj
            end
            
            -- Slider Element
            function SectionObj:CreateSlider(config)
                config = config or {}
                local sliderName = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local callback = config.Callback or function() end
                
                local SliderFrame = Create("Frame", {
                    Name = sliderName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = Section
                })
                
                local SliderLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -50, 0, 20),
                    Font = Config.FontLight,
                    Text = sliderName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local SliderValue = Create("TextLabel", {
                    Name = "Value",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -45, 0, 0),
                    Size = UDim2.new(0, 45, 0, 20),
                    Font = Config.Font,
                    Text = tostring(default),
                    TextColor3 = Config.Primary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SliderFrame
                })
                
                local SliderBack = Create("Frame", {
                    Name = "Background",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(0, 0, 0, 28),
                    Size = UDim2.new(1, 0, 0, 8),
                    Parent = SliderFrame
                })
                AddCorner(SliderBack, 4)
                
                local SliderFill = Create("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Config.Primary,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = SliderBack
                })
                AddCorner(SliderFill, 4)
                AddGradient(SliderFill)
                
                local SliderKnob = Create("Frame", {
                    Name = "Knob",
                    BackgroundColor3 = Config.Text,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    Parent = SliderBack
                })
                AddCorner(SliderKnob, 8)
                AddShadow(SliderKnob)
                
                local dragging = false
                
                local function UpdateSlider(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1),
                        0, 0.5, 0
                    )
                    SliderKnob.Position = pos
                    SliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
                    
                    local value = math.floor(min + (max - min) * pos.X.Scale)
                    SliderValue.Text = tostring(value)
                    callback(value)
                end
                
                SliderKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                SliderKnob.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                SliderBack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateSlider(input)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                function SliderObj:Set(value)
                    local pos = (value - min) / (max - min)
                    SliderKnob.Position = UDim2.new(pos, 0, 0.5, 0)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(value)
                    callback(value)
                end
                
                return SliderObj
            end
            
            -- Dropdown Element
            function SectionObj:CreateDropdown(config)
                config = config or {}
                local dropdownName = config.Name or "Dropdown"
                local options = config.Options or {}
                local default = config.Default or options[1] or "Select..."
                local callback = config.Callback or function() end
                
                local DropdownFrame = Create("Frame", {
                    Name = dropdownName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 60),
                    ClipsDescendants = true,
                    Parent = Section
                })
                
                local DropdownLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Config.FontLight,
                    Text = dropdownName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Config.FontLight,
                    Text = "  " .. default,
                    TextColor3 = Config.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownButton, 8)
                
                local DropdownArrow = Create("TextLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0, 0),
                    Size = UDim2.new(0, 30, 1, 0),
                    Font = Config.Font,
                    Text = "▼",
                    TextColor3 = Config.TextDark,
                    TextSize = 10,
                    Parent = DropdownButton
                })
                
                local DropdownList = Create("Frame", {
                    Name = "List",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(0, 0, 0, 60),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownList, 8)
                
                local DropdownListLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropdownList
                })
                
                local DropdownListPadding = Create("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                    Parent = DropdownList
                })
                
                local opened = false
                local selected = default
                
                -- Create options
                for _, option in pairs(options) do
                    local OptionBtn = Create("TextButton", {
                        Name = option,
                        BackgroundColor3 = Config.Surface,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 28),
                        Font = Config.FontLight,
                        Text = "  " .. option,
                        TextColor3 = Config.TextDark,
                        TextSize = 13,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        AutoButtonColor = false,
                        Parent = DropdownList
                    })
                    AddCorner(OptionBtn, 6)
                    
                    OptionBtn.MouseEnter:Connect(function()
                        Tween(OptionBtn, {BackgroundTransparency = 0})
                    end)
                    
                    OptionBtn.MouseLeave:Connect(function()
                        Tween(OptionBtn, {BackgroundTransparency = 1})
                    end)
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        selected = option
                        DropdownButton.Text = "  " .. option
                        opened = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 60)})
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)})
                        Tween(DropdownArrow, {Rotation = 0})
                        callback(option)
                    end)
                end
                
                local listHeight = (#options * 30) + 8
                
                DropdownButton.MouseButton1Click:Connect(function()
                    opened = not opened
                    if opened then
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 60 + listHeight)})
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listHeight)})
                        Tween(DropdownArrow, {Rotation = 180})
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 60)})
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)})
                        Tween(DropdownArrow, {Rotation = 0})
                    end
                end)
                
                local DropdownObj = {}
                function DropdownObj:Set(value)
                    selected = value
                    DropdownButton.Text = "  " .. value
                    callback(value)
                end
                
                return DropdownObj
            end
            
            -- TextBox Element
            function SectionObj:CreateInput(config)
                config = config or {}
                local inputName = config.Name or "Input"
                local placeholder = config.Placeholder or "Enter text..."
                local callback = config.Callback or function() end
                
                local InputFrame = Create("Frame", {
                    Name = inputName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 56),
                    Parent = Section
                })
                
                local InputLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Config.FontLight,
                    Text = inputName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputFrame
                })
                
                local InputBox = Create("TextBox", {
                    Name = "Box",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(0, 0, 0, 24),
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Config.FontLight,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Config.TextDark,
                    Text = "",
                    TextColor3 = Config.Text,
                    TextSize = 13,
                    ClearTextOnFocus = false,
                    Parent = InputFrame
                })
                AddCorner(InputBox, 8)
                AddStroke(InputBox, Config.Surface, 1)
                
                InputBox.Focused:Connect(function()
                    Tween(InputBox.UIStroke, {Color = Config.Primary, Transparency = 0})
                end)
                
                InputBox.FocusLost:Connect(function(enterPressed)
                    Tween(InputBox.UIStroke, {Color = Config.Surface, Transparency = 0.5})
                    if enterPressed then
                        callback(InputBox.Text)
                    end
                end)
                
                return InputBox
            end
            
            -- Label Element
            function SectionObj:CreateLabel(text)
                local Label = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Config.FontLight,
                    Text = text or "Label",
                    TextColor3 = Config.TextDark,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = Section
                })
                
                local LabelObj = {}
                function LabelObj:Set(newText)
                    Label.Text = newText
                end
                
                return LabelObj
            end
            
            -- Keybind Element
            function SectionObj:CreateKeybind(config)
                config = config or {}
                local keybindName = config.Name or "Keybind"
                local default = config.Default or Enum.KeyCode.Unknown
                local callback = config.Callback or function() end
                
                local KeybindFrame = Create("Frame", {
                    Name = keybindName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = Section
                })
                
                local KeybindLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -80, 1, 0),
                    Font = Config.FontLight,
                    Text = keybindName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = Config.Secondary,
                    Position = UDim2.new(1, -75, 0.5, -14),
                    Size = UDim2.new(0, 70, 0, 28),
                    Font = Config.Font,
                    Text = default.Name or "None",
                    TextColor3 = Config.Primary,
                    TextSize = 12,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                AddCorner(KeybindButton, 6)
                
                local currentKey = default
                local listening = false
                
                KeybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    KeybindButton.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            KeybindButton.Text = currentKey.Name
                            listening = false
                        end
                    elseif input.KeyCode == currentKey and not gameProcessed then
                        callback(currentKey)
                    end
                end)
                
                local KeybindObj = {}
                function KeybindObj:Set(key)
                    currentKey = key
                    KeybindButton.Text = key.Name
                end
                
                return KeybindObj
            end
            
            -- Color Picker Element
            function SectionObj:CreateColorPicker(config)
                config = config or {}
                local pickerName = config.Name or "Color"
                local default = config.Default or Color3.fromRGB(255, 255, 255)
                local callback = config.Callback or function() end
                
                local PickerFrame = Create("Frame", {
                    Name = pickerName,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 36),
                    Parent = Section
                })
                
                local PickerLabel = Create("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -45, 1, 0),
                    Font = Config.FontLight,
                    Text = pickerName,
                    TextColor3 = Config.Text,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = PickerFrame
                })
                
                local PickerButton = Create("TextButton", {
                    Name = "Button",
                    BackgroundColor3 = default,
                    Position = UDim2.new(1, -40, 0.5, -14),
                    Size = UDim2.new(0, 36, 0, 28),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = PickerFrame
                })
                AddCorner(PickerButton, 6)
                AddStroke(PickerButton, Config.TextDark, 1)
                
                local currentColor = default
                local pickerOpen = false
                
                -- Color Picker Panel
                local PickerPanel = Create("Frame", {
                    Name = "Panel",
                    BackgroundColor3 = Config.Background,
                    Position = UDim2.new(0, 0, 1, 5),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    Visible = false,
                    Parent = PickerFrame
                })
                AddCorner(PickerPanel, 8)
                
                -- Color Gradient
                local ColorGradient = Create("ImageButton", {
                    Name = "Gradient",
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -60, 0, 80),
                    Image = "rbxassetid://4155801252",
                    Parent = PickerPanel
                })
                AddCorner(ColorGradient, 4)
                
                -- Hue Slider
                local HueSlider = Create("ImageButton", {
                    Name = "Hue",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -40, 0, 10),
                    Size = UDim2.new(0, 20, 0, 80),
                    Image = "rbxassetid://3641079629",
                    Parent = PickerPanel
                })
                AddCorner(HueSlider, 4)
                
                PickerButton.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    PickerPanel.Visible = pickerOpen
                    if pickerOpen then
                        Tween(PickerFrame, {Size = UDim2.new(1, 0, 0, 146)})
                        Tween(PickerPanel, {Size = UDim2.new(1, 0, 0, 100)})
                    else
                        Tween(PickerFrame, {Size = UDim2.new(1, 0, 0, 36)})
                        Tween(PickerPanel, {Size = UDim2.new(1, 0, 0, 0)})
                    end
                end)
                
                local h, s, v = 0, 1, 1
                
                local function UpdateColor()
                    currentColor = Color3.fromHSV(h, s, v)
                    PickerButton.BackgroundColor3 = currentColor
                    ColorGradient.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    callback(currentColor)
                end
                
                -- Hue Selection
                HueSlider.MouseButton1Down:Connect(function()
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            connection:Disconnect()
                            return
                        end
                        local mouse = UserInputService:GetMouseLocation()
                        local y = math.clamp((mouse.Y - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                        h = y
                        UpdateColor()
                    end)
                end)
                
                -- SV Selection
                ColorGradient.MouseButton1Down:Connect(function()
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                            connection:Disconnect()
                            return
                        end
                        local mouse = UserInputService:GetMouseLocation()
                        s = math.clamp((mouse.X - ColorGradient.AbsolutePosition.X) / ColorGradient.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp((mouse.Y - ColorGradient.AbsolutePosition.Y) / ColorGradient.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end)
                end)
                
                local PickerObj = {}
                function PickerObj:Set(color)
                    h, s, v = Color3.toHSV(color)
                    UpdateColor()
                end
                
                return PickerObj
            end
            
            return SectionObj
        end
        
        return Tab
    end
    
    -- Notification Function
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local text = config.Text or ""
        local duration = config.Duration or 3
        local notifType = config.Type or "Info"
        
        local typeColors = {
            Info = Config.Primary,
            Success = Config.Success,
            Warning = Config.Warning,
            Error = Config.Error
        }
        
        local NotifFrame = Create("Frame", {
            Name = "Notification",
            BackgroundColor3 = Config.Surface,
            Position = UDim2.new(1, 20, 1, -100),
            Size = UDim2.new(0, 280, 0, 70),
            Parent = ScreenGui
        })
        AddCorner(NotifFrame, 10)
        AddShadow(NotifFrame)
        
        local NotifAccent = Create("Frame", {
            Name = "Accent",
            BackgroundColor3 = typeColors[notifType] or Config.Primary,
            Size = UDim2.new(0, 4, 1, 0),
            Parent = NotifFrame
        })
        AddCorner(NotifAccent, 2)
        
        local NotifTitle = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 10),
            Size = UDim2.new(1, -25, 0, 20),
            Font = Config.Font,
            Text = title,
            TextColor3 = Config.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotifFrame
        })
        
        local NotifText = Create("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 32),
            Size = UDim2.new(1, -25, 0, 30),
            Font = Config.FontLight,
            Text = text,
            TextColor3 = Config.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotifFrame
        })
        
        -- Animate in
        Tween(NotifFrame, {Position = UDim2.new(1, -290, 1, -100)}, 0.3)
        
        -- Auto dismiss
        task.delay(duration, function()
            Tween(NotifFrame, {Position = UDim2.new(1, 20, 1, -100)}, 0.3)
            task.wait(0.3)
            NotifFrame:Destroy()
        end)
    end
    
    -- Destroy Function
    function Window:Destroy()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end
    
    -- Toggle Visibility
    local visible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessed then
            visible = not visible
            MainFrame.Visible = visible
        end
    end)
    
    return Window
end

return NebulaUI
