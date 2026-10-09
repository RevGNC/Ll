-- GNCHUB Bundled File (Auto-Generated)
local __MODULES = {}
local function __DEF(name, func)
    __MODULES[name] = { func = func, loaded = false, value = nil }
end

local function __REQUIRE(name)
    local mod = __MODULES[name]
    if not mod then 
        error("Module not found: " .. tostring(name)) 
    end
    if not mod.loaded then
        mod.value = mod.func()
        mod.loaded = true
    end
    return mod.value
end

__DEF("GNCHUB", function()
-- File: GNCHUB/init.lua
--[[
    GNCHUB Modular Library
    Modul  : Init (Entry Point)
    Layer  : 6 (top)
    Require: semua modul
    Ekspor : Library (identik dengan GNCHUB.lua asli)

    Cara pakai (identik dengan sebelumnya):
        local Library = loadstring(game:HttpGet("...GNCHUB/init.lua"))()
        local Window  = Library:CreateWindow({...})
        local Tab     = Window:AddTab("Home")
        ...
--]]

-- ============================================================
-- LAYER 0: Bootstrap & Environment Cleanup
-- ============================================================
local function getSafeEnv()
    if getgenv then return getgenv() else return _G end
end

local env = getSafeEnv()

if env.GNCHUB and env.GNCHUB.Window then
    pcall(function() env.GNCHUB.Window:Destroy() end)
end
if env.AntoraLib and env.AntoraLib.Window then
    pcall(function() env.AntoraLib.Window:Destroy() end)
end

-- ============================================================
-- LAYER 0: Core requires
-- ============================================================
local Executor   = __REQUIRE("GNCHUB.core.executor")
local SafeW      = __REQUIRE("GNCHUB.core.safe_wrappers")
local Config     = __REQUIRE("GNCHUB.core.config")
local ColorMod   = __REQUIRE("GNCHUB.core.color")

local SafeEnum    = SafeW.SafeEnum
local SafeColor3  = SafeW.SafeColor3
local SafeUDim2   = SafeW.SafeUDim2
local SafeVector2 = SafeW.SafeVector2
local SafeUDim    = SafeW.SafeUDim
local SafeRect    = SafeW.SafeRect

-- ============================================================
-- LAYER 1: Roblox Services
-- ============================================================
local TweenService, UserInputService, RunService, Players

if game and game.GetService then
    local function safeGetService(name)
        local ok, s = pcall(function() return game:GetService(name) end)
        return ok and s or nil
    end
    TweenService     = safeGetService("TweenService")
    UserInputService = safeGetService("UserInputService")
    RunService       = safeGetService("RunService")
    Players          = safeGetService("Players")
end

local mouse = nil
if Players and Players.LocalPlayer then
    pcall(function() mouse = Players.LocalPlayer:GetMouse() end)
end

-- ============================================================
-- LAYER 1: Shared scroll state
-- ============================================================
local ScrollingFrames    = {}
local MomentumScrolls    = {}
local ScrollConnections  = {}
local GlobalInputConnections = {}

-- ============================================================
-- LAYER 1: Utils requires (depend on core)
-- ============================================================
local CreateElement = __REQUIRE("GNCHUB.utils.elements")
local ScrollMod     = __REQUIRE("GNCHUB.utils.scroll")
local DragMod       = __REQUIRE("GNCHUB.utils.draggable")

-- Inject shared state into draggable module
DragMod.SetScrollConnections(ScrollConnections)

local SmoothScrollTo             = ScrollMod.SmoothScrollTo
local ScrollToElement            = ScrollMod.ScrollToElement
local CreateEnhancedScrollFrame  = ScrollMod.CreateEnhancedScrollFrame
local SetupMomentumScrolling     = ScrollMod.SetupMomentumScrolling
local SetupKeyboardNavigation    = ScrollMod.SetupKeyboardNavigation
local MakeDraggable              = DragMod.MakeDraggable
local CleanupConnections         = DragMod.CleanupConnections

-- ============================================================
-- LAYER 2: Library table
-- ============================================================
local Library = {}

env.GNCHUB    = Library
env.AntoraLib = Library

-- ============================================================
-- Executor info (public)
-- ============================================================
Library.ExecutorInfo = {
    Name     = Executor.DetectedExecutor,
    IsMobile = Executor.IsMobile,
    IsPC     = Executor.IsPC,
    Capabilities = Executor.Capabilities,
}

-- ============================================================
-- LAYER 3: KeySystem
-- ============================================================
local KeySystemSetup = __REQUIRE("GNCHUB.keysystem.ui")
KeySystemSetup.Setup(Library, Executor)
Library.Platoboost = Library.KeySystem.Platoboost

-- ============================================================
-- LAYER 3: Window creation
-- ============================================================
local WindowMod = __REQUIRE("GNCHUB.window.window")
WindowMod.SetupCreateWindow(Library, {
    CreateElement             = CreateElement,
    Config                    = Config,
    SafeW                     = SafeW,
    TweenService              = TweenService,
    UserInputService          = UserInputService,
    RunService                = RunService,
    ScrollToElement           = ScrollToElement,
    MakeDraggable             = MakeDraggable,
    SmoothScrollTo            = SmoothScrollTo,
    CreateEnhancedScrollFrame = CreateEnhancedScrollFrame,
    SetupMomentumScrolling    = SetupMomentumScrolling,
    SetupKeyboardNavigation   = SetupKeyboardNavigation,
    CleanupConnections        = CleanupConnections,
    ScrollConnections         = ScrollConnections,
    GlobalInputConnections    = GlobalInputConnections,
    ResolveColor              = ColorMod.ResolveColor,
})

-- ============================================================
-- Expose safe wrappers & config publicly (backward compat)
-- ============================================================
Library.Config    = Config
Library.SafeEnum  = SafeEnum
Library.SafeColor3 = SafeColor3
Library.ESP = __REQUIRE("GNCHUB.utils.esp")
Library.ESP:Init()

return Library

end)

__DEF("GNCHUB.components.button", function()
-- File: GNCHUB/components/button.lua
--[[
    GNCHUB Modular Library
    Modul  : Button Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers, utils/button
    Ekspor : { AddButton, AddIconsButton }
--]]

local function AddButton(Section, CreateElement, Config, TweenService)
    local ButtonStyles = {
        Primary = {
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(28, 28, 32),
            BackgroundTransparency = 0,
            BorderColor3 = Color3.fromRGB(39, 39, 42),
            BorderSizePixel = 0,
            UIStroke = {
                Color = Color3.fromRGB(39, 39, 42),
                Thickness = 1,
            },
            HoverConfig = {
                BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                UIStroke = {
                    Color = Color3.fromRGB(50, 50, 55),
                    Thickness = 1,
                },
            },
            FocusConfig = {
                BackgroundColor3 = Color3.fromRGB(25, 25, 28),
                UIStroke = {
                    Color = Color3.fromRGB(60, 60, 65),
                    Thickness = 1,
                },
            },
        },
        Ghost = {
            TextColor3 = Color3.fromRGB(244, 244, 244),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            HoverConfig = {
                BackgroundTransparency = 0.98,
            },
            FocusConfig = {
                BackgroundTransparency = 0.94,
            },
        },
        Outline = {
            TextColor3 = Color3.fromRGB(244, 244, 244),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 1,
            UIStroke = {
                Color = Color3.fromRGB(39, 39, 42),
                Thickness = 1,
            },
            HoverConfig = {
                BackgroundTransparency = 0.94,
            },
            FocusConfig = {
                BackgroundTransparency = 0.98,
            },
        },
    }

    local function ApplyTweens(button, config, uiStroke)
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenGoals = {}

        for property, value in pairs(config) do
            if property ~= "UIStroke" then
                tweenGoals[property] = value
            end
        end

        local tween = TweenService:Create(button, tweenInfo, tweenGoals)
        tween:Play()

        if uiStroke and config.UIStroke then
            local strokeTweenGoals = {}
            for property, value in pairs(config.UIStroke) do
                strokeTweenGoals[property] = value
            end
            local strokeTween = TweenService:Create(uiStroke, tweenInfo, strokeTweenGoals)
            strokeTween:Play()
        end
    end

    local function CreateGNCButton(style, text, parent, iconId)
        local config = ButtonStyles[style]
        assert(config, "Invalid button style: " .. style)

        local button = CreateElement("TextButton", {
            Font = Config.Font,
            Text = "",
            BackgroundColor3 = config.BackgroundColor3,
            BackgroundTransparency = config.BackgroundTransparency,
            BorderColor3 = config.BorderColor3,
            BorderSizePixel = config.BorderSizePixel,
            Size = UDim2.new(1, 0, 0, 36),
            Visible = true,
            Parent = parent,
        })

        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = button,
        })

        local uiStroke = nil
        if config.UIStroke then
            uiStroke = CreateElement("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = config.UIStroke.Color,
                Enabled = true,
                LineJoinMode = Enum.LineJoinMode.Round,
                Thickness = config.UIStroke.Thickness,
                Parent = button,
            })
        end

        local buttonText = CreateElement("TextLabel", {
            Font = Config.Font,
            Text = text,
            TextColor3 = config.TextColor3,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 16, 0, 0),
            Parent = button,
        })

        local buttonIcon = nil
        if iconId then
            buttonIcon = CreateElement("ImageLabel", {
                BackgroundTransparency = 1,
                Image = iconId,
                ImageColor3 = config.TextColor3,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -30, 0.5, -10),
                ScaleType = Enum.ScaleType.Fit,
                Parent = button,
            })
        end

        button.MouseEnter:Connect(function()
            if config.HoverConfig then
                ApplyTweens(button, config.HoverConfig, uiStroke)
            end
        end)

        button.MouseLeave:Connect(function()
            ApplyTweens(button, {
                BackgroundColor3 = config.BackgroundColor3,
                TextColor3 = config.TextColor3,
                BackgroundTransparency = config.BackgroundTransparency,
                BorderColor3 = config.BorderColor3,
                BorderSizePixel = config.BorderSizePixel,
                UIStroke = config.UIStroke,
            }, uiStroke)
        end)

        button.MouseButton1Down:Connect(function()
            if config.FocusConfig then
                ApplyTweens(button, config.FocusConfig, uiStroke)
            end
        end)

        button.MouseButton1Up:Connect(function()
            if config.HoverConfig then
                ApplyTweens(button, config.HoverConfig, uiStroke)
            else
                ApplyTweens(button, {
                    BackgroundColor3 = config.BackgroundColor3,
                    TextColor3 = config.TextColor3,
                    BackgroundTransparency = config.BackgroundTransparency,
                    BorderColor3 = config.BorderColor3,
                    BorderSizePixel = config.BorderSizePixel,
                    UIStroke = config.UIStroke,
                }, uiStroke)
            end
        end)

        return button
    end

    return function(buttonName, callback, variant, iconId)
        callback = callback or function() end
        variant = variant or "Primary"

        if iconId and not string.match(iconId, "rbxassetid://") and Config.ButtonIcons[iconId] then
            iconId = Config.ButtonIcons[iconId]
        end

        iconId = iconId or "rbxassetid://87837139328535"

        local StyledButton = CreateGNCButton(variant, buttonName, Section.Container, iconId)
        local buttonText = StyledButton:FindFirstChild("TextLabel")

        StyledButton.MouseButton1Click:Connect(callback)

        return {
            Button = StyledButton,
            SetText = function(text)
                if buttonText then
                    buttonText.Text = text
                end
            end,
            SetCallback = function(newCallback)
                callback = newCallback
            end,
            SetIcon = function(newIconId)
                local buttonIcon = StyledButton:FindFirstChild("ImageLabel")
                if buttonIcon then
                    buttonIcon.Image = newIconId
                end
            end
        }
    end
end

local function AddIconsButton(Section, CreateElement, Config, TweenService)
    return function(buttonName, callback, iconId)
        callback = callback or function() end

        if iconId and not string.match(iconId, "rbxassetid://") and Config.ButtonIcons[iconId] then
            iconId = Config.ButtonIcons[iconId]
        end

        iconId = iconId or "rbxassetid://131516675975293"

        local ButtonFrame = CreateElement("Frame", {
            Name = buttonName,
            Parent = Section.Container,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Config.Colors.Primary
        })
        CreateElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = ButtonFrame })

        local ButtonLabel = CreateElement("TextLabel", {
            Name = "Label",
            Parent = ButtonFrame,
            Size = UDim2.new(1, -90, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = buttonName,
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local ClickButton = CreateElement("TextButton", {
            Name = "IconButton",
            Parent = ButtonFrame,
            Size = UDim2.new(0, 75, 0, 20),
            Position = UDim2.new(1, -80, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Config.Colors.Background,
            Font = Config.Font,
            Text = "",
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize - 2
        })
        CreateElement("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ClickButton })
        CreateElement("UIStroke", {
            Color = Config.Colors.Stroke,
            Thickness = 1,
            Parent = ClickButton
        })

        local ButtonIcon = CreateElement("ImageLabel", {
            Name = "ButtonIcon",
            Parent = ClickButton,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 4, 0.5, -8),
            BackgroundTransparency = 1,
            Image = iconId,
            ImageColor3 = Config.Colors.Text,
            ScaleType = Enum.ScaleType.Fit
        })

        local IconsLabel = CreateElement("TextLabel", {
            Name = "IconsLabel",
            Parent = ClickButton,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = "icons",
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize - 2,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        ClickButton.MouseButton1Click:Connect(function()
            ClickButton.BackgroundColor3 = Config.Colors.Accent
            ButtonIcon.ImageColor3 = Config.Colors.Background
            IconsLabel.TextColor3 = Config.Colors.Background

            spawn(function()
                task.wait(0.1)
                ClickButton.BackgroundColor3 = Config.Colors.Background
                ButtonIcon.ImageColor3 = Config.Colors.Text
                IconsLabel.TextColor3 = Config.Colors.Text
            end)
            callback()
        end)

        ClickButton.MouseEnter:Connect(function()
            ClickButton.BackgroundColor3 = Config.Colors.Secondary
        end)

        ClickButton.MouseLeave:Connect(function()
            ClickButton.BackgroundColor3 = Config.Colors.Background
        end)

        return {
            Frame = ButtonFrame,
            Button = ClickButton,
            Label = ButtonLabel,
            Icon = ButtonIcon
        }
    end
end

return { AddButton = AddButton, AddIconsButton = AddIconsButton }

end)

__DEF("GNCHUB.components.dropdown", function()
-- File: GNCHUB/components/dropdown.lua
--[[
    GNCHUB Modular Library
    Modul  : Dropdown Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : AddDropdown
--]]

local function AddDropdown(Section, Window, CreateElement, Config, TweenService, updatePageCanvasSize)
    return function(dropdownConfig, options, default, callback)
        local config = {}
        if type(dropdownConfig) == "table" and not dropdownConfig[1] then
            config = dropdownConfig
            config.Title = config.Title or config.Name or "Dropdown"
            config.Description = config.Description or nil
            config.Options = config.Options or {}
            config.Default = config.Default or ""
            config.Multiple = config.Multiple or false
            config.MaxOptions = config.MaxOptions or math.huge
            config.Placeholder = config.Placeholder or (config.Multiple and "Select options..." or "Select an option...")
            config.Callback = config.Callback or function() end
        else
            config.Title = dropdownConfig or "Dropdown"
            config.Options = options or {}
            config.Default = default or ""
            config.Multiple = false
            config.MaxOptions = math.huge
            config.Placeholder = "Select an option..."
            config.Callback = callback or function() end
        end

        local Dropdown = {
            Value = config.Multiple and (type(config.Default) == "table" and config.Default or {}) or config.Default,
            Options = config.Options or {},
            Buttons = {},
            Toggled = false,
            Type = "Dropdown",
            Multiple = config.Multiple,
            Callback = config.Callback
        }

        local tweenFast = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tweenSmooth = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        local isClosingTag = false
        local isInteractingInner = false

        -- Root Container
        local DropdownFrame = CreateElement("Frame", {
            Name = config.Title,
            Parent = Section.Container,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        })

        CreateElement("UIListLayout", {
            Parent = DropdownFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })

        -- Title
        if config.Title and config.Title ~= "" then
            CreateElement("TextLabel", {
                Name = "Title",
                Parent = DropdownFrame,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium,
                Text = config.Title,
                TextColor3 = Config.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                LayoutOrder = 1
            })
        end

        -- Description
        if config.Description and config.Description ~= "" then
            CreateElement("TextLabel", {
                Name = "Description",
                Parent = DropdownFrame,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Font = Config.Font,
                Text = config.Description,
                TextColor3 = Config.Colors.TextSecondary,
                TextSize = Config.TextSize - 2,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                LayoutOrder = 2
            })
        end

        -- Dropdown Header Box
        local DropdownElement = CreateElement("Frame", {
            Name = "DropdownElement",
            Parent = DropdownFrame,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Config.Colors.Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
            LayoutOrder = 3
        })

        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = DropdownElement
        })

        local ElementStroke = CreateElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Config.Colors.Stroke,
            Thickness = 1,
            Transparency = 0.3,
            Parent = DropdownElement
        })

        -- Right Chevron / Toggle Button
        local ToggleBtn = CreateElement("TextButton", {
            Name = "ToggleBtn",
            Parent = DropdownElement,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 36, 0, 36),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -2, 0, 2),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 3
        })

        local ChevronIcon = CreateElement("ImageLabel", {
            Name = "ChevronIcon",
            Parent = ToggleBtn,
            Image = "rbxassetid://15269180996",
            ImageRectOffset = Vector2.new(0, 257),
            ImageRectSize = Vector2.new(256, 256),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            ImageColor3 = Config.Colors.TextSecondary,
            Rotation = 0
        })

        -- Inner Container for Tags and SearchBox
        local DropdownInner = CreateElement("Frame", {
            Name = "DropdownInner",
            Parent = DropdownElement,
            Size = UDim2.new(1, -40, 0, 40),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        })

        CreateElement("UIListLayout", {
            Parent = DropdownInner,
            Padding = UDim.new(0, 2),
            FillDirection = Enum.FillDirection.Vertical,
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Left
        })

        -- Selected Tags Holder
        local holder = CreateElement("Frame", {
            Name = "Holder",
            Parent = DropdownInner,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            LayoutOrder = 1,
            Visible = false
        })

        CreateElement("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 7),
            Parent = holder
        })

        CreateElement("UIListLayout", {
            Padding = UDim.new(0, 6),
            Wraps = true,
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = holder
        })

        -- Search / Placeholder TextBox
        local search = CreateElement("TextBox", {
            Name = "SearchBox",
            Parent = DropdownInner,
            CursorPosition = -1,
            Font = Config.Font,
            PlaceholderText = config.Placeholder,
            PlaceholderColor3 = Config.Colors.TextMuted,
            Text = "",
            TextColor3 = Config.Colors.Text,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 38),
            LayoutOrder = 2,
            ClearTextOnFocus = false
        })

        CreateElement("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 8),
            Parent = search
        })

        -- Dropdown Popup Options Wrapper
        local dropcontWrapper = CreateElement("Frame", {
            Name = "DropdownContainerWrapper",
            Parent = DropdownFrame,
            BackgroundColor3 = Config.Colors.Secondary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = false,
            LayoutOrder = 4,
            ClipsDescendants = true
        })

        CreateElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Config.Colors.Stroke,
            Thickness = 1,
            Transparency = 0.3,
            Parent = dropcontWrapper
        })

        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = dropcontWrapper
        })

        -- Options Scrolling Frame
        local dropcont = CreateElement("ScrollingFrame", {
            Name = "DropdownContainer",
            Parent = dropcontWrapper,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Config.Colors.Accent,
            ScrollBarImageTransparency = 0.2,
            Size = UDim2.new(1, 0, 1, 0)
        })

        CreateElement("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = dropcont
        })

        CreateElement("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = dropcont
        })

        -- Empty state label
        local emptyLabel = CreateElement("TextLabel", {
            Name = "EmptyLabel",
            Parent = dropcont,
            Size = UDim2.new(1, 0, 0, 34),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = "No options found",
            TextColor3 = Config.Colors.TextMuted,
            TextSize = 12,
            Visible = false,
            LayoutOrder = 9999
        })

        -- Height calculation & animation
        local function getTargetHeight()
            local visibleCount = 0
            for _, btn in pairs(Dropdown.Buttons) do
                if btn.Visible then
                    visibleCount = visibleCount + 1
                end
            end
            if visibleCount == 0 then
                visibleCount = 1
            end
            local itemHeight = 34 + 4
            local contentHeight = (visibleCount * itemHeight) + 12
            return math.min(contentHeight, 220)
        end

        local function setDropdownOpen(open)
            Dropdown.Toggled = open

            if open then
                dropcontWrapper.Visible = true
                local targetH = getTargetHeight()

                TweenService:Create(ElementStroke, tweenFast, {
                    Color = Config.Colors.Accent,
                    Transparency = 0
                }):Play()

                TweenService:Create(ChevronIcon, tweenSmooth, {
                    Rotation = 180,
                    ImageColor3 = Config.Colors.Accent
                }):Play()

                local anim = TweenService:Create(dropcontWrapper, tweenSmooth, {
                    Size = UDim2.new(1, 0, 0, targetH)
                })
                anim:Play()
                anim.Completed:Connect(function()
                    if updatePageCanvasSize then updatePageCanvasSize() end
                end)
            else
                TweenService:Create(ElementStroke, tweenFast, {
                    Color = Config.Colors.Stroke,
                    Transparency = 0.3
                }):Play()

                TweenService:Create(ChevronIcon, tweenSmooth, {
                    Rotation = 0,
                    ImageColor3 = Config.Colors.TextSecondary
                }):Play()

                local anim = TweenService:Create(dropcontWrapper, tweenFast, {
                    Size = UDim2.new(1, 0, 0, 0)
                })
                anim:Play()
                anim.Completed:Connect(function()
                    if not Dropdown.Toggled then
                        dropcontWrapper.Visible = false
                        search.Text = ""
                        if updatePageCanvasSize then updatePageCanvasSize() end
                    end
                end)
            end
        end

        local function updateDropdownHeight()
            if Dropdown.Toggled then
                local targetH = getTargetHeight()
                TweenService:Create(dropcontWrapper, tweenFast, {
                    Size = UDim2.new(1, 0, 0, targetH)
                }):Play()
            end
        end

        -- Search filter
        local function SearchOptions()
            local searchText = string.lower(search.Text)
            local matchCount = 0
            for optName, btn in pairs(Dropdown.Buttons) do
                local label = btn:FindFirstChild("TextLabel")
                local btnText = label and string.lower(label.Text) or string.lower(optName)
                local match = string.find(btnText, searchText, 1, true) ~= nil
                btn.Visible = match
                if match then
                    matchCount = matchCount + 1
                end
            end
            emptyLabel.Visible = (matchCount == 0)
            updateDropdownHeight()
        end

        search:GetPropertyChangedSignal("Text"):Connect(SearchOptions)

        -- Interaction Triggers
        search.Focused:Connect(function()
            isInteractingInner = true
            task.defer(function()
                isInteractingInner = false
            end)
            if not Dropdown.Toggled then
                setDropdownOpen(true)
            end
        end)

        ToggleBtn.MouseButton1Click:Connect(function()
            setDropdownOpen(not Dropdown.Toggled)
        end)

        DropdownElement.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if isClosingTag or isInteractingInner then return end
                setDropdownOpen(not Dropdown.Toggled)
            end
        end)

        DropdownElement.MouseEnter:Connect(function()
            if not Dropdown.Toggled then
                TweenService:Create(DropdownElement, tweenFast, {
                    BackgroundColor3 = Config.Colors.PrimaryLight
                }):Play()
                TweenService:Create(ElementStroke, tweenFast, {
                    Color = Config.Colors.StrokeLight
                }):Play()
            end
        end)

        DropdownElement.MouseLeave:Connect(function()
            if not Dropdown.Toggled then
                TweenService:Create(DropdownElement, tweenFast, {
                    BackgroundColor3 = Config.Colors.Primary
                }):Play()
                TweenService:Create(ElementStroke, tweenFast, {
                    Color = Config.Colors.Stroke
                }):Play()
            end
        end)

        -- Option Buttons Builder
        local function AddOptions(Options)
            for _, Option in pairs(Options) do
                local isSelected = (config.Multiple and table.find(Dropdown.Value, Option)) or
                                 (not config.Multiple and Dropdown.Value == Option)

                local dropbtn = CreateElement("TextButton", {
                    Name = "OptionButton_" .. tostring(Option),
                    Font = Config.Font,
                    Text = "",
                    BackgroundColor3 = isSelected and Config.Colors.Accent or Config.Colors.PrimaryLight,
                    BackgroundTransparency = isSelected and 0.85 or 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 34),
                    AutoButtonColor = false,
                    Parent = dropcont
                })

                CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropbtn
                })

                local text_label = CreateElement("TextLabel", {
                    Name = "TextLabel",
                    Font = isSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium,
                    Text = tostring(Option),
                    TextColor3 = isSelected and Config.Colors.Text or Config.Colors.TextSecondary,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -34, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    Parent = dropbtn
                })

                local check = CreateElement("ImageLabel", {
                    Name = "CheckMark",
                    Image = "rbxassetid://15269180838",
                    ImageColor3 = Config.Colors.Accent,
                    ImageRectOffset = Vector2.new(514, 257),
                    ImageRectSize = Vector2.new(256, 256),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    ImageTransparency = isSelected and 0 or 1,
                    Parent = dropbtn
                })

                dropbtn.MouseEnter:Connect(function()
                    local currentlySelected = (config.Multiple and table.find(Dropdown.Value, Option)) or
                                             (not config.Multiple and Dropdown.Value == Option)
                    TweenService:Create(dropbtn, tweenFast, {
                        BackgroundTransparency = currentlySelected and 0.75 or 0.7,
                        BackgroundColor3 = currentlySelected and Config.Colors.Accent or Config.Colors.PrimaryLight
                    }):Play()
                    TweenService:Create(text_label, tweenFast, {
                        TextColor3 = Config.Colors.Text
                    }):Play()
                end)

                dropbtn.MouseLeave:Connect(function()
                    local currentlySelected = (config.Multiple and table.find(Dropdown.Value, Option)) or
                                             (not config.Multiple and Dropdown.Value == Option)
                    TweenService:Create(dropbtn, tweenFast, {
                        BackgroundTransparency = currentlySelected and 0.85 or 1,
                        BackgroundColor3 = currentlySelected and Config.Colors.Accent or Config.Colors.PrimaryLight
                    }):Play()
                    TweenService:Create(text_label, tweenFast, {
                        TextColor3 = currentlySelected and Config.Colors.Text or Config.Colors.TextSecondary
                    }):Play()
                end)

                dropbtn.MouseButton1Click:Connect(function()
                    if config.Multiple then
                        local index = table.find(Dropdown.Value, Option)
                        if index then
                            table.remove(Dropdown.Value, index)
                            Dropdown:Set(Dropdown.Value)
                            if #Dropdown.Value == 0 then
                                config.Callback({})
                            end
                        else
                            if #Dropdown.Value < config.MaxOptions then
                                table.insert(Dropdown.Value, Option)
                                Dropdown:Set(Dropdown.Value)
                            end
                        end
                    else
                        if Dropdown.Value == Option then
                            Dropdown:Set("")
                            config.Callback("")
                        else
                            Dropdown:Set(Option)
                        end
                        setDropdownOpen(false)
                    end
                end)

                Dropdown.Buttons[Option] = dropbtn
            end
            updateDropdownHeight()
        end

        -- Refresh method
        function Dropdown:Refresh(Options, Delete)
            if Delete ~= false then
                for _, v in pairs(Dropdown.Buttons) do
                    v:Destroy()
                end
                Dropdown.Buttons = {}
            end
            Dropdown.Options = Options or {}
            search.Text = ""
            AddOptions(Dropdown.Options)
        end

        -- Tag Builder with individual close buttons ("close satu persatu pilihan")
        local function addValueText(text)
            local tagBtn = CreateElement("Frame", {
                Name = "ValueTag",
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = Config.Colors.Accent,
                Size = UDim2.new(0, 0, 0, 26)
            })

            CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = tagBtn
            })

            CreateElement("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 6),
                Parent = tagBtn
            })

            local tagLayout = CreateElement("UIListLayout", {
                Padding = UDim.new(0, 6),
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = tagBtn
            })

            local tagText = CreateElement("TextLabel", {
                Name = "TagText",
                Font = Enum.Font.GothamMedium,
                Text = tostring(text),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                LayoutOrder = 1,
                Parent = tagBtn
            })

            local closeBtn = CreateElement("TextButton", {
                Name = "CloseBtn",
                Font = Config.Font,
                Text = "",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                AutoButtonColor = false,
                LayoutOrder = 2,
                Parent = tagBtn
            })

            local closeIcon = CreateElement("ImageLabel", {
                Name = "CloseIcon",
                Image = "rbxassetid://15269329696",
                ImageRectOffset = Vector2.new(0, 514),
                ImageRectSize = Vector2.new(256, 256),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 12, 0, 12),
                ImageColor3 = Color3.fromRGB(255, 255, 255),
                ImageTransparency = 0.2,
                Parent = closeBtn
            })

            closeBtn.MouseEnter:Connect(function()
                TweenService:Create(closeIcon, tweenFast, {
                    ImageTransparency = 0,
                    ImageColor3 = Color3.fromRGB(255, 200, 200)
                }):Play()
            end)

            closeBtn.MouseLeave:Connect(function()
                TweenService:Create(closeIcon, tweenFast, {
                    ImageTransparency = 0.2,
                    ImageColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
            end)

            closeBtn.MouseButton1Click:Connect(function()
                isClosingTag = true
                task.defer(function()
                    isClosingTag = false
                end)

                if config.Multiple then
                    local index = table.find(Dropdown.Value, text)
                    if index then
                        tagBtn:Destroy()
                        table.remove(Dropdown.Value, index)
                        Dropdown:Set(Dropdown.Value)
                        if #Dropdown.Value == 0 then
                            config.Callback({})
                        end
                    end
                else
                    Dropdown:Set("")
                    config.Callback("")
                end
            end)

            tagBtn.Parent = holder
            holder.Visible = true
        end

        local function clearValueText()
            for _, item in pairs(holder:GetChildren()) do
                if item:IsA("Frame") or item:IsA("TextButton") then
                    item:Destroy()
                end
            end
            holder.Visible = false
        end

        -- Set method
        function Dropdown:Set(Value, ignore)
            local function updateButtonVisuals(button, isSelected)
                local transparency = isSelected and 0.85 or 1
                local bgColor = isSelected and Config.Colors.Accent or Config.Colors.PrimaryLight
                local textColor = isSelected and Config.Colors.Text or Config.Colors.TextSecondary
                local font = isSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium
                local imageTransparency = isSelected and 0 or 1

                TweenService:Create(button, tweenFast, {
                    BackgroundTransparency = transparency,
                    BackgroundColor3 = bgColor
                }):Play()

                local checkMark = button:FindFirstChild("CheckMark")
                if checkMark then
                    TweenService:Create(checkMark, tweenFast, {
                        ImageTransparency = imageTransparency
                    }):Play()
                end

                local textLabel = button:FindFirstChild("TextLabel")
                if textLabel then
                    textLabel.Font = font
                    TweenService:Create(textLabel, tweenFast, {
                        TextColor3 = textColor
                    }):Play()
                end
            end

            if config.Multiple then
                if type(Value) == "table" then
                    Dropdown.Value = Value
                elseif Value and Value ~= "" then
                    if type(Dropdown.Value) ~= "table" then
                        Dropdown.Value = {}
                    end
                    local index = table.find(Dropdown.Value, Value)
                    if index then
                        table.remove(Dropdown.Value, index)
                    else
                        if #Dropdown.Value < config.MaxOptions then
                            table.insert(Dropdown.Value, Value)
                        end
                    end
                else
                    Dropdown.Value = {}
                end
            else
                Dropdown.Value = Value or ""
            end

            local found = config.Multiple or table.find(Dropdown.Options, Dropdown.Value)

            clearValueText()

            if config.Multiple then
                for _, val in ipairs(Dropdown.Value) do
                    if table.find(Dropdown.Options, val) then
                        addValueText(val)
                    end
                end
                found = #Dropdown.Value > 0
            else
                if table.find(Dropdown.Options, Dropdown.Value) then
                    addValueText(Dropdown.Value)
                else
                    found = false
                end
            end

            if not found and not config.Multiple then
                Dropdown.Value = ""
            elseif not found and config.Multiple and type(Value) ~= "table" then
                Dropdown.Value = {}
            end

            -- Adapt search box sizing
            local hasSelection = false
            if config.Multiple then
                hasSelection = #Dropdown.Value > 0
            else
                hasSelection = Dropdown.Value ~= ""
            end

            if hasSelection then
                if config.Multiple then
                    search.PlaceholderText = "Search or select..."
                    search.Size = UDim2.new(1, 0, 0, 28)
                    search.Visible = true
                else
                    search.PlaceholderText = ""
                    search.Size = UDim2.new(1, 0, 0, 0)
                    search.Visible = false
                end
            else
                search.PlaceholderText = config.Placeholder
                search.Size = UDim2.new(1, 0, 0, 38)
                search.Visible = true
            end

            for option, button in pairs(Dropdown.Buttons) do
                local isSelected = (config.Multiple and table.find(Dropdown.Value, option)) or
                                 (not config.Multiple and option == Dropdown.Value)
                updateButtonVisuals(button, isSelected)
            end

            if not ignore and config.Callback then
                config.Callback(Dropdown.Value)
            end

            task.wait(0.05)
            if updatePageCanvasSize then updatePageCanvasSize() end
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:Clear()
            Dropdown:Set(config.Multiple and {} or "", false)
        end

        -- Initial population
        Dropdown:Refresh(Dropdown.Options, false)
        if config.Multiple and type(config.Default) == "table" then
            Dropdown:Set(config.Default, true)
        else
            Dropdown:Set(Dropdown.Value, true)
        end

        Window:RegisterConfigElement(Section.TabName, Section.SectionName, config.Title, Dropdown)

        return Dropdown
    end
end

return { AddDropdown = AddDropdown }

end)

__DEF("GNCHUB.components.paragraph", function()
-- File: GNCHUB/components/paragraph.lua
--[[
    GNCHUB Modular Library
    Modul  : Paragraph Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : { AddParagraph, AddTag }
--]]

local function AddParagraph(Section, CreateElement, Config)
    return function(ConfigTable)
        assert(ConfigTable.Title, "Paragraph - Missing Title")
        ConfigTable.Description = ConfigTable.Description or nil

        local paragraph = CreateElement("Frame", {
            Name = ConfigTable.Title,
            Parent = Section.Container,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        })

        local ParagraphLayout = CreateElement("UIListLayout", {
            Parent = paragraph,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4)
        })

        local TitleLabel = CreateElement("TextLabel", {
            Name = "Title",
            Parent = paragraph,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamBold,
            Text = ConfigTable.Title,
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            LayoutOrder = 1
        })

        local DescriptionLabel
        if ConfigTable.Description then
            DescriptionLabel = CreateElement("TextLabel", {
                Name = "Description",
                Parent = paragraph,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Font = Config.Font,
                Text = ConfigTable.Description,
                TextColor3 = Config.Colors.TextSecondary,
                TextSize = Config.TextSize - 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                LayoutOrder = 2
            })
        end

        return paragraph
    end
end

local function AddTag(Section, CreateElement, Config, TweenService)
    return function(TagConfig)
        if type(TagConfig) == "string" then
            TagConfig = {
                Title = TagConfig,
                Color = Config.Colors.Accent
            }
        end

        TagConfig.Title = TagConfig.Title or "Tag"
        TagConfig.Color = TagConfig.Color or Config.Colors.Accent

        local function Color3ToHSB(color)
            local r, g, b = color.R, color.G, color.B
            local max = math.max(r, g, b)
            local min = math.min(r, g, b)
            local delta = max - min

            local h = 0
            if delta ~= 0 then
                if max == r then
                    h = (g - b) / delta % 6
                elseif max == g then
                    h = (b - r) / delta + 2
                else
                    h = (r - g) / delta + 4
                end
                h = h * 60
            else
                h = 0
            end

            local s = (max == 0) and 0 or (delta / max)
            local v = max

            return {
                h = math.floor(h + 0.5),
                s = s,
                b = v
            }
        end

        local function GetPerceivedBrightness(color)
            local r = color.R
            local g = color.G
            local b = color.B
            return 0.299 * r + 0.587 * g + 0.114 * b
        end

        local function GetTextColorForHSB(color)
            local hsb = Color3ToHSB(color)
            local h, s, b = hsb.h, hsb.s, hsb.b
            if GetPerceivedBrightness(color) > 0.5 then
                return Color3.fromHSV(h / 360, 0, 0.05)
            else
                return Color3.fromHSV(h / 360, 0, 0.98)
            end
        end

        local TagContainer = CreateElement("Frame", {
            Name = "TagContainer",
            Parent = Section.Container,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1
        })

        local TagTitle = CreateElement("TextLabel", {
            Name = "TagTitle",
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = Config.TextSize,
            Font = Enum.Font.GothamSemibold,
            Text = TagConfig.Title,
            TextColor3 = GetTextColorForHSB(TagConfig.Color),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        })

        local TagFrame = CreateElement("Frame", {
            Name = "TagFrame",
            Parent = TagContainer,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.new(0, 0, 0, 30),
            BackgroundColor3 = TagConfig.Color,
            Position = UDim2.new(0, 0, 0.5, -15)
        })

        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 999),
            Parent = TagFrame
        })

        CreateElement("UIPadding", {
            Parent = TagFrame,
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 0),
            PaddingBottom = UDim.new(0, 0)
        })

        CreateElement("UIListLayout", {
            Parent = TagFrame,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })

        TagTitle.Parent = TagFrame

        local TagModule = {
            Frame = TagContainer,
            TagFrame = TagFrame,
            Title = TagTitle,

            SetTitle = function(newTitle)
                TagConfig.Title = newTitle
                TagTitle.Text = newTitle
            end,

            SetColor = function(newColor)
                TagConfig.Color = newColor
                TagFrame.BackgroundColor3 = newColor
                TagTitle.TextColor3 = GetTextColorForHSB(newColor)
            end,

            GetTitle = function()
                return TagConfig.Title
            end,

            GetColor = function()
                return TagConfig.Color
            end
        }

        return TagModule
    end
