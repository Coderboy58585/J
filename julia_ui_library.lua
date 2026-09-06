-- Julia UI Library
-- Small repo-hosted UI helper layer for Julia Hub. Keep this file UI-only.

local Library = {}

Library.Name = "JuliaUILibrary"
Library.Version = "0.3.0"

function Library.Create(className, props, children)
	local object = Instance.new(className)
	for property, value in pairs(props or {}) do
		object[property] = value
	end
	for _, child in ipairs(children or {}) do
		child.Parent = object
	end
	return object
end

function Library.Corner(radius)
	return Library.Create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
	})
end

function Library.Stroke(color, thickness, transparency)
	return Library.Create("UIStroke", {
		Color = color or Color3.fromRGB(255, 255, 255),
		Thickness = thickness or 2,
		Transparency = transparency or 0,
	})
end

function Library.Tween(object, time, props, tweenService, activeTweens)
	if not object or not object.Parent then
		return nil
	end
	tweenService = tweenService or game:GetService("TweenService")
	activeTweens = activeTweens or {}
	local previousTween = activeTweens[object]
	if previousTween then
		pcall(function()
			previousTween:Cancel()
		end)
	end
	local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local animation = tweenService:Create(object, info, props)
	activeTweens[object] = animation
	animation.Completed:Connect(function()
		if activeTweens[object] == animation then
			activeTweens[object] = nil
		end
	end)
	animation:Play()
	return animation
end

function Library.MakeScreenGui(config)
	return Library.Create("ScreenGui", {
		Name = config.Name or "JuliaHub",
		ResetOnSpawn = config.ResetOnSpawn == nil and false or config.ResetOnSpawn,
		IgnoreGuiInset = config.IgnoreGuiInset == nil and true or config.IgnoreGuiInset,
		DisplayOrder = config.DisplayOrder or 999,
		Parent = config.Parent,
	})
end

function Library.MakeTopRightBadge(config)
	local theme = config.Theme
	return Library.Create("TextLabel", {
		Name = config.Name,
		AnchorPoint = Vector2.new(1, 0),
		Size = config.Size,
		Position = config.Position,
		BackgroundColor3 = config.BackgroundColor3,
		BackgroundTransparency = config.BackgroundTransparency or 0,
		BorderSizePixel = 0,
		Text = config.Text or "",
		TextColor3 = config.TextColor3 or theme.Text,
		TextSize = config.TextSize or 14,
		Font = config.Font or Enum.Font.GothamBold,
		TextXAlignment = config.TextXAlignment or Enum.TextXAlignment.Center,
		TextYAlignment = config.TextYAlignment or Enum.TextYAlignment.Center,
		TextWrapped = config.TextWrapped or false,
		Visible = config.Visible == nil and true or config.Visible,
		ZIndex = config.ZIndex or 100,
		Parent = config.Parent,
	}, { Library.Corner(config.CornerRadius or 8) })
end

function Library.MakeHudLabel(config)
	local label = Library.MakeTopRightBadge({
		Name = config.Name,
		Theme = config.Theme,
		Parent = config.Parent,
		Size = config.Size,
		Position = config.Position,
		BackgroundColor3 = config.BackgroundColor3 or Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = config.BackgroundTransparency or 0.45,
		Text = config.Text,
		TextColor3 = config.TextColor3,
		TextSize = config.TextSize,
		Font = config.Font,
		TextXAlignment = config.TextXAlignment,
		TextYAlignment = config.TextYAlignment,
		TextWrapped = config.TextWrapped,
		Visible = config.Visible,
		ZIndex = config.ZIndex,
		CornerRadius = config.CornerRadius,
	})
	if config.Padding then
		Library.Create("UIPadding", {
			PaddingTop = UDim.new(0, config.Padding.Top or 0),
			PaddingBottom = UDim.new(0, config.Padding.Bottom or 0),
			PaddingLeft = UDim.new(0, config.Padding.Left or 0),
			PaddingRight = UDim.new(0, config.Padding.Right or 0),
			Parent = label,
		})
	end
	return label
end

function Library.MakeFOVCircle(config)
	local stroke = Library.Stroke(config.Color, config.Thickness or 2, config.Transparency or 0.15)
	local frame = Library.Create("Frame", {
		Name = config.Name or "FOVCircle",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Visible = config.Visible,
		Parent = config.Parent,
	}, {
		Library.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		stroke,
	})
	return {
		Frame = frame,
		Stroke = stroke,
	}
end

function Library.MakeCrosshairHolder(config)
	return Library.Create("Frame", {
		Name = config.Name or "CrosshairHolder",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = config.Size or UDim2.fromOffset(90, 90),
		Position = config.Position or UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = config.ZIndex or 200,
		Parent = config.Parent,
	})
end

function Library.MakeControlPanel(config)
	local theme = config.Theme
	local panel = Library.Create("Frame", {
		Name = config.Name or "ControlPanel",
		Size = config.Size or UDim2.fromOffset(250, 760),
		Position = config.Position or UDim2.fromOffset(20, 90),
		BackgroundColor3 = theme.Main,
		BackgroundTransparency = theme.PanelTransparency,
		BorderSizePixel = 0,
		Visible = config.Visible == nil and true or config.Visible,
		Parent = config.Parent,
	}, { Library.Corner(config.CornerRadius or 10) })

	local gradient = Library.Create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, theme.GradientA),
			ColorSequenceKeypoint.new(1, theme.GradientB),
		}),
		Rotation = 35,
		Enabled = theme.GradientEnabled,
		Parent = panel,
	})

	local title = Library.Create("TextLabel", {
		Name = "PanelTitle",
		Size = UDim2.new(1, -20, 0, 32),
		Position = UDim2.fromOffset(10, 8),
		BackgroundTransparency = 1,
		Text = config.Title or "Julia Hub",
		TextColor3 = theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	})

	local subtitle = Library.Create("TextLabel", {
		Name = "PanelSubtitle",
		Size = UDim2.new(1, -20, 0, 34),
		Position = UDim2.fromOffset(10, 36),
		BackgroundTransparency = 1,
		Text = config.Subtitle or "K = menu | Right Mouse = camera assist",
		TextColor3 = theme.Muted,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	})

	local dragHandle = Library.Create("Frame", {
		Name = "DragHandle",
		Size = UDim2.new(1, 0, 0, 70),
		Position = UDim2.fromOffset(0, 0),
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = 1,
		Parent = panel,
	})

	return {
		Panel = panel,
		Gradient = gradient,
		Title = title,
		Subtitle = subtitle,
		DragHandle = dragHandle,
	}
end

function Library.MakeKeyGui(config)
	local theme = config.Theme
	local keyGui = Library.Create("ScreenGui", {
		Name = "KeySystemGui",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 50,
		Parent = config.Parent,
	})
	local frame = Library.Create("Frame", {
		Size = UDim2.fromOffset(400, 245),
		Position = UDim2.new(0.5, -200, 0.5, -122),
		BackgroundColor3 = theme.Main,
		BorderSizePixel = 0,
		Parent = keyGui,
	}, { Library.Corner(12) })
	Library.Create("TextLabel", {
		Size = UDim2.new(1, -30, 0, 40),
		Position = UDim2.fromOffset(15, 15),
		BackgroundTransparency = 1,
		Text = "Julia Hub Key System",
		TextColor3 = theme.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})
	Library.Create("TextLabel", {
		Size = UDim2.new(1, -30, 0, 24),
		Position = UDim2.fromOffset(15, 55),
		BackgroundTransparency = 1,
		Text = "Enter your access key to continue",
		TextColor3 = theme.Muted,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})
	local keyBox = Library.Create("TextBox", {
		Size = UDim2.new(1, -40, 0, 40),
		Position = UDim2.fromOffset(20, 90),
		BackgroundColor3 = theme.Button,
		TextColor3 = theme.Text,
		PlaceholderText = "Enter key...",
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		Text = "",
		TextSize = 14,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false,
		Parent = frame,
	}, { Library.Corner(8) })
	local statusLabel = Library.Create("TextLabel", {
		Size = UDim2.new(1, -40, 0, 44),
		Position = UDim2.fromOffset(20, 135),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = theme.Bad,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})
	local submitButton = Library.Create("TextButton", {
		Size = UDim2.new(1, -40, 0, 38),
		Position = UDim2.fromOffset(20, 188),
		BackgroundColor3 = theme.Accent,
		TextColor3 = theme.Text,
		Text = "Submit Key",
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = frame,
	}, { Library.Corner(8) })
	return {
		Gui = keyGui,
		Frame = frame,
		KeyBox = keyBox,
		StatusLabel = statusLabel,
		SubmitButton = submitButton,
	}
end

