-- Julia UI Library
-- Small repo-hosted UI helper layer for Julia Hub. Keep this file UI-only.

local Library = {}

Library.Name = "JuliaUILibrary"
Library.Version = "0.2.0"

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
		Text = "v" .. tostring(config.Version or "0.6.4") .. "   •   SESSION SETTINGS ARE PRESERVED",
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

return Library