end

return { AddParagraph = AddParagraph, AddTag = AddTag }

end)

__DEF("GNCHUB.components.slider", function()
-- File: GNCHUB/components/slider.lua
--[[
    GNCHUB Modular Library
    Modul  : Slider Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : AddSlider
--]]

local function AddSlider(Section, Window, CreateElement, Config, SafeW, TweenService, UserInputService)
    local SafeEnum    = SafeW.SafeEnum
    local SafeUDim2   = SafeW.SafeUDim2
    local SafeUDim    = SafeW.SafeUDim
    local SafeColor3  = SafeW.SafeColor3

    return function(sliderConfig, minVal, maxVal, defaultVal, callback)
        local config = {}
        if type(sliderConfig) == "table" then
            config = sliderConfig
            config.Title = config.Title or config.Name or "Slider"
            config.Description = config.Description or nil
            config.Min = config.Min or 0
            config.Max = config.Max or 100
            config.Default = config.Default or config.Min
            config.Increment = config.Increment or 1
            config.Suffix = config.Suffix or ""
            config.Callback = config.Callback or function() end
        else
            config.Title = sliderConfig or "Slider"
            config.Min = minVal or 0
            config.Max = maxVal or 100
            config.Default = defaultVal or config.Min
            config.Increment = 1
            config.Suffix = ""
            config.Callback = callback or function() end
        end

        local function Round(Number, Factor)
            local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor
            if Result < 0 then
                Result = Result + Factor
            end
            return Result
        end

        local Slider = {
            Value = config.Default,
            Min = config.Min,
            Max = config.Max,
            Increment = config.Increment,
            Callback = config.Callback,
            Type = "Slider",
            FirstUpdate = true
        }

        local Dragging = false
        local DraggingDot = false

        local frameHeight = config.Description and 70 or 52

        local SliderFrame = CreateElement("Frame", {
            Name = config.Title,
            Parent = Section.Container,
            Size = SafeUDim2.new(1, 0, 0, frameHeight),
            BackgroundColor3 = Config.Colors.Primary,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 8),
            Parent = SliderFrame
        })

        CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(60, 60, 70),
            Thickness = 1.2,
            Transparency = 0.6,
            Parent = SliderFrame
        })

        CreateElement("UIGradient", {
            Parent = SliderFrame,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(32, 32, 38)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(26, 26, 30))
            }),
            Rotation = 90
        })

        local ContentContainer = CreateElement("Frame", {
            Name = "Content",
            Parent = SliderFrame,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
        })

        local SliderLabel = CreateElement("TextLabel", {
            Name = "Label",
            Parent = ContentContainer,
            Size = UDim2.new(0.6, 0, 0, 18),
            Position = UDim2.new(0, 2, 0, 8),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = config.Title,
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        })

        local ValueText = CreateElement("TextLabel", {
            Name = "ValueText",
            Parent = ContentContainer,
            Size = UDim2.new(0.4, -10, 0, 18),
            Position = UDim2.new(0.6, 0, 0, 8),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = tostring(config.Default) .. config.Suffix,
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextYAlignment = Enum.TextYAlignment.Center,
            RichText = true,
        })

        if config.Description then
            local DescLabel = CreateElement("TextLabel", {
                Name = "Description",
                Parent = ContentContainer,
                Size = UDim2.new(1, 0, 0, 14),
                Position = UDim2.new(0, 2, 0, 26),
                BackgroundTransparency = 1,
                Font = Config.Font,
                Text = config.Description,
                TextColor3 = Config.Colors.TextSecondary,
                TextSize = Config.TextSize - 2,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            })
        end

        local sliderYPos = config.Description and 44 or 32

        local SliderBar = CreateElement("Frame", {
            Name = "SliderBar",
            Parent = ContentContainer,
            Size = UDim2.new(1, -4, 0, 6),
            Position = UDim2.new(0, 2, 0, sliderYPos),
            BackgroundColor3 = SafeColor3.fromRGB(45, 45, 55),
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 3),
            Parent = SliderBar
        })

        CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(60, 60, 70),
            Thickness = 1,
            Transparency = 0.5,
            Parent = SliderBar
        })

        local SliderProgress = CreateElement("Frame", {
            Name = "SliderProgress",
            Parent = SliderBar,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Config.Colors.Accent,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 3),
            Parent = SliderProgress
        })

        CreateElement("UIGradient", {
            Parent = SliderProgress,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(88, 101, 242)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(67, 78, 184))
            }),
            Rotation = 0
        })

        local SliderDot = CreateElement("TextButton", {
            Name = "SliderDot",
            Parent = SliderFrame,
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = SafeColor3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 10,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(1, 0),
            Parent = SliderDot
        })

        CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(100, 100, 110),
            Thickness = 1.5,
            Transparency = 0.3,
            Parent = SliderDot
        })

        CreateElement("UIGradient", {
            Parent = SliderDot,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(240, 240, 245))
            }),
            Rotation = 90
        })

        local SliderButton = CreateElement("TextButton", {
            Name = "SliderButton",
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, sliderYPos - 9),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 3,
        })

        local function updateDotPosition(newPosition, animate)
            local barAbsPos = SliderBar.AbsolutePosition
            local barAbsSize = SliderBar.AbsoluteSize
            local frameAbsPos = SliderFrame.AbsolutePosition
            
            local dotX = (barAbsPos.X - frameAbsPos.X) + (barAbsSize.X * newPosition)
            local dotY = (barAbsPos.Y - frameAbsPos.Y) + (barAbsSize.Y / 2)
            
            local targetPos = UDim2.new(0, dotX, 0, dotY)
            
            if animate and not (DraggingDot or Dragging) then
                TweenService:Create(SliderDot, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out), {
                    Position = targetPos
                }):Play()
            else
                SliderDot.Position = targetPos
            end
        end

        function Slider:Set(Value, ignore)
            self.Value = math.clamp(Round(Value, config.Increment), config.Min, config.Max)
            
            local displayValue = tostring(self.Value)
            if config.Max then
                ValueText.Text = displayValue .. "<font transparency='0.5'>/" .. tostring(config.Max) .. "</font>" .. config.Suffix
            else
                ValueText.Text = displayValue .. config.Suffix
            end
            
            local newPosition = (self.Value - config.Min) / (config.Max - config.Min)
            
            if DraggingDot or Dragging then
                SliderProgress.Size = UDim2.fromScale(newPosition, 1)
                updateDotPosition(newPosition, false)
            else
                TweenService:Create(SliderProgress, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out), {
                    Size = UDim2.fromScale(newPosition, 1)
                }):Play()
                updateDotPosition(newPosition, true)
            end
            
            if not ignore and (not self.FirstUpdate) then
                task.spawn(function()
                    pcall(self.Callback, self.Value)
                end)
            end
            self.FirstUpdate = false
        end

        local currentDragInput = nil
        local dragInputEndedConn = nil

        local function getScreenGui()
            if Window and Window.ScreenGui then
                return Window.ScreenGui
            end
            local p = SliderFrame.Parent
            while p do
                if p:IsA("ScreenGui") then
                    return p
                end
                p = p.Parent
            end
            return nil
        end

        local function getTouchCatcher()
            local sg = getScreenGui()
            if not sg then return nil end
            local catcher = sg:FindFirstChild("SliderTouchCatcher")
            if not catcher then
                catcher = CreateElement("TextButton", {
                    Name = "SliderTouchCatcher",
                    Parent = sg,
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Active = true,
                    Modal = true,
                    ZIndex = 999999,
                    Visible = false
                })
            end
            return catcher
        end

        local function toggleScrolling(enabled)
            local p = SliderFrame.Parent
            while p do
                if p:IsA("ScrollingFrame") then
                    p.ScrollingEnabled = enabled
                end
                p = p.Parent
            end
        end

        local function updateSliderFromInput(inputPosition)
            if Dragging then
                local barPosition = SliderBar.AbsolutePosition
                local barSize = SliderBar.AbsoluteSize
                if barSize.X > 0 then
                    local relativeX = (inputPosition.X - barPosition.X) / barSize.X
                    local clampedPosition = math.clamp(relativeX, 0, 1)
                    local newValue = config.Min + (config.Max - config.Min) * clampedPosition
                    Slider:Set(newValue)
                end
            end
        end

        local function endDrag()
            if not Dragging then return end
            Dragging = false
            DraggingDot = false
            currentDragInput = nil

            if dragInputEndedConn then
                dragInputEndedConn:Disconnect()
                dragInputEndedConn = nil
            end

            local catcher = getTouchCatcher()
            if catcher then
                catcher.Visible = false
            end

            toggleScrolling(true)

            local leaveTween = TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
            TweenService:Create(SliderFrame, leaveTween, {
                BackgroundColor3 = Config.Colors.Primary
            }):Play()
            TweenService:Create(SliderDot, leaveTween, {
                Size = UDim2.new(0, 14, 0, 14)
            }):Play()
        end

        local function startDrag(input)
            if input.UserInputType == SafeEnum.UserInputType.MouseButton1 or input.UserInputType == SafeEnum.UserInputType.Touch then
                if Dragging then
                    endDrag()
                end

                Dragging = true
                DraggingDot = true
                currentDragInput = input

                toggleScrolling(false)

                local catcher = getTouchCatcher()
                if catcher then
                    catcher.Visible = true
                end

                updateSliderFromInput(input.Position)

                if dragInputEndedConn then
                    dragInputEndedConn:Disconnect()
                end

                dragInputEndedConn = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                        endDrag()
                    end
                end)
            end
        end

        SliderDot.InputBegan:Connect(startDrag)
        SliderButton.InputBegan:Connect(startDrag)

        if UserInputService then
            UserInputService.InputEnded:Connect(function(input)
                if Dragging then
                    if input == currentDragInput or input.UserInputType == SafeEnum.UserInputType.MouseButton1 or input.UserInputType == SafeEnum.UserInputType.Touch then
                        endDrag()
                    end
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging then
                    if input == currentDragInput or (currentDragInput and currentDragInput.UserInputType == SafeEnum.UserInputType.MouseButton1 and input.UserInputType == SafeEnum.UserInputType.MouseMovement) or input.UserInputType == SafeEnum.UserInputType.Touch then
                        updateSliderFromInput(input.Position)
                    end
                end
            end)
        end

        local catcher = getTouchCatcher()
        if catcher then
            catcher.InputChanged:Connect(function(input)
                if Dragging then
                    updateSliderFromInput(input.Position)
                end
            end)
            catcher.InputEnded:Connect(function(input)
                if Dragging then
                    endDrag()
                end
            end)
        end

        SliderButton.MouseEnter:Connect(function()
            if not Dragging then
                local hoverTween = TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
                TweenService:Create(SliderFrame, hoverTween, {
                    BackgroundColor3 = SafeColor3.fromRGB(35, 35, 42)
                }):Play()
                TweenService:Create(SliderDot, hoverTween, {
                    Size = UDim2.new(0, 16, 0, 16)
                }):Play()
            end
        end)

        SliderButton.MouseLeave:Connect(function()
            if not Dragging then
                local leaveTween = TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
                TweenService:Create(SliderFrame, leaveTween, {
                    BackgroundColor3 = Config.Colors.Primary
                }):Play()
                TweenService:Create(SliderDot, leaveTween, {
                    Size = UDim2.new(0, 14, 0, 14)
                }):Play()
            end
        end)

        Slider:Set(config.Default, true)

        task.spawn(function()
            task.wait(0.1)
            local newPosition = (Slider.Value - config.Min) / (config.Max - config.Min)
            updateDotPosition(newPosition, false)
        end)

        Window:RegisterConfigElement(Section.TabName, Section.SectionName, config.Title, Slider)

        return Slider
    end
end

return { AddSlider = AddSlider }

end)

__DEF("GNCHUB.components.textbox", function()
-- File: GNCHUB/components/textbox.lua
--[[
    GNCHUB Modular Library
    Modul  : Textbox Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : { AddTextbox, AddInput }
--]]

local function AddTextbox(Section, Window, CreateElement, Config, TweenService)
    return function(textboxName, placeholder, defaultValue, textDisappear, callback)
        local config = {}
        if type(textboxName) == "table" then
            config = textboxName
            config.Title = config.Title or config.Name or "Input"
            config.Description = config.Description or nil
            config.Placeholder = config.Placeholder or "Enter text..."
            config.Value = config.Value or config.Default or ""
            config.MultiLine = config.MultiLine or false
            config.ClearTextOnFocus = config.ClearTextOnFocus or false
            config.Callback = config.Callback or function() end
        else
            config.Title = textboxName or "Input"
            config.Description = nil
            config.Placeholder = placeholder or "Enter text..."
            config.Value = defaultValue or ""
            config.MultiLine = false
            config.ClearTextOnFocus = textDisappear or false
            config.Callback = callback or function() end
        end

        local Textbox = {
            Value = config.Value,
            Callback = config.Callback,
            Type = "Textbox"
        }

        local InputFrame = CreateElement("Frame", {
            Name = config.Title,
            Parent = Section.Container,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        })

        local InputLayout = CreateElement("UIListLayout", {
            Parent = InputFrame,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6)
        })

        if config.Title and config.Title ~= "" then
            local TitleLabel = CreateElement("TextLabel", {
                Name = "Title",
                Parent = InputFrame,
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamMedium,
                Text = config.Title,
                TextColor3 = Config.Colors.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                LayoutOrder = 1
            })
        end

        if config.Description and config.Description ~= "" then
            local DescLabel = CreateElement("TextLabel", {
                Name = "Description",
                Parent = InputFrame,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Font = Config.Font,
                Text = config.Description,
                TextColor3 = Config.Colors.TextSecondary,
                TextSize = Config.TextSize - 2,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                LayoutOrder = 2
            })
        end

        local InputElement = CreateElement("Frame", {
            Name = "InputElement",
            Parent = InputFrame,
            AutomaticSize = config.MultiLine and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = Config.Colors.Primary,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, config.MultiLine and 80 or 40),
            LayoutOrder = 3
        })

        CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = InputElement
        })

        CreateElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Config.Colors.Stroke,
            Thickness = 1,
            Transparency = 0.3,
            Parent = InputElement
        })

        local InputBox = CreateElement("TextBox", {
            Name = "TextBox",
            Parent = InputElement,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Font = Config.Font,
            Text = config.Value,
            PlaceholderText = config.Placeholder,
            PlaceholderColor3 = Config.Colors.TextSecondary,
            TextColor3 = Config.Colors.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = config.MultiLine and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
            TextWrapped = config.MultiLine,
            MultiLine = config.MultiLine,
            ClearTextOnFocus = config.ClearTextOnFocus,
            ClipsDescendants = true
        })

        CreateElement("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, config.MultiLine and 10 or 0),
            PaddingBottom = UDim.new(0, config.MultiLine and 10 or 0),
            Parent = InputBox
        })

        InputBox.FocusLost:Connect(function()
            Textbox.Value = InputBox.Text
            spawn(function()
                pcall(Textbox.Callback, Textbox.Value)
            end)
        end)

        function Textbox:Set(value, ignore)
            InputBox.Text = value or ""
            self.Value = value or ""
        end

        function Textbox:SetPlaceholder(text)
            InputBox.PlaceholderText = text or ""
        end

        function Textbox:Get()
            return self.Value
        end

        Window:RegisterConfigElement(Section.TabName, Section.SectionName, config.Title, Textbox)

        return Textbox
    end
end

local function AddInput(Section, Window, CreateElement, Config, TweenService)
    local addTextboxFn = AddTextbox(Section, Window, CreateElement, Config, TweenService)
    return function(inputName, placeholder, defaultValue, callback)
        return addTextboxFn(inputName, placeholder, defaultValue, false, callback)
    end
end

return { AddTextbox = AddTextbox, AddInput = AddInput }

end)

__DEF("GNCHUB.components.toggle", function()
-- File: GNCHUB/components/toggle.lua
--[[
    GNCHUB Modular Library
    Modul  : Toggle Component
    Layer  : 4
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : AddToggle(Section, Window, config) -> Toggle
--]]

-- Fungsi ini dipanggil dari window/section.lua
-- Parameter:
--   Section    : object Section yang punya .Container
--   Window     : object Window (untuk RegisterConfigElement)
--   toggleConfig : tabel config toggle
local function AddToggle(Section, Window, CreateElement, Config, SafeW, TweenService)
    local SafeEnum    = SafeW.SafeEnum
    local SafeUDim2   = SafeW.SafeUDim2
    local SafeUDim    = SafeW.SafeUDim
    local SafeColor3  = SafeW.SafeColor3
    local SafeVector2 = SafeW.SafeVector2

    return function(toggleName, defaultState, callback)
        local config = {}
        if type(toggleName) == "table" then
            config = toggleName
            config.Title = config.Title or config.Name or "Toggle"
            config.Description = config.Description or nil
            config.Default = config.Default or false
            config.Callback = config.Callback or function() end
        else
            if type(defaultState) == "function" then
                callback = defaultState
                defaultState = false
            end
            config.Title = toggleName or "Toggle"
            config.Default = defaultState or false
            config.Callback = callback or function() end
        end

        local Toggle = {
            Value = config.Default,
            Callback = config.Callback,
            Type = "Toggle",
            FirstUpdate = true
        }

        local frameHeight = config.Description and 56 or 38
        
        local ToggleFrame = CreateElement("Frame", {
            Name = config.Title,
            Parent = Section.Container,
            Size = SafeUDim2.new(1, 0, 0, frameHeight),
            BackgroundColor3 = Config.Colors.Primary,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 8),
            Parent = ToggleFrame
        })

        local ToggleStroke = CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(60, 60, 70),
            Thickness = 1.2,
            Transparency = 0.6,
            Parent = ToggleFrame
        })

        local ToggleGradient = CreateElement("UIGradient", {
            Parent = ToggleFrame,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(32, 32, 38)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(26, 26, 30))
            }),
            Rotation = 90
        })

        local ContentContainer = CreateElement("Frame", {
            Name = "Content",
            Parent = ToggleFrame,
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
        })

        local ToggleLabel = CreateElement("TextLabel", {
            Name = "Label",
            Parent = ContentContainer,
            Size = config.Description and UDim2.new(1, -55, 0, 18) or UDim2.new(1, -55, 1, 0),
            Position = config.Description and UDim2.new(0, 12, 0, 8) or UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Font = Config.Font,
            Text = config.Title,
            TextColor3 = Config.Colors.Text,
            TextSize = Config.TextSize,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = config.Description and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center
        })

        if config.Description then
            local DescLabel = CreateElement("TextLabel", {
                Name = "Description",
                Parent = ContentContainer,
                Size = UDim2.new(1, -55, 0, 16),
                Position = UDim2.new(0, 12, 0, 30),
                BackgroundTransparency = 1,
                Font = Config.Font,
                Text = config.Description,
                TextColor3 = Config.Colors.TextSecondary,
                TextSize = Config.TextSize - 2,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            })
        end

        local ToggleSwitch = CreateElement("Frame", {
            Name = "ToggleSwitch",
            Parent = ContentContainer,
            Size = SafeUDim2.new(0, 46, 0, 26),
            Position = SafeUDim2.new(1, -46, 0.5, -13),
            BackgroundColor3 = SafeColor3.fromRGB(45, 45, 55),
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 13),
            Parent = ToggleSwitch
        })

        CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(80, 80, 90),
            Thickness = 1,
            Transparency = 0.7,
            Parent = ToggleSwitch
        })

        local ToggleLayer = CreateElement("Frame", {
            Name = "Layer",
            Parent = ToggleSwitch,
            Size = SafeUDim2.new(1, 0, 1, 0),
            Position = SafeUDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Config.Colors.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 13),
            Parent = ToggleLayer
        })

        local ActiveGradient = CreateElement("UIGradient", {
            Parent = ToggleLayer,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(88, 101, 242)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(67, 78, 184))
            }),
            Rotation = 45
        })

        local KnobShadow = CreateElement("Frame", {
            Name = "KnobShadow",
            Parent = ToggleSwitch,
            Size = SafeUDim2.new(0, 18, 0, 18),
            Position = SafeUDim2.new(0, 4, 0.5, 1),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            ZIndex = 1,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(1, 0),
            Parent = KnobShadow
        })

        local ToggleKnob = CreateElement("Frame", {
            Name = "Knob",
            Parent = ToggleSwitch,
            Size = SafeUDim2.new(0, 18, 0, 18),
            Position = SafeUDim2.new(0, 4, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = SafeColor3.fromRGB(255, 255, 255),
            BorderSizePixel = 0,
            ZIndex = 2,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(1, 0),
            Parent = ToggleKnob
        })

        local KnobGradient = CreateElement("UIGradient", {
            Parent = ToggleKnob,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(240, 240, 245))
            }),
            Rotation = 90
        })

        local KnobStroke = CreateElement("UIStroke", {
            Color = SafeColor3.fromRGB(0, 0, 0),
            Thickness = 0.5,
            Transparency = 0.92,
            Parent = ToggleKnob
        })

        local KnobInnerShadow = CreateElement("Frame", {
            Name = "InnerHighlight",
            Parent = ToggleKnob,
            Size = SafeUDim2.new(0, 6, 0, 6),
            Position = SafeUDim2.new(0.5, 0, 0.3, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = SafeColor3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(1, 0),
            Parent = KnobInnerShadow
        })

        local ToggleButton = CreateElement("TextButton", {
            Name = "ToggleButton",
            Parent = ToggleFrame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
        })

        function Toggle:Set(Value, ignore)
            self.Value = Value

            local tweenInfo = TweenInfo.new(0.2, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out)
            local bounceTween = TweenInfo.new(0.25, SafeEnum.EasingStyle.Back, SafeEnum.EasingDirection.Out)

            if self.Value then
                TweenService:Create(ToggleKnob, bounceTween, {
                    Position = SafeUDim2.new(1, -20, 0.5, 0),
                    Size = SafeUDim2.new(0, 20, 0, 20),
                }):Play()
                TweenService:Create(KnobShadow, bounceTween, {
                    Position = SafeUDim2.new(1, -19, 0.5, 1),
                    Size = SafeUDim2.new(0, 18, 0, 18),
                }):Play()
                TweenService:Create(ToggleLayer, tweenInfo, {
                    BackgroundTransparency = 0.1,
                }):Play()
            else
                TweenService:Create(ToggleKnob, bounceTween, {
                    Position = SafeUDim2.new(0, 4, 0.5, 0),
                    Size = SafeUDim2.new(0, 18, 0, 18),
                }):Play()
                TweenService:Create(KnobShadow, bounceTween, {
                    Position = SafeUDim2.new(0, 4, 0.5, 1),
                    Size = SafeUDim2.new(0, 18, 0, 18),
                }):Play()
                TweenService:Create(ToggleLayer, tweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
            end

            if not ignore and (not self.FirstUpdate) then
                spawn(function()
                    pcall(self.Callback, self.Value)
                end)
            end
            self.FirstUpdate = false
        end

        ToggleButton.MouseEnter:Connect(function()
            local hoverTween = TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
            TweenService:Create(ToggleFrame, hoverTween, {
                BackgroundColor3 = SafeColor3.fromRGB(35, 35, 42)
            }):Play()
            TweenService:Create(KnobGradient, hoverTween, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(250, 250, 252))
                })
            }):Play()
            TweenService:Create(KnobShadow, hoverTween, {
                BackgroundTransparency = 0.55
            }):Play()
        end)

        ToggleButton.MouseLeave:Connect(function()
            local leaveTween = TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
            TweenService:Create(ToggleFrame, leaveTween, {
                BackgroundColor3 = Config.Colors.Primary
            }):Play()
            TweenService:Create(KnobGradient, leaveTween, {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(240, 240, 245))
                })
            }):Play()
            TweenService:Create(KnobShadow, leaveTween, {
                BackgroundTransparency = 0.7
            }):Play()
        end)

        ToggleButton.MouseButton1Click:Connect(function()
            Toggle:Set(not Toggle.Value)
        end)

        Toggle:Set(Toggle.Value, true)

        Window:RegisterConfigElement(Section.TabName, Section.SectionName, config.Title, Toggle)

        return Toggle
    end