function Library.MakeRadar(config)
	local radarConfig = config.RadarConfig
	local frame = Library.Create("Frame", {
		Name = config.Name or "BasedGPTRadar",
		AnchorPoint = Vector2.new(1, 0),
		Position = config.Position or UDim2.new(1, -12, 0, 80),
		Size = UDim2.fromOffset(radarConfig.Size, radarConfig.Size),
		BackgroundColor3 = radarConfig.BackgroundColor,
		BorderSizePixel = 0,
		Visible = config.Visible or false,
		ZIndex = 100,
		Parent = config.Parent,
	}, {
		Library.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		Library.Create("UIStroke", {
			Color = Color3.fromRGB(114, 124, 156),
			Thickness = 2,
			Transparency = 0.15,
		}),
		Library.Create("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
	})

	local inner = Library.Create("Frame", {
		Name = "Inner",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 101,
		Parent = frame,
	})

	local function createRing(scale)
		return Library.Create("Frame", {
			Name = "Ring",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(scale, scale),
			BackgroundTransparency = 1,
			ZIndex = 101,
			Parent = inner,
		}, {
			Library.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Library.Create("UIStroke", {
				Color = radarConfig.GridColor,
				Thickness = 1,
				Transparency = 0.35,
			}),
		})
	end

	createRing(1)
	createRing(0.66)
	createRing(0.33)

	Library.Create("Frame", {
		Name = "HorizontalLine",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -12, 0, 1),
		BackgroundColor3 = radarConfig.GridColor,
		BorderSizePixel = 0,
		BackgroundTransparency = 0.35,
		ZIndex = 101,
		Parent = inner,
	})

	Library.Create("Frame", {
		Name = "VerticalLine",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0, 1, 1, -12),
		BackgroundColor3 = radarConfig.GridColor,
		BorderSizePixel = 0,
		BackgroundTransparency = 0.35,
		ZIndex = 101,
		Parent = inner,
	})

	Library.Create("Frame", {
		Name = "CenterDot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = radarConfig.CenterColor,
		BorderSizePixel = 0,
		ZIndex = 103,
		Parent = inner,
	}, {
		Library.Create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local headingMarker = Library.Create("Frame", {
		Name = "HeadingMarker",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(4, 24),
		BackgroundColor3 = radarConfig.CenterColor,
		BorderSizePixel = 0,
		ZIndex = 102,
		Parent = inner,
	})

	local blipFolder = Library.Create("Folder", {
		Name = "Blips",
		Parent = inner,
	})

	return {
		Frame = frame,
		Inner = inner,
		HeadingMarker = headingMarker,
		BlipFolder = blipFolder,
	}
end

function Library.MakeModernCategoryShell(config)
	local theme = config.Theme
	local panel = config.Panel
	local connect = config.Connect
	local tween = config.Tween or function(object, _, props)
		for property, value in pairs(props or {}) do
			object[property] = value
		end
	end
	local categories = config.Categories or {}
	local accentPresets = config.AccentPresets or {}
	local onCategorySelected = config.OnCategorySelected or function() end
	local onModeToggle = config.OnModeToggle or function() end
	local onAccentSelected = config.OnAccentSelected or function() end

	local panelStroke = Library.Create("UIStroke", {
		Name = "ModernPanelStroke",
		Color = theme.CurrentAccent,
		Thickness = 1.4,
		Transparency = 0.22,
		Enabled = true,
		Parent = panel,
	})

	local railShadow = Library.Create("Frame", {
		Name = "ModernRailShadow",
		Size = UDim2.fromOffset(96, 566),
		Position = UDim2.fromOffset(-102, 78),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.76,
		BorderSizePixel = 0,
		Visible = true,
		ZIndex = 39,
		Parent = panel,
	}, { Library.Corner(18) })

	local rail = Library.Create("Frame", {
		Name = "ModernCategoryRail",
		Size = UDim2.fromOffset(96, 566),
		Position = UDim2.fromOffset(-108, 72),
		BackgroundColor3 = Color3.fromRGB(12, 15, 23),
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Visible = true,
		ZIndex = 40,
		Parent = panel,
	}, {
		Library.Corner(18),
		Library.Stroke(theme.CurrentAccent, 1.2, 0.35),
		Library.Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 30, 44)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 10, 15)),
			}),
			Rotation = 90,
		}),
	})

	local railTitle = Library.Create("TextLabel", {
		Name = "RailTitle",
		Size = UDim2.new(1, -12, 0, 34),
		Position = UDim2.fromOffset(6, 8),
		BackgroundTransparency = 1,
		Text = "JULIA",
		TextColor3 = theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 42,
		Parent = rail,
	})

	local categoryLabel = Library.Create("TextLabel", {
		Name = "ModernCategoryLabel",
		Size = UDim2.fromOffset(118, 24),
		Position = UDim2.new(1, -132, 0, 12),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Text = categories[1] and categories[1].Name or "Combat",
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		ZIndex = 6,
		Parent = panel,
	}, { Library.Corner(10) })

	local modeToggle = Library.Create("TextButton", {
		Name = "UIModeToggle",
		Size = UDim2.fromOffset(74, 24),
		Position = UDim2.new(1, -84, 0, 42),
		BackgroundColor3 = theme.CurrentAccent,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Text = "Modern",
		TextColor3 = theme.Text,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 10,
		Parent = panel,
	}, { Library.Corner(10) })

	local categoryButtons = {}
	for index, category in ipairs(categories) do
		local button = Library.Create("TextButton", {
			Name = "ModernCategory_" .. tostring(category.Page or index),
			Size = UDim2.new(1, -14, 0, 42),
			Position = UDim2.fromOffset(7, 46 + ((index - 1) * 48)),
			BackgroundColor3 = Color3.fromRGB(26, 31, 44),
			BackgroundTransparency = 0.2,
			BorderSizePixel = 0,
			Text = category.Name or ("Page " .. tostring(index)),
			TextColor3 = theme.Text,
			TextSize = 11,
			Font = Enum.Font.GothamBold,
			AutoButtonColor = false,
			ZIndex = 42,
			Parent = rail,
		}, { Library.Corner(13) })
		categoryButtons[category.Page or index] = button
		connect(button.MouseEnter, function()
			tween(button, 0.12, {
				BackgroundTransparency = 0.08,
				Size = UDim2.new(1, -10, 0, 44),
				Position = UDim2.fromOffset(5, 45 + ((index - 1) * 48)),
			})
		end)
		connect(button.MouseLeave, function()
			local selected = button:GetAttribute("JuliaSelected") == true
			tween(button, 0.12, {
				BackgroundColor3 = selected and theme.CurrentAccent or Color3.fromRGB(26, 31, 44),
				BackgroundTransparency = selected and 0.02 or 0.2,
				Size = UDim2.new(1, -14, 0, 42),
				Position = UDim2.fromOffset(7, 46 + ((index - 1) * 48)),
			})
		end)
		connect(button.MouseButton1Click, function()
			onCategorySelected(category.Page or index)
		end)
	end

	local accentButtons = {}
	for index, preset in ipairs(accentPresets) do
		local button = Library.Create("TextButton", {
			Name = "ModernAccent_" .. tostring(index),
			Size = UDim2.fromOffset(18, 18),
			Position = UDim2.fromOffset(10 + ((index - 1) * 21), 532),
			BackgroundColor3 = preset.A,
			BorderSizePixel = 0,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 43,
			Parent = rail,
		}, {
			Library.Corner(999),
			Library.Stroke(Color3.fromRGB(255, 255, 255), 1, 0.45),
		})
		accentButtons[index] = button
		connect(button.MouseButton1Click, function()
			onAccentSelected(preset)
		end)
	end

	connect(modeToggle.MouseEnter, function()
		tween(modeToggle, 0.12, {
			BackgroundTransparency = 0,
			Size = UDim2.fromOffset(78, 26),
			Position = UDim2.new(1, -86, 0, 41),
		})
	end)
	connect(modeToggle.MouseLeave, function()
		tween(modeToggle, 0.12, {
			BackgroundTransparency = 0.08,
			Size = UDim2.fromOffset(74, 24),
			Position = UDim2.new(1, -84, 0, 42),
		})
	end)
	connect(modeToggle.MouseButton1Click, onModeToggle)

	local api = {}
	function api.SetActivePage(page, modernEnabled)
		local selectedName = "Page " .. tostring(page)
		for _, category in ipairs(categories) do
			local button = categoryButtons[category.Page]
			local selected = category.Page == page
			if selected then
				selectedName = category.Name
			end
			if button then
				button.BackgroundColor3 = selected and theme.CurrentAccent or Color3.fromRGB(26, 31, 44)
				button.BackgroundTransparency = selected and 0.02 or 0.2
				button:SetAttribute("JuliaSelected", selected)
			end
		end
		categoryLabel.Text = selectedName
		rail.Visible = modernEnabled
		railShadow.Visible = modernEnabled
	end
	function api.SetMode(mode)
		local modernEnabled = mode == "Modern"
		rail.Visible = modernEnabled
		railShadow.Visible = modernEnabled
		categoryLabel.Visible = modernEnabled
		modeToggle.Visible = true
		modeToggle.Text = modernEnabled and "Modern" or "Classic"
		panelStroke.Enabled = modernEnabled
	end
	function api.RefreshTheme()
		panelStroke.Color = theme.CurrentAccent
		modeToggle.BackgroundColor3 = theme.CurrentAccent
		for _, button in pairs(categoryButtons) do
			if button.BackgroundTransparency <= 0.03 then
				button.BackgroundColor3 = theme.CurrentAccent
			end
		end
	end

	return {
		Rail = rail,
		RailShadow = railShadow,
		CategoryLabel = categoryLabel,
		ModeToggle = modeToggle,
		PanelStroke = panelStroke,
		CategoryButtons = categoryButtons,
		AccentButtons = accentButtons,
		SetActivePage = api.SetActivePage,
		SetMode = api.SetMode,
		RefreshTheme = api.RefreshTheme,
	}
end

