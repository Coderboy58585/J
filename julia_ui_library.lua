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