end

return { AddToggle = AddToggle }

end)

__DEF("GNCHUB.core.bootstrap", function()
-- File: GNCHUB/core/bootstrap.lua
--[[
    GNCHUB Modular Library
    Modul  : Bootstrap
    Layer  : 0
    Require: (tidak ada)
    Ekspor : Library (tabel utama)
--]]

local function getSafeEnv()
    if getgenv then
        return getgenv()
    else
        return _G
    end
end

local env = getSafeEnv()

if env.GNCHUB and env.GNCHUB.Window then
    pcall(function()
        env.GNCHUB.Window:Destroy()
    end)
end
if env.AntoraLib and env.AntoraLib.Window then
    pcall(function()
        env.AntoraLib.Window:Destroy()
    end)
end

local Library = {}

env.GNCHUB = Library
env.AntoraLib = Library

return Library

end)

__DEF("GNCHUB.core.color", function()
-- File: GNCHUB/core/color.lua
--[[
    GNCHUB Modular Library
    Modul  : Color
    Layer  : 0
    Require: core/safe_wrappers, core/config
    Ekspor : { ColorNames, ResolveColor }
--]]

local SafeW = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeColor3 = SafeW.SafeColor3
local Config = __REQUIRE("GNCHUB.core.config")

local ColorNames = {

    ["Red"] = SafeColor3.fromRGB(237, 66, 69),
    ["red"] = SafeColor3.fromRGB(237, 66, 69),
    ["RED"] = SafeColor3.fromRGB(237, 66, 69),
    ["Green"] = SafeColor3.fromRGB(67, 181, 129),
    ["green"] = SafeColor3.fromRGB(67, 181, 129),
    ["GREEN"] = SafeColor3.fromRGB(67, 181, 129),
    ["Blue"] = SafeColor3.fromRGB(88, 101, 242),
    ["blue"] = SafeColor3.fromRGB(88, 101, 242),
    ["BLUE"] = SafeColor3.fromRGB(88, 101, 242),
    ["Purple"] = SafeColor3.fromRGB(139, 69, 195),
    ["purple"] = SafeColor3.fromRGB(139, 69, 195),
    ["PURPLE"] = SafeColor3.fromRGB(139, 69, 195),
    ["Orange"] = SafeColor3.fromRGB(250, 166, 26),
    ["orange"] = SafeColor3.fromRGB(250, 166, 26),
    ["ORANGE"] = SafeColor3.fromRGB(250, 166, 26),
    ["Yellow"] = SafeColor3.fromRGB(255, 215, 0),
    ["yellow"] = SafeColor3.fromRGB(255, 215, 0),
    ["YELLOW"] = SafeColor3.fromRGB(255, 215, 0),
    ["Pink"] = SafeColor3.fromRGB(255, 105, 180),
    ["pink"] = SafeColor3.fromRGB(255, 105, 180),
    ["PINK"] = SafeColor3.fromRGB(255, 105, 180),
    ["Cyan"] = SafeColor3.fromRGB(0, 255, 255),
    ["cyan"] = SafeColor3.fromRGB(0, 255, 255),
    ["CYAN"] = SafeColor3.fromRGB(0, 255, 255),
    ["White"] = SafeColor3.fromRGB(255, 255, 255),
    ["white"] = SafeColor3.fromRGB(255, 255, 255),
    ["WHITE"] = SafeColor3.fromRGB(255, 255, 255),
    ["Black"] = SafeColor3.fromRGB(0, 0, 0),
    ["black"] = SafeColor3.fromRGB(0, 0, 0),
    ["BLACK"] = SafeColor3.fromRGB(0, 0, 0),

    ["Accent"] = Config.Colors.Accent,
    ["accent"] = Config.Colors.Accent,
    ["ACCENT"] = Config.Colors.Accent,
    ["Success"] = Config.Colors.Success,
    ["success"] = Config.Colors.Success,
    ["SUCCESS"] = Config.Colors.Success,
    ["Warning"] = Config.Colors.Warning,
    ["warning"] = Config.Colors.Warning,
    ["WARNING"] = Config.Colors.Warning,
    ["Error"] = Config.Colors.Error,
    ["error"] = Config.Colors.Error,
    ["ERROR"] = Config.Colors.Error,
}

local function ResolveColor(colorInput)
    if type(colorInput) == "string" then
        return ColorNames[colorInput] or Config.Colors.Accent
    else
        return colorInput
    end
end

return {
    ColorNames   = ColorNames,
    ResolveColor = ResolveColor,
}

end)

__DEF("GNCHUB.core.config", function()
-- File: GNCHUB/core/config.lua
--[[
    GNCHUB Modular Library
    Modul  : Config
    Layer  : 0
    Require: core/safe_wrappers (SafeEnum, SafeColor3)
    Ekspor : Config
--]]

local SafeW = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeEnum   = SafeW.SafeEnum
local SafeColor3 = SafeW.SafeColor3

local Config = {
    Colors = {

        Background = SafeColor3.fromRGB(18, 18, 20),
        BackgroundGradient = SafeColor3.fromRGB(22, 22, 26),
        Primary = SafeColor3.fromRGB(28, 28, 32),
        PrimaryLight = SafeColor3.fromRGB(35, 35, 40),
        Secondary = SafeColor3.fromRGB(38, 38, 44),
        SecondaryLight = SafeColor3.fromRGB(45, 45, 52),
        Accent = SafeColor3.fromRGB(88, 101, 242),
        AccentHover = SafeColor3.fromRGB(71, 82, 196),
        AccentDark = SafeColor3.fromRGB(67, 78, 184),
        Success = SafeColor3.fromRGB(67, 181, 129),
        Warning = SafeColor3.fromRGB(250, 166, 26),
        Error = SafeColor3.fromRGB(237, 66, 69),
        Text = SafeColor3.fromRGB(255, 255, 255),
        TextSecondary = SafeColor3.fromRGB(181, 186, 193),
        TextMuted = SafeColor3.fromRGB(114, 118, 125),
        Stroke = SafeColor3.fromRGB(47, 49, 54),
        StrokeLight = SafeColor3.fromRGB(79, 84, 92),
        Shadow = SafeColor3.fromRGB(0, 0, 0),
    },
    Font = SafeEnum.Font.GothamSemibold,
    TextSize = 14,
    CornerRadius = 8,

    Effects = {
        ShadowTransparency = 0.6,
        GlowTransparency = 0.8,
        BackdropTransparency = 0.4,
        AnimationTime = 0.25,
        EasingStyle = SafeEnum.EasingStyle.Quad,
        EasingDirection = SafeEnum.EasingDirection.Out,
    },

    Scrolling = {
        AnimationTime = 0.3,
        EasingStyle = SafeEnum.EasingStyle.Quad,
        EasingDirection = SafeEnum.EasingDirection.Out,
        ScrollSensitivity = 25,
        MomentumDecay = 0.85,
        AutoScrollPadding = 20,
    },

    TabIcons = {
        ["Home"] = "rbxassetid://70988859006742",
        ["home"] = "rbxassetid://70988859006742",
        ["HOME"] = "rbxassetid://70988859006742",
        ["Main"] = "rbxassetid://96157481781292",
        ["main"] = "rbxassetid://96157481781292",
        ["MAIN"] = "rbxassetid://96157481781292",
        ["Setting"] = "rbxassetid://129470134418632",
        ["setting"] = "rbxassetid://129470134418632",
        ["SETTING"] = "rbxassetid://129470134418632",
        ["Settings"] = "rbxassetid://129470134418632",
        ["settings"] = "rbxassetid://129470134418632",
        ["SETTINGS"] = "rbxassetid://129470134418632",
        ["Teleport"] = "rbxassetid://121345596634521",
        ["teleport"] = "rbxassetid://121345596634521",
        ["TELEPORT"] = "rbxassetid://121345596634521",
        ["Player"] = "rbxassetid://106231385837988",
        ["player"] = "rbxassetid://106231385837988",
        ["PLAYER"] = "rbxassetid://106231385837988",
        ["Players"] = "rbxassetid://106231385837988",
        ["players"] = "rbxassetid://106231385837988",
        ["PLAYERS"] = "rbxassetid://106231385837988",
        ["Shop"] = "rbxassetid://97347795838056",
        ["shop"] = "rbxassetid://97347795838056",
        ["SHOP"] = "rbxassetid://97347795838056",
        ["Inventory"] = "rbxassetid://78177185711216",
        ["inventory"] = "rbxassetid://78177185711216",
        ["INVENTORY"] = "rbxassetid://78177185711216",
        ["Favorite"] = "rbxassetid://90214397890411",
        ["favorite"] = "rbxassetid://90214397890411",
        ["FAVORITE"] = "rbxassetid://90214397890411",
        ["Favorit"] = "rbxassetid://90214397890411",
        ["favorit"] = "rbxassetid://90214397890411",
        ["FAVORIT"] = "rbxassetid://90214397890411",
        ["Favourites"] = "rbxassetid://90214397890411",
        ["favourites"] = "rbxassetid://90214397890411",
        ["FAVOURITES"] = "rbxassetid://90214397890411",
        ["Crafting"] = "rbxassetid://128364577049514",
        ["crafting"] = "rbxassetid://128364577049514",
        ["CRAFTING"] = "rbxassetid://128364577049514",
        ["Craft"] = "rbxassetid://128364577049514",
        ["craft"] = "rbxassetid://128364577049514",
        ["CRAFT"] = "rbxassetid://128364577049514",
        ["Travel"] = "rbxassetid://121345596634521",
        ["travel"] = "rbxassetid://121345596634521",
        ["TRAVEL"] = "rbxassetid://121345596634521",
        ["Utility"] = "rbxassetid://97726559137925",
        ["utility"] = "rbxassetid://97726559137925",
        ["UTILITY"] = "rbxassetid://97726559137925",
        ["Utilities"] = "rbxassetid://97726559137925",
        ["utilities"] = "rbxassetid://97726559137925",
        ["UTILITIES"] = "rbxassetid://97726559137925",
        ["Event"] = "rbxassetid://127193555125863",
        ["EVENT"] = "rbxassetid://127193555125863",
        ["event"] = "rbxassetid://127193555125863",
        ["Exploit"] = "rbxassetid://92900538987065",
        ["Gacha"] = "rbxassetid://93516893368175",
    },

    ButtonIcons = {
        ["Button"] = "rbxassetid://85032776791084",
        ["button"] = "rbxassetid://85032776791084",
        ["BUTTON"] = "rbxassetid://85032776791084",
    },
}

return Config

end)

__DEF("GNCHUB.core.executor", function()
-- File: GNCHUB/core/executor.lua
--[[
    GNCHUB Modular Library
    Modul  : ExecutorDetection
    Layer  : 0
    Require: (tidak ada)
    Ekspor : ExecutorDetection
--]]

local ExecutorDetection = {
    DetectedExecutor = "Unknown",
    IsMobile = false,
    IsPC = false,
    Capabilities = {}
}

function ExecutorDetection:DetectExecutor()
    local detectedName = "Unknown"
    local isMobile = false
    
    if identifyexecutor then
        local success, result = pcall(identifyexecutor)
        if success and result then
            detectedName = result
        end
    end
    
    if detectedName == "Unknown" then
        if getexecutorname then
            local success, name = pcall(getexecutorname)
            if success and name then
                detectedName = name
            end
        elseif KRNL_LOADED then
            detectedName = "KRNL"
        elseif syn then
            if syn.cache_replace then
                detectedName = "Synapse Z"
            else
                detectedName = "Synapse X"
            end
        elseif SONA_LOADED then
            detectedName = "Sona"
        elseif issentinel then
            detectedName = "Sentinel"
        elseif PROTOSMASHER_LOADED then
            detectedName = "ProtoSmasher"
        elseif is_sirhurt_closure then
            detectedName = "SirHurt"
        elseif Fluxus then
            detectedName = "Fluxus"
            isMobile = true
        elseif Delta then
            detectedName = "Delta"
            isMobile = true
        elseif hydroxide then
            detectedName = "Hydroxide"
        elseif is_arceus_x or ARCEUS_LOADED then
            detectedName = "Arceus X"
            isMobile = true
        elseif ScriptWare or SCRIPTWARE then
            detectedName = "Script-Ware"
        elseif pebc_execute then
            detectedName = "ProtoSmasher"
        elseif OXYGEN_LOADED then
            detectedName = "Oxygen U"
        elseif IsElectron or Electron then
            detectedName = "Electron"
        elseif TRIGON_LOADED or Trigon then
            detectedName = "Trigon"
        elseif EVON_LOADED or Evon then
            detectedName = "Evon"
        elseif SOLARA_LOADED or Solara then
            detectedName = "Solara"
        elseif WAVE_LOADED or Wave then
            detectedName = "Wave"
        elseif Nezur then
            detectedName = "Nezur"
            isMobile = true
        elseif CODEX_LOADED or Codex then
            detectedName = "Codex"
            isMobile = true
        elseif HYDROGEN_LOADED or Hydrogen then
            detectedName = "Hydrogen"
            isMobile = true
        elseif VALYSE_LOADED then
            detectedName = "Valyse"
            isMobile = true
        elseif AndroidXExecutor then
            detectedName = "Android X"
            isMobile = true
        elseif ZORARA_LOADED then
            detectedName = "Zorara"
            isMobile = true
        elseif COMETRBX then
            detectedName = "Comet"
            isMobile = true
        elseif Xeno then
            detectedName = "Xeno"
            isMobile = true
        elseif XENO_LOADED then
            detectedName = "Xeno"
            isMobile = true
        elseif isexecutorclosure then
            detectedName = "Generic Executor"
        elseif checkcaller then
            detectedName = "Generic Executor"
        elseif getnamecallmethod then
            detectedName = "Generic Executor"
        end
    end
    
    local mobileKeywords = {"Arceus", "Fluxus", "Delta", "Codex", "Hydrogen", "Nezur", "Valyse", "Android", "Zorara", "Comet", "Xeno"}
    for _, keyword in ipairs(mobileKeywords) do
        if string.find(detectedName, keyword) then
            isMobile = true
            break
        end
    end
    
    self.DetectedExecutor = detectedName
    self.IsMobile = isMobile
    self.IsPC = not isMobile
    
    self:DetectCapabilities()
    
    return detectedName, isMobile
end

function ExecutorDetection:DetectCapabilities()
    self.Capabilities = {
        getgenv = getgenv ~= nil,
        setclipboard = (setclipboard or toclipboard) ~= nil,
        request = (request or http_request or (syn and syn.request)) ~= nil,
        writefile = writefile ~= nil,
        readfile = readfile ~= nil,
        makefolder = makefolder ~= nil,
        isfolder = isfolder ~= nil,
        delfile = delfile ~= nil,
        gethwid = gethwid ~= nil,
        isfile = isfile ~= nil,
        listfiles = listfiles ~= nil,
        drawing = Drawing ~= nil,
        websocket = (syn and syn.websocket) or WebSocket ~= nil,
        getloadedmodules = getloadedmodules ~= nil,
        getcallingscript = getcallingscript ~= nil,
        hookmetamethod = hookmetamethod ~= nil,
        hookfunction = hookfunction ~= nil,
        firesignal = firesignal ~= nil,
        getconnections = getconnections ~= nil
    }
end

function ExecutorDetection:GetAdaptedFunction(functionName)
    if functionName == "setclipboard" then
        return setclipboard or toclipboard or function() end
    elseif functionName == "request" then
        return request or http_request or (syn and syn.request) or nil
    elseif functionName == "gethwid" then
        return gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
    elseif functionName == "getgenv" then
        return getgenv or function() return _G end
    elseif functionName == "writefile" then
        return writefile or function() end
    elseif functionName == "readfile" then
        return readfile or function() return "" end
    elseif functionName == "makefolder" then
        return makefolder or function() end
    elseif functionName == "isfolder" then
        return isfolder or function() return false end
    elseif functionName == "isfile" then
        return isfile or function() return false end
    elseif functionName == "listfiles" then
        return listfiles or function() return {} end
    elseif functionName == "delfile" then
        return delfile or function() end
    end
    return function() end
end

function ExecutorDetection:HasHTTPSupport()
    return (request or http_request or (syn and syn.request)) ~= nil
end

ExecutorDetection:DetectExecutor()

return ExecutorDetection

end)

__DEF("GNCHUB.core.safe_wrappers", function()
-- File: GNCHUB/core/safe_wrappers.lua
--[[
    GNCHUB Modular Library
    Modul  : SafeWrappers
    Layer  : 0
    Require: (tidak ada)
    Ekspor : { SafeEnum, SafeColor3, SafeUDim2, SafeVector2, SafeUDim, SafeRect }
--]]

local SafeEnum = Enum or {
    Font = {
        GothamSemibold = "GothamSemibold",
        GothamBold = "GothamBold",
        Gotham = "Gotham"
    },
    EasingStyle = {
        Quad = "Quad",
        Sine = "Sine",
        Quart = "Quart",
        Quint = "Quint",
        Back = "Back",
        Bounce = "Bounce",
        Elastic = "Elastic"
    },
    EasingDirection = {
        Out = "Out",
        In = "In",
        InOut = "InOut"
    },
    TextXAlignment = {
        Left = "Left",
        Center = "Center",
        Right = "Right"
    },
    TextYAlignment = {
        Top = "Top",
        Center = "Center",
        Bottom = "Bottom"
    },
    ZIndexBehavior = {
        Sibling = "Sibling"
    },
    FillDirection = {
        Horizontal = "Horizontal",
        Vertical = "Vertical"
    },
    HorizontalAlignment = {
        Left = "Left",
        Center = "Center",
        Right = "Right"
    },
    VerticalAlignment = {
        Top = "Top",
        Center = "Center",
        Bottom = "Bottom"
    },
    SortOrder = {
        LayoutOrder = "LayoutOrder"
    },
    AutomaticSize = {
        Y = "Y",
        X = "X",
        XY = "XY"
    },
    UserInputType = {
        MouseButton1 = "MouseButton1",
        MouseMovement = "MouseMovement",
        Touch = "Touch"
    }
}

local SafeColor3 = Color3 or {
    fromRGB = function(r, g, b)
        return {R = r/255, G = g/255, B = b/255}
    end
}

local SafeUDim2 = UDim2 or {
    new = function(xScale, xOffset, yScale, yOffset)
        return {
            X = {Scale = xScale or 0, Offset = xOffset or 0},
            Y = {Scale = yScale or 0, Offset = yOffset or 0}
        }
    end,
    fromScale = function(xScale, yScale)
        return {
            X = {Scale = xScale or 0, Offset = 0},
            Y = {Scale = yScale or 0, Offset = 0}
        }
    end
}

local SafeVector2 = Vector2 or {
    new = function(x, y)
        return {X = x or 0, Y = y or 0}
    end
}

local SafeUDim = UDim or {
    new = function(scale, offset)
        return {Scale = scale or 0, Offset = offset or 0}
    end
}

local SafeRect = Rect or {
    new = function(x1, y1, x2, y2)
        return {Min = {X = x1, Y = y1}, Max = {X = x2, Y = y2}}
    end
}

return {
    SafeEnum    = SafeEnum,
    SafeColor3  = SafeColor3,
    SafeUDim2   = SafeUDim2,
    SafeVector2 = SafeVector2,
    SafeUDim    = SafeUDim,
    SafeRect    = SafeRect,
}

end)

__DEF("GNCHUB.features.config_system", function()
-- File: GNCHUB/features/config_system.lua
--[[
    GNCHUB Modular Library
    Modul  : Config System
    Layer  : 4
    Require: (deps)
    Ekspor : SetupConfigSystem(Window, deps)
--]]

local function SetupConfigSystem(Window, deps)
    local ConfigElements      = Window.ConfigElements
    local ConfigFolder        = Window.ConfigFolder
    local EnsureConfigFolders = Window.EnsureConfigFolders
    local AutoLoadConfigFile  = Window.AutoLoadConfigFile

    function Window:SaveConfig(configName)
        if not writefile or not makefolder or not isfolder then
            warn("File functions not available in this executor")
            self:Notify("Error", "Config system not supported by your executor", 3)
            return false
        end
        
        if not configName or configName == "" then
            self:Notify("Error", "Please provide a config name", 3)
            return false
        end
        
        EnsureConfigFolders()
        
        local configData = {}
        
        for id, element in pairs(ConfigElements) do
            if element.Type == "Toggle" then
                configData[id] = {
                    Type = "Toggle",
                    Value = element.Value
                }
            elseif element.Type == "Textbox" then
                configData[id] = {
                    Type = "Textbox",
                    Value = element.Value
                }
            elseif element.Type == "Dropdown" then
                configData[id] = {
                    Type = "Dropdown",
                    Value = element.Value,
                    Multiple = element.Multiple
                }
            elseif element.Type == "Slider" then
                configData[id] = {
                    Type = "Slider",
                    Value = element.Value
                }
            end
        end
        
        local success, encoded = pcall(function()
            return game:GetService("HttpService"):JSONEncode(configData)
        end)
        
        if not success then
            self:Notify("Error", "Failed to encode config data", 3)
            return false
        end
        
        local fileName = ConfigFolder .. "/" .. configName .. ".json"
        writefile(fileName, encoded)
        self:Notify("Success", "Config '" .. configName .. "' saved!", 3)
        return true
    end

    function Window:LoadConfig(configName)
        if not readfile or not isfile then
            warn("File functions not available in this executor")
            self:Notify("Error", "Config system not supported by your executor", 3)
            return false
        end
        
        if not configName or configName == "" then
            self:Notify("Error", "Please provide a config name", 3)
            return false
        end
        
        local fileName = ConfigFolder .. "/" .. configName .. ".json"
        
        if not isfile(fileName) then
            self:Notify("Error", "Config '" .. configName .. "' not found", 3)
            return false
        end
        
        local success, fileContent = pcall(function()
            return readfile(fileName)
        end)
        
        if not success then
            self:Notify("Error", "Failed to read config file", 3)
            return false
        end
        
        local decoded
        success, decoded = pcall(function()
            return game:GetService("HttpService"):JSONDecode(fileContent)
        end)
        
        if not success then
            self:Notify("Error", "Failed to decode config data", 3)
            return false
        end
        
        for id, data in pairs(decoded) do
            local element = ConfigElements[id]
            if element then
                if data.Type == "Toggle" and element.Type == "Toggle" then
                    if element.Set then
                        element:Set(data.Value, true)
                    end
                elseif data.Type == "Textbox" and element.Type == "Textbox" then
                    if element.Set then
                        element:Set(data.Value, true)
                    end
                elseif data.Type == "Dropdown" and element.Type == "Dropdown" then
                    if element.Set then
                        element:Set(data.Value, true)
                    end
                elseif data.Type == "Slider" and element.Type == "Slider" then
                    if element.Set then
                        element:Set(data.Value, true)
                    end
                end
            end
        end
        
        self:Notify("Success", "Config loaded successfully!", 3)
        return true
    end

    function Window:GetSavedConfigs()
        if not isfolder or not listfiles then
            return {}
        end
        
        if not isfolder(ConfigFolder) then
            return {}
        end
        
        local success, files = pcall(function()
            return listfiles(ConfigFolder)
        end)
        
        if not success then
            return {}
        end
        
        local configs = {}
        for _, file in ipairs(files) do
            local fileName = file:match("([^/\\]+)$")
            if fileName and fileName:match("%.json$") and fileName ~= "autoload.txt" then
                local configName = fileName:gsub("%.json$", "")
                table.insert(configs, configName)
            end
        end
        
        return configs
    end

    function Window:DeleteConfig(configName)
        if not delfile or not isfile then
            self:Notify("Error", "Config system not supported by your executor", 3)
            return false
        end
        
        if not configName or configName == "" then
            self:Notify("Error", "Please provide a config name", 3)
            return false
        end
        
        local fileName = ConfigFolder .. "/" .. configName .. ".json"
        
        if not isfile(fileName) then
            self:Notify("Error", "Config '" .. configName .. "' not found", 3)
            return false
        end
        
        delfile(fileName)
        self:Notify("Success", "Config '" .. configName .. "' deleted!", 3)
        return true
    end

    function Window:SetAutoLoadConfig(configName)
        if not writefile or not makefolder or not isfolder then
            self:Notify("Error", "Config system not supported by your executor", 3)
            return false
        end
        
        if not configName or configName == "" then
            self:Notify("Error", "Please provide a config name", 3)
            return false
        end
        
        local fileName = ConfigFolder .. "/" .. configName .. ".json"
        if not isfile(fileName) then
            self:Notify("Error", "Config '" .. configName .. "' not found", 3)
            return false
        end
        
        EnsureConfigFolders()
        
        writefile(AutoLoadConfigFile, configName)
        self:Notify("Success", "Auto-load set to '" .. configName .. "'", 3)
        return true
    end

    function Window:ResetAutoLoadConfig()
        if not delfile or not isfile then
            self:Notify("Error", "Config system not supported by your executor", 3)
            return false
        end
        
        if isfile(AutoLoadConfigFile) then
            delfile(AutoLoadConfigFile)
        end
        
        self:Notify("Success", "Auto-load config reset!", 3)
        return true
    end

    function Window:GetAutoLoadConfig()
        if not readfile or not isfile then
            return nil
        end
        
        if not isfile(AutoLoadConfigFile) then
            return nil
        end
        
        local success, configName = pcall(function()
            return readfile(AutoLoadConfigFile)
        end)
        
        if success and configName and configName ~= "" then
            return configName
        end
        
        return nil
    end

    function Window:RegisterConfigElement(tabName, sectionName, elementName, element)
        if not element or not element.Type then
            return
        end
        
        local id = tabName .. "." .. sectionName .. "." .. elementName
        ConfigElements[id] = element
    end

    task.spawn(function()
        task.wait(2)
        local autoLoadConfig = Window:GetAutoLoadConfig()
        if autoLoadConfig then
            Window:LoadConfig(autoLoadConfig)
        end
    end)
end

return { SetupConfigSystem = SetupConfigSystem }

end)

