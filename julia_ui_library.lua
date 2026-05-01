-- Julia UI Library
-- Small repo-hosted UI helper layer for Julia Hub. Keep this file UI-only.

local Library = {}

Library.Name = "JuliaUILibrary"
Library.Version = "0.1.0"

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

function Library.MakeButton(config)
	local theme = config.Theme
	local panel = config.Panel
	local connect = config.Connect
	local tween = config.Tween
	local callback = config.Callback or function() end
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
		tween(button, 0.12, {
			BackgroundColor3 = theme.ButtonHover,
			Size = hoverSize,
			Position = hoverPos,
		})
	end)
	connect(button.MouseLeave, function()
		tween(button, 0.12, {
			BackgroundColor3 = theme.Button,
			Size = normalSize,
			Position = normalPos,
		})
	end)
	connect(button.MouseButton1Down, function()
		tween(button, 0.07, {
			BackgroundColor3 = theme.ButtonClick,
			Size = clickSize,
			Position = clickPos,
		})
	end)
	connect(button.MouseButton1Up, function()
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