function Library.MakeStudioShell(config)
	local theme = config.Theme
	local panel = config.Panel
	local screenGui = config.ScreenGui
	local connect = config.Connect
	local tween = config.Tween or function(object, _, props)
		for property, value in pairs(props or {}) do
			object[property] = value
		end
	end
	local categories = config.Categories or {}
	local onCategorySelected = config.OnCategorySelected or function() end
	local onModeToggle = config.OnModeToggle or function() end
	local getScale = config.GetScale or function()
		return 1
	end

	local shell = Library.Create("Frame", {
		Name = "StudioShell",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 10,
		Parent = panel,
	})

	local panelStroke = Library.Create("UIStroke", {
		Name = "StudioPanelStroke",
		Color = theme.CurrentAccent,
		Thickness = 1.25,
		Transparency = 0.34,
		Enabled = false,
		Parent = panel,
	})

	local panelScale = panel:FindFirstChild("StudioUIScale") or Library.Create("UIScale", {
		Name = "StudioUIScale",
		Scale = 1,
		Parent = panel,
	})

	local ambient = Library.Create("Frame", {
		Name = "Ambient",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(10, 13, 19),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		ZIndex = 10,
		Parent = shell,
	}, {
		Library.Corner(18),
		Library.Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 24, 34)),
				ColorSequenceKeypoint.new(0.52, Color3.fromRGB(11, 14, 21)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 18, 27)),
			}),
			Rotation = 24,
		}),
	})

	for index = 1, 5 do
		Library.Create("Frame", {
			Name = "GridLine" .. tostring(index),
			Size = UDim2.new(0, 1, 1, -24),
			Position = UDim2.new(index / 6, 0, 0, 12),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.965,
			BorderSizePixel = 0,
			ZIndex = 11,
			Parent = ambient,
		})
	end

	local logo = Library.Create("Frame", {
		Name = "LogoMark",
		Size = UDim2.fromOffset(38, 38),
		Position = UDim2.fromOffset(16, 15),
		BackgroundColor3 = theme.CurrentAccent,
		BorderSizePixel = 0,
		ZIndex = 22,
		Parent = shell,
	}, { Library.Corner(11) })
	local logoGradient = Library.Create("UIGradient", {
		Color = ColorSequence.new(theme.GradientA, theme.GradientB),
		Rotation = 35,
		Parent = logo,
	})

	Library.Create("TextLabel", {
		Name = "LogoText",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "J",
		TextColor3 = theme.Text,
		TextSize = 19,
		Font = Enum.Font.GothamBlack,
		ZIndex = 23,
		Parent = logo,
	})

	local title = Library.Create("TextLabel", {
		Name = "StudioTitle",
		Size = UDim2.fromOffset(260, 24),
		Position = UDim2.fromOffset(66, 13),
		BackgroundTransparency = 1,
		Text = "JULIA CONTROL",
		TextColor3 = theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = shell,
	})

	local subtitle = Library.Create("TextLabel", {
		Name = "StudioSubtitle",
		Size = UDim2.fromOffset(340, 18),
		Position = UDim2.fromOffset(66, 35),
		BackgroundTransparency = 1,
		Text = "SESSION READY  /  K TO TOGGLE  /  DRAG THE HEADER",
		TextColor3 = theme.Muted,
		TextSize = 9,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = shell,
	})

	local statusPill = Library.Create("TextLabel", {
		Name = "StatusPill",
		Size = UDim2.fromOffset(76, 24),
		Position = UDim2.new(1, -174, 0, 22),
		BackgroundColor3 = Color3.fromRGB(28, 39, 35),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Text = "●  ONLINE",
		TextColor3 = Color3.fromRGB(126, 235, 169),
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		ZIndex = 24,
		Parent = shell,
	}, { Library.Corner(999) })

	local modeToggle = Library.Create("TextButton", {
		Name = "StudioModeToggle",
		Size = UDim2.fromOffset(82, 28),
		Position = UDim2.new(1, -94, 0, 20),
		BackgroundColor3 = Color3.fromRGB(31, 37, 50),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		Text = "STUDIO  III",
		TextColor3 = theme.Text,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 30,
		Parent = shell,
	}, {
		Library.Corner(9),
		Library.Stroke(theme.CurrentAccent, 1, 0.48),
	})

	local divider = Library.Create("Frame", {
		Name = "HeaderDivider",
		Size = UDim2.new(1, -28, 0, 1),
		Position = UDim2.fromOffset(14, 64),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.91,
		BorderSizePixel = 0,
		ZIndex = 14,
		Parent = shell,
	})

	local sidebar = Library.Create("Frame", {
		Name = "StudioSidebar",
		Size = UDim2.fromOffset(164, 474),
		Position = UDim2.fromOffset(14, 74),
		BackgroundColor3 = Color3.fromRGB(14, 18, 26),
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		ZIndex = 14,
		Parent = shell,
	}, {
		Library.Corner(13),
		Library.Stroke(Color3.fromRGB(255, 255, 255), 1, 0.92),
	})

	Library.Create("TextLabel", {
		Name = "NavigationLabel",
		Size = UDim2.new(1, -20, 0, 22),
		Position = UDim2.fromOffset(10, 9),
		BackgroundTransparency = 1,
		Text = "WORKSPACES",
		TextColor3 = theme.Muted,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 18,
		Parent = sidebar,
	})

	local content = Library.Create("Frame", {
		Name = "StudioContent",
		Size = UDim2.new(1, -202, 1, -86),
		Position = UDim2.fromOffset(188, 74),
		BackgroundColor3 = Color3.fromRGB(17, 21, 30),
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 14,
		Parent = shell,
	}, {
		Library.Corner(13),
		Library.Stroke(Color3.fromRGB(255, 255, 255), 1, 0.92),
	})

	local categoryTitle = Library.Create("TextLabel", {
		Name = "StudioCategoryTitle",
		Size = UDim2.new(1, -30, 0, 25),
		Position = UDim2.fromOffset(15, 10),
		BackgroundTransparency = 1,
		Text = categories[1] and categories[1].Name or "Overview",
		TextColor3 = theme.Text,
		TextSize = 17,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 19,
		Parent = content,
	})

	local categoryHint = Library.Create("TextLabel", {
		Name = "StudioCategoryHint",
		Size = UDim2.new(1, -30, 0, 18),
		Position = UDim2.fromOffset(15, 35),
		BackgroundTransparency = 1,
		Text = categories[1] and categories[1].Description or "Session controls and preferences",
		TextColor3 = theme.Muted,
		TextSize = 10,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 19,
		Parent = content,
	})

	local contentDivider = Library.Create("Frame", {
		Name = "ContentDivider",
		Size = UDim2.new(1, -30, 0, 1),
		Position = UDim2.fromOffset(15, 58),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.92,
		BorderSizePixel = 0,
		ZIndex = 18,
		Parent = content,
	})

	local categoryButtons = {}
	local pageFrames = {}
	local pageLayouts = {}
	for index, category in ipairs(categories) do
		local page = category.Page or index
		local button = Library.Create("TextButton", {
			Name = "StudioCategory_" .. tostring(page),
			Size = UDim2.new(1, -16, 0, 38),
			Position = UDim2.fromOffset(8, 35 + ((index - 1) * 43)),
			BackgroundColor3 = Color3.fromRGB(24, 29, 40),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "  " .. (category.Name or ("Page " .. tostring(page))),
			TextColor3 = theme.Muted,
			TextSize = 11,
			Font = Enum.Font.GothamMedium,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			ZIndex = 18,
			Parent = sidebar,
		}, { Library.Corner(9) })
		categoryButtons[page] = button
		connect(button.MouseEnter, function()
			if button:GetAttribute("JuliaSelected") ~= true then
				tween(button, 0.12, { BackgroundTransparency = 0.45, TextColor3 = theme.Text })
			end
		end)
		connect(button.MouseLeave, function()
			if button:GetAttribute("JuliaSelected") ~= true then
				tween(button, 0.12, { BackgroundTransparency = 1, TextColor3 = theme.Muted })
			end
		end)
		connect(button.MouseButton1Click, function()
			onCategorySelected(page)
		end)

		local pageFrame = Library.Create("ScrollingFrame", {
			Name = "StudioPage_" .. tostring(page),
			Size = UDim2.new(1, -18, 1, -72),
			Position = UDim2.fromOffset(9, 66),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = theme.CurrentAccent,
			ScrollBarImageTransparency = 0.25,
			Visible = index == 1,
			ZIndex = 18,
			Parent = content,
		}, {
			Library.Create("UIPadding", {
				PaddingTop = UDim.new(0, 2),
				PaddingBottom = UDim.new(0, 10),
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 7),
			}),
		})
		local layout = Library.Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8),
			Parent = pageFrame,
		})
		pageFrames[page] = pageFrame
		pageLayouts[page] = layout
	end

	local footer = Library.Create("TextLabel", {
		Name = "StudioFooter",
		Size = UDim2.new(1, -20, 0, 22),
		Position = UDim2.new(0, 10, 1, -30),
		BackgroundTransparency = 1,
		Text = "v" .. tostring(config.Version or "0.6.5") .. "   •   SESSION SETTINGS ARE PRESERVED",
		TextColor3 = theme.Muted,
		TextSize = 8,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 18,
		Parent = sidebar,
	})

	local loadingOverlay = Library.Create("Frame", {
		Name = "StudioStartup",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(8, 10, 15),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 70,
		Parent = panel,
	}, { Library.Corner(18) })
	local loadingTitle = Library.Create("TextLabel", {
		Name = "LoadingTitle",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(320, 34),
		Position = UDim2.fromScale(0.5, 0.43),
		BackgroundTransparency = 1,
		Text = "JULIA CONTROL",
		TextColor3 = theme.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBlack,
		ZIndex = 72,
		Parent = loadingOverlay,
	})
	local loadingStatus = Library.Create("TextLabel", {
		Name = "LoadingStatus",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(320, 22),
		Position = UDim2.fromScale(0.5, 0.49),
		BackgroundTransparency = 1,
		Text = "PREPARING SESSION  0%",
		TextColor3 = theme.Muted,
		TextSize = 9,
		Font = Enum.Font.GothamBold,
		ZIndex = 72,
		Parent = loadingOverlay,
	})
	local loadingTrack = Library.Create("Frame", {
		Name = "LoadingTrack",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(250, 4),
		Position = UDim2.fromScale(0.5, 0.54),
		BackgroundColor3 = Color3.fromRGB(31, 36, 48),
		BorderSizePixel = 0,
		ZIndex = 72,
		Parent = loadingOverlay,
	}, { Library.Corner(999) })
	local loadingFill = Library.Create("Frame", {
		Name = "LoadingFill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = theme.CurrentAccent,
		BorderSizePixel = 0,
		ZIndex = 73,
		Parent = loadingTrack,
	}, { Library.Corner(999) })

	local originals = {}
	local pageItems = {}
	local activePage = categories[1] and (categories[1].Page or 1) or 1
	local active = false
	local adopted = false
	local density = config.Density or "Comfortable"
	local visibilityRevision = 0
	local loadingRevision = 0
	local renderedPage = nil

	local function responsiveScale()
		local wanted = math.clamp(tonumber(getScale()) or 1, 0.7, 1.2)
		local camera = workspace.CurrentCamera
		if not camera then
			return wanted
		end
		local viewport = camera.ViewportSize
		local available = math.min((viewport.X - 24) / 720, (viewport.Y - 24) / 560)
		return math.max(0.52, math.min(wanted, available))
	end

	local function remember(item)
		if originals[item] then
			return
		end
		originals[item] = {
			Parent = item.Parent,
			Position = item.Position,
			Size = item.Size,
			LayoutOrder = item.LayoutOrder,
			ZIndex = item.ZIndex,
			Font = (item:IsA("TextButton") or item:IsA("TextLabel")) and item.Font or nil,
			TextSize = (item:IsA("TextButton") or item:IsA("TextLabel")) and item.TextSize or nil,
			TextXAlignment = (item:IsA("TextButton") or item:IsA("TextLabel")) and item.TextXAlignment or nil,
		}
	end

	local function itemHeight(item)
		local saved = originals[item]
		if item:IsA("TextButton") then
			return density == "Compact" and 34 or 40
		end
		return math.max(20, saved and saved.Size.Y.Offset or item.Size.Y.Offset)
	end

	local function attachControls()
		if not adopted then
			return
		end
		for page, items in pairs(pageItems) do
			local pageFrame = pageFrames[page]
			if pageFrame then
				for order, item in ipairs(items) do
					if item and item.Parent then
						item.Parent = pageFrame
						item.LayoutOrder = order
						item.Position = UDim2.fromOffset(0, 0)
						item.Size = UDim2.new(1, 0, 0, itemHeight(item))
						item.ZIndex = 22
						if item:IsA("TextButton") then
							item.Font = Enum.Font.GothamMedium
							item.TextSize = density == "Compact" and 11 or 12
							item.BackgroundColor3 = Color3.fromRGB(27, 33, 45)
							item.BackgroundTransparency = 0.06
						end
						item.Visible = page == activePage
					end
				end
			end
		end
	end

	local function restoreControls()
		for item, saved in pairs(originals) do
			if item and item.Parent then
				item.Parent = saved.Parent
				item.Position = saved.Position
				item.Size = saved.Size
				item.LayoutOrder = saved.LayoutOrder
				item.ZIndex = saved.ZIndex
				if saved.Font then
					item.Font = saved.Font
					item.TextSize = saved.TextSize
					item.TextXAlignment = saved.TextXAlignment
				end
			end
		end
	end

	local api = {}
	function api.AdoptControls(pageButtons, pageDecor)
		table.clear(pageItems)
		for page = 1, math.max(#pageButtons, #pageDecor) do
			local items = {}
			for _, item in ipairs(pageButtons[page] or {}) do
				remember(item)
				table.insert(items, item)
			end
			for _, item in ipairs(pageDecor[page] or {}) do
				remember(item)
				table.insert(items, item)
			end
			table.sort(items, function(a, b)
				local aSaved = originals[a]
				local bSaved = originals[b]
				local ay = aSaved and aSaved.Position.Y.Offset or 0
				local by = bSaved and bSaved.Position.Y.Offset or 0
				if ay == by then
					local ax = aSaved and aSaved.Position.X.Offset or 0
					local bx = bSaved and bSaved.Position.X.Offset or 0
					return ax < bx
				end
				return ay < by
			end)
			pageItems[page] = items
		end
		adopted = true
		renderedPage = nil
		if active then
			attachControls()
		end
	end

	function api.SetActivePage(page)
		if renderedPage == page then
			return
		end
		activePage = page
		local selectedCategory = nil
		for _, category in ipairs(categories) do
			local categoryPage = category.Page or 1
			local selected = categoryPage == page
			local button = categoryButtons[categoryPage]
			if button then
				button:SetAttribute("JuliaSelected", selected)
				button.BackgroundColor3 = selected and theme.CurrentAccent or Color3.fromRGB(24, 29, 40)
				button.BackgroundTransparency = selected and 0.12 or 1
				button.TextColor3 = selected and theme.Text or theme.Muted
			end
			if selected then
				selectedCategory = category
			end
		end
		categoryTitle.Text = selectedCategory and selectedCategory.Name or ("Page " .. tostring(page))
		categoryHint.Text = selectedCategory and selectedCategory.Description or "Session controls and preferences"
		for pageNumber, pageFrame in pairs(pageFrames) do
			pageFrame.Visible = active and pageNumber == page
			if pageNumber == page then
				pageFrame.CanvasPosition = Vector2.zero
			end
		end
		for pageNumber, items in pairs(pageItems) do
			for _, item in ipairs(items) do
				if item and item.Parent then
					item.Visible = pageNumber == page
				end
			end
		end
		renderedPage = page
	end

	function api.SetMode(mode)
		local wasActive = active
		active = mode == "Studio"
		shell.Visible = active
		panelStroke.Enabled = active
		loadingRevision += 1
		loadingOverlay.Visible = false
		if active then
			if not wasActive then
				attachControls()
				renderedPage = nil
			end
			api.SetActivePage(activePage)
			panelScale.Scale = responsiveScale()
		elseif wasActive then
			restoreControls()
			renderedPage = nil
			for _, pageFrame in pairs(pageFrames) do
				pageFrame.Visible = false
			end
			panelScale.Scale = 1
		end
	end

	function api.SetDensity(value)
		local nextDensity = value == "Compact" and "Compact" or "Comfortable"
		if nextDensity == density then
			return
		end
		density = nextDensity
		for _, layout in pairs(pageLayouts) do
			layout.Padding = UDim.new(0, density == "Compact" and 5 or 8)
		end
		if active then
			attachControls()
		end
	end

	function api.SetScale()
		if active then
			panelScale.Scale = responsiveScale()
		end
	end

	function api.SetVisible(visible, animate)
		visibilityRevision += 1
		local revision = visibilityRevision
		local baseScale = responsiveScale()
		if not visible then
			loadingRevision += 1
			loadingOverlay.Visible = false
		end
		if not active or not animate then
			panel.Visible = visible
			panelScale.Scale = active and baseScale or 1
			return
		end
		if visible then
			panel.Visible = true
			panelScale.Scale = baseScale * 0.94
			tween(panelScale, 0.22, { Scale = baseScale })
		else
			tween(panelScale, 0.14, { Scale = baseScale * 0.96 })
			task.delay(0.15, function()
				if revision == visibilityRevision then
					panel.Visible = false
				end
			end)
		end
	end

	function api.AnimateOpen(showLoader)
		if not active then
			return
		end
		loadingRevision += 1
		local revision = loadingRevision
		panel.Visible = true
		local baseScale = responsiveScale()
		panelScale.Scale = baseScale * 0.9
		tween(panelScale, 0.3, { Scale = baseScale })
		if not showLoader then
			loadingOverlay.Visible = false
			return
		end
		loadingOverlay.Visible = true
		loadingOverlay.BackgroundTransparency = 0
		loadingTitle.TextTransparency = 0
		loadingStatus.TextTransparency = 0
		loadingFill.Size = UDim2.new(0, 0, 1, 0)
		task.spawn(function()
			local stages = {
				{ 0.24, "MOUNTING INTERFACE  24%" },
				{ 0.53, "RESTORING SESSION  53%" },
				{ 0.81, "BINDING CONTROLS  81%" },
				{ 1, "SESSION READY  100%" },
			}
			for _, stage in ipairs(stages) do
				if revision ~= loadingRevision or not active then
					return
				end
				loadingStatus.Text = stage[2]
				tween(loadingFill, 0.16, { Size = UDim2.new(stage[1], 0, 1, 0) })
				task.wait(0.17)
			end
			if revision ~= loadingRevision or not active then
				return
			end
			tween(loadingOverlay, 0.22, { BackgroundTransparency = 1 })
			tween(loadingTitle, 0.18, { TextTransparency = 1 })
			tween(loadingStatus, 0.18, { TextTransparency = 1 })
			task.wait(0.24)
			if revision == loadingRevision then
				loadingOverlay.Visible = false
			end
		end)
	end

	function api.RefreshTheme()
		panelStroke.Color = theme.CurrentAccent
		logo.BackgroundColor3 = theme.CurrentAccent
		logoGradient.Color = ColorSequence.new(theme.GradientA, theme.GradientB)
		loadingFill.BackgroundColor3 = theme.CurrentAccent
		local toggleStroke = modeToggle:FindFirstChildOfClass("UIStroke")
		if toggleStroke then
			toggleStroke.Color = theme.CurrentAccent
		end
		for page, button in pairs(categoryButtons) do
			if page == activePage then
				button.BackgroundColor3 = theme.CurrentAccent
			end
		end
		for _, pageFrame in pairs(pageFrames) do
			pageFrame.ScrollBarImageColor3 = theme.CurrentAccent
		end
	end

	connect(modeToggle.MouseEnter, function()
		tween(modeToggle, 0.12, { BackgroundColor3 = Color3.fromRGB(43, 50, 67) })
	end)
	connect(modeToggle.MouseLeave, function()
		tween(modeToggle, 0.12, { BackgroundColor3 = Color3.fromRGB(31, 37, 50) })
	end)
	connect(modeToggle.MouseButton1Click, onModeToggle)

	return {
		Shell = shell,
		ModeToggle = modeToggle,
		PanelScale = panelScale,
		SetMode = api.SetMode,
		SetActivePage = api.SetActivePage,
		SetDensity = api.SetDensity,
		SetScale = api.SetScale,
		SetVisible = api.SetVisible,
		AnimateOpen = api.AnimateOpen,
		AdoptControls = api.AdoptControls,
		RefreshTheme = api.RefreshTheme,
	}
end

Library.MakeStudioShell = nil

function Library.MakeButton(config)
	local theme = config.Theme
	local panel = config.Panel
	local connect = config.Connect
	local tween = config.Tween
	local callback = config.Callback or function() end
	local getMode = config.GetMode or function()
		return "Classic"
	end
	local pageButtons = config.PageButtons
	local activePage = config.ActivePage or 1
	local page = math.clamp(config.Page or 1, 1, #pageButtons)
	local buttonWidth = config.Width
	local buttonX = config.X or 10
	local buttonHeight = config.Height or 30
	local normalSize
	local hoverSize
	local clickSize
	if buttonWidth then
		normalSize = UDim2.fromOffset(buttonWidth, buttonHeight)
		hoverSize = UDim2.fromOffset(buttonWidth + 4, buttonHeight + 2)
		clickSize = UDim2.fromOffset(math.max(20, buttonWidth - 10), math.max(20, buttonHeight - 3))
	else
		normalSize = UDim2.new(1, -20, 0, buttonHeight)
		hoverSize = UDim2.new(1, -16, 0, buttonHeight + 2)
		clickSize = UDim2.new(1, -30, 0, math.max(20, buttonHeight - 3))
	end
	local normalPos = UDim2.fromOffset(buttonX, config.Y)
	local hoverPos = UDim2.fromOffset(buttonX - 2, config.Y - 1)
	local clickPos = UDim2.fromOffset(buttonX + 5, config.Y + 2)
	local button = Library.Create("TextButton", {
		Size = normalSize,
		Position = normalPos,
		BackgroundColor3 = theme.Button,
		BackgroundTransparency = theme.ButtonTransparency,
		TextColor3 = theme.Text,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		Text = config.Text,
		AutoButtonColor = false,
		Parent = panel,
	}, { Library.Corner(8) })
	table.insert(pageButtons[page], button)
	button.Visible = activePage == page
	connect(button.MouseEnter, function()
		if getMode() == "Studio" then
			tween(button, 0.12, {
				BackgroundColor3 = theme.ButtonHover,
				BackgroundTransparency = 0,
			})
			return
		end
		tween(button, 0.12, {
			BackgroundColor3 = theme.ButtonHover,
			Size = hoverSize,
			Position = hoverPos,
		})
	end)
	connect(button.MouseLeave, function()
		if getMode() == "Studio" then
			tween(button, 0.12, {
				BackgroundColor3 = Color3.fromRGB(27, 33, 45),
				BackgroundTransparency = 0.06,
			})
			return
		end
		tween(button, 0.12, {
			BackgroundColor3 = theme.Button,
			Size = normalSize,
			Position = normalPos,
		})
	end)
	connect(button.MouseButton1Down, function()
		if getMode() == "Studio" then
			tween(button, 0.07, {
				BackgroundColor3 = theme.ButtonClick,
			})
			return
		end
		tween(button, 0.07, {
			BackgroundColor3 = theme.ButtonClick,
			Size = clickSize,
			Position = clickPos,
		})
	end)
	connect(button.MouseButton1Up, function()
		if getMode() == "Studio" then
			tween(button, 0.1, {
				BackgroundColor3 = theme.ButtonHover,
			})
			return
		end
		tween(button, 0.1, {
			BackgroundColor3 = theme.ButtonHover,
			Size = hoverSize,
			Position = hoverPos,
		})
	end)
	connect(button.MouseButton1Click, function()
		callback(button)
	end)
	return button
end

function Library.MakeSliderSection(config)
	local theme = config.Theme
	local panel = config.Panel
	local connect = config.Connect
	local registerPageDecor = config.RegisterPageDecor
	local sliderVisuals = config.SliderVisuals
	local userInputService = config.UserInputService
	local options = config.Options or {}
	local stepValue = options.Step or 0.01
	local formatter = options.Formatter or function(value)
		return tostring(value)
	end
	local headerText = config.HeaderText
	local sliderText = config.SliderText
	local y = config.Y
	local minValue = config.MinValue
	local maxValue = config.MaxValue
	local initialValue = config.InitialValue
	local onChanged = config.OnChanged or function() end
	local page = config.Page

	local header = registerPageDecor(Library.Create("TextLabel", {
		Name = headerText:gsub("%s+", "") .. "Header",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, y),
		BackgroundTransparency = 1,
		Text = headerText,
		TextColor3 = theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), page)

	local frame = registerPageDecor(Library.Create("Frame", {
		Name = sliderText:gsub("%s+", "") .. "SliderFrame",
		Size = UDim2.new(1, -20, 0, 52),
		Position = UDim2.fromOffset(10, y + 22),
		Active = true,
		BackgroundColor3 = theme.Button,
		BackgroundTransparency = theme.ButtonTransparency,
		BorderSizePixel = 0,
		Parent = panel,
	}, { Library.Corner(8) }), page)

	local titleLabel = Library.Create("TextLabel", {
		Name = "SliderTitle",
		Size = UDim2.new(1, -70, 0, 18),
		Position = UDim2.fromOffset(10, 6),
		BackgroundTransparency = 1,
		Text = sliderText,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = frame,
	})

	local valueLabel = Library.Create("TextLabel", {
		Name = "SliderValue",
		Size = UDim2.fromOffset(54, 18),
		Position = UDim2.new(1, -64, 0, 6),
		BackgroundTransparency = 1,
		Text = formatter(initialValue),
		TextColor3 = theme.CurrentAccent,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = frame,
	})

	local track = Library.Create("Frame", {
		Name = "SliderTrack",
		Size = UDim2.new(1, -20, 0, 6),
		Position = UDim2.fromOffset(10, 34),
		Active = true,
		BackgroundColor3 = theme.ButtonHover,
		BorderSizePixel = 0,
		Parent = frame,
	}, { Library.Corner(999) })

	local fill = Library.Create("Frame", {
		Name = "SliderFill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = theme.CurrentAccent,
		BorderSizePixel = 0,
		Parent = track,
	}, { Library.Corner(999) })

	local knob = Library.Create("Frame", {
		Name = "SliderKnob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(12, 12),
		Position = UDim2.new(0, 0, 0.5, 0),
		Active = true,
		BackgroundColor3 = theme.Text,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = track,
	}, { Library.Corner(999) })

	table.insert(sliderVisuals, {
		Header = header,
		Frame = frame,
		Title = titleLabel,
		Value = valueLabel,
		Track = track,
		Fill = fill,
		Knob = knob,
	})

	local dragging = false
	local currentValue = initialValue

	local function applySliderValue(value)
		local alpha = math.clamp((value - minValue) / math.max(maxValue - minValue, 0.001), 0, 1)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = formatter(value)
		currentValue = value
		onChanged(value)
	end

	local function setValueFromInput(input)
		local trackX = track.AbsolutePosition.X
		local trackWidth = math.max(track.AbsoluteSize.X, 1)
		local alpha = math.clamp((input.Position.X - trackX) / trackWidth, 0, 1)
		local rawValue = minValue + ((maxValue - minValue) * alpha)
		local snappedValue = math.floor((rawValue / stepValue) + 0.5) * stepValue
		snappedValue = math.clamp(snappedValue, minValue, maxValue)
		applySliderValue(snappedValue)
	end

	connect(track.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setValueFromInput(input)
		end
	end)
	connect(knob.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			setValueFromInput(input)
		end
	end)
	connect(userInputService.InputChanged, function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			setValueFromInput(input)
		end
	end)
	connect(userInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	applySliderValue(currentValue)
	return frame
end

local SINISTER_GREEN = Color3.fromRGB(62, 255, 104)
local SINISTER_DARK = Color3.fromRGB(5, 12, 8)
local SINISTER_PANEL = Color3.fromRGB(8, 18, 12)

local function makeSinisterLabel(parent, text, size, position, textSize, color, zIndex, alignment)
	return Library.Create("TextLabel", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = text or "",
		TextColor3 = color or SINISTER_GREEN,
		TextSize = textSize or 12,
		Font = Enum.Font.Code,
		TextWrapped = true,
		TextXAlignment = alignment or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = zIndex or 932,
		Parent = parent,
	})
end

local function makeSinisterButton(parent, text, size, position, zIndex)
	return Library.Create("TextButton", {
		Size = size,
		Position = position,
		BackgroundColor3 = Color3.fromRGB(12, 35, 20),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = SINISTER_GREEN,
		TextSize = 12,
		Font = Enum.Font.Code,
		AutoButtonColor = false,
		Active = true,
		Selectable = true,
		ZIndex = zIndex or 934,
		Parent = parent,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.55),
	})
end

local function bindSinisterButton(button, connect, tween, callback)
	connect(button.MouseEnter, function()
		tween(button, 0.12, {
			BackgroundColor3 = Color3.fromRGB(20, 62, 34),
			BackgroundTransparency = 0,
		})
	end)
	connect(button.MouseLeave, function()
		tween(button, 0.12, {
			BackgroundColor3 = Color3.fromRGB(12, 35, 20),
			BackgroundTransparency = 0.08,
		})
	end)
	connect(button.Activated, callback)
end

local function makeSinisterInput(parent, labelText, defaultText, placeholder, position, width)
	local holder = Library.Create("Frame", {
		Size = UDim2.fromOffset(width, 50),
		Position = position,
		BackgroundColor3 = Color3.fromRGB(7, 25, 14),
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ZIndex = 933,
		Parent = parent,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.72),
	})
	makeSinisterLabel(holder, labelText, UDim2.new(1, -12, 0, 16), UDim2.fromOffset(7, 3), 10, Color3.fromRGB(120, 220, 145), 934)
	return Library.Create("TextBox", {
		Size = UDim2.new(1, -12, 0, 24),
		Position = UDim2.fromOffset(6, 21),
		BackgroundTransparency = 1,
		Text = tostring(defaultText or ""),
		PlaceholderText = placeholder or "",
		PlaceholderColor3 = Color3.fromRGB(74, 124, 88),
		TextColor3 = Color3.fromRGB(222, 255, 230),
		TextSize = 13,
		Font = Enum.Font.Code,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		Active = true,
		ZIndex = 935,
		Parent = holder,
	})