__DEF("GNCHUB.features.notify", function()
-- File: GNCHUB/features/notify.lua
--[[
    GNCHUB Modular Library
    Modul  : Notify & Tab Locks
    Layer  : 4
    Require: (deps)
    Ekspor : SetupNotify(Window, deps)
--]]

local function SetupNotify(Window, deps)
    local CreateElement       = deps.CreateElement
    local Config              = deps.Config
    local SafeW               = deps.SafeW
    local TweenService        = deps.TweenService
    local ScrollToElement     = deps.ScrollToElement
    
    local SafeEnum   = SafeW.SafeEnum
    local SafeUDim2  = SafeW.SafeUDim2
    local SafeUDim   = SafeW.SafeUDim
    local SafeColor3 = SafeW.SafeColor3

    local ScreenGui = Window.ScreenGui
    local Tabs = Window.Tabs
    local ContentContainer = Window.ContentContainer
    local TabScroller = Window.TabScroller

    local NotificationContainer = nil
    local NotificationQueue = {}
    local ActiveNotifications = {}

    local function CreateNotificationContainer()
        if NotificationContainer then return end

        NotificationContainer = CreateElement("Frame", {
            Name = "NotificationContainer",
            Parent = ScreenGui,
            AnchorPoint = Vector2.new(1, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 1, 0),
            Size = UDim2.new(0, 262, 0, 100),
            Visible = true,
            ZIndex = 200
        })

        local NotificationPadding = CreateElement("UIPadding", {
            Parent = NotificationContainer,
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 0),
            PaddingRight = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 0),
        })

        local NotificationLayout = CreateElement("UIListLayout", {
            Parent = NotificationContainer,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8),
        })
    end

    function Window:Notify(title, message, duration)
        title = title or "Notification"
        message = message or ""
        duration = duration or 3

        CreateNotificationContainer()

        local NotificationFrame = CreateElement("CanvasGroup", {
            Name = "Notification",
            Parent = NotificationContainer,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(9, 9, 9),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(1, -10, 0.5, -150),
            AnchorPoint = Vector2.new(1, 0.5),
            Visible = true,
            LayoutOrder = #ActiveNotifications + 1,
            ZIndex = 201
        })
        CreateElement("UICorner", { CornerRadius = UDim.new(0, 6), Parent = NotificationFrame })
        CreateElement("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            Color = Color3.fromRGB(23, 23, 23),
            Thickness = 1,
            Parent = NotificationFrame
        })

        local HolderIn = CreateElement("Frame", {
            Name = "HolderIn",
            Parent = NotificationFrame,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            Visible = true,
        })
        CreateElement("UIPadding", {
            Parent = HolderIn,
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 12),
        })
        CreateElement("UIListLayout", {
            Parent = HolderIn,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local TopFrame = CreateElement("Frame", {
            Name = "TopFrame",
            Parent = HolderIn,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            Visible = true,
        })

        local UserIcon = CreateElement("ImageLabel", {
            Name = "UserIcon",
            Parent = TopFrame,
            Image = "rbxassetid://10723415903",
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 18, 0, 18),
            Visible = true,
        })

        local CloseButton = CreateElement("TextButton", {
            Name = "CloseButton",
            Parent = NotificationFrame,
            Text = "×",
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -25, 0, 5),
            ZIndex = 204
        })

        local TitleLabel = CreateElement("TextLabel", {
            Name = "Title",
            Parent = TopFrame,
            Font = Enum.Font.GothamMedium,
            LineHeight = 1.2,
            RichText = true,
            TextColor3 = Color3.fromRGB(225, 225, 225),
            TextSize = 18,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            Text = title,
            Visible = true,
            ZIndex = 203
        })
        CreateElement("UIPadding", {
            Parent = TitleLabel,
            PaddingLeft = UDim.new(0, 24),
        })

        local MessageLabel = CreateElement("TextLabel", {
            Name = "Message",
            Parent = HolderIn,
            Font = Enum.Font.Gotham,
            RichText = true,
            TextColor3 = Color3.fromRGB(225, 225, 225),
            TextSize = 16,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            AutomaticSize = Enum.AutomaticSize.XY,
            LayoutOrder = 1,
            BackgroundTransparency = 1,
            Text = message,
            Visible = true,
            ZIndex = 203
        })

        local ProgressFrame = CreateElement("Frame", {
            Name = "ProgressFrame",
            Parent = NotificationFrame,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 2),
            Visible = true,
            ZIndex = 202
        })
        CreateElement("UICorner", {
            Parent = ProgressFrame,
            CornerRadius = UDim.new(1, 0),
        })

        local ProgressIndicator = CreateElement("Frame", {
            Name = "ProgressIndicator",
            Parent = ProgressFrame,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 0, 2),
            Visible = true,
            ZIndex = 203
        })
        CreateElement("UICorner", {
            Parent = ProgressIndicator,
            CornerRadius = UDim.new(1, 0),
        })

        table.insert(ActiveNotifications, NotificationFrame)

        local function CloseNotification()
            for i, notif in ipairs(ActiveNotifications) do
                if notif == NotificationFrame then
                    table.remove(ActiveNotifications, i)
                    break
                end
            end

            if NotificationFrame and NotificationFrame.Parent then
                NotificationFrame:Destroy()
            end
        end

        spawn(function()
            pcall(function()
                if game:GetService("TweenService") then
                    local TS = game:GetService("TweenService")
                    local fadeInTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                    local fadeInTween = TS:Create(NotificationFrame, fadeInTweenInfo, {BackgroundTransparency = 0.4})
                    fadeInTween:Play()

                    local fadeInTweenTitle = TS:Create(TitleLabel, fadeInTweenInfo, {TextTransparency = 0})
                    fadeInTweenTitle:Play()

                    local fadeInTweenMessage = TS:Create(MessageLabel, fadeInTweenInfo, {TextTransparency = 0})
                    fadeInTweenMessage:Play()

                    local fadeInTweenIcon = TS:Create(UserIcon, fadeInTweenInfo, {ImageTransparency = 0})
                    fadeInTweenIcon:Play()

                    local progressTweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                    local progressTween = TS:Create(ProgressIndicator, progressTweenInfo, {Size = UDim2.new(0, 0, 0, 2)})
                    progressTween:Play()

                    progressTween.Completed:Connect(function()
                        CloseNotification()
                    end)
                else
                    local waitFunc = task and task.wait or wait
                    if waitFunc then
                        waitFunc(duration)
                        CloseNotification()
                    end
                end
            end)
        end)

        spawn(function()
            pcall(function()
                local waitFunc = task and task.wait or wait
                if waitFunc then
                    waitFunc(duration + 1)
                    if NotificationFrame and NotificationFrame.Parent then
                        CloseNotification()
                    end
                end
            end)
        end)

        if CloseButton and CloseButton.MouseButton1Click then
            CloseButton.MouseButton1Click:Connect(CloseNotification)
        end

        return {
            Close = CloseNotification,
            SetTitle = function(newTitle)
                if TitleLabel then TitleLabel.Text = newTitle end
            end,
            SetMessage = function(newMessage)
                if MessageLabel then MessageLabel.Text = newMessage end
            end
        }
    end

    function Window:LockTab(tabName, lockMessage, lockIcon)
        lockMessage = lockMessage or "This tab is locked. because you are not a premium user"
        lockIcon = lockIcon or "rbxassetid://72426107706105"

        for _, tab in pairs(Tabs) do
            if tab.Name == tabName then
                tab.IsLocked = true
                tab.LockMessage = lockMessage
                tab.LockIcon = lockIcon

                if tab.LockIconElement and tab.Icon then
                    tab.Icon.Visible = false
                    tab.LockIconElement.Visible = true

                    tab.LockIconElement.Image = lockIcon
                    tab.LockIconElement.ImageColor3 = tab.Selected and SafeColor3.fromRGB(255, 255, 255) or SafeColor3.fromRGB(180, 180, 185)
                end

                break
            end
        end
    end

    function Window:UnlockTab(tabName)
        for _, tab in pairs(Tabs) do
            if tab.Name == tabName then
                tab.IsLocked = false

                if tab.LockIconElement and tab.Icon then
                    tab.LockIconElement.Visible = false
                    tab.Icon.Visible = true
                end

                local function SelectUnlockedTab()
                    if not ContentContainer.Visible then return end

                    for _, existingTab in pairs(Tabs) do
                        if existingTab.Label and existingTab.Icon and existingTab.SelectionBackground then
                            TweenService:Create(
                                existingTab.Label,
                                TweenInfo.new(0.25, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                                { TextColor3 = SafeColor3.fromRGB(180, 180, 185) }
                            ):Play()

                            TweenService:Create(
                                existingTab.Icon,
                                TweenInfo.new(0.25, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                                { ImageColor3 = SafeColor3.fromRGB(180, 180, 185) }
                            ):Play()

                            if existingTab.LockIconElement then
                                TweenService:Create(
                                    existingTab.LockIconElement,
                                    TweenInfo.new(0.25, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                                    { ImageColor3 = SafeColor3.fromRGB(180, 180, 185) }
                                ):Play()
                            end

                            TweenService:Create(
                                existingTab.SelectionBackground,
                                TweenInfo.new(0.25, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                                { BackgroundTransparency = 1 }
                            ):Play()

                            TweenService:Create(
                                existingTab.Button,
                                TweenInfo.new(0.25, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                                { BackgroundTransparency = 0.95 }
                            ):Play()

                            existingTab.Page.Visible = false
                            existingTab.Selected = false
                        end
                    end

                    TweenService:Create(
                        tab.Label,
                        TweenInfo.new(0.3, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                        { TextColor3 = SafeColor3.fromRGB(255, 255, 255) }
                    ):Play()

                    TweenService:Create(
                        tab.Icon,
                        TweenInfo.new(0.3, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                        { ImageColor3 = SafeColor3.fromRGB(255, 255, 255) }
                    ):Play()

                    TweenService:Create(
                        tab.SelectionBackground,
                        TweenInfo.new(0.3, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                        { BackgroundTransparency = 0.9 }
                    ):Play()

                    TweenService:Create(
                        tab.Button,
                        TweenInfo.new(0.3, SafeEnum.EasingStyle.Quart, SafeEnum.EasingDirection.Out),
                        { BackgroundTransparency = 0.85 }
                    ):Play()

                    tab.Selected = true
                    -- Note: CurrentTab is a local in Window, we just set the tab fields.
                    -- If we need to update CurrentTab, it's not strictly necessary for this UI tween to work, 
                    -- but ideally we should update it. We can't access it easily here unless we pass it,
                    -- but GNCHUB monolithic code just changed it.
                    tab.Page.Visible = true

                    if ScrollToElement and TabScroller then
                        ScrollToElement(TabScroller, tab.Button)
                    end
                end

                SelectUnlockedTab()
                break
            end
        end
    end
end

return { SetupNotify = SetupNotify }

end)

__DEF("GNCHUB.keysystem.panda", function()
-- File: GNCHUB/keysystem/panda.lua
--[[
    GNCHUB Modular Library
    Modul  : PandaDev (KeySystem Backend)
    Layer  : 1
    Require: core/executor
    Ekspor : PandaDev  — PandaDev.New(serviceName) -> service object
--]]

local Executor = __REQUIRE("GNCHUB.core.executor")

local fSetClipboard = Executor:GetAdaptedFunction("setclipboard")
local fRequest      = Executor:GetAdaptedFunction("request")
local fToString     = tostring
local fGetHwid      = Executor:GetAdaptedFunction("gethwid")
local fWriteFile    = Executor:GetAdaptedFunction("writefile")
local fReadFile     = Executor:GetAdaptedFunction("readfile")
local fMakeFolder   = Executor:GetAdaptedFunction("makefolder")
local fIsFile       = Executor:GetAdaptedFunction("isfile")

-- onMessage: will be set from ui.lua; default is a no-op
local onMessage = function(msg) end

local PandaDev = {}

function PandaDev.SetMessageHandler(handler)
    onMessage = handler
end

function PandaDev.New(serviceName)
    local hwid = fGetHwid()
    local keyStorageFolder = "GNCHUB_KEYS"
    local keyStorageFile = keyStorageFolder .. "/" .. serviceName .. "_key.json"

    local function EncryptData(data)
        local encryptionKey = tostring(hwid) .. serviceName .. "GNCHUB_SECRET"
        local encrypted = {}
        local keyLen = #encryptionKey
        for i = 1, #data do
            local charCode = string.byte(data, i)
            local keyChar = string.byte(encryptionKey, ((i - 1) % keyLen) + 1)
            encrypted[i] = string.char(bit32.bxor(charCode, keyChar))
        end
        local encryptedStr = table.concat(encrypted)
        local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local result = {}
        for i = 1, #encryptedStr, 3 do
            local b1, b2, b3 = string.byte(encryptedStr, i, i + 2)
            b2 = b2 or 0
            b3 = b3 or 0
            local n = b1 * 65536 + b2 * 256 + b3
            local c1 = bit32.extract(n, 18, 6)
            local c2 = bit32.extract(n, 12, 6)
            local c3 = bit32.extract(n, 6, 6)
            local c4 = bit32.extract(n, 0, 6)
            result[#result + 1] = string.sub(base64Chars, c1 + 1, c1 + 1)
            result[#result + 1] = string.sub(base64Chars, c2 + 1, c2 + 1)
            result[#result + 1] = string.sub(base64Chars, c3 + 1, c3 + 1)
            result[#result + 1] = string.sub(base64Chars, c4 + 1, c4 + 1)
        end
        local padding = (3 - (#encryptedStr % 3)) % 3
        for i = 1, padding do
            result[#result - i + 1] = "="
        end
        return table.concat(result)
    end

    local function DecryptData(encodedData)
        if not encodedData or encodedData == "" then
            return nil
        end
        local encryptionKey = tostring(hwid) .. serviceName .. "GNCHUB_SECRET"
        local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        encodedData = string.gsub(encodedData, "[^" .. base64Chars .. "=]", "")
        local decoded = {}
        for i = 1, #encodedData, 4 do
            local c1, c2, c3, c4 = string.byte(encodedData, i, i + 3)
            local n1 = string.find(base64Chars, string.char(c1)) - 1
            local n2 = string.find(base64Chars, string.char(c2)) - 1
            local n3 = c3 and string.find(base64Chars, string.char(c3))
            local n4 = c4 and string.find(base64Chars, string.char(c4))
            n3 = n3 and (n3 - 1) or 0
            n4 = n4 and (n4 - 1) or 0
            local n = n1 * 262144 + n2 * 4096 + n3 * 64 + n4
            local b1 = bit32.extract(n, 16, 8)
            local b2 = bit32.extract(n, 8, 8)
            local b3 = bit32.extract(n, 0, 8)
            decoded[#decoded + 1] = string.char(b1)
            if c3 ~= 61 then
                decoded[#decoded + 1] = string.char(b2)
            end
            if c4 ~= 61 then
                decoded[#decoded + 1] = string.char(b3)
            end
        end
        local encryptedStr = table.concat(decoded)
        local decrypted = {}
        local keyLen = #encryptionKey
        for i = 1, #encryptedStr do
            local charCode = string.byte(encryptedStr, i)
            local keyChar = string.byte(encryptionKey, ((i - 1) % keyLen) + 1)
            decrypted[i] = string.char(bit32.bxor(charCode, keyChar))
        end
        return table.concat(decrypted)
    end

    local function SaveKeyData(key, expirationTimestamp)
        pcall(function()
            fMakeFolder(keyStorageFolder)
            local keyData = {
                key = key,
                expiration = expirationTimestamp,
                hwid = hwid,
                savedAt = os.time()
            }
            local jsonData = game:GetService("HttpService"):JSONEncode(keyData)
            local encryptedData = EncryptData(jsonData)
            fWriteFile(keyStorageFile, encryptedData)
        end)
    end

    local function LoadKeyData()
        local success, result = pcall(function()
            if fIsFile(keyStorageFile) then
                local fileContent = fReadFile(keyStorageFile)
                if fileContent and fileContent ~= "" then
                    local decryptedData = DecryptData(fileContent)
                    if decryptedData then
                        return game:GetService("HttpService"):JSONDecode(decryptedData)
                    end
                end
            end
            return nil
        end)
        return success and result or nil
    end

    local function IsKeyExpired(expirationTimestamp)
        if not expirationTimestamp then
            return true
        end
        return os.time() >= expirationTimestamp
    end

    local function ValidateKey(key, skipSave)
        if not fRequest then
            return false, "Your executor doesn't support HTTP requests. Please use a different executor like Solara, Wave, or Arceus X."
        end
        
        if not Executor:HasHTTPSupport() then
            return false, "HTTP is not supported on this executor. Try using Solara (PC) or Arceus X (Mobile)."
        end

        local validationUrl = "https://api.pandauth.com/api/v1/keys/validate"
        
        local payload = {
            ServiceID = serviceName,
            HWID = tostring(hwid),
            Key = tostring(key),
        }
        
        local jsonData = game:GetService("HttpService"):JSONEncode(payload)

        local success, response = pcall(function()
            return fRequest({
                Url = validationUrl,
                Method = "POST",
                Headers = {
                    ["User-Agent"] = "Roblox/Exploit",
                    ["Content-Type"] = "application/json",
                },
                Body = jsonData,
            })
        end)

        if not success then
            return false, "Request failed. Make sure your executor supports HTTP and has internet access."
        end
        
        if not response then
            return false, "No response received. Check your internet connection or try a different executor."
        end

        if response.Success or (response.StatusCode and response.StatusCode == 200) then
            local decodeSuccess, responseData = pcall(function()
                return game:GetService("HttpService"):JSONDecode(response.Body)
            end)

            if decodeSuccess and responseData then
                if responseData.Authenticated_Status and responseData.Authenticated_Status == "Success" then
                    if not skipSave then
                        -- Panda's new API might not return Expiry, so default to 30 days if absent
                        local expirationTimestamp = nil
                        if responseData.Key_Information and responseData.Key_Information.Expiry then
                            expirationTimestamp = tonumber(responseData.Key_Information.Expiry)
                        else
                            expirationTimestamp = os.time() + (30 * 24 * 60 * 60)
                        end
                        SaveKeyData(key, expirationTimestamp)
                    end
                    return true, "Authenticated", responseData
                else
                    local reason = responseData.Note or (responseData.Key_Information and responseData.Key_Information.Notes) or "Invalid or expired key"
                    return false, "Key verification failed: " .. reason
                end
            else
                return false, "Unable to verify key. Server response error. Please try again."
            end
        else
            local errorMsg = "Connection failed. Please check your internet."
            if response.StatusCode then
                errorMsg = "Server error (Code: " .. response.StatusCode .. "). Try again later."
            elseif response.StatusMessage and response.StatusMessage ~= "" then
                errorMsg = "Connection error: " .. response.StatusMessage
            end
            return false, errorMsg
        end
    end

    local function CheckSavedKey()
        local savedData = LoadKeyData()
        if savedData and savedData.key and savedData.expiration and savedData.hwid == hwid then
            if not IsKeyExpired(savedData.expiration) then
                local success, message = ValidateKey(savedData.key, true)
                if success then
                    return true, savedData.key
                end
            end
        end
        return false, nil
    end

    local function GetKeyLink()
        return "https://new.pandadevelopment.net/getkey/" .. tostring(serviceName) .. "?hwid=" .. tostring(hwid)
    end

    local function CopyLink()
        fSetClipboard(GetKeyLink())
        onMessage("Key link copied! Open it in your browser.")
    end

    return {
        Verify     = ValidateKey,
        Copy       = CopyLink,
        GetLink    = GetKeyLink,
        CheckSaved = CheckSavedKey
    }
end

return PandaDev

end)

__DEF("GNCHUB.keysystem.platoboost", function()
-- File: GNCHUB/keysystem/platoboost.lua
--[[
    GNCHUB Modular Library
    Modul  : Platoboost (KeySystem Backend)
    Layer  : 1
    Require: core/executor
    Ekspor : Platoboost — Platoboost.New(service, secret, useNonce) -> service object
--]]

local Executor = __REQUIRE("GNCHUB.core.executor")

-- ==============================================================================
-- 1. Pure Lua Cryptography & JSON Libraries (Embedded from Platoboost SDK)
-- ==============================================================================
local a = 2^32; local b = a - 1
local function c(d, e)
    local f, g = 0, 1
    while d ~= 0 or e ~= 0 do
        local h, i = d % 2, e % 2
        local j = (h + i) % 2
        f = f + j * g
        d = math.floor(d / 2)
        e = math.floor(e / 2)
        g = g * 2
    end
    return f % a
end

local function k(d, e, l, ...)
    local m
    if e then
        d = d % a; e = e % a; m = c(d, e)
        if l then m = k(m, l, ...) end
        return m
    elseif d then
        return d % a
    else
        return 0
    end
end

local function n(d, e, l, ...)
    local m
    if e then
        d = d % a; e = e % a; m = (d + e - c(d, e)) / 2
        if l then m = n(m, l, ...) end
        return m
    elseif d then
        return d % a
    else
        return b
    end
end

local function o(p) return b - p end
local s, lshift, q
q = function(d, r) if r < 0 then return lshift(d, -r) end return math.floor(d % 2^32 / 2^r) end
s = function(p, r) if r > 31 or r < -31 then return 0 end return q(p % a, r) end
lshift = function(d, r) if r < 0 then return s(d, -r) end return d * 2^r % 2^32 end
local function t(p, r) p = p % a; r = r % 32; local u = n(p, 2^r - 1) return s(p, r) + lshift(u, 32 - r) end

local v = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function w(x) return string.gsub(x, ".", function(l) return string.format("%02x", string.byte(l)) end) end
local function y(z, A) local x = "" for B = 1, A do local C = z % 256; x = string.char(C) .. x; z = (z - C) / 256 end return x end
local function D(x, B) local A = 0 for idx = B, B + 3 do A = A * 256 + string.byte(x, idx) end return A end
local function E(F, G) local H = 64 - (G + 9) % 64; G = y(8 * G, 8); F = F .. "\128" .. string.rep("\0", H) .. G; assert(#F % 64 == 0); return F end
local function I(J) J[1] = 0x6a09e667; J[2] = 0xbb67ae85; J[3] = 0x3c6ef372; J[4] = 0xa54ff53a; J[5] = 0x510e527f; J[6] = 0x9b05688c; J[7] = 0x1f83d9ab; J[8] = 0x5be0cd19; return J end
local function K(F, B, J)
    local L = {}
    for M = 1, 16 do L[M] = D(F, B + (M - 1) * 4) end
    for M = 17, 64 do
        local N = L[M - 15]
        local O = k(t(N, 7), t(N, 18), s(N, 3))
        N = L[M - 2]
        L[M] = (L[M - 16] + O + L[M - 7] + k(t(N, 17), t(N, 19), s(N, 10))) % a
    end
    local d, e, l, P, Q, R, S, T = J[1], J[2], J[3], J[4], J[5], J[6], J[7], J[8]
    for idx = 1, 64 do
        local O = k(t(d, 2), t(d, 13), t(d, 22))
        local U = k(n(d, e), n(d, l), n(e, l))
        local V = (O + U) % a
        local W = k(t(Q, 6), t(Q, 11), t(Q, 25))
        local X = k(n(Q, R), n(o(Q), S))
        local Y = (T + W + X + v[idx] + L[idx]) % a
        T = S; S = R; R = Q; Q = (P + Y) % a; P = l; l = e; e = d; d = (Y + V) % a
    end
    J[1] = (J[1] + d) % a; J[2] = (J[2] + e) % a; J[3] = (J[3] + l) % a; J[4] = (J[4] + P) % a
    J[5] = (J[5] + Q) % a; J[6] = (J[6] + R) % a; J[7] = (J[7] + S) % a; J[8] = (J[8] + T) % a
end

local function Z(F)
    F = E(F, #F)
    local J = I({})
    for B = 1, #F, 64 do K(F, B, J) end
    return w(y(J[1], 4) .. y(J[2], 4) .. y(J[3], 4) .. y(J[4], 4) .. y(J[5], 4) .. y(J[6], 4) .. y(J[7], 4) .. y(J[8], 4))
end

-- Fallback Pure Lua JSON
local e_json
local l_map = {["\\"] = "\\", ["\""] = "\"", ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t"}
local P_map = {["/"] = "/"}
for Q, R in pairs(l_map) do P_map[R] = Q end
local S_esc = function(T) return "\\" .. (l_map[T] or string.format("u%04x", T:byte())) end
local B_null = function(M) return "null" end
local v_tbl = function(M, z)
    local _ = {}
    z = z or {}
    if z[M] then error("circular reference") end
    z[M] = true
    if rawget(M, 1) ~= nil or next(M) == nil then
        local A = 0
        for Q in pairs(M) do
            if type(Q) ~= "number" then error("invalid table: mixed or invalid key types") end
            A = A + 1
        end
        if A ~= #M then error("invalid table: sparse array") end
        for a0, R in ipairs(M) do table.insert(_, e_json(R, z)) end
        z[M] = nil
        return "[" .. table.concat(_, ",") .. "]"
    else
        for Q, R in pairs(M) do
            if type(Q) ~= "string" then error("invalid table: mixed or invalid key types") end
            table.insert(_, e_json(Q, z) .. ":" .. e_json(R, z))
        end
        z[M] = nil
        return "{" .. table.concat(_, ",") .. "}"
    end
end
local g_str = function(M) return '"' .. M:gsub('[%z\1-\31\\"]', S_esc) .. '"' end
local a1_num = function(M)
    if M ~= M or M <= -math.huge or M >= math.huge then error("unexpected number value '" .. tostring(M) .. "'") end
    return string.format("%.14g", M)
end
local j_types = {["nil"] = B_null, ["table"] = v_tbl, ["string"] = g_str, ["number"] = a1_num, ["boolean"] = tostring}
e_json = function(M, z)
    local x = type(M)
    local a2 = j_types[x]
    if a2 then return a2(M, z) end
    error("unexpected type '" .. x .. "'")
end
local a3 = function(M) return e_json(M) end

local a4
local N_set = function(...) local _ = {} for a0 = 1, select("#", ...) do _[select(a0, ...)] = true end return _ end
local L_ws = N_set(" ", "\t", "\r", "\n")
local p_delim = N_set(" ", "\t", "\r", "\n", "]", "}", ",")
local a5_esc = N_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local m_lit = N_set("true", "false", "null")
local a6_val = {["true"] = true, ["false"] = false, ["null"] = nil}
local a7_next = function(a8, a9, aa, ab) for a0 = a9, #a8 do if aa[a8:sub(a0, a0)] ~= ab then return a0 end end return #a8 + 1 end
local ac_err = function(a8, a9, J)
    local ad, ae = 1, 1
    for a0 = 1, a9 - 1 do ae = ae + 1 if a8:sub(a0, a0) == "\n" then ad = ad + 1; ae = 1 end end
    error(string.format("%s at line %d col %d", J, ad, ae))
end
local af_cp = function(A)
    local a2 = math.floor
    if A <= 0x7f then return string.char(A)
    elseif A <= 0x7ff then return string.char(a2(A / 64) + 192, A % 64 + 128)
    elseif A <= 0xffff then return string.char(a2(A / 4096) + 224, a2(A % 4096 / 64) + 128, A % 64 + 128)
    elseif A <= 0x10ffff then return string.char(a2(A / 262144) + 240, a2(A % 262144 / 4096) + 128, a2(A % 4096 / 64) + 128, A % 64 + 128) end
    error(string.format("invalid unicode codepoint '%x'", A))
end
local ag_uni = function(ah)
    local ai = tonumber(ah:sub(1, 4), 16)
    local aj = tonumber(ah:sub(7, 10), 16)
    if aj then return af_cp((ai - 0xd800) * 0x400 + aj - 0xdc00 + 0x10000) else return af_cp(ai) end
end
local ak_str = function(a8, a0)
    local _ = ""
    local al = a0 + 1
    local Q = al
    while al <= #a8 do
        local am = a8:byte(al)
        if am < 32 then ac_err(a8, al, "control character in string")
        elseif am == 92 then
            _ = _ .. a8:sub(Q, al - 1)
            al = al + 1
            local T = a8:sub(al, al)
            if T == "u" then
                local an = a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", al + 1) or a8:match("^%x%x%x%x", al + 1) or ac_err(a8, al - 1, "invalid unicode escape in string")
                _ = _ .. ag_uni(an)
                al = al + #an
            else
                if not a5_esc[T] then ac_err(a8, al - 1, "invalid escape char '" .. T .. "' in string") end
                _ = _ .. P_map[T]
            end
            Q = al + 1
        elseif am == 34 then
            _ = _ .. a8:sub(Q, al - 1)
            return _, al + 1
        end
        al = al + 1
    end
    ac_err(a8, a0, "expected closing quote for string")
end
local ao_num = function(a8, a0) local am = a7_next(a8, a0, p_delim); local ah = a8:sub(a0, am - 1); local A = tonumber(ah); if not A then ac_err(a8, a0, "invalid number '" .. ah .. "'") end return A, am end
local ap_lit = function(a8, a0) local am = a7_next(a8, a0, p_delim); local aq = a8:sub(a0, am - 1); if not m_lit[aq] then ac_err(a8, a0, "invalid literal '" .. aq .. "'") end return a6_val[aq], am end
local ar_arr = function(a8, a0)
    local _ = {}; local A = 1; a0 = a0 + 1
    while true do
        local am
        a0 = a7_next(a8, a0, L_ws, true)
        if a8:sub(a0, a0) == "]" then a0 = a0 + 1; break end
        am, a0 = a4(a8, a0)
        _[A] = am; A = A + 1
        a0 = a7_next(a8, a0, L_ws, true)
        local as = a8:sub(a0, a0)
        a0 = a0 + 1
        if as == "]" then break end
        if as ~= "," then ac_err(a8, a0, "expected ']' or ','") end
    end
    return _, a0
end
local at_obj = function(a8, a0)
    local _ = {}; a0 = a0 + 1
    while true do
        local au, M
        a0 = a7_next(a8, a0, L_ws, true)
        if a8:sub(a0, a0) == "}" then a0 = a0 + 1; break end
        if a8:sub(a0, a0) ~= '"' then ac_err(a8, a0, "expected string for key") end
        au, a0 = a4(a8, a0)
        a0 = a7_next(a8, a0, L_ws, true)
        if a8:sub(a0, a0) ~= ":" then ac_err(a8, a0, "expected ':' after key") end
        a0 = a7_next(a8, a0 + 1, L_ws, true)
        M, a0 = a4(a8, a0)
        _[au] = M
        a0 = a7_next(a8, a0, L_ws, true)
        local as = a8:sub(a0, a0)
        a0 = a0 + 1
        if as == "}" then break end
        if as ~= "," then ac_err(a8, a0, "expected '}' or ','") end
    end
    return _, a0
end
local av_chars = {['"'] = ak_str, ["0"] = ao_num, ["1"] = ao_num, ["2"] = ao_num, ["3"] = ao_num, ["4"] = ao_num, ["5"] = ao_num, ["6"] = ao_num, ["7"] = ao_num, ["8"] = ao_num, ["9"] = ao_num, ["-"] = ao_num, ["t"] = ap_lit, ["f"] = ap_lit, ["n"] = ap_lit, ["["] = ar_arr, ["{"] = at_obj}
a4 = function(a8, a9) local as = a8:sub(a9, a9); local a2 = av_chars[as]; if a2 then return a2(a8, a9) end ac_err(a8, a9, "unexpected character '" .. as .. "'") end
local aw = function(a8)
    if type(a8) ~= "string" then error("expected argument of type string, got " .. type(a8)) end
    local _, a9 = a4(a8, a7_next(a8, 1, L_ws, true))
    a9 = a7_next(a8, a9, L_ws, true)
    if a9 <= #a8 then ac_err(a8, a9, "trailing garbage") end
    return _
end

local lEncode, lDecode, lDigest = a3, aw, Z

-- JSON wrapper with HttpService acceleration and pure Lua fallback
local HttpService = nil
if game and game.GetService then
    pcall(function()
        HttpService = game:GetService("HttpService")
    end)
end

local function jsonEncode(tbl)
    if HttpService then
        local ok, res = pcall(function() return HttpService:JSONEncode(tbl) end)
        if ok and res then return res end
    end
    return lEncode(tbl)
end

local function jsonDecode(str)
    if HttpService then
        local ok, res = pcall(function() return HttpService:JSONDecode(str) end)
        if ok and res then return res end
    end
    return lDecode(str)
end

-- ==============================================================================
-- 2. Platoboost KeySystem Module
-- ==============================================================================
local fSetClipboard = Executor:GetAdaptedFunction("setclipboard")
local fRequest      = Executor:GetAdaptedFunction("request")
local fGetHwid      = Executor:GetAdaptedFunction("gethwid")
local fWriteFile    = Executor:GetAdaptedFunction("writefile")
local fReadFile     = Executor:GetAdaptedFunction("readfile")
local fMakeFolder   = Executor:GetAdaptedFunction("makefolder")
local fIsFile       = Executor:GetAdaptedFunction("isfile")

local fStringChar   = string.char
local fToString     = tostring
local fStringSub    = string.sub
local fOsTime       = os.time
local fMathRandom   = math.random
local fMathFloor    = math.floor

local onMessage = function(msg) end

local Platoboost = {}

function Platoboost.SetMessageHandler(handler)
    if type(handler) == "function" then
        onMessage = handler
    end
end

-- Platoboost.New: creates a new Platoboost service client instance
-- Parameters:
--   serviceParam: service ID (number or string) or table with options { ServiceID, Secret, UseNonce }
--   secretParam: secret key (string)
--   useNonceParam: boolean
function Platoboost.New(serviceParam, secretParam, useNonceParam)
    local service = 5677
    local secret = "77098738-af78-4d82-bc48-f69b35f41015"
    local useNonce = true

    if type(serviceParam) == "table" then
        service = serviceParam.ServiceID or serviceParam.service or serviceParam.serviceId or serviceParam.Id or service
        secret = serviceParam.Secret or serviceParam.secret or secret
        if serviceParam.UseNonce ~= nil then
            useNonce = serviceParam.UseNonce
        elseif serviceParam.useNonce ~= nil then
            useNonce = serviceParam.useNonce
        else
            useNonce = (secret ~= nil and secret ~= "")
        end
    elseif serviceParam ~= nil then
        service = serviceParam
        if secretParam ~= nil then
            secret = secretParam
        end
        if useNonceParam ~= nil then
            useNonce = useNonceParam
        else
            useNonce = (secret ~= nil and secret ~= "")
        end
    end

    local hwidRaw = fToString(fGetHwid())
    local hwidDigest = lDigest(hwidRaw)
    local keyStorageFolder = "GNCHUB_KEYS"
    local keyStorageFile = keyStorageFolder .. "/platoboost_" .. fToString(service) .. "_key.json"

    local requestSending = false
    local cachedLink, cachedTime = "", 0
    local selectedHost = nil

    -- Pick host lazily or on demand
    local function getHost()
        if selectedHost then return selectedHost end
        selectedHost = "https://api.platoboost.com"
        if fRequest then
            local ok, hostResponse = pcall(function()
                return fRequest({
                    Url = selectedHost .. "/public/connectivity",
                    Method = "GET"
                })
            end)
            if not ok or not hostResponse or (hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429) then
                selectedHost = "https://api.platoboost.net"
            end
        end
        return selectedHost
    end

    -- Nonce generator (16 lowercase chars)
    local function generateNonce()
        local str = ""
        for _ = 1, 16 do
            str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
        end
        return str
    end

    -- Encrypt data for local caching (XOR + Base64)
    local function EncryptData(data)
        local encryptionKey = hwidRaw .. fToString(service) .. "GNCHUB_SECRET"
        local encrypted = {}
        local keyLen = #encryptionKey
        for i = 1, #data do
            local charCode = string.byte(data, i)
            local keyChar = string.byte(encryptionKey, ((i - 1) % keyLen) + 1)
            encrypted[i] = string.char(bit32.bxor(charCode, keyChar))
        end
        local encryptedStr = table.concat(encrypted)
        local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local result = {}
        for i = 1, #encryptedStr, 3 do
            local b1, b2, b3 = string.byte(encryptedStr, i, i + 2)
            b2 = b2 or 0
            b3 = b3 or 0
            local nVal = b1 * 65536 + b2 * 256 + b3
            local c1 = bit32.extract(nVal, 18, 6)
            local c2 = bit32.extract(nVal, 12, 6)
            local c3 = bit32.extract(nVal, 6, 6)
            local c4 = bit32.extract(nVal, 0, 6)
            result[#result + 1] = string.sub(base64Chars, c1 + 1, c1 + 1)
            result[#result + 1] = string.sub(base64Chars, c2 + 1, c2 + 1)
            result[#result + 1] = string.sub(base64Chars, c3 + 1, c3 + 1)
            result[#result + 1] = string.sub(base64Chars, c4 + 1, c4 + 1)
        end
        local padding = (3 - (#encryptedStr % 3)) % 3
        for i = 1, padding do
            result[#result - i + 1] = "="
        end
        return table.concat(result)
    end

    -- Decrypt data from local cache
    local function DecryptData(encodedData)
        if not encodedData or encodedData == "" then
            return nil
        end
        local encryptionKey = hwidRaw .. fToString(service) .. "GNCHUB_SECRET"
        local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        encodedData = string.gsub(encodedData, "[^" .. base64Chars .. "=]", "")
        local decoded = {}
        for i = 1, #encodedData, 4 do
            local c1, c2, c3, c4 = string.byte(encodedData, i, i + 3)
            local n1 = string.find(base64Chars, string.char(c1)) - 1
            local n2 = string.find(base64Chars, string.char(c2)) - 1
            local n3 = c3 and string.find(base64Chars, string.char(c3))
            local n4 = c4 and string.find(base64Chars, string.char(c4))
            n3 = n3 and (n3 - 1) or 0
            n4 = n4 and (n4 - 1) or 0
            local nVal = n1 * 262144 + n2 * 4096 + n3 * 64 + n4
            local b1 = bit32.extract(nVal, 16, 8)
            local b2 = bit32.extract(nVal, 8, 8)
            local b3 = bit32.extract(nVal, 0, 8)
            decoded[#decoded + 1] = string.char(b1)
            if c3 ~= 61 then decoded[#decoded + 1] = string.char(b2) end
            if c4 ~= 61 then decoded[#decoded + 1] = string.char(b3) end
        end
        local encryptedStr = table.concat(decoded)
        local decrypted = {}
        local keyLen = #encryptionKey
        for i = 1, #encryptedStr do
            local charCode = string.byte(encryptedStr, i)
            local keyChar = string.byte(encryptionKey, ((i - 1) % keyLen) + 1)
            decrypted[i] = string.char(bit32.bxor(charCode, keyChar))
        end
        return table.concat(decrypted)
    end

    -- Save key to local file
    local function SaveKeyData(key, expirationTimestamp)
        pcall(function()
            fMakeFolder(keyStorageFolder)
            local keyData = {
                key = key,
                expiration = expirationTimestamp or (fOsTime() + (24 * 60 * 60)),
                hwid = hwidRaw,
                service = fToString(service),
                savedAt = fOsTime()
            }
            local jsonData = jsonEncode(keyData)
            local encryptedData = EncryptData(jsonData)
            fWriteFile(keyStorageFile, encryptedData)
        end)
    end

    -- Load key from local file
    local function LoadKeyData()
        local success, result = pcall(function()
            if fIsFile(keyStorageFile) then
                local fileContent = fReadFile(keyStorageFile)
                if fileContent and fileContent ~= "" then
                    local decryptedData = DecryptData(fileContent)
                    if decryptedData then
                        return jsonDecode(decryptedData)
                    end
                end
            end
            return nil
        end)
        return success and result or nil
    end

    local function IsKeyExpired(expirationTimestamp)
        if not expirationTimestamp then return false end
        return fOsTime() >= expirationTimestamp
    end

    -- Cache link from Platoboost server
    local function cacheLink()
        if cachedTime + (10 * 60) < fOsTime() or cachedLink == "" then
            if not fRequest then
                local msg = "Your executor doesn't support HTTP requests."
                onMessage(msg)
                return false, msg
            end

            local ok, response = pcall(function()
                return fRequest({
                    Url = getHost() .. "/public/start",
                    Method = "POST",
                    Body = jsonEncode({
                        service = service,
                        identifier = hwidDigest
                    }),
                    Headers = {
                        ["Content-Type"] = "application/json"
                    }
                })
            end)

            if not ok or not response then
                local msg = "Failed to connect to Platoboost server."
                onMessage(msg)
                return false, msg
            end

            if response.StatusCode == 200 then
                local decOk, decoded = pcall(function() return jsonDecode(response.Body) end)
                if decOk and decoded and decoded.success == true then
                    cachedLink = decoded.data.url
                    cachedTime = fOsTime()
                    return true, cachedLink
                else
                    local msg = (decOk and decoded and decoded.message) or "Failed to retrieve key link."
                    onMessage(msg)
                    return false, msg
                end
            elseif response.StatusCode == 429 then
                local msg = "you are being rate limited, please wait 20 seconds and try again."
                onMessage(msg)
                return false, msg
            else
                local msg = "Failed to cache link."
                if response.StatusCode then
                    msg = msg .. " (Code: " .. tostring(response.StatusCode) .. ")"
                end
                onMessage(msg)
                return false, msg
            end
        else
            return true, cachedLink
        end
    end

    -- Copy key link to clipboard
    local function copyLink()
        local success, link = cacheLink()
        if success and link then
            fSetClipboard(link)
            onMessage("Key link copied! Open it in your browser.")
            return true, link
        else
            onMessage("Failed to copy link. Please try again.")
            return false, nil
        end
    end

    -- Get key link string
    local function getLink()
        if cachedLink and cachedLink ~= "" and (cachedTime + (10 * 60) >= fOsTime()) then
            return cachedLink
        end
        local success, link = cacheLink()
        if success and link then
            return link
        end
        return "https://gateway.platoboost.com/a/" .. fToString(service) .. "?id=" .. hwidDigest
    end

    -- Redeem key (for KEY_ prefixes or new keys)
    local function redeemKey(key, skipSave)
        if not fRequest then
            return false, "Executor does not support HTTP requests."
        end

        local nonce = generateNonce()
        local endpoint = getHost() .. "/public/redeem/" .. fToString(service)

        local body = {
            identifier = hwidDigest,
            key = key
        }

        if useNonce and secret and secret ~= "" then
            body.nonce = nonce
        end

        local ok, response = pcall(function()
            return fRequest({
                Url = endpoint,
                Method = "POST",
                Body = jsonEncode(body),
                Headers = {
                    ["Content-Type"] = "application/json"
                }
            })
        end)

        if not ok or not response then
            local msg = "Failed to connect to Platoboost server."
            onMessage(msg)
            return false, msg
        end

        if response.StatusCode == 200 then
            local decOk, decoded = pcall(function() return jsonDecode(response.Body) end)
            if decOk and decoded and decoded.success == true then
                if decoded.data and decoded.data.valid == true then
                    if useNonce and secret and secret ~= "" then
                        if decoded.data.hash == lDigest("true-" .. nonce .. "-" .. secret) then
                            if not skipSave then
                                SaveKeyData(key)
                            end
                            return true, "Authenticated"
                        else
                            local msg = "failed to verify integrity."
                            onMessage(msg)
                            return false, msg
                        end
                    else
                        if not skipSave then
                            SaveKeyData(key)
                        end
                        return true, "Authenticated"
                    end
                else
                    local msg = "key is invalid."
                    onMessage(msg)
                    return false, msg
                end
            else
                local msg = (decOk and decoded and decoded.message) or "Redemption failed."
                if fStringSub(msg, 1, 27) == "unique constraint violation" then
                    local friendlyMsg = "you already have an active key, please wait for it to expire before redeeming it."
                    onMessage(friendlyMsg)
                    return false, friendlyMsg
                else
                    onMessage(msg)
                    return false, msg
                end
            end
        elseif response.StatusCode == 429 then
            local msg = "you are being rate limited, please wait 20 seconds and try again."
            onMessage(msg)
            return false, msg
        else
            local msg = "server returned an invalid status code, please try again later."
            if response.StatusCode then
                msg = msg .. " (Code: " .. tostring(response.StatusCode) .. ")"
            end
            onMessage(msg)
            return false, msg
        end
    end

    -- Verify key against Platoboost whitelist
    local function verifyKey(key, skipSave)
        if not key or key == "" then
            local msg = "Please enter a key."
            onMessage(msg)
            return false, msg
        end

        if not fRequest then
            return false, "Executor does not support HTTP requests."
        end

        if requestSending == true then
            local msg = "a request is already being sent, please slow down."
            onMessage(msg)
            return false, msg
        else
            requestSending = true
        end

        local nonce = generateNonce()
        local endpoint = getHost() .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. hwidDigest .. "&key=" .. tostring(key)

        if useNonce and secret and secret ~= "" then
            endpoint = endpoint .. "&nonce=" .. nonce
        end

        local ok, response = pcall(function()
            return fRequest({
                Url = endpoint,
                Method = "GET"
            })
        end)

        requestSending = false

        if not ok or not response then
            local msg = "Failed to connect to Platoboost server."
            onMessage(msg)
            return false, msg
        end

        if response.StatusCode == 200 then
            local decOk, decoded = pcall(function() return jsonDecode(response.Body) end)
            if decOk and decoded and decoded.success == true then
                if decoded.data and decoded.data.valid == true then
                    if useNonce and secret and secret ~= "" then
                        if decoded.data.hash == lDigest("true-" .. nonce .. "-" .. secret) then
                            if not skipSave then
                                SaveKeyData(key)
                            end
                            return true, "Authenticated"
                        else
                            local msg = "failed to verify integrity."
                            onMessage(msg)
                            return false, msg
                        end
                    else
                        if not skipSave then
                            SaveKeyData(key)
                        end
                        return true, "Authenticated"
                    end
                else
                    if fStringSub(key, 1, 4) == "KEY_" then
                        return redeemKey(key, skipSave)
                    else
                        local msg = "key is invalid."
                        onMessage(msg)
                        return false, msg
                    end
                end
            else
                local msg = (decOk and decoded and decoded.message) or "Verification failed."
                onMessage(msg)
                return false, msg
            end
        elseif response.StatusCode == 429 then
            local msg = "you are being rate limited, please wait 20 seconds and try again."
            onMessage(msg)
            return false, msg
        else
            local msg = "server returned an invalid status code, please try again later."
            if response.StatusCode then
                msg = msg .. " (Code: " .. tostring(response.StatusCode) .. ")"
            end
            onMessage(msg)
            return false, msg
        end
    end

    -- Get a flag from Platoboost dashboard
    local function getFlag(name)
        if not fRequest then return nil end

        local nonce = generateNonce()
        local endpoint = getHost() .. "/public/flag/" .. fToString(service) .. "?name=" .. tostring(name)

        if useNonce and secret and secret ~= "" then
            endpoint = endpoint .. "&nonce=" .. nonce
        end

        local ok, response = pcall(function()
            return fRequest({
                Url = endpoint,
                Method = "GET"
            })
        end)

        if not ok or not response then return nil end

        if response.StatusCode == 200 then
            local decOk, decoded = pcall(function() return jsonDecode(response.Body) end)
            if decOk and decoded and decoded.success == true then
                if useNonce and secret and secret ~= "" then
                    if decoded.data and decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
                        return decoded.data.value
                    else
                        onMessage("failed to verify integrity.")
                        return nil
                    end
                else
                    return decoded.data and decoded.data.value
                end
            else
                if decOk and decoded and decoded.message then
                    onMessage(decoded.message)
                end
                return nil
            end
        else
            return nil
        end
    end

    -- Check saved key locally and verify validity against Platoboost
    local function CheckSavedKey()
        local savedData = LoadKeyData()
        if savedData and savedData.key and savedData.hwid == hwidRaw then
            if not IsKeyExpired(savedData.expiration) then
                local success, message = verifyKey(savedData.key, true)
                if success then
                    return true, savedData.key
                end
            end
        end
        return false, nil
    end

    return {
        Verify     = verifyKey,
        Redeem     = redeemKey,
        Copy       = copyLink,
        GetLink    = getLink,
        GetFlag    = getFlag,
        CheckSaved = CheckSavedKey
    }
end

return Platoboost

end)

__DEF("GNCHUB.keysystem.ui", function()
-- File: GNCHUB/keysystem/ui.lua
--[[
    GNCHUB Modular Library
    Modul  : KeySystem UI
    Layer  : 2
    Require: keysystem/panda, keysystem/platoboost, utils/elements, core/config, core/safe_wrappers
    Ekspor : memodifikasi Library.KeySystem in-place
--]]

local PandaDev    = __REQUIRE("GNCHUB.keysystem.panda")
local Platoboost  = __REQUIRE("GNCHUB.keysystem.platoboost")
local CreateElement = __REQUIRE("GNCHUB.utils.elements")

-- Dipanggil dari init.lua dengan Library sebagai argument
local function Setup(Library, Executor)
    Library.KeySystem = Library.KeySystem or {
        Config = {
            Service = "Panda", -- "Panda" or "Platoboost"
            serviceName = nil,
            ServiceID = nil,
            Secret = nil,
            UseNonce = true,
            AllowNoKey = true,
            KeyVerified = false,
            LockedTabs = {}
        }
    }

    Library.KeySystem.Panda = PandaDev
    Library.KeySystem.Platoboost = Platoboost

    local activeAPI = nil
    local requestSending = false
    local onMessage = function(message)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "GNCHUB",
                Text = tostring(message),
                Duration = 5
            })
        end)
    end

    local function getActiveService()
        if activeAPI then return activeAPI end

        local serviceType = string.lower(tostring(Library.KeySystem.Config.Service or "Panda"))
        if serviceType == "platoboost" or serviceType == "boost" or serviceType == "plato" then
            local serviceId = Library.KeySystem.Config.ServiceID or Library.KeySystem.Config.serviceName or 5677
            local secret = Library.KeySystem.Config.Secret or "77098738-af78-4d82-bc48-f69b35f41015"
            local useNonce = Library.KeySystem.Config.UseNonce
            activeAPI = Platoboost.New(serviceId, secret, useNonce)
        else
            local serviceName = Library.KeySystem.Config.serviceName or Library.KeySystem.Config.ServiceID or "gnchub"
            activeAPI = PandaDev.New(serviceName)
        end

        PandaDev.SetMessageHandler(onMessage)
        Platoboost.SetMessageHandler(onMessage)

        return activeAPI
    end

    function Library.KeySystem.GetService()
        return getActiveService()
    end

    function Library.KeySystem.getKeyLink()
        local api = getActiveService()
        if api and api.GetLink then
            return api.GetLink()
        else
            onMessage("Something went wrong. Please try again later.")
            local svcLower = string.lower(tostring(Library.KeySystem.Config.Service or ""))
            if svcLower == "platoboost" or svcLower == "boost" or svcLower == "plato" then
                return "https://gateway.platoboost.com/"
            end
            return "https://pandadevelopment.net/"
        end
    end

    function Library.KeySystem.copyLink()
        local api = getActiveService()
        if api and api.Copy then
            api.Copy()
        else
            onMessage("Something went wrong. Please try again later.")
        end
    end

    function Library.KeySystem.verifyKey(key)
        if requestSending == true then
            onMessage("Please wait, checking your key...")
            return false
        else
            requestSending = true
        end

        local api = getActiveService()
        if not api then
            onMessage("Key system service is not configured. Please try again later.")
            requestSending = false
            return false
        end

        local success, result = api.Verify(key)
        requestSending = false

        if success then
            return true
        else
            onMessage(result or "Key verification failed. Please try again.")
            return false
        end
    end

    function Library.KeySystem.redeemKey(key)
        local api = getActiveService()
        if api and api.Redeem then
            return api.Redeem(key)
        end
        return false, "Redeem is only supported on Platoboost service."
    end

    function Library.KeySystem.getFlag(name)
        local api = getActiveService()
        if api and api.GetFlag then
            return api.GetFlag(name)
        end
        return nil
    end

    function Library.KeySystem.CreateUI(mainScriptCallback, customConfig)

        if customConfig then
            if type(customConfig) == "table" then
                for key, value in pairs(customConfig) do
                    Library.KeySystem.Config[key] = value
                end
            end
        end

        local api = getActiveService()

        if api and api.CheckSaved then
            local hasValidKey, savedKey = api.CheckSaved()
            if hasValidKey then
                Library.KeySystem.Config.KeyVerified = true
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "GNCHUB",
                    Text = "Auto-authenticated with saved key!",
                    Duration = 3
                })
                task.wait(0.5)
                if mainScriptCallback then
                    mainScriptCallback()
                end
                return nil
            end
        end

        local KeySystemConfig = {
            Colors = {
                Background = Color3.fromRGB(18, 18, 22),
                BackgroundSecondary = Color3.fromRGB(22, 22, 27),
                Primary = Color3.fromRGB(28, 28, 35),
                PrimaryHover = Color3.fromRGB(35, 35, 42),
                Text = Color3.fromRGB(255, 255, 255),
                TextSecondary = Color3.fromRGB(156, 163, 175),
                TextMuted = Color3.fromRGB(107, 114, 128),
                Stroke = Color3.fromRGB(55, 65, 81),
                StrokeLight = Color3.fromRGB(75, 85, 99),
                StrokeFocus = Color3.fromRGB(99, 102, 241),
                SecondaryLight = Color3.fromRGB(55, 65, 81),
                Secondary = Color3.fromRGB(75, 85, 99),
                Accent = Color3.fromRGB(99, 102, 241),
                AccentHover = Color3.fromRGB(79, 70, 229),
                AccentLight = Color3.fromRGB(165, 180, 252),
                PrimaryLight = Color3.fromRGB(45, 45, 55),
                Success = Color3.fromRGB(34, 197, 94),
                SuccessLight = Color3.fromRGB(134, 239, 172),
                Warning = Color3.fromRGB(251, 191, 36),
                Error = Color3.fromRGB(239, 68, 68),
                Shadow = Color3.fromRGB(0, 0, 0)
            },
            CornerRadius = 6,
            InputCornerRadius = 6,
            ButtonCornerRadius = 6,
            ShadowTransparency = 0.9,
            BorderTransparency = 0.1
        }

        repeat task.wait(1) until game:IsLoaded()

        if game:GetService("CoreGui"):FindFirstChild("KeySystemUI") then
            game:GetService("CoreGui"):FindFirstChild("KeySystemUI"):Destroy()
        end

        onMessage = function(message)
            local notifTitle = "GNCHUB"
            local svcLower = string.lower(tostring(Library.KeySystem.Config.Service or ""))
            if svcLower == "platoboost" or svcLower == "boost" or svcLower == "plato" then
                notifTitle = "Platoboost"
            end
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = notifTitle,
                    Text = tostring(message),
                    Duration = 5
                })
            end)
        end

        PandaDev.SetMessageHandler(onMessage)
        Platoboost.SetMessageHandler(onMessage)

        local KeySystemUI = Instance.new("ScreenGui")
        KeySystemUI.Name = "KeySystemUI"
        KeySystemUI.Parent = game:GetService("CoreGui")
        KeySystemUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        KeySystemUI.ResetOnSpawn = false

        local WindowContainer = Instance.new("Frame")
        WindowContainer.Name = "WindowContainer"
        WindowContainer.Parent = KeySystemUI
        WindowContainer.BackgroundTransparency = 1
        WindowContainer.Position = UDim2.new(0.5, -200, 0.5, -110)
        WindowContainer.Size = UDim2.new(0, 400, 0, 220)
        WindowContainer.Active = true
        WindowContainer.Draggable = true
        WindowContainer.BorderSizePixel = 0
        WindowContainer.ZIndex = 10

        local ShadowFrame = Instance.new("Frame")
        ShadowFrame.Name = "ShadowFrame"
        ShadowFrame.Parent = WindowContainer
        ShadowFrame.BackgroundColor3 = KeySystemConfig.Colors.Shadow
        ShadowFrame.BackgroundTransparency = KeySystemConfig.ShadowTransparency
        ShadowFrame.Position = UDim2.new(0, -2, 0, -2)
        ShadowFrame.Size = UDim2.new(1, 4, 1, 4)
        ShadowFrame.ZIndex = 9
        ShadowFrame.BorderSizePixel = 0
        ShadowFrame.Active = false

        local ShadowUICorner = Instance.new("UICorner")
        ShadowUICorner.CornerRadius = UDim.new(0, KeySystemConfig.CornerRadius + 2)
        ShadowUICorner.Parent = ShadowFrame

        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Parent = WindowContainer
        MainFrame.BackgroundColor3 = KeySystemConfig.Colors.Background
        MainFrame.Position = UDim2.new(0, 0, 0, 0)
        MainFrame.Size = UDim2.new(1, 0, 1, 0)
        MainFrame.BorderSizePixel = 0
        MainFrame.ZIndex = 10

        local MainUICorner = Instance.new("UICorner")
        MainUICorner.CornerRadius = UDim.new(0, KeySystemConfig.CornerRadius)
        MainUICorner.Parent = MainFrame

        local MainUIStroke = Instance.new("UIStroke")
        MainUIStroke.Color = KeySystemConfig.Colors.StrokeLight
        MainUIStroke.Thickness = 1
        MainUIStroke.Transparency = KeySystemConfig.BorderTransparency
        MainUIStroke.Parent = MainFrame

        local TitleBar = Instance.new("Frame")
        TitleBar.Name = "TitleBar"
        TitleBar.Parent = MainFrame
        TitleBar.BackgroundColor3 = KeySystemConfig.Colors.BackgroundSecondary
        TitleBar.BorderSizePixel = 0
        TitleBar.Size = UDim2.new(1, 0, 0, 40)

        local TitleUICorner = Instance.new("UICorner")
        TitleUICorner.CornerRadius = UDim.new(0, KeySystemConfig.CornerRadius)
        TitleUICorner.Parent = TitleBar

        local TitleStroke = Instance.new("UIStroke")
        TitleStroke.Color = KeySystemConfig.Colors.Stroke
        TitleStroke.Thickness = 1
        TitleStroke.Transparency = 0.5
        TitleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        TitleStroke.Parent = TitleBar

        local TitleIcon = Instance.new("ImageLabel")
        TitleIcon.Name = "TitleIcon"
        TitleIcon.Parent = TitleBar
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Position = UDim2.new(0, 15, 0.5, -8)
        TitleIcon.Size = UDim2.new(0, 16, 0, 16)
        TitleIcon.Image = "rbxassetid://133932674578196"
        TitleIcon.ImageColor3 = KeySystemConfig.Colors.AccentLight

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Name = "TitleLabel"
        TitleLabel.Parent = TitleBar
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Position = UDim2.new(0, 38, 0.5, -8)
        TitleLabel.Size = UDim2.new(1, -80, 0, 16)
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.Text = (customConfig and customConfig.Title) or "Key Verification"
        TitleLabel.TextColor3 = KeySystemConfig.Colors.Text
        TitleLabel.TextSize = 14
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Center

        local ExecutorLabel = Instance.new("TextLabel")
        ExecutorLabel.Name = "ExecutorLabel"
        ExecutorLabel.Parent = TitleBar
        ExecutorLabel.BackgroundColor3 = KeySystemConfig.Colors.Error
        ExecutorLabel.BorderSizePixel = 0
        ExecutorLabel.Position = UDim2.new(1, -130, 0.5, -9)
        ExecutorLabel.Size = UDim2.new(0, 80, 0, 18)
        ExecutorLabel.Font = Enum.Font.GothamBold
        ExecutorLabel.Text = Library.ExecutorInfo and Library.ExecutorInfo.Name or "Unknown"
        ExecutorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ExecutorLabel.TextSize = 9
        ExecutorLabel.TextScaled = false
        ExecutorLabel.TextXAlignment = Enum.TextXAlignment.Center
        ExecutorLabel.TextYAlignment = Enum.TextYAlignment.Center

        local ExecutorUICorner = Instance.new("UICorner")
        ExecutorUICorner.CornerRadius = UDim.new(0, 6)
        ExecutorUICorner.Parent = ExecutorLabel

        local ExecutorStroke = Instance.new("UIStroke")
        ExecutorStroke.Color = Color3.fromRGB(200, 50, 50)
        ExecutorStroke.Thickness = 1
        ExecutorStroke.Transparency = 0.3
        ExecutorStroke.Parent = ExecutorLabel

        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.Parent = TitleBar
        CloseButton.BackgroundTransparency = 1
        CloseButton.BorderSizePixel = 0
        CloseButton.Position = UDim2.new(1, -35, 0.5, 0)
        CloseButton.AnchorPoint = Vector2.new(0, 0.5)
        CloseButton.Size = UDim2.new(0, 30, 0, 30)
        CloseButton.Text = ""
        CloseButton.AutoButtonColor = false

        local CloseIcon = Instance.new("ImageLabel")
        CloseIcon.Name = "CloseIcon"
        CloseIcon.Parent = CloseButton
        CloseIcon.BackgroundTransparency = 1
        CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseIcon.Size = UDim2.new(0, 18, 0, 18)
        CloseIcon.Image = "rbxassetid://102969121878134"
        CloseIcon.ImageColor3 = KeySystemConfig.Colors.TextSecondary

        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Parent = MainFrame
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 20, 0, 50)
        ContentFrame.Size = UDim2.new(1, -40, 1, -60)

        local DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.Name = "DescriptionLabel"
        DescriptionLabel.Parent = ContentFrame
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Position = UDim2.new(0, 0, 0, 10)
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 45)
        DescriptionLabel.Font = Enum.Font.Gotham
        DescriptionLabel.Text = "Enter your key below or if you don't have one, just click 'get key' and paste it in your browser"
        DescriptionLabel.TextColor3 = KeySystemConfig.Colors.TextSecondary
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
        DescriptionLabel.LineHeight = 1.2

        local KeyInputFrame = Instance.new("Frame")
        KeyInputFrame.Name = "KeyInputFrame"
        KeyInputFrame.Parent = ContentFrame
        KeyInputFrame.BackgroundColor3 = KeySystemConfig.Colors.Primary
        KeyInputFrame.BackgroundTransparency = 0
        KeyInputFrame.Position = UDim2.new(0, 0, 0, 55)
        KeyInputFrame.Size = UDim2.new(1, 0, 0, 40)
        KeyInputFrame.BorderSizePixel = 0

        local KeyInputUICorner = Instance.new("UICorner")
        KeyInputUICorner.CornerRadius = UDim.new(0, KeySystemConfig.InputCornerRadius)
        KeyInputUICorner.Parent = KeyInputFrame

        local KeyInputStroke = Instance.new("UIStroke")
        KeyInputStroke.Color = KeySystemConfig.Colors.Stroke
        KeyInputStroke.Thickness = 2
        KeyInputStroke.Transparency = KeySystemConfig.BorderTransparency
        KeyInputStroke.Parent = KeyInputFrame

        local KeyInputIcon = Instance.new("ImageLabel")
        KeyInputIcon.Name = "KeyInputIcon"
        KeyInputIcon.Parent = KeyInputFrame
        KeyInputIcon.BackgroundTransparency = 1
        KeyInputIcon.Position = UDim2.new(0, 12, 0.5, -6)
        KeyInputIcon.Size = UDim2.new(0, 12, 0, 12)
        KeyInputIcon.Image = "rbxassetid://107047212111598"
        KeyInputIcon.ImageColor3 = KeySystemConfig.Colors.TextMuted

        local KeyInput = Instance.new("TextBox")
        KeyInput.Name = "KeyInput"
        KeyInput.Parent = KeyInputFrame
        KeyInput.BackgroundTransparency = 1
        KeyInput.Position = UDim2.new(0, 32, 0, 0)
        KeyInput.Size = UDim2.new(1, -42, 1, 0)
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.PlaceholderText = "Enter your key here..."
        KeyInput.PlaceholderColor3 = KeySystemConfig.Colors.TextMuted
        KeyInput.Text = ""
        KeyInput.TextColor3 = KeySystemConfig.Colors.Text
        KeyInput.TextSize = 12
        KeyInput.TextXAlignment = Enum.TextXAlignment.Left
        KeyInput.ClearTextOnFocus = false
        KeyInput.TextTruncate = Enum.TextTruncate.AtEnd

        local ButtonContainer = Instance.new("Frame")
        ButtonContainer.Name = "ButtonContainer"
        ButtonContainer.Parent = ContentFrame
        ButtonContainer.BackgroundTransparency = 1
        ButtonContainer.Position = UDim2.new(0, 0, 0, 105)
        ButtonContainer.Size = UDim2.new(1, 0, 0, 45)

        local ButtonLayout = Instance.new("UIListLayout")
        ButtonLayout.Parent = ButtonContainer
        ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
        ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ButtonLayout.Padding = UDim.new(0, 10)

        local GetKeyButton = Instance.new("TextButton")
        GetKeyButton.Name = "GetKeyButton"
        GetKeyButton.Parent = ButtonContainer
        GetKeyButton.BackgroundColor3 = KeySystemConfig.Colors.Secondary
        GetKeyButton.BorderSizePixel = 0
        GetKeyButton.Size = UDim2.new(0, 120, 1, 0)
        GetKeyButton.Font = Enum.Font.GothamBold
        GetKeyButton.Text = "Get Key"
        GetKeyButton.TextColor3 = KeySystemConfig.Colors.Text
        GetKeyButton.TextSize = 11
        GetKeyButton.AutoButtonColor = false

        local GetKeyUICorner = Instance.new("UICorner")
        GetKeyUICorner.CornerRadius = UDim.new(0, KeySystemConfig.ButtonCornerRadius)
        GetKeyUICorner.Parent = GetKeyButton

        local GetKeyStroke = Instance.new("UIStroke")
        GetKeyStroke.Color = KeySystemConfig.Colors.StrokeLight
        GetKeyStroke.Thickness = 1
        GetKeyStroke.Transparency = 0.3
        GetKeyStroke.Parent = GetKeyButton

        local SubmitButton = Instance.new("TextButton")
        SubmitButton.Name = "SubmitButton"
        SubmitButton.Parent = ButtonContainer
        SubmitButton.BackgroundColor3 = KeySystemConfig.Colors.Accent
        SubmitButton.BorderSizePixel = 0
        SubmitButton.Size = UDim2.new(0, 120, 1, 0)
        SubmitButton.Font = Enum.Font.GothamBold
        SubmitButton.Text = "Check Key"
        SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitButton.TextSize = 11
        SubmitButton.AutoButtonColor = false

        local SubmitUICorner = Instance.new("UICorner")
        SubmitUICorner.CornerRadius = UDim.new(0, KeySystemConfig.ButtonCornerRadius)
        SubmitUICorner.Parent = SubmitButton

        local TweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        local fastTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

        local function setupEnhancedButtonHover(button, normalColor, hoverColor, stroke, icon)
            button.MouseEnter:Connect(function()
                TweenService:Create(button, tweenInfo, {
                    BackgroundColor3 = hoverColor,
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset + 2, button.Size.Y.Scale, button.Size.Y.Offset + 1)
                }):Play()
                if stroke then
                    TweenService:Create(stroke, fastTween, {Transparency = 0}):Play()
                end
                if icon then
                    TweenService:Create(icon, fastTween, {ImageTransparency = 0}):Play()
                end
            end)

            button.MouseLeave:Connect(function()
                TweenService:Create(button, tweenInfo, {
                    BackgroundColor3 = normalColor,
                    Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 2, button.Size.Y.Scale, button.Size.Y.Offset - 1)
                }):Play()
                if stroke then
                    TweenService:Create(stroke, fastTween, {Transparency = 0.3}):Play()
                end
                if icon then
                    TweenService:Create(icon, fastTween, {ImageTransparency = 0.2}):Play()
                end
            end)
        end

        setupEnhancedButtonHover(GetKeyButton, KeySystemConfig.Colors.Secondary, KeySystemConfig.Colors.SecondaryLight, GetKeyStroke, nil)
        setupEnhancedButtonHover(SubmitButton, KeySystemConfig.Colors.Accent, KeySystemConfig.Colors.AccentHover, nil, nil)

        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseIcon, fastTween, {
                Size = UDim2.new(0, 20, 0, 20),
                ImageColor3 = KeySystemConfig.Colors.Error
            }):Play()
        end)
        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseIcon, fastTween, {
                Size = UDim2.new(0, 18, 0, 18),
                ImageColor3 = KeySystemConfig.Colors.TextSecondary
            }):Play()
        end)

        KeyInput.Focused:Connect(function()
            TweenService:Create(KeyInputStroke, tweenInfo, {
                Color = KeySystemConfig.Colors.StrokeFocus,
                Transparency = 0
            }):Play()
            TweenService:Create(KeyInputIcon, fastTween, {
                ImageColor3 = KeySystemConfig.Colors.AccentLight
            }):Play()
            TweenService:Create(KeyInputFrame, tweenInfo, {
                BackgroundColor3 = KeySystemConfig.Colors.PrimaryHover
            }):Play()
        end)

        KeyInput.FocusLost:Connect(function()
            TweenService:Create(KeyInputStroke, tweenInfo, {
                Color = KeySystemConfig.Colors.Stroke,
                Transparency = KeySystemConfig.BorderTransparency
            }):Play()
            TweenService:Create(KeyInputIcon, fastTween, {
                ImageColor3 = KeySystemConfig.Colors.TextMuted
            }):Play()
            TweenService:Create(KeyInputFrame, tweenInfo, {
                BackgroundColor3 = KeySystemConfig.Colors.Primary
            }):Play()
        end)

        local function StartMainScript()
            KeySystemUI:Destroy()
            if mainScriptCallback then
                mainScriptCallback()
            end
        end

        GetKeyButton.MouseButton1Click:Connect(function()
            Library.KeySystem.copyLink()
        end)

        CloseButton.MouseButton1Click:Connect(function()
            KeySystemUI:Destroy()
        end)

        SubmitButton.MouseButton1Click:Connect(function()
            local key = KeyInput.Text
            if key and key ~= "" then
                onMessage("Verifying your key...")

                SubmitButton.Text = "Verifying..."
                SubmitButton.BackgroundColor3 = KeySystemConfig.Colors.Warning

                task.spawn(function()
                    local success = Library.KeySystem.verifyKey(key)
                    if success then
                        Library.KeySystem.Config.KeyVerified = true
                        onMessage("Welcome!")

                        SubmitButton.Text = "Authenticated!"
                        SubmitButton.BackgroundColor3 = KeySystemConfig.Colors.Success

                        task.wait(1.5)
                        StartMainScript()
                    else

                        SubmitButton.Text = "Failed"
                        SubmitButton.BackgroundColor3 = KeySystemConfig.Colors.Error

                        task.wait(2)

                        SubmitButton.Text = "Check Key"
                        SubmitButton.BackgroundColor3 = KeySystemConfig.Colors.Accent
                    end
                end)
            else

                TweenService:Create(KeyInputStroke, fastTween, {
                    Color = KeySystemConfig.Colors.Error,
                    Transparency = 0
                }):Play()
                TweenService:Create(KeyInputIcon, fastTween, {
                    ImageColor3 = KeySystemConfig.Colors.Error
                }):Play()

                onMessage("Please enter your key first.")

                task.wait(1)

                TweenService:Create(KeyInputStroke, tweenInfo, {
                    Color = KeySystemConfig.Colors.Stroke,
                    Transparency = KeySystemConfig.BorderTransparency
                }):Play()
                TweenService:Create(KeyInputIcon, tweenInfo, {
                    ImageColor3 = KeySystemConfig.Colors.TextMuted
                }):Play()
            end
        end)

        return KeySystemUI
    end

    function Library.KeySystem.Configure(arg1, arg2, arg3, arg4, arg5, arg6)
        activeAPI = nil

        if type(arg1) == "table" then
            local cfg = arg1
            local svc = cfg.Service or cfg.service or cfg.ServiceType or cfg.type or (cfg.Secret and "Platoboost") or Library.KeySystem.Config.Service or "Panda"
            Library.KeySystem.Config.Service = svc
            Library.KeySystem.Config.serviceName = cfg.ServiceName or cfg.serviceName or cfg.service or cfg.ServiceID or cfg.serviceId or Library.KeySystem.Config.serviceName
            Library.KeySystem.Config.ServiceID = cfg.ServiceID or cfg.serviceId or cfg.service or cfg.ServiceName or cfg.serviceName or Library.KeySystem.Config.ServiceID
            Library.KeySystem.Config.Secret = cfg.Secret or cfg.secret or Library.KeySystem.Config.Secret
            if cfg.UseNonce ~= nil then
                Library.KeySystem.Config.UseNonce = cfg.UseNonce
            elseif cfg.useNonce ~= nil then
                Library.KeySystem.Config.UseNonce = cfg.useNonce
            end
            if cfg.AllowNoKey ~= nil then
                Library.KeySystem.Config.AllowNoKey = cfg.AllowNoKey
            elseif cfg.allowNoKey ~= nil then
                Library.KeySystem.Config.AllowNoKey = cfg.allowNoKey
            end
            if cfg.LockedTabs or cfg.lockedTabs then
                Library.KeySystem.Config.LockedTabs = cfg.LockedTabs or cfg.lockedTabs
            end
        elseif type(arg1) == "string" and (string.lower(arg1) == "platoboost" or string.lower(arg1) == "boost" or string.lower(arg1) == "plato") then
            -- Syntax: Configure("Platoboost", serviceId, secret, useNonce, allowNoKey, lockedTabs)
            Library.KeySystem.Config.Service = "Platoboost"
            Library.KeySystem.Config.ServiceID = arg2 or Library.KeySystem.Config.ServiceID
            Library.KeySystem.Config.serviceName = arg2 or Library.KeySystem.Config.serviceName
            Library.KeySystem.Config.Secret = arg3 or Library.KeySystem.Config.Secret
            if arg4 ~= nil then Library.KeySystem.Config.UseNonce = arg4 end
            if arg5 ~= nil then Library.KeySystem.Config.AllowNoKey = arg5 end
            if arg6 ~= nil then Library.KeySystem.Config.LockedTabs = arg6 end
        elseif type(arg1) == "number" then
            -- Syntax: Configure(5677, allowNoKey, lockedTabs, "Platoboost", secret, useNonce)
            Library.KeySystem.Config.Service = arg4 or "Platoboost"
            Library.KeySystem.Config.ServiceID = arg1
            Library.KeySystem.Config.serviceName = arg1
            if arg2 ~= nil then Library.KeySystem.Config.AllowNoKey = arg2 end
            if arg3 ~= nil then Library.KeySystem.Config.LockedTabs = arg3 end
            if arg5 ~= nil then Library.KeySystem.Config.Secret = arg5 end
            if arg6 ~= nil then Library.KeySystem.Config.UseNonce = arg6 end
        else
            -- Traditional: Configure(serviceName, allowNoKey, lockedTabs, serviceType, secret, useNonce)
            Library.KeySystem.Config.serviceName = arg1 or Library.KeySystem.Config.serviceName
            Library.KeySystem.Config.ServiceID = arg1 or Library.KeySystem.Config.ServiceID
            if arg2 ~= nil then Library.KeySystem.Config.AllowNoKey = arg2 end
            if arg3 ~= nil then Library.KeySystem.Config.LockedTabs = arg3 end
            if arg4 ~= nil then Library.KeySystem.Config.Service = arg4 end
            if arg5 ~= nil then Library.KeySystem.Config.Secret = arg5 end
            if arg6 ~= nil then Library.KeySystem.Config.UseNonce = arg6 end
        end

        getActiveService()
    end
end

return { Setup = Setup }

end)

__DEF("GNCHUB.utils.button", function()
-- File: GNCHUB/utils/button.lua
--[[
    GNCHUB Modular Library
    Modul  : Button (utils)
    Layer  : 2
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : CreateModernButton
--]]

local CreateElement = __REQUIRE("GNCHUB.utils.elements")
local Config  = __REQUIRE("GNCHUB.core.config")
local SafeW   = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeEnum    = SafeW.SafeEnum
local SafeUDim    = SafeW.SafeUDim
local SafeUDim2   = SafeW.SafeUDim2
local SafeColor3  = SafeW.SafeColor3

local TweenService = game and game.GetService and game:GetService("TweenService") or nil

local function CreateModernButton(parent, text, position, size, color, textColor, callback)
    local button = CreateElement("TextButton", {
        Name = text .. "Button",
        Parent = parent,
        Size = size or SafeUDim2.new(0, 100, 0, 30),
        Position = position or SafeUDim2.new(0, 0, 0, 0),
        BackgroundColor3 = color or Config.Colors.Primary,
        BorderSizePixel = 0,
        Font = Config.Font,
        Text = text,
        TextColor3 = textColor or Config.Colors.Text,
        TextSize = Config.TextSize,
        AutoButtonColor = false,
    })

    CreateElement("UICorner", {
        CornerRadius = SafeUDim.new(0, 8),
        Parent = button
    })

    CreateElement("UIStroke", {
        Color = Config.Colors.Stroke,
        Thickness = 1,
        Transparency = 0.5,
        Parent = button
    })

    local originalColor = button.BackgroundColor3
    local hoverTween, clickTween

    button.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(button, TweenInfo.new(0.2, SafeEnum.EasingStyle.Quad), {
            BackgroundColor3 = SafeColor3.fromRGB(
                math.min(255, originalColor.R * 255 + 15),
                math.min(255, originalColor.G * 255 + 15),
                math.min(255, originalColor.B * 255 + 15)
            )
        })
        hoverTween:Play()
    end)

    button.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = TweenService:Create(button, TweenInfo.new(0.2, SafeEnum.EasingStyle.Quad), {
            BackgroundColor3 = originalColor
        })
        hoverTween:Play()
    end)

    button.MouseButton1Down:Connect(function()
        if clickTween then clickTween:Cancel() end
        clickTween = TweenService:Create(button, TweenInfo.new(0.1, SafeEnum.EasingStyle.Quad), {
            Size = SafeUDim2.new(button.Size.X.Scale, button.Size.X.Offset - 2, button.Size.Y.Scale, button.Size.Y.Offset - 2)
        })
        clickTween:Play()
    end)

    button.MouseButton1Up:Connect(function()
        if clickTween then clickTween:Cancel() end
        clickTween = TweenService:Create(button, TweenInfo.new(0.1, SafeEnum.EasingStyle.Quad), {
            Size = size or SafeUDim2.new(0, 100, 0, 30)
        })
        clickTween:Play()
        if callback then callback() end
    end)

    return button
end

return CreateModernButton

end)

__DEF("GNCHUB.utils.draggable", function()
-- File: GNCHUB/utils/draggable.lua
--[[
    GNCHUB Modular Library
    Modul  : Draggable
    Layer  : 2
    Require: core/safe_wrappers
    Ekspor : { MakeDraggable, CleanupConnections, GlobalInputConnections }
--]]

local SafeW   = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeEnum    = SafeW.SafeEnum
local SafeUDim2   = SafeW.SafeUDim2

-- Shared state (dipakai bersama dengan scroll.lua via init.lua)
local GlobalInputConnections = {}

-- Referensi ke ScrollConnections dari scroll module (di-set oleh init.lua)
local _ScrollConnections = nil

local function SetScrollConnections(sc)
    _ScrollConnections = sc
end

local function MakeDraggable(element)
    local dragging = false
    local dragInput, dragStart, startPos

    element.InputBegan:Connect(function(input)
        if input.UserInputType == SafeEnum.UserInputType.MouseButton1 or input.UserInputType == SafeEnum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == SafeEnum.UserInputState and SafeEnum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    element.InputChanged:Connect(function(input)
        if input.UserInputType == SafeEnum.UserInputType.MouseMovement or input.UserInputType == SafeEnum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                element.Parent.Position = SafeUDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

local function CleanupConnections(scrollConnections)
    scrollConnections = scrollConnections or _ScrollConnections or {}

    for scrollFrame, connectionData in pairs(scrollConnections) do
        if type(connectionData) == "table" then

            for _, connection in pairs(connectionData) do
                if connection and connection.Connected then
                    connection:Disconnect()
                end
            end
        elseif connectionData and connectionData.Connected then

            connectionData:Disconnect()
        end
    end
    -- Clear the table in-place
    for k in pairs(scrollConnections) do
        scrollConnections[k] = nil
    end

    for _, connection in pairs(GlobalInputConnections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    for k in pairs(GlobalInputConnections) do
        GlobalInputConnections[k] = nil
    end
end

return {
    MakeDraggable          = MakeDraggable,
    CleanupConnections     = CleanupConnections,
    SetScrollConnections   = SetScrollConnections,
    GlobalInputConnections = GlobalInputConnections,
}

end)

__DEF("GNCHUB.utils.elements", function()
-- File: GNCHUB/utils/elements.lua
--[[
    GNCHUB Modular Library
    Modul  : Elements
    Layer  : 1
    Require: core/safe_wrappers
    Ekspor : CreateElement
--]]

local function CreateElement(className, properties)
    local element
    local success = false

    if Instance and Instance.new then
        success, element = pcall(function()
            return Instance.new(className)
        end)
    end

    if not success or not element then
        element = setmetatable({}, {
            __index = function(t, k)

                if k == "Name" or k == "Parent" or k == "Size" or k == "Position" or
                   k == "BackgroundColor3" or k == "BorderSizePixel" or k == "Visible" or
                   k == "BackgroundTransparency" or k == "Text" or k == "TextColor3" or
                   k == "Font" or k == "TextSize" or k == "AnchorPoint" or k == "ZIndex" or
                   k == "AbsolutePosition" or k == "AbsoluteSize" or k == "CanvasPosition" or
                   k == "AbsoluteCanvasSize" then
                    return rawget(t, k)
                end

                if k == "Connect" then
                    return function()
                        return {
                            Connected = true,
                            Disconnect = function() end
                        }
                    end
                end

                if k == "InputBegan" or k == "InputEnded" or k == "InputChanged" or k == "Changed" or
                   k == "MouseEnter" or k == "MouseLeave" or k == "MouseButton1Down" or k == "MouseButton1Up" then
                    return {
                        Connect = function()
                            return {
                                Connected = true,
                                Disconnect = function() end
                            }
                        end
                    }
                end

                return function() end
            end,
            __newindex = function(t, k, v)
                rawset(t, k, v)
            end
        })

        if warn then warn("Using fallback element for:", className) end
    end

    for prop, value in pairs(properties or {}) do
        local propSuccess, propError = pcall(function()
            element[prop] = value
        end)
        if not propSuccess then
            if warn then warn("Failed to set property", prop, "on", className, ":", propError) end
        end
    end

    return element
end

return CreateElement

end)

__DEF("GNCHUB.utils.esp", function()
-- File: GNCHUB/utils/esp.lua
-- GNCHUB ESP Library

local ESP = {
    Enabled = false,
    Boxes = false,
    BoxOutline = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    Names = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    Health = false,
    Distance = false,
    Tracers = false,
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerOrigin = "Bottom", -- "Top", "Center", "Bottom", "Mouse"
    TeamCheck = false,
    MaxDistance = 3000,
    TextSize = 14,
    Players = {},
    Connections = {}
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function DrawLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.new(1, 1, 1)
    line.Thickness = 1
    line.Transparency = 1
    return line
end

local function DrawText()
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Font = 2
    text.Size = 14
    text.Color = Color3.new(1, 1, 1)
    return text
end

local function DrawSquare()
    local square = Drawing.new("Square")
    square.Visible = false
    square.Color = Color3.new(1, 1, 1)
    square.Thickness = 1
    square.Transparency = 1
    square.Filled = false
    return square
end

function ESP:AddPlayer(player)
    if player == LocalPlayer then return end
    
    local objects = {
        -- Outlines first so they render behind
        TopLineO = DrawLine(),
        BottomLineO = DrawLine(),
        LeftLineO = DrawLine(),
        RightLineO = DrawLine(),
        HealthBarOutline = DrawLine(),
        
        -- Inner lines render on top
        TopLine = DrawLine(),
        BottomLine = DrawLine(),
        LeftLine = DrawLine(),
        RightLine = DrawLine(),
        HealthBar = DrawLine(),
        
        Tracer = DrawLine(),
        Name = DrawText(),
        Distance = DrawText(),
    }
    
    local outlineThickness = 3
    local innerThickness = 1.5
    local outlineColor = Color3.new(0, 0, 0)
    
    objects.TopLineO.Thickness = outlineThickness
    objects.TopLineO.Color = outlineColor
    objects.BottomLineO.Thickness = outlineThickness
    objects.BottomLineO.Color = outlineColor
    objects.LeftLineO.Thickness = outlineThickness
    objects.LeftLineO.Color = outlineColor
    objects.RightLineO.Thickness = outlineThickness
    objects.RightLineO.Color = outlineColor
    
    objects.TopLine.Thickness = innerThickness
    objects.BottomLine.Thickness = innerThickness
    objects.LeftLine.Thickness = innerThickness
    objects.RightLine.Thickness = innerThickness
    
    objects.HealthBarOutline.Thickness = 5
    objects.HealthBarOutline.Color = outlineColor
    
    objects.HealthBar.Thickness = 3
    
    self.Players[player] = objects
end

function ESP:RemovePlayer(player)
    if self.Players[player] then
        for _, obj in pairs(self.Players[player]) do
            obj:Remove()
        end
        self.Players[player] = nil
    end
end

function ESP:Toggle(state)
    self.Enabled = state
    if not state then
        for player, objects in pairs(self.Players) do
            for _, obj in pairs(objects) do
                obj.Visible = false
            end
        end
    end
end

function ESP:Update()
    for player, objects in pairs(self.Players) do
        if not self.Enabled then
            for _, obj in pairs(objects) do
                obj.Visible = false
            end
            continue
        end
        
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        local head = character and character:FindFirstChild("Head")
        
        local isAlive = humanoid and humanoid.Health > 0
        local isAlly = self.TeamCheck and player.Team == LocalPlayer.Team
        
        local distance = rootPart and math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude) or 0
        local isTooFar = distance > self.MaxDistance
        
        if isAlive and rootPart and head and not isAlly and not isTooFar then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
            
            if onScreen then
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                -- Box
                if self.Boxes then
                    local TL = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                    local TR = Vector2.new(rootPos.X + width/2, rootPos.Y - height/2)
                    local BL = Vector2.new(rootPos.X - width/2, rootPos.Y + height/2)
                    local BR = Vector2.new(rootPos.X + width/2, rootPos.Y + height/2)
                    
                    objects.TopLine.From = TL
                    objects.TopLine.To = TR
                    objects.TopLine.Color = self.BoxColor
                    objects.TopLine.Visible = true

                    objects.BottomLine.From = BL
                    objects.BottomLine.To = BR
                    objects.BottomLine.Color = self.BoxColor
                    objects.BottomLine.Visible = true

                    objects.LeftLine.From = TL
                    objects.LeftLine.To = BL
                    objects.LeftLine.Color = self.BoxColor
                    objects.LeftLine.Visible = true

                    objects.RightLine.From = TR
                    objects.RightLine.To = BR
                    objects.RightLine.Color = self.BoxColor
                    objects.RightLine.Visible = true
                    
                    if self.BoxOutline then
                        -- Outlines
                        objects.TopLineO.From = TL
                        objects.TopLineO.To = TR
                        objects.TopLineO.Visible = true
                        
                        objects.BottomLineO.From = BL
                        objects.BottomLineO.To = BR
                        objects.BottomLineO.Visible = true
                        
                        objects.LeftLineO.From = TL
                        objects.LeftLineO.To = BL
                        objects.LeftLineO.Visible = true
                        
                        objects.RightLineO.From = TR
                        objects.RightLineO.To = BR
                        objects.RightLineO.Visible = true
                    else
                        objects.TopLineO.Visible = false
                        objects.BottomLineO.Visible = false
                        objects.LeftLineO.Visible = false
                        objects.RightLineO.Visible = false
                    end
                else
                    objects.TopLine.Visible = false
                    objects.BottomLine.Visible = false
                    objects.LeftLine.Visible = false
                    objects.RightLine.Visible = false
                    
                    objects.TopLineO.Visible = false
                    objects.BottomLineO.Visible = false
                    objects.LeftLineO.Visible = false
                    objects.RightLineO.Visible = false
                end
                
                -- Health
                if self.Health then
                    local healthPct = humanoid.Health / humanoid.MaxHealth
                    local healthColor = Color3.new(1 - healthPct, healthPct, 0) -- Green to Red
                    
                    local barHeight = height * healthPct
                    local offsetX = width / 2 + 5 -- Distance from box

                    -- Outline (Black background)
                    objects.HealthBarOutline.From = Vector2.new(rootPos.X - offsetX, rootPos.Y + height/2 + 1)
                    objects.HealthBarOutline.To = Vector2.new(rootPos.X - offsetX, rootPos.Y - height/2 - 1)
                    objects.HealthBarOutline.Visible = true
                    
                    -- Actual Health Bar
                    objects.HealthBar.From = Vector2.new(rootPos.X - offsetX, rootPos.Y + height/2)
                    objects.HealthBar.To = Vector2.new(rootPos.X - offsetX, rootPos.Y + height/2 - barHeight)
                    objects.HealthBar.Color = healthColor
                    objects.HealthBar.Visible = true
                else
                    objects.HealthBar.Visible = false
                    objects.HealthBarOutline.Visible = false
                end
                
                -- Name
                if self.Names then
                    objects.Name.Text = player.Name
                    objects.Name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 15)
                    objects.Name.Color = self.NameColor
                    objects.Name.Size = self.TextSize
                    objects.Name.Visible = true
                else
                    objects.Name.Visible = false
                end
                
                -- Distance
                if self.Distance then
                    local distance = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                    objects.Distance.Text = tostring(distance) .. "m"
                    objects.Distance.Position = Vector2.new(rootPos.X, rootPos.Y + height/2 + 2)
                    objects.Distance.Color = Color3.new(1, 1, 1)
                    objects.Distance.Size = self.TextSize
                    objects.Distance.Visible = true
                else
                    objects.Distance.Visible = false
                end
                
                -- Tracers
                if self.Tracers then
                    local origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y) -- Bottom
                    if self.TracerOrigin == "Top" then
                        origin = Vector2.new(Camera.ViewportSize.X/2, 0)
                    elseif self.TracerOrigin == "Center" then
                        origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                    elseif self.TracerOrigin == "Mouse" then
                        local mouse = LocalPlayer:GetMouse()
                        origin = Vector2.new(mouse.X, mouse.Y + 36) -- Offset for cursor
                    end
                    
                    objects.Tracer.From = origin
                    objects.Tracer.To = Vector2.new(rootPos.X, rootPos.Y - height/2) -- Top of box
                    objects.Tracer.Color = self.TracerColor
                    objects.Tracer.Visible = true
                else
                    objects.Tracer.Visible = false
                end
                
            else
                for _, obj in pairs(objects) do
                    obj.Visible = false
                end
            end
        else
            for _, obj in pairs(objects) do
                obj.Visible = false
            end
        end
    end
end

function ESP:Init()
    for _, player in pairs(Players:GetPlayers()) do
        self:AddPlayer(player)
    end
    
    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        self:AddPlayer(player)
    end)
    
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)
    
    self.Connections.RenderStepped = RunService.RenderStepped:Connect(function()
        self:Update()
    end)
end

function ESP:Unload()
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    
    for player, _ in pairs(self.Players) do
        self:RemovePlayer(player)
    end
end

return ESP

end)

__DEF("GNCHUB.utils.scroll", function()
-- File: GNCHUB/utils/scroll.lua
--[[
    GNCHUB Modular Library
    Modul  : Scroll
    Layer  : 2
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : { CreateEnhancedScrollFrame, SmoothScrollTo, ScrollToElement,
               SetupMomentumScrolling, SetupKeyboardNavigation,
               ScrollingFrames, MomentumScrolls, ScrollConnections }
--]]

local CreateElement = __REQUIRE("GNCHUB.utils.elements")
local Config  = __REQUIRE("GNCHUB.core.config")
local SafeW   = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeEnum = SafeW.SafeEnum

local UserInputService = game and game.GetService and game:GetService("UserInputService") or nil
local RunService       = game and game.GetService and game:GetService("RunService") or nil
local TweenService     = game and game.GetService and game:GetService("TweenService") or nil

local ScrollingFrames = {}
local MomentumScrolls = {}
local ScrollConnections = {}

local function SmoothScrollTo(scrollFrame, targetPosition, duration)
    duration = duration or Config.Scrolling.AnimationTime

    local startPosition = scrollFrame.CanvasPosition
    local tweenInfo = TweenInfo.new(
        duration,
        Config.Scrolling.EasingStyle,
        Config.Scrolling.EasingDirection
    )

    local tween = TweenService:Create(scrollFrame, tweenInfo, {
        CanvasPosition = targetPosition
    })

    tween:Play()
    return tween
end

local function ScrollToElement(scrollFrame, targetElement, padding)
    padding = padding or Config.Scrolling.AutoScrollPadding

    if not targetElement or not targetElement.Parent then return end

    local targetPosition = targetElement.AbsolutePosition.Y - scrollFrame.AbsolutePosition.Y
    local scrollFrameHeight = scrollFrame.AbsoluteSize.Y
    local currentScroll = scrollFrame.CanvasPosition.Y

    local newScrollY = targetPosition - padding

    if targetPosition < currentScroll + padding then
        newScrollY = targetPosition - padding
    elseif targetPosition + targetElement.AbsoluteSize.Y > currentScroll + scrollFrameHeight - padding then
        newScrollY = targetPosition - scrollFrameHeight + targetElement.AbsoluteSize.Y + padding
    else
        return
    end

    newScrollY = math.max(0, math.min(newScrollY, scrollFrame.AbsoluteCanvasSize.Y - scrollFrameHeight))

    SmoothScrollTo(scrollFrame, Vector2.new(0, newScrollY))
end

local function CreateEnhancedScrollFrame(properties)
    local frame = CreateElement("ScrollingFrame", properties)

    frame.ScrollBarThickness = (properties and properties.ScrollBarThickness ~= nil) and properties.ScrollBarThickness or 3
    frame.ScrollBarImageColor3 = (properties and properties.ScrollBarImageColor3 ~= nil) and properties.ScrollBarImageColor3 or Config.Colors.Accent
    frame.ScrollBarImageTransparency = (properties and properties.ScrollBarImageTransparency ~= nil) and properties.ScrollBarImageTransparency or 0.3
    frame.ScrollingEnabled = true
    frame.ElasticBehavior = SafeEnum.ElasticBehavior and SafeEnum.ElasticBehavior.WhenScrollable or "WhenScrollable"
    frame.ScrollingDirection = SafeEnum.ScrollingDirection and SafeEnum.ScrollingDirection.Y or "Y"
    frame.VerticalScrollBarPosition = SafeEnum.VerticalScrollBarPosition and SafeEnum.VerticalScrollBarPosition.Right or "Right"

    ScrollingFrames[frame] = true

    return frame
end

local function SetupMomentumScrolling(scrollFrame)
    if not UserInputService then return end

    local lastScrollPosition = scrollFrame.CanvasPosition
    local velocity = Vector2.new(0, 0)
    local isDragging = false
    local momentumConnection

    local function updateMomentum()
        if not isDragging and velocity.Magnitude > 0.1 then
            local newPosition = scrollFrame.CanvasPosition + velocity

            newPosition = Vector2.new(
                math.max(0, math.min(newPosition.X, scrollFrame.AbsoluteCanvasSize.X - scrollFrame.AbsoluteSize.X)),
                math.max(0, math.min(newPosition.Y, scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteSize.Y))
            )

            scrollFrame.CanvasPosition = newPosition
            velocity = velocity * Config.Scrolling.MomentumDecay
        end
    end

    scrollFrame.Changed:Connect(function(property)
        if property == "CanvasPosition" then
            if not isDragging then
                velocity = (scrollFrame.CanvasPosition - lastScrollPosition) * 0.1
            end
            lastScrollPosition = scrollFrame.CanvasPosition
        end
    end)

    scrollFrame.InputBegan:Connect(function(input)
        if input.UserInputType == SafeEnum.UserInputType.MouseButton1 or input.UserInputType == SafeEnum.UserInputType.Touch then
            isDragging = true
            velocity = Vector2.new(0, 0)
        end
    end)

    scrollFrame.InputEnded:Connect(function(input)
        if input.UserInputType == SafeEnum.UserInputType.MouseButton1 or input.UserInputType == SafeEnum.UserInputType.Touch then
            isDragging = false
            if not momentumConnection then
                momentumConnection = RunService.Heartbeat:Connect(updateMomentum)
                ScrollConnections[scrollFrame] = momentumConnection
            end
        end
    end)

    if UserInputService.InputBegan then
        local wheelConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end

            if input.UserInputType == SafeEnum.UserInputType.MouseWheel then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = scrollFrame.AbsolutePosition
                local frameSize = scrollFrame.AbsoluteSize

                if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                   mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then

                    local scrollDelta = -input.Position.Z * Config.Scrolling.ScrollSensitivity
                    local newY = math.max(0, math.min(
                        scrollFrame.CanvasPosition.Y + scrollDelta,
                        scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteSize.Y
                    ))

                    SmoothScrollTo(scrollFrame, Vector2.new(0, newY), 0.1)
                end
            end
        end)

        if not ScrollConnections[scrollFrame] then
            ScrollConnections[scrollFrame] = {}
        end
        table.insert(ScrollConnections[scrollFrame], wheelConnection)
    end
end

local function SetupKeyboardNavigation(scrollFrame)
    if not UserInputService then return end

    local keyboardConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        local mousePos = UserInputService:GetMouseLocation()
        local framePos = scrollFrame.AbsolutePosition
        local frameSize = scrollFrame.AbsoluteSize

        if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
           mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then

            if input.KeyCode == SafeEnum.KeyCode.PageUp then
                local newY = math.max(0, scrollFrame.CanvasPosition.Y - scrollFrame.AbsoluteSize.Y * 0.8)
                SmoothScrollTo(scrollFrame, Vector2.new(0, newY))
            elseif input.KeyCode == SafeEnum.KeyCode.PageDown then
                local maxY = scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteSize.Y
                local newY = math.min(maxY, scrollFrame.CanvasPosition.Y + scrollFrame.AbsoluteSize.Y * 0.8)
                SmoothScrollTo(scrollFrame, Vector2.new(0, newY))
            elseif input.KeyCode == SafeEnum.KeyCode.Home then
                SmoothScrollTo(scrollFrame, Vector2.new(0, 0))
            elseif input.KeyCode == SafeEnum.KeyCode.End then
                local maxY = scrollFrame.AbsoluteCanvasSize.Y - scrollFrame.AbsoluteSize.Y
                SmoothScrollTo(scrollFrame, Vector2.new(0, maxY))
            end
        end
    end)

    if not ScrollConnections[scrollFrame] then
        ScrollConnections[scrollFrame] = {}
    end
    table.insert(ScrollConnections[scrollFrame], keyboardConnection)
end

return {
    CreateEnhancedScrollFrame  = CreateEnhancedScrollFrame,
    SmoothScrollTo             = SmoothScrollTo,
    ScrollToElement            = ScrollToElement,
    SetupMomentumScrolling     = SetupMomentumScrolling,
    SetupKeyboardNavigation    = SetupKeyboardNavigation,
    ScrollingFrames            = ScrollingFrames,
    MomentumScrolls            = MomentumScrolls,
    ScrollConnections          = ScrollConnections,
}

end)

__DEF("GNCHUB.utils.visuals", function()
-- File: GNCHUB/utils/visuals.lua
--[[
    GNCHUB Modular Library
    Modul  : Visuals
    Layer  : 2
    Require: utils/elements, core/config, core/safe_wrappers
    Ekspor : { CreateGradient, CreateGlow, AnimateIn }
--]]

local CreateElement = __REQUIRE("GNCHUB.utils.elements")
local Config  = __REQUIRE("GNCHUB.core.config")
local SafeW   = __REQUIRE("GNCHUB.core.safe_wrappers")
local SafeEnum    = SafeW.SafeEnum
local SafeUDim2   = SafeW.SafeUDim2
local SafeVector2 = SafeW.SafeVector2
local SafeRect    = SafeW.SafeRect

local TweenService = game and game.GetService and game:GetService("TweenService") or nil

local function CreateGradient(parent, colorTop, colorBottom, rotation)
    rotation = rotation or 90
    local gradient = CreateElement("UIGradient", {
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, colorTop),
            ColorSequenceKeypoint.new(1, colorBottom)
        },
        Rotation = rotation,
        Parent = parent
    })
    return gradient
end

local function CreateGlow(parent, color, transparency)
    transparency = transparency or Config.Effects.GlowTransparency
    color = color or Config.Colors.Accent
    local glow = CreateElement("ImageLabel", {
        Name = "Glow",
        Parent = parent,
        Size = SafeUDim2.new(1, 20, 1, 20),
        Position = SafeUDim2.new(0, -10, 0, -10),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = color,
        ImageTransparency = transparency,
        ZIndex = parent.ZIndex - 2 or -1,
        ScaleType = SafeEnum.ScaleType and SafeEnum.ScaleType.Slice or "Slice",
        SliceCenter = SafeRect.new(10, 10, 118, 118)
    })
    return glow
end

local function AnimateIn(element, animationType)
    animationType = animationType or "fade"

    if animationType == "fade" then
        element.BackgroundTransparency = 1
        local tween = TweenService:Create(element, TweenInfo.new(
            Config.Effects.AnimationTime,
            Config.Effects.EasingStyle,
            Config.Effects.EasingDirection
        ), { BackgroundTransparency = 0 })
        tween:Play()
    elseif animationType == "scale" then
        element.Size = SafeUDim2.new(0, 0, 0, 0)
        element.AnchorPoint = SafeVector2.new(0.5, 0.5)
        element.Position = SafeUDim2.new(
            element.Position.X.Scale + element.Size.X.Scale/2,
            element.Position.X.Offset + element.Size.X.Offset/2,
            element.Position.Y.Scale + element.Size.Y.Scale/2,
            element.Position.Y.Offset + element.Size.Y.Offset/2
        )
        local targetSize = element.Size
        local tween = TweenService:Create(element, TweenInfo.new(
            Config.Effects.AnimationTime,
            SafeEnum.EasingStyle.Back,
            SafeEnum.EasingDirection.Out
        ), { Size = targetSize })
        tween:Play()
    end
end

return {
    CreateGradient = CreateGradient,
    CreateGlow     = CreateGlow,
    AnimateIn      = AnimateIn,
}

end)

__DEF("GNCHUB.window.section", function()
-- File: GNCHUB/window/section.lua
--[[
    GNCHUB Modular Library
    Modul  : Section
    Layer  : 5 
    Require: window/tab, components/*
    Ekspor : SetupAddSection(Tab, deps)
--]]

local ToggleMod    = __REQUIRE("GNCHUB.components.toggle")
local ButtonMod    = __REQUIRE("GNCHUB.components.button")
local TextboxMod   = __REQUIRE("GNCHUB.components.textbox")
local ParagraphMod = __REQUIRE("GNCHUB.components.paragraph")
local DropdownMod  = __REQUIRE("GNCHUB.components.dropdown")
local SliderMod    = __REQUIRE("GNCHUB.components.slider")

local function SetupAddSection(Tab, deps)
    local CreateElement       = deps.CreateElement
    local Config              = deps.Config
    local SafeW               = deps.SafeW
    local TweenService        = deps.TweenService
    local UserInputService    = deps.UserInputService
    local Window              = deps.Window
    local Page                = deps.Page
    local updatePageCanvasSize = deps.updatePageCanvasSize

    local SafeEnum   = SafeW.SafeEnum
    local SafeUDim2  = SafeW.SafeUDim2
    local SafeUDim   = SafeW.SafeUDim
    local SafeColor3 = SafeW.SafeColor3

    function Tab:AddSection(sectionConfig)
        local sectionName, description, isExpanded, isLocked, titleTextSize
        if type(sectionConfig) == "string" then
            sectionName = sectionConfig
            description = nil
            isExpanded = false
            isLocked = false
            titleTextSize = 14
        else
            sectionConfig = sectionConfig or {}
            sectionName = sectionConfig.Title or "Section"
            description = sectionConfig.Description
            isExpanded = sectionConfig.Default == true or sectionConfig.Defualt == true
            isLocked = sectionConfig.Locked == true
            titleTextSize = sectionConfig.TitleTextSize or 14
        end

        local Section = { 
            Type = "Section",
            TabName = Tab.Name,
            SectionName = sectionName
        }

        local SectionFrame = CreateElement("Frame", {
            Name = "Section",
            Parent = Page,
            Size = SafeUDim2.new(1, -12, 0, 0),
            AutomaticSize = SafeEnum.AutomaticSize.Y,
            BackgroundColor3 = SafeColor3.fromRGB(24, 24, 28),
            BackgroundTransparency = 0.45,
            BorderSizePixel = 0
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, Config.CornerRadius - 2),
            Parent = SectionFrame
        })

        CreateElement("UIPadding", {
            Parent = SectionFrame,
            PaddingBottom = SafeUDim.new(0, 8),
            PaddingLeft = SafeUDim.new(0, 12),
            PaddingRight = SafeUDim.new(0, 12),
            PaddingTop = SafeUDim.new(0, 8)
        })

        CreateElement("UIStroke", {
            Parent = SectionFrame,
            ApplyStrokeMode = SafeEnum.ApplyStrokeMode.Border,
            Color = Config.Colors.Stroke,
            Thickness = 1,
            Transparency = 0.3
        })

        CreateElement("UIListLayout", {
            Parent = SectionFrame,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local topBox = nil
        local chevronIcon = nil

        if not isLocked then
            topBox = CreateElement("TextButton", {
                Name = "TopBox",
                Parent = SectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Text = ""
            })

            CreateElement("UIListLayout", {
                Parent = topBox,
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            chevronIcon = CreateElement("ImageButton", {
                Name = "ChevronIcon",
                Parent = topBox,
                Size = UDim2.new(0, 24, 0, 24),
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = "rbxassetid://15269180996",
                ImageRectOffset = Vector2.new(0, 257),
                ImageRectSize = Vector2.new(256, 256),
                ImageColor3 = Config.Colors.Text,
                Rotation = 0,
                ZIndex = 99
            })

            local SectionLabel = CreateElement("TextLabel", {
                Name = "SectionLabel",
                Parent = topBox,
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Font = Enum.Font.Gotham,
                Text = sectionName,
                TextColor3 = Config.Colors.Text,
                TextSize = titleTextSize,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                TextTruncate = Enum.TextTruncate.AtEnd,
                RichText = true,
                LineHeight = 1.2,
                Visible = sectionName ~= nil and sectionName ~= ""
            })

            chevronIcon.Parent = SectionLabel

            if description and description ~= "" then
                CreateElement("TextLabel", {
                    Name = "DescriptionLabel",
                    Parent = topBox,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = description,
                    TextColor3 = Config.Colors.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    RichText = true
                })
            end
        else
            if sectionName and sectionName ~= "" then
                local SectionLabel = CreateElement("TextLabel", {
                    Name = "SectionLabel",
                    Parent = SectionFrame,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = sectionName,
                    TextColor3 = Config.Colors.Text,
                    TextSize = titleTextSize,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    RichText = true,
                    LineHeight = 1.2
                })
            end

            if description and description ~= "" then
                CreateElement("TextLabel", {
                    Name = "DescriptionLabel",
                    Parent = SectionFrame,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Font = Enum.Font.Gotham,
                    Text = description,
                    TextColor3 = Config.Colors.TextSecondary,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    RichText = true
                })
            end
        end

        local SectionContainer = CreateElement("Frame", {
            Name = "SectionContainer",
            Parent = SectionFrame,
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true
        })

        CreateElement("UIListLayout", {
            Parent = SectionContainer,
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        CreateElement("UIPadding", {
            Parent = SectionContainer,
            PaddingBottom = UDim.new(0, 1),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 1),
            PaddingTop = UDim.new(0, 1)
        })

        local sectionLayout = SectionContainer:FindFirstChild("UIListLayout")

        local function updateSectionSize()
            if sectionLayout then
                if isExpanded then
                    SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
                    task.wait()
                    local calculatedHeight = sectionLayout.AbsoluteContentSize.Y + 18
                    SectionContainer.AutomaticSize = Enum.AutomaticSize.None
                    SectionContainer.Size = UDim2.new(1, 0, 0, calculatedHeight)
                else
                    SectionContainer.Size = UDim2.new(1, 0, 0, 0)
                end
            end
        end

        if isExpanded then
            task.defer(function()
                updateSectionSize()
            end)
        end

        local function toggleSection()
            isExpanded = not isExpanded

            local targetSize
            if isExpanded then
                SectionContainer.AutomaticSize = Enum.AutomaticSize.Y
                task.wait()
                local calculatedHeight = sectionLayout.AbsoluteContentSize.Y + 18
                SectionContainer.AutomaticSize = Enum.AutomaticSize.None
                SectionContainer.Size = UDim2.new(1, 0, 0, 0)
                targetSize = UDim2.new(1, 0, 0, calculatedHeight)
            else
                targetSize = UDim2.new(1, 0, 0, 0)
            end
            
            TweenService:Create(SectionContainer, TweenInfo.new(0.3), {
                Size = targetSize
            }):Play()

            task.wait(0.35)
            updatePageCanvasSize()
        end

        if not isLocked and topBox and chevronIcon then
            topBox.MouseButton1Click:Connect(toggleSection)
            chevronIcon.MouseButton1Click:Connect(toggleSection)
        end

        if sectionLayout then
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if isExpanded then
                    local newHeight = sectionLayout.AbsoluteContentSize.Y + 18
                    TweenService:Create(SectionContainer, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, newHeight)
                    }):Play()
                    task.wait(0.15)
                    updatePageCanvasSize()
                end
            end)
        end

        if isLocked then
            Section.Container = SectionFrame
        else
            Section.Container = SectionContainer
        end

        -- Component Proxies
        function Section:AddToggle(toggleName, defaultState, callback)
            return ToggleMod.AddToggle(Section, Window, CreateElement, Config, SafeW, TweenService)(toggleName, defaultState, callback)
        end

        function Section:AddButton(buttonName, callback, variant, iconId)
            return ButtonMod.AddButton(Section, CreateElement, Config, TweenService)(buttonName, callback, variant, iconId)
        end

        function Section:AddIconsButton(buttonName, callback, iconId)
            return ButtonMod.AddIconsButton(Section, CreateElement, Config, TweenService)(buttonName, callback, iconId)
        end

        function Section:AddParagraph(ConfigTable)
            return ParagraphMod.AddParagraph(Section, CreateElement, Config)(ConfigTable)
        end

        function Section:AddTag(TagConfig)
            return ParagraphMod.AddTag(Section, CreateElement, Config, TweenService)(TagConfig)
        end

        function Section:AddTextbox(textboxName, placeholder, defaultValue, textDisappear, callback)
            return TextboxMod.AddTextbox(Section, Window, CreateElement, Config, TweenService)(textboxName, placeholder, defaultValue, textDisappear, callback)
        end

        function Section:AddInput(inputName, placeholder, defaultValue, callback)
            return TextboxMod.AddInput(Section, Window, CreateElement, Config, TweenService)(inputName, placeholder, defaultValue, callback)
        end

        function Section:AddDropdown(dropdownConfig, options, default, callback)
            return DropdownMod.AddDropdown(Section, Window, CreateElement, Config, TweenService, updatePageCanvasSize)(dropdownConfig, options, default, callback)
        end

        function Section:AddSlider(sliderConfig, minVal, maxVal, defaultVal, callback)
            return SliderMod.AddSlider(Section, Window, CreateElement, Config, SafeW, TweenService, UserInputService)(sliderConfig, minVal, maxVal, defaultVal, callback)
        end

        return Section
    end
end

return { SetupAddSection = SetupAddSection }

end)

__DEF("GNCHUB.window.tab", function()
-- File: GNCHUB/window/tab.lua
--[[
    GNCHUB Modular Library
    Modul  : Tab
    Layer  : 4
    Require: window/section
    Ekspor : SetupAddTab(Window, deps)
--]]

local function SetupAddTab(Window, deps)
    local CreateElement       = deps.CreateElement
    local Config              = deps.Config
    local SafeW               = deps.SafeW
    local TweenService        = deps.TweenService
    local UserInputService    = deps.UserInputService
    local RunService          = deps.RunService
    local ScrollToElement     = deps.ScrollToElement
    local MakeDraggable       = deps.MakeDraggable
    local SetupMomentumScrolling = deps.SetupMomentumScrolling
    local SetupKeyboardNavigation = deps.SetupKeyboardNavigation
    local CreateEnhancedScrollFrame = deps.CreateEnhancedScrollFrame
    local SmoothScrollTo     = deps.SmoothScrollTo
    local CleanupConnections = deps.CleanupConnections

    local SafeEnum    = SafeW.SafeEnum
    local SafeUDim2   = SafeW.SafeUDim2
    local SafeUDim    = SafeW.SafeUDim
    local SafeColor3  = SafeW.SafeColor3
    local SafeVector2 = SafeW.SafeVector2

    local Tabs = Window.Tabs
    local CurrentTab = nil
    local PageContainer = Window.PageContainer
    local TabContainer = Window.TabContainer
    local ContentContainer = Window.ContentContainer
    local Library = Window.Library

    function Window:AddTab(tabName, iconId, config)
        local Tab = {}

        local actualTabName = tabName
        local simpleLockedSyntax = false
        if string.find(tabName, ", Lock$") then
            actualTabName = string.gsub(tabName, ", Lock$", "")
            simpleLockedSyntax = true
        end

        local tabConfig = {}
        if type(iconId) == "table" then
            tabConfig = iconId
            iconId = tabConfig.Icon
        elseif type(config) == "table" then
            tabConfig = config
        else
            tabConfig = {}
        end

        local isLocked = simpleLockedSyntax or tabConfig.Locked == true

        if not Library.KeySystem.Config.KeyVerified then
            for _, lockedTabName in pairs(Library.KeySystem.Config.LockedTabs or {}) do
                if string.lower(actualTabName) == string.lower(lockedTabName) then
                    isLocked = true
                    break
                end
            end
        end

        local lockMessage = tabConfig.LockMessage or (not Library.KeySystem.Config.KeyVerified and "This premium tab is locked. Activate your key to unlock all features." or "This tab is locked. because you are not a premium user")
        local lockIcon = tabConfig.LockIcon or "rbxassetid://72426107706105"

        Tab.IsLocked = isLocked
        Tab.LockMessage = lockMessage
        Tab.LockIcon = lockIcon
        Tab.Name = actualTabName

        if not iconId and Config.TabIcons[actualTabName] then
            iconId = Config.TabIcons[actualTabName]
        end

        local Page = CreateEnhancedScrollFrame({
            Name = actualTabName .. "Page",
            Parent = PageContainer,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
        })

        SetupMomentumScrolling(Page)
        SetupKeyboardNavigation(Page)
        local PageLayout = CreateElement("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Parent = Page,
        })

        CreateElement("UIPadding", {
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 4),
            Parent = Page,
        })

        local function updatePageCanvasSize()
            if RunService and RunService.Heartbeat then
                RunService.Heartbeat:Wait()
                RunService.Heartbeat:Wait()
            end
            local contentHeight = PageLayout.AbsoluteContentSize.Y + 30
            Page.CanvasSize = UDim2.new(0, 0, 0, math.max(contentHeight, Page.AbsoluteSize.Y))
        end
        deps.updatePageCanvasSize = updatePageCanvasSize

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updatePageCanvasSize)
        Page.DescendantAdded:Connect(function()
            task.wait(0.1)
            updatePageCanvasSize()
        end)
        Page.DescendantRemoving:Connect(function()
            task.wait(0.1)
            updatePageCanvasSize()
        end)

        -- Clean, Modern Tab Button
        local TabButton = CreateElement("TextButton", {
            Name = actualTabName .. "Button",
            Parent = TabContainer,
            Size = SafeUDim2.new(1, 0, 0, 36),
            Position = SafeUDim2.new(0, 0, 0, 0),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 7),
            Parent = TabButton
        })

        -- Selection Background Plate
        local SelectionBackground = CreateElement("Frame", {
            Name = "SelectionBG",
            Parent = TabButton,
            BackgroundColor3 = Config.Colors.PrimaryLight,
            BackgroundTransparency = 1,
            Position = SafeUDim2.new(0, 0, 0, 0),
            Size = SafeUDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            ZIndex = TabButton.ZIndex,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 7),
            Parent = SelectionBackground
        })

        local SelectionStroke = CreateElement("UIStroke", {
            Name = "SelectionStroke",
            Parent = SelectionBackground,
            Color = Config.Colors.StrokeLight,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = SafeEnum.ApplyStrokeMode.Border
        })

        -- Left Active Pill Indicator
        local AccentLine = CreateElement("Frame", {
            Name = "AccentLine",
            Parent = TabButton,
            BackgroundColor3 = Config.Colors.Accent,
            BackgroundTransparency = 1,
            AnchorPoint = SafeVector2.new(0, 0.5),
            Position = SafeUDim2.new(0, 2, 0.5, 0),
            Size = SafeUDim2.new(0, 3, 0, 0),
            BorderSizePixel = 0,
            ZIndex = TabButton.ZIndex + 2,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 2),
            Parent = AccentLine
        })

        local LockIconElement = nil
        local TabIcon = nil

        if isLocked then
            LockIconElement = CreateElement("ImageLabel", {
                Name = "LockIcon",
                Parent = TabButton,
                Size = SafeUDim2.new(0, 16, 0, 16),
                Position = SafeUDim2.new(0, 12, 0.5, 0),
                AnchorPoint = SafeVector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = lockIcon,
                ImageColor3 = Config.Colors.TextSecondary,
                ImageTransparency = 0.45,
                Visible = true,
                ZIndex = TabButton.ZIndex + 1,
            })

            TabIcon = CreateElement("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                Size = SafeUDim2.new(0, 16, 0, 16),
                Position = SafeUDim2.new(0, 12, 0.5, 0),
                AnchorPoint = SafeVector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = iconId or Config.TabIcons[actualTabName] or "rbxassetid://131516675975293",
                ImageColor3 = Config.Colors.TextSecondary,
                ImageTransparency = 0.45,
                Visible = false,
                ZIndex = TabButton.ZIndex + 1,
            })
        else
            TabIcon = CreateElement("ImageLabel", {
                Name = "Icon",
                Parent = TabButton,
                Size = SafeUDim2.new(0, 16, 0, 16),
                Position = SafeUDim2.new(0, 12, 0.5, 0),
                AnchorPoint = SafeVector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = iconId or Config.TabIcons[actualTabName] or "rbxassetid://131516675975293",
                ImageColor3 = Config.Colors.TextSecondary,
                ImageTransparency = 0.45,
                Visible = true,
                ZIndex = TabButton.ZIndex + 1,
            })

            LockIconElement = CreateElement("ImageLabel", {
                Name = "LockIcon",
                Parent = TabButton,
                Size = SafeUDim2.new(0, 16, 0, 16),
                Position = SafeUDim2.new(0, 12, 0.5, 0),
                AnchorPoint = SafeVector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Image = lockIcon,
                ImageColor3 = Config.Colors.TextSecondary,
                ImageTransparency = 0.45,
                Visible = false,
                ZIndex = TabButton.ZIndex + 1,
            })
        end

        local TabLabel = CreateElement("TextLabel", {
            Name = "Title",
            Parent = TabButton,
            Font = SafeEnum.Font.GothamMedium,
            TextColor3 = Config.Colors.TextSecondary,
            TextTransparency = 0.45,
            TextSize = 12.5,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextXAlignment = SafeEnum.TextXAlignment.Left,
            TextYAlignment = SafeEnum.TextYAlignment.Center,
            TextTruncate = SafeEnum.TextTruncate.AtEnd,
            AnchorPoint = SafeVector2.new(0, 0.5),
            Position = SafeUDim2.new(0, 35, 0.5, 0),
            Size = SafeUDim2.new(1, -40, 1, 0),
            Text = actualTabName,
            ZIndex = TabButton.ZIndex + 1,
        })

        Tab.Button = TabButton
        Tab.Icon = TabIcon
        Tab.Label = TabLabel
        Tab.SelectionBackground = SelectionBackground
        Tab.SelectionStroke = SelectionStroke
        Tab.AccentLine = AccentLine
        Tab.Page = Page
        Tab.Selected = false
        Tab.LockIconElement = LockIconElement

        local fastTween = TweenInfo.new(0.18, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)
        local hoverTween = TweenInfo.new(0.12, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out)

        local function SelectTab()
            if Tab.IsLocked then
                Window:Notify("Tab Locked", Tab.LockMessage, 3)
                return
            end

            if not ContentContainer.Visible then return end

            for _, existingTab in pairs(Tabs) do
                if existingTab.Label and existingTab.SelectionBackground then
                    existingTab.Label.Font = SafeEnum.Font.GothamMedium
                    TweenService:Create(
                        existingTab.Label,
                        fastTween,
                        { TextColor3 = Config.Colors.TextSecondary, TextTransparency = 0.45 }
                    ):Play()

                    if existingTab.IsLocked and existingTab.LockIconElement and existingTab.LockIconElement.Visible then
                        TweenService:Create(
                            existingTab.LockIconElement,
                            fastTween,
                            { ImageColor3 = Config.Colors.TextSecondary, ImageTransparency = 0.45 }
                        ):Play()
                    elseif not existingTab.IsLocked and existingTab.Icon and existingTab.Icon.Visible then
                        TweenService:Create(
                            existingTab.Icon,
                            fastTween,
                            { ImageColor3 = Config.Colors.TextSecondary, ImageTransparency = 0.45 }
                        ):Play()
                    end

                    if existingTab.AccentLine then
                        TweenService:Create(
                            existingTab.AccentLine,
                            fastTween,
                            { Size = SafeUDim2.new(0, 3, 0, 0), BackgroundTransparency = 1 }
                        ):Play()
                    end

                    TweenService:Create(
                        existingTab.SelectionBackground,
                        fastTween,
                        { BackgroundTransparency = 1 }
                    ):Play()

                    if existingTab.SelectionStroke then
                        TweenService:Create(
                            existingTab.SelectionStroke,
                            fastTween,
                            { Transparency = 1 }
                        ):Play()
                    end

                    existingTab.Page.Visible = false
                    existingTab.Selected = false
                end
            end

            -- Activate Selected Tab
            TabLabel.Font = SafeEnum.Font.GothamBold
            TweenService:Create(
                TabLabel,
                fastTween,
                { TextColor3 = Config.Colors.Text, TextTransparency = 0 }
            ):Play()

            if Tab.IsLocked and LockIconElement and LockIconElement.Visible then
                TweenService:Create(
                    LockIconElement,
                    fastTween,
                    { ImageColor3 = Config.Colors.Text, ImageTransparency = 0 }
                ):Play()
            elseif not Tab.IsLocked and TabIcon and TabIcon.Visible then
                TweenService:Create(
                    TabIcon,
                    fastTween,
                    { ImageColor3 = Config.Colors.Accent, ImageTransparency = 0 }
                ):Play()
            end

            TweenService:Create(
                SelectionBackground,
                fastTween,
                { BackgroundColor3 = SafeColor3.fromRGB(35, 35, 42), BackgroundTransparency = 0 }
            ):Play()

            if SelectionStroke then
                TweenService:Create(
                    SelectionStroke,
                    fastTween,
                    { Color = SafeColor3.fromRGB(55, 55, 65), Transparency = 0.4 }
                ):Play()
            end

            TweenService:Create(
                AccentLine,
                fastTween,
                { Size = SafeUDim2.new(0, 3, 0, 18), BackgroundTransparency = 0 }
            ):Play()

            Tab.Selected = true
            CurrentTab = Tab
            Page.Visible = true

            if ScrollToElement and Window.TabScroller then
                ScrollToElement(Window.TabScroller, TabButton)
            end

            updatePageCanvasSize()
        end

        TabButton.MouseEnter:Connect(function()
            if not Tab.Selected then
                TweenService:Create(
                    TabLabel,
                    hoverTween,
                    { TextColor3 = Config.Colors.Text, TextTransparency = 0.1 }
                ):Play()

                if Tab.IsLocked and LockIconElement and LockIconElement.Visible then
                    TweenService:Create(
                        LockIconElement,
                        hoverTween,
                        { ImageColor3 = Config.Colors.Text, ImageTransparency = 0.1 }
                    ):Play()
                elseif not Tab.IsLocked and TabIcon and TabIcon.Visible then
                    TweenService:Create(
                        TabIcon,
                        hoverTween,
                        { ImageColor3 = Config.Colors.Text, ImageTransparency = 0.1 }
                    ):Play()
                end

                TweenService:Create(
                    SelectionBackground,
                    hoverTween,
                    { BackgroundColor3 = SafeColor3.fromRGB(28, 28, 34), BackgroundTransparency = 0.3 }
                ):Play()

                if SelectionStroke then
                    TweenService:Create(
                        SelectionStroke,
                        hoverTween,
                        { Color = SafeColor3.fromRGB(45, 45, 52), Transparency = 0.6 }
                    ):Play()
                end
            end
        end)

        TabButton.MouseLeave:Connect(function()
            if not Tab.Selected then
                TweenService:Create(
                    TabLabel,
                    fastTween,
                    { TextColor3 = Config.Colors.TextSecondary, TextTransparency = 0.45 }
                ):Play()

                if Tab.IsLocked and LockIconElement and LockIconElement.Visible then
                    TweenService:Create(
                        LockIconElement,
                        fastTween,
                        { ImageColor3 = Config.Colors.TextSecondary, ImageTransparency = 0.45 }
                    ):Play()
                elseif not Tab.IsLocked and TabIcon and TabIcon.Visible then
                    TweenService:Create(
                        TabIcon,
                        fastTween,
                        { ImageColor3 = Config.Colors.TextSecondary, ImageTransparency = 0.45 }
                    ):Play()
                end

                TweenService:Create(
                    SelectionBackground,
                    fastTween,
                    { BackgroundTransparency = 1 }
                ):Play()

                if SelectionStroke then
                    TweenService:Create(
                        SelectionStroke,
                        fastTween,
                        { Transparency = 1 }
                    ):Play()
                end
            end
        end)

        TabButton.MouseButton1Click:Connect(SelectTab)

        function Tab:Select()
            SelectTab()
        end

        table.insert(Tabs, Tab)

        if not CurrentTab then SelectTab() end

        deps.Page = Page
        deps.Window = Window
        local SectionMod = __REQUIRE("GNCHUB.window.section")
        SectionMod.SetupAddSection(Tab, deps)

        return Tab
    end

    function Window:SelectTab(tabName)
        for _, tab in ipairs(Tabs) do
            if string.lower(tab.Name) == string.lower(tabName) then
                tab:Select()
                return true
            end
        end
        return false
    end

    function Window:AddHomeTab(tabName)
        tabName = tabName or "Home"
        return self:AddTab(tabName)
    end

    function Window:AddMainTab(tabName)
        tabName = tabName or "Main"
        return self:AddTab(tabName)
    end
end

return { SetupAddTab = SetupAddTab }

end)

__DEF("GNCHUB.window.window", function()
-- File: GNCHUB/window/window.lua
--[[
    GNCHUB Modular Library
    Modul  : Window
    Layer  : 3
    Require: utils/elements, core/config, core/safe_wrappers, utils/draggable, utils/scroll
    Ekspor : SetupCreateWindow(Library, deps)
--]]

local function SetupCreateWindow(Library, deps)
    local CreateElement       = deps.CreateElement
    local Config              = deps.Config
    local SafeW               = deps.SafeW
    local TweenService        = deps.TweenService
    local UserInputService    = deps.UserInputService
    local RunService          = deps.RunService
    local ScrollToElement     = deps.ScrollToElement
    local MakeDraggable       = deps.MakeDraggable
    local ScrollConnections   = deps.ScrollConnections
    local GlobalInputConnections = deps.GlobalInputConnections
    local SetupMomentumScrolling = deps.SetupMomentumScrolling
    local SetupKeyboardNavigation = deps.SetupKeyboardNavigation
    local CreateEnhancedScrollFrame = deps.CreateEnhancedScrollFrame
    local SmoothScrollTo     = deps.SmoothScrollTo
    local CleanupConnections = deps.CleanupConnections
    local ResolveColor       = deps.ResolveColor

    local SafeEnum    = SafeW.SafeEnum
    local SafeUDim2   = SafeW.SafeUDim2
    local SafeUDim    = SafeW.SafeUDim
    local SafeColor3  = SafeW.SafeColor3
    local SafeVector2 = SafeW.SafeVector2
    local SafeRect    = SafeW.SafeRect

    function Library:CreateWindow(config)
        local Window = {}
        local Tabs = {}
        local CurrentTab = nil
        local isMinimized = false
        
        local ConfigElements = {}
        
        local function GetGameInfo()
            local gameName = "Unknown"
            local placeId = "0"
            
            pcall(function()
                placeId = tostring(game.PlaceId)
            end)
            
            pcall(function()
                local marketplaceService = game:GetService("MarketplaceService")
                local info = marketplaceService:GetProductInfo(game.PlaceId)
                if info and info.Name then
                    gameName = info.Name:gsub("[^%w%s%-_]", ""):gsub("%s+", "_"):sub(1, 50)
                end
            end)
            
            if gameName == "Unknown" or gameName == "" then
                pcall(function()
                    gameName = game:GetService("Players").LocalPlayer:GetAttribute("GameName") or "Game_" .. placeId
                end)
            end
            
            if gameName == "Unknown" or gameName == "" then
                gameName = "Game_" .. placeId
            end
            
            return gameName, placeId
        end
        
        local GameName, GamePlaceId = GetGameInfo()
        local BaseConfigFolder = "GNCHUB_Configs"
        local ConfigFolder = BaseConfigFolder .. "/" .. GameName .. "_" .. GamePlaceId
        local AutoLoadConfigFile = ConfigFolder .. "/autoload.txt"
        
        local function EnsureConfigFolders()
            if makefolder and isfolder then
                if not isfolder(BaseConfigFolder) then
                    makefolder(BaseConfigFolder)
                end
                if not isfolder(ConfigFolder) then
                    makefolder(ConfigFolder)
                end
            end
        end
        
        EnsureConfigFolders()

        local title, description, size, tagText, tagColor, toggleButton
        if type(config) == "string" then
            title = config
            description = ""
            size = SafeUDim2.new(0, 580, 0, 380)
            tagText = "v5.14.7"
            tagColor = ResolveColor(Config.Colors.Accent)
            toggleButton = ""
        elseif type(config) == "table" then
            title = config.Title or config.title or "GNCHUB Window"
            description = config.Description or config.description or ""
            size = config.Size or config.size or SafeUDim2.new(0, 580, 0, 380)
            tagText = config.TagText or config.tagText or "v5.14.7"
            tagColor = ResolveColor(config.TagColor or config.tagColor or Config.Colors.Accent)
            toggleButton = config.ToggleButton or config.toggleButton or ""
        else
            title = "GNCHUB Window"
            description = ""
            size = SafeUDim2.new(0, 580, 0, 380)
            tagText = "v5.14.7"
            tagColor = ResolveColor(Config.Colors.Accent)
        end

        local parent = nil

        if pcall(function() return gethui() end) then
            parent = gethui()
        elseif pcall(function() return game:GetService("CoreGui") end) then
            parent = game:GetService("CoreGui")
        else
            local playersService = game:GetService("Players")
            if playersService and playersService.LocalPlayer then
                local success, playerGui = pcall(function()
                    return playersService.LocalPlayer:WaitForChild("PlayerGui")
                end)
                if success then
                    parent = playerGui
                end
            end
        end

        if not parent then
            parent = setmetatable({}, {
                __index = function() return function() end end
            })
        end

        local ScreenGui = CreateElement("ScreenGui", {
            Name = "GNCHUB_UI",
            Parent = parent,
            ResetOnSpawn = false,
        })
        Library.Window = ScreenGui

        local toggleBtn = nil
        if toggleButton and toggleButton ~= "" then
            toggleBtn = CreateElement("ImageButton", {
                Name = "ToggleButton",
                Parent = ScreenGui,
                AnchorPoint = SafeVector2.new(0.5, 0),
                AutoButtonColor = false,
                BackgroundColor3 = Config.Colors.Background,
                Position = SafeUDim2.new(0.5, 8, 0, 0),
                Size = SafeUDim2.new(0, 45, 0, 45),
                Image = toggleButton,
                Visible = false,
                ZIndex = 1000,
            })

            CreateElement("UICorner", {
                CornerRadius = SafeUDim.new(0, 6),
                Parent = toggleBtn
            })

            CreateElement("UIStroke", {
                Color = Config.Colors.StrokeLight,
                Thickness = 1,
                Parent = toggleBtn
            })
        end

        local MainFrame = CreateElement("Frame", {
            Name = "MainFrame",
            Parent = ScreenGui,
            Size = size,
            Position = SafeUDim2.fromScale(0.5, 0.5),
            AnchorPoint = SafeVector2.new(0.5, 0.5),
            BackgroundColor3 = Config.Colors.Background,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, Config.CornerRadius),
            Parent = MainFrame
        })

        CreateElement("UIStroke", {
            Color = Config.Colors.StrokeLight,
            Thickness = 1.5,
            Transparency = 0.2,
            Parent = MainFrame
        })

        local WindowGradient = CreateElement("UIGradient", {
            Parent = MainFrame,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(20, 20, 24)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(16, 16, 18))
            }),
            Rotation = 90
        })

        local ShadowFrame = CreateElement("Frame", {
            Name = "WindowShadow",
            Parent = MainFrame,
            Size = SafeUDim2.new(1, 8, 1, 8),
            Position = SafeUDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = SafeVector2.new(0.5, 0.5),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = math.max(0, (MainFrame.ZIndex or 1) - 1),
            Active = false,
            Selectable = false,
            InputTransparent = true,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, Config.CornerRadius + 2),
            Parent = ShadowFrame
        })

        MainFrame.Size = SafeUDim2.new(0, 0, 0, 0)
        MainFrame.BackgroundTransparency = 1
        ShadowFrame.BackgroundTransparency = 1

        local entranceTween = TweenService:Create(MainFrame,
            TweenInfo.new(0.4, SafeEnum.EasingStyle.Back, SafeEnum.EasingDirection.Out), {
            Size = size,
            BackgroundTransparency = 0
        })

        local shadowTween = TweenService:Create(ShadowFrame,
            TweenInfo.new(0.35, SafeEnum.EasingStyle.Quad, SafeEnum.EasingDirection.Out), {
            BackgroundTransparency = 0.7
        })

        entranceTween:Play()
        task.wait(0.05)
        shadowTween:Play()

        MainFrame.Visible = true
        ScreenGui.Enabled = true

        local TitleBar = CreateElement("Frame", {
            Name = "TitleBar",
            Parent = MainFrame,
            Size = SafeUDim2.new(1, 0, 0, 38),
            BackgroundColor3 = Config.Colors.Primary,
            BorderSizePixel = 0,
        })

        local TitleBarGradient = CreateElement("UIGradient", {
            Parent = TitleBar,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(32, 32, 38)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(28, 28, 32))
            }),
            Rotation = 90
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, Config.CornerRadius),
            Parent = TitleBar
        })

        local TitleSeparator = CreateElement("Frame", {
            Name = "TitleSeparator",
            Parent = TitleBar,
            Size = SafeUDim2.new(1, 0, 0, 1),
            Position = SafeUDim2.new(0, 0, 1, -1),
            BackgroundColor3 = Config.Colors.StrokeLight,
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
        })

        CreateElement("UIGradient", {
            Parent = TitleSeparator,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, SafeColor3.fromRGB(60, 60, 68)),
                ColorSequenceKeypoint.new(0.5, SafeColor3.fromRGB(80, 80, 90)),
                ColorSequenceKeypoint.new(1, SafeColor3.fromRGB(60, 60, 68))
            }),
            Rotation = 0
        })

        MakeDraggable(TitleBar)

        local AppIcon = CreateElement("ImageLabel", {
            Name = "AppIcon",
            Parent = TitleBar,
            Size = SafeUDim2.new(0, 20, 0, 20),
            Position = SafeUDim2.new(0, 15, 0.5, 0),
            AnchorPoint = SafeVector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://82393254565370",
            ScaleType = SafeEnum.ScaleType.Fit,
        })
        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 6),
            Parent = AppIcon
        })

        local TitleLabel = CreateElement("TextLabel", {
            Name = "TitleLabel",
            Parent = TitleBar,
            Size = SafeUDim2.new(1, -240, 1, 0),
            Position = SafeUDim2.new(0, 42, 0, 0),
            BackgroundTransparency = 1,
            Font = SafeEnum.Font.GothamBold,
            Text = title,
            TextColor3 = Config.Colors.Text,
            TextSize = 14,
            TextXAlignment = SafeEnum.TextXAlignment.Left,
        })

        local TitlebarTag = CreateElement("Frame", {
            Name = "TitlebarTag",
            Parent = TitleBar,
            Size = SafeUDim2.new(0, 0, 0, 24),
            Position = SafeUDim2.new(1, -200, 0.5, 0),
            AnchorPoint = SafeVector2.new(0, 0.5),
            BackgroundColor3 = tagColor,
            AutomaticSize = SafeEnum.AutomaticSize.X,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, 999),
            Parent = TitlebarTag
        })

        CreateElement("UIPadding", {
            Parent = TitlebarTag,
            PaddingLeft = SafeUDim.new(0, 12),
            PaddingRight = SafeUDim.new(0, 12),
            PaddingTop = SafeUDim.new(0, 4),
            PaddingBottom = SafeUDim.new(0, 4)
        })

        CreateElement("UIListLayout", {
            Parent = TitlebarTag,
            FillDirection = SafeEnum.FillDirection.Horizontal,
            VerticalAlignment = SafeEnum.VerticalAlignment.Center,
            HorizontalAlignment = SafeEnum.HorizontalAlignment.Center
        })

        local function getTextColorForBackground(bgColor)
            local brightness = 0.299 * bgColor.R + 0.587 * bgColor.G + 0.114 * bgColor.B
            if brightness > 0.5 then
                return SafeColor3.fromRGB(0, 0, 0)
            else
                return SafeColor3.fromRGB(255, 255, 255)
            end
        end

        local TitlebarTagText = CreateElement("TextLabel", {
            Name = "TitlebarTagText",
            Parent = TitlebarTag,
            BackgroundTransparency = 1,
            AutomaticSize = SafeEnum.AutomaticSize.XY,
            TextSize = 12,
            Font = SafeEnum.Font.GothamSemibold,
            Text = tagText,
            TextColor3 = getTextColorForBackground(tagColor),
            TextXAlignment = SafeEnum.TextXAlignment.Center,
            TextYAlignment = SafeEnum.TextYAlignment.Center
        })

        local WindowControls = CreateElement("Frame", {
            Name = "WindowControls",
            Parent = TitleBar,
            Size = SafeUDim2.new(0, 90, 0, 30),
            Position = SafeUDim2.new(1, -80, 0.5, 0),
            AnchorPoint = SafeVector2.new(0, 0.5),
            BackgroundTransparency = 1,
        })

        local CloseButton = CreateElement("TextButton", {
            Name = "CloseButton",
            Parent = WindowControls,
            Size = SafeUDim2.new(0, 30, 0, 30),
            Position = SafeUDim2.new(0, 43, 0.5, 0),
            AnchorPoint = SafeVector2.new(0, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        })

        local CloseIcon = CreateElement("ImageLabel", {
            Name = "CloseIcon",
            Parent = CloseButton,
            Size = SafeUDim2.new(0, 18, 0, 18),
            Position = SafeUDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = SafeVector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://102969121878134",
            ImageColor3 = Config.Colors.TextSecondary,
        })

        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad), {
                Size = SafeUDim2.new(0, 20, 0, 20),
                ImageColor3 = Config.Colors.Error
            }):Play()
        end)

        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseIcon, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad), {
                Size = SafeUDim2.new(0, 18, 0, 18),
                ImageColor3 = Config.Colors.TextSecondary
            }):Play()
        end)

        local MinimizeButton = CreateElement("TextButton", {
            Name = "MinimizeButton",
            Parent = WindowControls,
            Size = SafeUDim2.new(0, 30, 0, 30),
            Position = SafeUDim2.new(0, 0, 0.5, 0),
            AnchorPoint = SafeVector2.new(0, 0.5),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
        })

        local MinimizeIcon = CreateElement("ImageLabel", {
            Name = "MinimizeIcon",
            Parent = MinimizeButton,
            Size = SafeUDim2.new(0, 18, 0, 18),
            Position = SafeUDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = SafeVector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://118651690157486",
            ImageColor3 = Config.Colors.TextSecondary,
        })

        MinimizeButton.MouseEnter:Connect(function()
            TweenService:Create(MinimizeIcon, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad), {
                Size = SafeUDim2.new(0, 20, 0, 20),
                ImageColor3 = Config.Colors.Text
            }):Play()
        end)

        MinimizeButton.MouseLeave:Connect(function()
            TweenService:Create(MinimizeIcon, TweenInfo.new(0.15, SafeEnum.EasingStyle.Quad), {
                Size = SafeUDim2.new(0, 18, 0, 18),
                ImageColor3 = Config.Colors.TextSecondary
            }):Play()
        end)

        CloseButton.MouseButton1Click:Connect(function()
            local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                CleanupConnections()
                ScreenGui:Destroy()
            end)
        end)

        local function updateTagPosition()
            task.wait()
            
            if TitlebarTag.AbsoluteSize.X == 0 then
                return
            end
            
            local titleStartX = TitleLabel.Position.X.Offset
            local tagSpacing = 10
            local titleTextWidth = TitleLabel.TextBounds.X
            local idealTagX = titleStartX + titleTextWidth + tagSpacing
            
            local controlsStartX = WindowControls.AbsolutePosition.X - TitleBar.AbsolutePosition.X
            local tagWidth = TitlebarTag.AbsoluteSize.X
            local safetyMargin = 10
            
            local maxTagX = controlsStartX - tagWidth - safetyMargin
            if maxTagX < 0 then
                maxTagX = 0
            end
            
            local newTagX = math.max(0, math.min(idealTagX, maxTagX))
            
            if newTagX + tagWidth + safetyMargin > controlsStartX then
                newTagX = math.max(0, controlsStartX - tagWidth - safetyMargin)
            end
            
            TitlebarTag.Position = SafeUDim2.new(0, newTagX, 0.5, 0)
        end
        
        task.spawn(function()
            repeat task.wait() until TitlebarTag.AbsoluteSize.X > 0
            updateTagPosition()
        end)
        
        TitleLabel:GetPropertyChangedSignal("Text"):Connect(function()
            updateTagPosition()
        end)
        
        TitleLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
            updateTagPosition()
        end)
        
        TitlebarTag:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            updateTagPosition()
        end)
        
        TitleBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            updateTagPosition()
        end)

        ScreenGui.Destroying:Connect(function()
            CleanupConnections()
        end)

        local ContentContainer = CreateElement("Frame", {
            Name = "ContentContainer",
            Parent = MainFrame,
            Size = UDim2.new(1, 0, 1, -38),
            Position = UDim2.new(0, 0, 0, 38),
            BackgroundTransparency = 1,
        })

        local TabSidebar = CreateElement("Frame", {
            Name = "TabSidebar",
            Parent = ContentContainer,
            Size = UDim2.new(0, 130, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
        })

        CreateElement("UICorner", {
            CornerRadius = SafeUDim.new(0, Config.CornerRadius),
            Parent = TabSidebar
        })

        -- Hide the top-left and top-right rounding by placing a square cover frame
        CreateElement("Frame", {
            Name = "TabSidebarTopCover",
            Parent = TabSidebar,
            Size = UDim2.new(1, 0, 0, Config.CornerRadius),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
        })

        -- Hide the bottom-right rounding by placing a square cover frame
        CreateElement("Frame", {
            Name = "TabSidebarBottomRightCover",
            Parent = TabSidebar,
            Size = UDim2.new(0, Config.CornerRadius, 0, Config.CornerRadius),
            Position = UDim2.new(1, -Config.CornerRadius, 1, -Config.CornerRadius),
            BackgroundColor3 = SafeColor3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
        })

        local SidebarDivider = CreateElement("Frame", {
            Name = "SidebarDivider",
            Parent = ContentContainer,
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(0, 130, 0, 0),
            BackgroundColor3 = Config.Colors.Stroke,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
        })

        local TabScroller = CreateEnhancedScrollFrame({
            Name = "TabScroller",
            Parent = TabSidebar,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1,
        })
        TabScroller.ScrollBarThickness = 0
        TabScroller.ScrollBarImageTransparency = 1

        SetupMomentumScrolling(TabScroller)
        SetupKeyboardNavigation(TabScroller)

        local TabContainer = CreateElement("Frame", {
            Name = "TabContainer",
            Parent = TabScroller,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        })

        CreateElement("UIPadding", {
            PaddingTop = UDim.new(0, 6),
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 4),
            Parent = TabContainer,
        })

        local TabListLayout = CreateElement("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContainer,
        })

        local function updateTabCanvasSize()
            if RunService and RunService.Heartbeat then
                RunService.Heartbeat:Wait()
            end
            local contentHeight = TabListLayout.AbsoluteContentSize.Y + 12
            TabScroller.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end

        local function updateTabCanvasSizeOnChange()
            local contentHeight = TabListLayout.AbsoluteContentSize.Y + 12
            TabScroller.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
        end

        TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvasSizeOnChange)
        TabContainer.DescendantAdded:Connect(updateTabCanvasSize)
        TabContainer.DescendantRemoving:Connect(updateTabCanvasSize)

        local PageContainer = CreateElement("Frame", {
            Name = "PageContainer",
            Parent = ContentContainer,
            Size = UDim2.new(1, -131, 1, 0),
            Position = UDim2.new(0, 131, 0, 0),
            BackgroundTransparency = 1,
        })

        CreateElement("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            Parent = PageContainer,
        })

        local ClickDetector = CreateElement("TextButton", {
            Name = "ClickDetector",
            Parent = ScreenGui,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 50,
            Visible = false,
        })

        ClickDetector.MouseButton1Click:Connect(function()
            ClickDetector.Visible = false
        end)

        local function ToggleVisibility()
            isMinimized = not isMinimized

            if not isMinimized then
                ContentContainer.Visible = true
                MainFrame.Visible = true
                MainFrame.AnchorPoint = SafeVector2.new(0.5, 0.5)
                MainFrame:TweenSize(size, "Out", "Quad", 0.2)
                MainFrame:TweenPosition(SafeUDim2.fromScale(0.5, 0.5), "Out", "Quad", 0.2)

                if toggleBtn then
                    toggleBtn.Visible = false
                end
            else
                ContentContainer.Visible = false
                MainFrame.Visible = false

                if toggleBtn then
                    toggleBtn.Visible = true
                end
            end
        end

        MinimizeButton.MouseButton1Click:Connect(ToggleVisibility)

        if toggleBtn then
            MakeDraggable(toggleBtn)
            toggleBtn.MouseButton1Click:Connect(ToggleVisibility)
        end

        if UserInputService then
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == SafeEnum.KeyCode.RightControl then
                    ToggleVisibility()
                end
            end)
        end

        Window.Tabs = Tabs
        Window.ScreenGui = ScreenGui
        Window.ContentContainer = ContentContainer
        Window.PageContainer = PageContainer
        Window.TabContainer = TabContainer
        Window.ConfigElements = ConfigElements
        Window.ConfigFolder = ConfigFolder
        Window.AutoLoadConfigFile = AutoLoadConfigFile
        Window.EnsureConfigFolders = EnsureConfigFolders
        Window.Library = Library

        -- Setup Tab methods
        local TabSetup = __REQUIRE("GNCHUB.window.tab")
        TabSetup.SetupAddTab(Window, deps)

        -- Setup Notify methods
        local NotifySetup = __REQUIRE("GNCHUB.features.notify")
        NotifySetup.SetupNotify(Window, deps)

        -- Setup Config System
        local ConfigSystemSetup = __REQUIRE("GNCHUB.features.config_system")
        ConfigSystemSetup.SetupConfigSystem(Window, deps)

        return Window
    end
end

return { SetupCreateWindow = SetupCreateWindow }

end)

return __REQUIRE("GNCHUB")