end

function Library.MakeSinisterPanel(config)
	local parent = config.Parent
	if not parent then
		return nil
	end

	local connect = config.Connect or function(signal, callback)
		return signal:Connect(callback)
	end
	local tweenService = config.TweenService or game:GetService("TweenService")
	local inputService = config.UserInputService or game:GetService("UserInputService")
	local tween = config.Tween or function(object, duration, properties)
		return Library.Tween(object, duration, properties, tweenService, {})
	end
	local accessCode = tostring(config.AccessCode or "Sinister")
	local unlocked = config.InitiallyUnlocked == true
	local matrixVisionEnabled = config.InitialMatrixVision == true
	local animationToken = 0
	local activePage = 1

	local gateLayer = Library.Create("Frame", {
		Name = "SinisterGateLayer",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.18,
		BorderSizePixel = 0,
		Visible = false,
		Active = true,
		ZIndex = 900,
		Parent = parent,
	})

	local gate = Library.Create("Frame", {
		Name = "SinisterGate",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(390, 224),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = SINISTER_DARK,
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		ZIndex = 902,
		Parent = gateLayer,
	}, {
		Library.Corner(10),
		Library.Stroke(SINISTER_GREEN, 1.5, 0.25),
		Library.Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 10, 7)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 31, 17)),
			}),
			Rotation = 28,
		}),
	})

	makeSinisterLabel(gate, "CLASSIFIED NODE // AUTHORIZATION REQUIRED", UDim2.new(1, -68, 0, 20), UDim2.fromOffset(18, 14), 10, Color3.fromRGB(116, 214, 140), 904)
	makeSinisterLabel(gate, "SINISTER", UDim2.new(1, -36, 0, 42), UDim2.fromOffset(18, 38), 27, SINISTER_GREEN, 904)
	makeSinisterLabel(gate, "Enter the access phrase to initialize the private matrix.", UDim2.new(1, -36, 0, 30), UDim2.fromOffset(18, 78), 11, Color3.fromRGB(153, 205, 165), 904)

	local gateClose = makeSinisterButton(gate, "X", UDim2.fromOffset(34, 28), UDim2.new(1, -48, 0, 14), 905)
	local codeBox = Library.Create("TextBox", {
		Name = "SinisterCodeInput",
		Size = UDim2.new(1, -36, 0, 38),
		Position = UDim2.fromOffset(18, 116),
		BackgroundColor3 = Color3.fromRGB(4, 22, 11),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "ACCESS PHRASE",
		PlaceholderColor3 = Color3.fromRGB(70, 126, 84),
		TextColor3 = Color3.fromRGB(224, 255, 231),
		TextSize = 14,
		Font = Enum.Font.Code,
		ClearTextOnFocus = false,
		Active = true,
		ZIndex = 904,
		Parent = gate,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.48),
	})
	local unlockButton = makeSinisterButton(gate, "INITIALIZE", UDim2.new(1, -36, 0, 34), UDim2.fromOffset(18, 164), 905)
	local gateStatus = makeSinisterLabel(gate, "NODE LOCKED", UDim2.new(1, -36, 0, 16), UDim2.fromOffset(18, 201), 10, Color3.fromRGB(112, 180, 128), 904, Enum.TextXAlignment.Center)

	local loadingOverlay = Library.Create("Frame", {
		Name = "SinisterMatrixBoot",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 3, 1),
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Visible = false,
		Active = true,
		ZIndex = 940,
		Parent = parent,
	})

	local matrixColumns = {}
	for index = 1, 14 do
		local column = makeSinisterLabel(
			loadingOverlay,
			(index % 3 == 0 and "01\n10\n11\n00\n01\n11" or "11\n00\n10\n01\n10\n00"),
			UDim2.fromOffset(42, 180),
			UDim2.new((index - 0.5) / 14, -21, 0, -190 - ((index % 4) * 35)),
			14,
			index % 4 == 0 and Color3.fromRGB(184, 255, 198) or SINISTER_GREEN,
			942,
			Enum.TextXAlignment.Center
		)
		column.TextTransparency = 0.18 + ((index % 3) * 0.12)
		matrixColumns[index] = column
	end

	local geometry = {}
	for index = 1, 10 do
		local size = 24 + ((index % 4) * 12)
		local shape = Library.Create("Frame", {
			Name = "MatrixGeometry" .. tostring(index),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(size, size),
			Position = UDim2.new(-0.12, 0, 0.08 + ((index % 7) * 0.13), 0),
			BackgroundTransparency = 1,
			Rotation = (index * 19) % 90,
			ZIndex = 943,
			Parent = loadingOverlay,
		}, {
			index % 3 == 0 and Library.Corner(999) or Library.Corner(2),
			Library.Stroke(SINISTER_GREEN, index % 2 == 0 and 2 or 1, 0.25 + ((index % 3) * 0.15)),
		})
		geometry[index] = shape
	end

	local triangle = Library.Create("Frame", {
		Name = "SinisterTriangle",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(136, 136),
		Position = UDim2.fromScale(0.5, 0.46),
		BackgroundTransparency = 1,
		ZIndex = 950,
		Parent = loadingOverlay,
	})
	local trianglePoints = {
		Vector2.new(68, 8),
		Vector2.new(8, 122),
		Vector2.new(128, 122),
	}
	for index = 1, 3 do
		local fromPoint = trianglePoints[index]
		local toPoint = trianglePoints[(index % 3) + 1]
		local difference = toPoint - fromPoint
		local midpoint = (fromPoint + toPoint) * 0.5
		Library.Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(difference.Magnitude, 3),
			Position = UDim2.fromOffset(midpoint.X, midpoint.Y),
			Rotation = math.deg(math.atan2(difference.Y, difference.X)),
			BackgroundColor3 = SINISTER_GREEN,
			BorderSizePixel = 0,
			ZIndex = 951,
			Parent = triangle,
		}, { Library.Corner(999) })
	end
	Library.Create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(12, 12),
		Position = UDim2.fromScale(0.5, 0.62),
		BackgroundColor3 = SINISTER_GREEN,
		BorderSizePixel = 0,
		ZIndex = 952,
		Parent = triangle,
	}, { Library.Corner(999) })

	local bootTitle = makeSinisterLabel(loadingOverlay, "SINISTER MATRIX // HANDSHAKE", UDim2.fromOffset(420, 34), UDim2.new(0.5, -210, 0.68, 0), 17, SINISTER_GREEN, 952, Enum.TextXAlignment.Center)
	local bootStatus = makeSinisterLabel(loadingOverlay, "DECRYPTING GEOMETRY...", UDim2.fromOffset(420, 22), UDim2.new(0.5, -210, 0.68, 34), 11, Color3.fromRGB(144, 226, 161), 952, Enum.TextXAlignment.Center)
	local progressBack = Library.Create("Frame", {
		Size = UDim2.fromOffset(360, 5),
		Position = UDim2.new(0.5, -180, 0.68, 66),
		BackgroundColor3 = Color3.fromRGB(17, 52, 27),
		BorderSizePixel = 0,
		ZIndex = 952,
		Parent = loadingOverlay,
	}, { Library.Corner(999) })
	local progressFill = Library.Create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = SINISTER_GREEN,
		BorderSizePixel = 0,
		ZIndex = 953,
		Parent = progressBack,
	}, { Library.Corner(999) })

	local panel = Library.Create("Frame", {
		Name = "SinisterPanel",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(620, 500),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = SINISTER_PANEL,
		BackgroundTransparency = 0.02,
		BorderSizePixel = 0,
		Visible = false,
		Active = true,
		ZIndex = 920,
		Parent = parent,
	}, {
		Library.Corner(11),
		Library.Stroke(SINISTER_GREEN, 1.5, 0.28),
		Library.Create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 13, 8)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 28, 16)),
			}),
			Rotation = 35,
		}),
	})

	local dragHandle = Library.Create("Frame", {
		Name = "SinisterDragHandle",
		Size = UDim2.new(1, 0, 0, 54),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 928,
		Parent = panel,
	})
	makeSinisterLabel(panel, "SINISTER // ADVANCED LAB", UDim2.new(1, -160, 0, 26), UDim2.fromOffset(18, 10), 17, SINISTER_GREEN, 930)
	makeSinisterLabel(panel, "LOCAL BALLISTICS, TELEMETRY, AND VISUAL SYSTEMS", UDim2.new(1, -160, 0, 16), UDim2.fromOffset(18, 33), 9, Color3.fromRGB(112, 185, 130), 930)
	local closePanelButton = makeSinisterButton(panel, "HIDE", UDim2.fromOffset(68, 28), UDim2.new(1, -84, 0, 13), 931)

	local sidebar = Library.Create("Frame", {
		Size = UDim2.fromOffset(132, 428),
		Position = UDim2.fromOffset(12, 58),
		BackgroundColor3 = Color3.fromRGB(4, 15, 8),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		ZIndex = 922,
		Parent = panel,
	}, {
		Library.Corner(8),
		Library.Stroke(SINISTER_GREEN, 1, 0.72),
	})

	local content = Library.Create("Frame", {
		Size = UDim2.new(1, -162, 1, -72),
		Position = UDim2.fromOffset(152, 58),
		BackgroundTransparency = 1,
		ZIndex = 922,
		Parent = panel,
	})
	local pages = {}
	local tabButtons = {}
	local tabNames = { "BALLISTICS", "TELEMETRY", "MATRIX LAB" }
	for index, tabName in ipairs(tabNames) do
		local tabIndex = index
		local tab = makeSinisterButton(sidebar, tabName, UDim2.new(1, -16, 0, 38), UDim2.fromOffset(8, 12 + ((index - 1) * 46)), 925)
		tabButtons[index] = tab
		pages[index] = Library.Create("Frame", {
			Name = "Sinister" .. tabName:gsub("%s+", "") .. "Page",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = index == 1,
			ZIndex = 923,
			Parent = content,
		})
		bindSinisterButton(tab, connect, tween, function()
			activePage = tabIndex
			for pageIndex, page in ipairs(pages) do
				page.Visible = pageIndex == activePage
				local pageButton = tabButtons[pageIndex]
				if pageButton then
					pageButton.BackgroundColor3 = pageIndex == activePage and Color3.fromRGB(26, 81, 42) or Color3.fromRGB(12, 35, 20)
				end
			end
		end)
	end
	tabButtons[1].BackgroundColor3 = Color3.fromRGB(26, 81, 42)
	makeSinisterLabel(sidebar, "NODE 7A\nSTATUS: READY\nSCOPE: LOCAL", UDim2.new(1, -16, 0, 68), UDim2.new(0, 8, 1, -80), 10, Color3.fromRGB(92, 165, 109), 925)

	local ballisticPage = pages[1]
	makeSinisterLabel(ballisticPage, "LOW-ARC BALLISTIC SOLVER", UDim2.new(1, 0, 0, 24), UDim2.fromOffset(0, 0), 15, SINISTER_GREEN, 925)
	makeSinisterLabel(ballisticPage, "Vacuum trajectory model. Values are local calculations and do not alter weapon systems.", UDim2.new(1, 0, 0, 32), UDim2.fromOffset(0, 25), 10, Color3.fromRGB(129, 190, 143), 925)
	local speedBox = makeSinisterInput(ballisticPage, "MUZZLE SPEED (STUDS/S)", config.DefaultSpeed or 1000, "1000", UDim2.fromOffset(0, 60), 218)
	local distanceBox = makeSinisterInput(ballisticPage, "HORIZONTAL RANGE (STUDS)", config.DefaultDistance or 500, "500", UDim2.fromOffset(230, 60), 218)
	local heightBox = makeSinisterInput(ballisticPage, "TARGET HEIGHT DELTA", config.DefaultHeight or 0, "0", UDim2.fromOffset(0, 116), 218)
	local gravityBox = makeSinisterInput(ballisticPage, "GRAVITY (STUDS/S^2)", config.WorldGravity or 196.2, "196.2", UDim2.fromOffset(230, 116), 218)
	local lateralBox = makeSinisterInput(ballisticPage, "LATERAL TARGET SPEED", config.DefaultLateralSpeed or 0, "0", UDim2.fromOffset(0, 172), 218)
	local worldGravityButton = makeSinisterButton(ballisticPage, "USE WORLD GRAVITY", UDim2.fromOffset(218, 50), UDim2.fromOffset(230, 172), 926)
	local solveButton = makeSinisterButton(ballisticPage, "SOLVE TRAJECTORY", UDim2.new(1, 0, 0, 36), UDim2.fromOffset(0, 230), 926)
	local resultLabel = Library.Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 72),
		Position = UDim2.fromOffset(0, 274),
		BackgroundColor3 = Color3.fromRGB(4, 20, 10),
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		Text = "AWAITING TRAJECTORY INPUT",
		TextColor3 = Color3.fromRGB(175, 232, 187),
		TextSize = 11,
		Font = Enum.Font.Code,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 925,
		Parent = ballisticPage,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.75),
		Library.Create("UIPadding", {
			PaddingTop = UDim.new(0, 7),
			PaddingBottom = UDim.new(0, 7),
			PaddingLeft = UDim.new(0, 9),
			PaddingRight = UDim.new(0, 9),
		}),
	})
	local graph = Library.Create("Frame", {
		Name = "TrajectoryGraph",
		Size = UDim2.new(1, 0, 0, 68),
		Position = UDim2.fromOffset(0, 354),
		BackgroundColor3 = Color3.fromRGB(3, 15, 8),
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ZIndex = 925,
		Parent = ballisticPage,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.78),
	})
	for index = 1, 3 do
		Library.Create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, index / 4, 0),
			BackgroundColor3 = SINISTER_GREEN,
			BackgroundTransparency = 0.88,
			BorderSizePixel = 0,
			ZIndex = 926,
			Parent = graph,
		})
	end
	local zeroLine = Library.Create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.fromScale(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(159, 232, 174),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		ZIndex = 927,
		Parent = graph,
	})
	local arcDots = {}
	for index = 1, 25 do
		arcDots[index] = Library.Create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(index == 25 and 5 or 3, index == 25 and 5 or 3),
			Position = UDim2.fromScale((index - 1) / 24, 0.5),
			BackgroundColor3 = index == 25 and Color3.fromRGB(224, 255, 230) or SINISTER_GREEN,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 928,
			Parent = graph,
		}, { Library.Corner(999) })
	end

	local function renderArc(arc)
		local minY = 0
		local maxY = 0
		for _, point in ipairs(type(arc) == "table" and arc or {}) do
			minY = math.min(minY, point.Y)
			maxY = math.max(maxY, point.Y)
		end
		local range = math.max(maxY - minY, 1)
		zeroLine.Position = UDim2.new(0, 0, 1 - math.clamp((0 - minY) / range, 0, 1), 0)
		for index, dot in ipairs(arcDots) do
			local point = type(arc) == "table" and arc[index] or nil
			if point then
				dot.Position = UDim2.new(math.clamp(point.X, 0, 1), 0, 1 - math.clamp((point.Y - minY) / range, 0, 1), 0)
				dot.Visible = true
			else
				dot.Visible = false
			end
		end
	end

	bindSinisterButton(worldGravityButton, connect, tween, function()
		gravityBox.Text = tostring(workspace.Gravity or config.WorldGravity or 196.2)
	end)
	bindSinisterButton(solveButton, connect, tween, function()
		if type(config.OnSolve) ~= "function" then
			resultLabel.Text = "SOLVER MODULE UNAVAILABLE"
			resultLabel.TextColor3 = Color3.fromRGB(255, 105, 105)
			return
		end
		local ok, solution = pcall(config.OnSolve, {
			Speed = speedBox.Text,
			Distance = distanceBox.Text,
			Height = heightBox.Text,
			Gravity = gravityBox.Text,
			LateralSpeed = lateralBox.Text,
		})
		if not ok or type(solution) ~= "table" then
			resultLabel.Text = "SOLVER ERROR // " .. tostring(solution)
			resultLabel.TextColor3 = Color3.fromRGB(255, 105, 105)
			renderArc(nil)
			return
		end
		resultLabel.Text = tostring(solution.Summary or "NO SOLUTION DATA")
		resultLabel.TextColor3 = solution.Ok and Color3.fromRGB(175, 232, 187) or Color3.fromRGB(255, 120, 120)
		renderArc(solution.Arc)
	end)

	local telemetryPage = pages[2]
	makeSinisterLabel(telemetryPage, "LIVE LOCAL TELEMETRY", UDim2.new(1, 0, 0, 24), UDim2.fromOffset(0, 0), 15, SINISTER_GREEN, 925)
	makeSinisterLabel(telemetryPage, "A read-only snapshot of local environment, camera, rig, and current lock state.", UDim2.new(1, 0, 0, 36), UDim2.fromOffset(0, 25), 10, Color3.fromRGB(129, 190, 143), 925)
	local telemetryLabel = Library.Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 300),
		Position = UDim2.fromOffset(0, 70),
		BackgroundColor3 = Color3.fromRGB(3, 17, 8),
		BackgroundTransparency = 0.04,
		BorderSizePixel = 0,
		Text = "PRESS REFRESH TO SAMPLE",
		TextColor3 = Color3.fromRGB(184, 238, 196),
		TextSize = 12,
		Font = Enum.Font.Code,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 925,
		Parent = telemetryPage,
	}, {
		Library.Corner(7),
		Library.Stroke(SINISTER_GREEN, 1, 0.72),
		Library.Create("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
		}),
	})
	local refreshTelemetryButton = makeSinisterButton(telemetryPage, "REFRESH SNAPSHOT", UDim2.new(1, 0, 0, 38), UDim2.fromOffset(0, 382), 926)
	local function refreshTelemetry()
		if type(config.OnTelemetry) ~= "function" then
			telemetryLabel.Text = "TELEMETRY MODULE UNAVAILABLE"
			return
		end
		local ok, report = pcall(config.OnTelemetry)
		telemetryLabel.Text = ok and tostring(report or "NO TELEMETRY") or ("TELEMETRY ERROR // " .. tostring(report))
	end
	bindSinisterButton(refreshTelemetryButton, connect, tween, refreshTelemetry)

	local matrixPage = pages[3]
	makeSinisterLabel(matrixPage, "LOCAL VIEW MANIPULATION", UDim2.new(1, 0, 0, 24), UDim2.fromOffset(0, 0), 15, SINISTER_GREEN, 925)
	makeSinisterLabel(matrixPage, "These controls affect only your local presentation. They do not modify server state or weapon remotes.", UDim2.new(1, 0, 0, 44), UDim2.fromOffset(0, 25), 10, Color3.fromRGB(129, 190, 143), 925)
	local matrixVisionButton = makeSinisterButton(matrixPage, "MATRIX VISION: " .. (matrixVisionEnabled and "ON" or "OFF"), UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, 82), 926)
	local replayButton = makeSinisterButton(matrixPage, "REPLAY GEOMETRIC HANDSHAKE", UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, 134), 926)
	local resetInputsButton = makeSinisterButton(matrixPage, "RESET BALLISTIC INPUTS", UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, 186), 926)
	local lockNodeButton = makeSinisterButton(matrixPage, "LOCK CLASSIFIED NODE", UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, 238), 926)
	local matrixInfo = makeSinisterLabel(matrixPage, "MATRIX ENGINE\nEVENT DRIVEN // NO RENDER LOOP\nGEOMETRY: TWEEN PIPELINE\nAUTHORIZATION: SESSION SCOPED", UDim2.new(1, 0, 0, 112), UDim2.fromOffset(0, 306), 11, Color3.fromRGB(151, 220, 166), 925)
	matrixInfo.BackgroundColor3 = Color3.fromRGB(3, 17, 8)
	matrixInfo.BackgroundTransparency = 0.1

	local function showPanel()
		gateLayer.Visible = false
		loadingOverlay.Visible = false
		panel.Visible = true
		panel.Size = UDim2.fromOffset(590, 474)
		panel.BackgroundTransparency = 0.35
		tween(panel, 0.22, {
			Size = UDim2.fromOffset(620, 500),
			BackgroundTransparency = 0.02,
		})
		refreshTelemetry()
	end

	local function playMatrixBoot()
		animationToken += 1
		local token = animationToken
		panel.Visible = false
		gateLayer.Visible = false
		loadingOverlay.Visible = true
		loadingOverlay.BackgroundTransparency = 0.02
		triangle.Rotation = 0
		triangle.Size = UDim2.fromOffset(92, 92)
		progressFill.Size = UDim2.fromScale(0, 1)
		bootStatus.Text = "DECRYPTING GEOMETRY..."
		bootTitle.TextTransparency = 0
		bootStatus.TextTransparency = 0
		for index, column in ipairs(matrixColumns) do
			column.Position = UDim2.new((index - 0.5) / #matrixColumns, -21, 0, -190 - ((index % 4) * 35))
			column.TextTransparency = 0.18 + ((index % 3) * 0.12)
			tweenService:Create(column, TweenInfo.new(2.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, (index % 5) * 0.08), {
				Position = UDim2.new((index - 0.5) / #matrixColumns, -21 + ((index % 2 == 0) and 25 or -25), 1, 35),
				TextTransparency = 0.82,
			}):Play()
		end
		for index, shape in ipairs(geometry) do
			shape.Position = UDim2.new(-0.12, 0, 0.08 + ((index % 7) * 0.13), 0)
			shape.Rotation = (index * 19) % 90
			tweenService:Create(shape, TweenInfo.new(2.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, (index - 1) * 0.06), {
				Position = UDim2.new(1.12, 0, 0.12 + (((index * 3) % 7) * 0.12), 0),
				Rotation = shape.Rotation + 240,
			}):Play()
		end
		tweenService:Create(triangle, TweenInfo.new(2.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Rotation = 720,
			Size = UDim2.fromOffset(154, 154),
		}):Play()
		tweenService:Create(progressFill, TweenInfo.new(2.65, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Size = UDim2.fromScale(1, 1),
		}):Play()
		task.delay(1.2, function()
			if token == animationToken and bootStatus.Parent then
				bootStatus.Text = "VECTOR CORE ONLINE // LOADING LAB..."
			end
		end)
		task.delay(2.85, function()
			if token ~= animationToken or not loadingOverlay.Parent then
				return
			end
			tween(loadingOverlay, 0.18, { BackgroundTransparency = 1 })
			bootTitle.TextTransparency = 1
			bootStatus.TextTransparency = 1
			task.delay(0.2, function()
				if token == animationToken and loadingOverlay.Parent then
					showPanel()
				end
			end)
		end)
	end

	local function lockNode()
		animationToken += 1
		unlocked = false
		panel.Visible = false
		loadingOverlay.Visible = false
		gateLayer.Visible = false
		codeBox.Text = ""
		gateStatus.Text = "NODE LOCKED"
		gateStatus.TextColor3 = Color3.fromRGB(112, 180, 128)
		if type(config.OnLocked) == "function" then
			config.OnLocked()
		end
	end

	local function attemptUnlock()
		local entered = tostring(codeBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if entered:lower() ~= accessCode:lower() then
			gateStatus.Text = "ACCESS DENIED // INVALID PHRASE"
			gateStatus.TextColor3 = Color3.fromRGB(255, 90, 90)
			codeBox.Text = ""
			local originalPosition = gate.Position
			tween(gate, 0.06, { Position = originalPosition + UDim2.fromOffset(8, 0) })
			task.delay(0.07, function()
				if gate.Parent then
					tween(gate, 0.1, { Position = originalPosition })
				end
			end)
			return
		end
		unlocked = true
		codeBox:ReleaseFocus()
		gateStatus.Text = "ACCESS ACCEPTED"
		gateStatus.TextColor3 = SINISTER_GREEN
		if type(config.OnUnlocked) == "function" then
			config.OnUnlocked()
		end
		playMatrixBoot()
	end

	local function open()
		if unlocked then
			showPanel()
			return
		end
		panel.Visible = false
		loadingOverlay.Visible = false
		gateLayer.Visible = true
		gateStatus.Text = "NODE LOCKED"
		gateStatus.TextColor3 = Color3.fromRGB(112, 180, 128)
		gate.Position = UDim2.fromScale(0.5, 0.5)
		gate.Size = UDim2.fromOffset(360, 204)
		gate.BackgroundTransparency = 0.35
		tween(gate, 0.2, {
			Size = UDim2.fromOffset(390, 224),
			BackgroundTransparency = 0.02,
		})
		task.defer(function()
			if codeBox.Parent and gateLayer.Visible then
				codeBox:CaptureFocus()
			end
		end)
	end

	bindSinisterButton(gateClose, connect, tween, function()
		codeBox:ReleaseFocus()
		gateLayer.Visible = false
	end)
	bindSinisterButton(unlockButton, connect, tween, attemptUnlock)
	connect(codeBox.FocusLost, function(enterPressed)
		if enterPressed then
			attemptUnlock()
		end
	end)
	bindSinisterButton(closePanelButton, connect, tween, function()
		panel.Visible = false
	end)
	bindSinisterButton(matrixVisionButton, connect, tween, function()
		matrixVisionEnabled = not matrixVisionEnabled
		if type(config.OnMatrixVision) == "function" then
			local ok, applied = pcall(config.OnMatrixVision, matrixVisionEnabled)
			if ok and type(applied) == "boolean" then
				matrixVisionEnabled = applied
			end
		end
		matrixVisionButton.Text = "MATRIX VISION: " .. (matrixVisionEnabled and "ON" or "OFF")
	end)
	bindSinisterButton(replayButton, connect, tween, playMatrixBoot)
	bindSinisterButton(resetInputsButton, connect, tween, function()
		speedBox.Text = tostring(config.DefaultSpeed or 1000)
		distanceBox.Text = tostring(config.DefaultDistance or 500)
		heightBox.Text = tostring(config.DefaultHeight or 0)
		gravityBox.Text = tostring(config.WorldGravity or 196.2)
		lateralBox.Text = tostring(config.DefaultLateralSpeed or 0)
		resultLabel.Text = "BALLISTIC INPUTS RESET"
		resultLabel.TextColor3 = Color3.fromRGB(175, 232, 187)
		renderArc(nil)
	end)
	bindSinisterButton(lockNodeButton, connect, tween, lockNode)

	local dragging = false
	local dragStart = nil
	local startPosition = nil
	local dragInput = nil
	connect(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = panel.Position
			dragInput = input
		end
	end)
	connect(dragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	connect(inputService.InputChanged, function(input)
		if not dragging or input ~= dragInput or not dragStart or not startPosition then
			return
		end
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
	connect(inputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			dragStart = nil
			startPosition = nil
			dragInput = nil
		end
	end)

	return {
		GateLayer = gateLayer,
		Panel = panel,
		LoadingOverlay = loadingOverlay,
		Open = open,
		Close = function()
			animationToken += 1
			gateLayer.Visible = false
			loadingOverlay.Visible = false
			panel.Visible = false
		end,
		Lock = lockNode,
		Replay = playMatrixBoot,
		IsUnlocked = function()
			return unlocked
		end,
		SetMatrixVision = function(enabled)
			matrixVisionEnabled = enabled == true
			matrixVisionButton.Text = "MATRIX VISION: " .. (matrixVisionEnabled and "ON" or "OFF")
		end,
	}
end

return Library
