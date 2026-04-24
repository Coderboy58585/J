local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAMES_TO_CLEAR = {
	DevCamlockESP = true,
	KeySystemGui = true,
	JuliaHub = true,
	PentagramFlash = true,
}

for _, gui in ipairs(PlayerGui:GetChildren()) do
	if GUI_NAMES_TO_CLEAR[gui.Name] then
		gui:Destroy()
	end
end

local EXPIRY = {
	Lifetime = math.huge,
	Tester = 1777075200,
	SixMonth = 1792800000,
	OneYear = 1808524800,
}

local CorrectKeys = {
	["TEST-1H-A8K2-QP7M"] = { Expires = EXPIRY.Tester, Note = "Tester Key #1" },
	["TEST-1H-R4N9-ZX2C"] = { Expires = EXPIRY.Tester, Note = "Tester Key #2" },
	["TEST-1H-L6V3-MD8T"] = { Expires = EXPIRY.Tester, Note = "Tester Key #3" },

	["LT-A7K9-Q2M4-Z8PX"] = { Expires = EXPIRY.Lifetime, Note = "Lifetime Key #1" },
	["LT-R3N8-V6Y1-B5KC"] = { Expires = EXPIRY.Lifetime, Note = "Lifetime Key #2" },
	["LT-X9D2-L7P5-W4QA"] = { Expires = EXPIRY.Lifetime, Note = "Lifetime Key #3" },
	["LT-M6C1-T8Z3-N9VR"] = { Expires = EXPIRY.Lifetime, Note = "Lifetime Key #4" },
	["LT-P4W7-H2Q9-J6LD"] = { Expires = EXPIRY.Lifetime, Note = "Lifetime Key #5" },

	["YR-8QZ2-MK5P-LA91"] = { Expires = EXPIRY.OneYear, Note = "Year Key #1" },
	["YR-C7N4-VX8D-RP20"] = { Expires = EXPIRY.OneYear, Note = "Year Key #2" },
	["YR-Z3L9-BQ6W-TA58"] = { Expires = EXPIRY.OneYear, Note = "Year Key #3" },
	["YR-H5P1-KD7M-XC84"] = { Expires = EXPIRY.OneYear, Note = "Year Key #4" },
	["YR-V9A3-RL2Q-JT67"] = { Expires = EXPIRY.OneYear, Note = "Year Key #5" },
	["YR-Q4X8-NC1Z-MP35"] = { Expires = EXPIRY.OneYear, Note = "Year Key #6" },
	["YR-L2D6-TW9K-BV73"] = { Expires = EXPIRY.OneYear, Note = "Year Key #7" },
	["YR-N8M5-ZP3A-QX16"] = { Expires = EXPIRY.OneYear, Note = "Year Key #8" },
	["YR-T1V7-HQ4L-CD92"] = { Expires = EXPIRY.OneYear, Note = "Year Key #9" },
	["YR-B6K9-XR2N-WA45"] = { Expires = EXPIRY.OneYear, Note = "Year Key #10" },
	["YR-P3C8-MV6Z-LQ70"] = { Expires = EXPIRY.OneYear, Note = "Year Key #11" },
	["YR-D9W2-QA5T-RX38"] = { Expires = EXPIRY.OneYear, Note = "Year Key #12" },
	["YR-X1L4-CN8P-ZV63"] = { Expires = EXPIRY.OneYear, Note = "Year Key #13" },
	["YR-M7Q6-TZ1D-KB29"] = { Expires = EXPIRY.OneYear, Note = "Year Key #14" },
	["YR-A5V3-PX9L-WC81"] = { Expires = EXPIRY.OneYear, Note = "Year Key #15" },

	["6M-Q9A2-ZX7L-MC14"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #1" },
	["6M-L5D8-VP2Q-RT60"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #2" },
	["6M-X3N7-BK9W-HA25"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #3" },
	["6M-C8P1-MZ4T-LQ79"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #4" },
	["6M-V2R6-QA9D-XN43"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #5" },
	["6M-T7W3-LC8K-PZ91"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #6" },
	["6M-B4Q9-XV2N-MD68"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #7" },
	["6M-P1Z5-RA7L-QC36"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #8" },
	["6M-N6K2-TM8V-WX04"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #9" },
	["6M-D9X4-QP1C-ZL82"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #10" },
	["6M-W3A7-LN5R-KQ29"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #11" },
	["6M-R8C1-ZV6D-TP50"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #12" },
	["6M-K2L9-QX4A-MB73"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #13" },
	["6M-Z5P3-CT8N-LR16"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #14" },
	["6M-A7V6-MQ2X-WD94"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #15" },
	["6M-M4T8-BL1Q-ZX37"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #16" },
	["6M-Q1D5-XC9P-NV62"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #17" },
	["6M-L9R2-WA6K-TP85"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #18" },
	["6M-C3X7-QN4V-MZ10"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #19" },
	["6M-V8P1-LD5A-RK49"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #20" },
	["6M-T2K6-ZQ9C-WM31"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #21" },
	["6M-B7N4-XP2L-CA58"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #22" },
	["6M-P5W9-RT3D-QV76"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #23" },
	["6M-N1A8-MC6X-LZ20"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #24" },
	["6M-D4Q2-VL9P-KT63"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #25" },
	["6M-W6C5-ZA1N-XR88"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #26" },
	["6M-R9L3-QK7V-MP42"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #27" },
	["6M-K5X1-TD8C-LA07"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #28" },
	["6M-Z2P6-WN4Q-RC95"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #29" },
	["6M-A8M7-LX3T-QD51"] = { Expires = EXPIRY.SixMonth, Note = "6 Month Key #30" },
}

local Settings = {
	ESPEnabled = true,
	CamlockEnabled = true,
	HardLockEnabled = false,
	ShowFOV = true,
	ShowNames = true,
	TeamCheck = true,
	VisibleCheck = true,

	FOVRadius = 180,
	AimPart = "Head",
	SoftLockSmoothing = 0.22,
	HardLockSmoothing = 0.85,

	MaxESPDistance = 5000,
	MaxAimlockDistance = 5000,
	DistanceStep = 500,
	MinimumDistance = 500,
	MaximumDistance = 10000,

	HighlightFillTransparency = 0.75,
	HighlightOutlineTransparency = 0,

	CamlockHoldKey = Enum.UserInputType.MouseButton2,
	ToggleGuiKey = Enum.KeyCode.K,
}

local Theme = {
	Main = Color3.fromRGB(25, 25, 30),
	Button = Color3.fromRGB(45, 45, 55),
	Accent = Color3.fromRGB(60, 90, 160),
	Text = Color3.fromRGB(255, 255, 255),
	Muted = Color3.fromRGB(180, 180, 180),
	Good = Color3.fromRGB(120, 255, 140),
	Bad = Color3.fromRGB(255, 100, 100),
	Red = Color3.fromRGB(255, 40, 40),
}

local State = {
	KeyPassed = false,
	HoldingCamlock = false,
	ESPObjects = {},
	Connections = {},
	Camera = Workspace.CurrentCamera,
}

local function connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(State.Connections, connection)
	return connection
end

local function cleanupConnections()
	for _, connection in ipairs(State.Connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end

	table.clear(State.Connections)
end

local function create(className, props, children)
	local object = Instance.new(className)

	for property, value in pairs(props or {}) do
		object[property] = value
	end

	for _, child in ipairs(children or {}) do
		child.Parent = object
	end

	return object
end

local function corner(radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
	})
end

local function stroke(color, thickness, transparency)
	return create("UIStroke", {
		Color = color or Theme.Text,
		Thickness = thickness or 2,
		Transparency = transparency or 0,
	})
end

local function cleanKey(text)
	return tostring(text or "")
		:gsub("%s+", "")
		:upper()
end

local function pad2(number)
	number = math.floor(number)
	return number < 10 and ("0" .. number) or tostring(number)
end

local function formatTimeLeft(seconds)
	if seconds == math.huge then
		return "Lifetime"
	end

	seconds = math.max(0, math.floor(seconds))

	local days = math.floor(seconds / 86400)
	seconds -= days * 86400

	local hours = math.floor(seconds / 3600)
	seconds -= hours * 3600

	local minutes = math.floor(seconds / 60)
	seconds -= minutes * 60

	return string.format("%dd %sh %sm %ss", days, pad2(hours), pad2(minutes), pad2(seconds))
end

local function getTeamColor(player)
	return player.TeamColor and player.TeamColor.Color or Theme.Text
end

local function isEnemy(player)
	if player == LocalPlayer then
		return false
	end

	if not Settings.TeamCheck then
		return true
	end

	if LocalPlayer.Team and player.Team then
		return LocalPlayer.Team ~= player.Team
	end

	return true
end

local function getHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function isAlive(character)
	local humanoid = getHumanoid(character)
	return humanoid and humanoid.Health > 0
end

local function getRoot(player)
	local character = player.Character
	if not character or not isAlive(character) then
		return nil
	end

	return character:FindFirstChild("HumanoidRootPart")
end

local function getCharacterPart(player, partName)
	local character = player.Character
	if not character or not isAlive(character) then
		return nil
	end

	return character:FindFirstChild(partName)
end

local function getLocalRoot()
	local character = LocalPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function withinDistance(root, maxDistance)
	local localRoot = getLocalRoot()
	if not localRoot or not root then
		return true
	end

	return (localRoot.Position - root.Position).Magnitude <= maxDistance
end

local function isVisible(targetPart)
	if not Settings.VisibleCheck then
		return true
	end

	local camera = State.Camera
	local localCharacter = LocalPlayer.Character

	if not camera or not targetPart or not localCharacter then
		return true
	end

	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { localCharacter }
	params.IgnoreWater = true

	local result = Workspace:Raycast(origin, direction, params)
	return not result or result.Instance:IsDescendantOf(targetPart.Parent)
end

local function cycleDistance(current)
	current += Settings.DistanceStep
	return current > Settings.MaximumDistance and Settings.MinimumDistance or current
end

local function removeESP(player)
	local data = State.ESPObjects[player]
	if not data then
		return
	end

	for _, object in pairs(data) do
		if typeof(object) == "Instance" then
			object:Destroy()
		end
	end

	State.ESPObjects[player] = nil
end

local function createESP(player, screenGui)
	if player == LocalPlayer then
		return
	end

	removeESP(player)

	local character = player.Character
	local root = getRoot(player)
	if not character or not root then
		return
	end

	local head = character:FindFirstChild("Head")
	local color = getTeamColor(player)

	local highlight = create("Highlight", {
		Name = "TeamHighlightESP_" .. player.Name,
		Adornee = character,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		FillTransparency = Settings.HighlightFillTransparency,
		OutlineTransparency = Settings.HighlightOutlineTransparency,
		FillColor = color,
		OutlineColor = color,
		Enabled = Settings.ESPEnabled,
		Parent = screenGui,
	})

	local nameGui = create("BillboardGui", {
		Name = "NameESP_" .. player.Name,
		Adornee = head or root,
		AlwaysOnTop = true,
		Size = UDim2.fromOffset(160, 28),
		StudsOffset = Vector3.new(0, 2.8, 0),
		MaxDistance = Settings.MaxESPDistance,
		Enabled = Settings.ESPEnabled and Settings.ShowNames,
		Parent = screenGui,
	})

	local nameLabel = create("TextLabel", {
		Name = "NameLabel",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = player.DisplayName ~= player.Name and (player.DisplayName .. " (@" .. player.Name .. ")") or player.Name,
		TextColor3 = color,
		TextStrokeTransparency = 0.25,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Parent = nameGui,
	})

	State.ESPObjects[player] = {
		Highlight = highlight,
		NameGui = nameGui,
		NameLabel = nameLabel,
	}
end

local function updateESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then
			continue
		end

		local character = player.Character
		local root = getRoot(player)

		if not character or not root then
			removeESP(player)
			continue
		end

		local data = State.ESPObjects[player]
		if not data then
			continue
		end

		local shouldShow = Settings.ESPEnabled
			and isEnemy(player)
			and withinDistance(root, Settings.MaxESPDistance)

		local color = getTeamColor(player)
		local head = character:FindFirstChild("Head")

		if data.Highlight then
			data.Highlight.Adornee = character
			data.Highlight.FillColor = color
			data.Highlight.OutlineColor = color
			data.Highlight.FillTransparency = Settings.HighlightFillTransparency
			data.Highlight.OutlineTransparency = Settings.HighlightOutlineTransparency
			data.Highlight.Enabled = shouldShow
		end

		if data.NameGui then
			data.NameGui.Adornee = head or root
			data.NameGui.MaxDistance = Settings.MaxESPDistance
			data.NameGui.Enabled = shouldShow and Settings.ShowNames
		end

		if data.NameLabel then
			data.NameLabel.TextColor3 = color
		end
	end
end

local function getClosestTarget()
	local camera = State.Camera
	if not camera then
		return nil
	end

	local mousePosition = UserInputService:GetMouseLocation()
	local closestPart = nil
	local closestDistance = Settings.FOVRadius

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer or not isEnemy(player) then
			continue
		end

		local part = getCharacterPart(player, Settings.AimPart)
		local root = getRoot(player)

		if not part or not root then
			continue
		end

		if not withinDistance(root, Settings.MaxAimlockDistance) or not isVisible(part) then
			continue
		end

		local screenPosition, onScreen = camera:WorldToViewportPoint(part.Position)
		if not onScreen then
			continue
		end

		local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePosition).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			closestPart = part
		end
	end

	return closestPart
end

local function aimCameraAt(part)
	local camera = State.Camera
	if not camera or not part then
		return
	end

	local smoothing = Settings.HardLockEnabled and Settings.HardLockSmoothing or Settings.SoftLockSmoothing
	local desiredCFrame = CFrame.new(camera.CFrame.Position, part.Position)
	camera.CFrame = camera.CFrame:Lerp(desiredCFrame, smoothing)
end

local function flashPentagram()
	local old = PlayerGui:FindFirstChild("PentagramFlash")
	if old then
		old:Destroy()
	end

	local flashGui = create("ScreenGui", {
		Name = "PentagramFlash",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 999999,
		Parent = PlayerGui,
	})

	local holder = create("Frame", {
		Name = "FlashHolder",
		Size = UDim2.fromOffset(260, 300),
		Position = UDim2.new(0.5, -130, 0.5, -150),
		BackgroundTransparency = 1,
		Parent = flashGui,
	})

	local title = create("TextLabel", {
		Name = "JuliaText",
		Size = UDim2.fromOffset(260, 50),
		BackgroundTransparency = 1,
		Text = "Julia",
		TextColor3 = Theme.Red,
		TextStrokeTransparency = 0.2,
		TextSize = 34,
		Font = Enum.Font.GothamBold,
		ZIndex = 30,
		Parent = holder,
	})

	local starHolder = create("Frame", {
		Name = "StarHolder",
		Size = UDim2.fromOffset(200, 200),
		Position = UDim2.fromOffset(30, 60),
		BackgroundTransparency = 1,
		Parent = holder,
	})

	local center = Vector2.new(100, 100)
	local radius = 80
	local points = {}

	for i = 1, 5 do
		local angle = math.rad(90 + (i - 1) * 72)
		points[i] = Vector2.new(center.X + math.cos(angle) * radius, center.Y + math.sin(angle) * radius)
	end

	local function makeLine(fromPoint, toPoint)
		local diff = toPoint - fromPoint
		local midpoint = (fromPoint + toPoint) / 2

		return create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(diff.Magnitude, 4),
			Position = UDim2.fromOffset(midpoint.X, midpoint.Y),
			Rotation = math.deg(math.atan2(diff.Y, diff.X)),
			BackgroundColor3 = Theme.Red,
			BorderSizePixel = 0,
			ZIndex = 20,
			Parent = starHolder,
		})
	end

	local starOrder = {
		{ 1, 3 },
		{ 3, 5 },
		{ 5, 2 },
		{ 2, 4 },
		{ 4, 1 },
	}

	local lines = {}
	for _, pair in ipairs(starOrder) do
		table.insert(lines, makeLine(points[pair[1]], points[pair[2]]))
	end

	local circleStroke = stroke(Theme.Red, 4, 0)
	create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(180, 180),
		Position = UDim2.fromOffset(center.X, center.Y),
		BackgroundTransparency = 1,
		ZIndex = 19,
		Parent = starHolder,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		circleStroke,
	})

	task.spawn(function()
		for _ = 1, 10 do
			title.TextTransparency = 0
			title.TextStrokeTransparency = 0.2
			circleStroke.Transparency = 0

			for _, line in ipairs(lines) do
				line.BackgroundTransparency = 0
			end

			task.wait(0.15)

			title.TextTransparency = 1
			title.TextStrokeTransparency = 1
			circleStroke.Transparency = 1

			for _, line in ipairs(lines) do
				line.BackgroundTransparency = 1
			end

			task.wait(0.15)
		end

		flashGui:Destroy()
	end)
end

local function createKeyGui()
	local keyGui = create("ScreenGui", {
		Name = "KeySystemGui",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 50,
		Parent = PlayerGui,
	})

	local frame = create("Frame", {
		Size = UDim2.fromOffset(400, 245),
		Position = UDim2.new(0.5, -200, 0.5, -122),
		BackgroundColor3 = Theme.Main,
		BorderSizePixel = 0,
		Parent = keyGui,
	}, {
		corner(12),
	})

	create("TextLabel", {
		Size = UDim2.new(1, -30, 0, 40),
		Position = UDim2.fromOffset(15, 15),
		BackgroundTransparency = 1,
		Text = "Julia Hub Key System",
		TextColor3 = Theme.Text,
		TextSize = 22,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})

	create("TextLabel", {
		Size = UDim2.new(1, -30, 0, 24),
		Position = UDim2.fromOffset(15, 55),
		BackgroundTransparency = 1,
		Text = "Enter your access key to continue",
		TextColor3 = Theme.Muted,
		TextSize = 14,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})

	local keyBox = create("TextBox", {
		Size = UDim2.new(1, -40, 0, 40),
		Position = UDim2.fromOffset(20, 90),
		BackgroundColor3 = Theme.Button,
		TextColor3 = Theme.Text,
		PlaceholderText = "Enter key...",
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		Text = "",
		TextSize = 14,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false,
		Parent = frame,
	}, {
		corner(8),
	})

	local statusLabel = create("TextLabel", {
		Size = UDim2.new(1, -40, 0, 44),
		Position = UDim2.fromOffset(20, 135),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.Bad,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		Parent = frame,
	})

	local submitButton = create("TextButton", {
		Size = UDim2.new(1, -40, 0, 38),
		Position = UDim2.fromOffset(20, 188),
		BackgroundColor3 = Theme.Accent,
		TextColor3 = Theme.Text,
		Text = "Submit Key",
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Parent = frame,
	}, {
		corner(8),
	})

	local checking = false

	local function checkKey()
		if checking then
			return
		end

		checking = true

		local enteredKey = cleanKey(keyBox.Text)
		local keyData = CorrectKeys[enteredKey]

		if not keyData then
			statusLabel.TextColor3 = Theme.Bad
			statusLabel.Text = "Invalid key. Try again."
			keyBox.Text = ""
			checking = false
			return
		end

		local now = os.time()
		if keyData.Expires ~= math.huge and now >= keyData.Expires then
			statusLabel.TextColor3 = Theme.Bad
			statusLabel.Text = "This key has expired."
			keyBox.Text = ""
			checking = false
			return
		end

		statusLabel.TextColor3 = Theme.Good
		statusLabel.Text = keyData.Note .. " accepted.\nTime left: " .. formatTimeLeft(keyData.Expires == math.huge and math.huge or keyData.Expires - now)

		task.wait(0.35)
		keyGui.Enabled = false
		flashPentagram()
		task.wait(3)

		State.KeyPassed = true
		keyGui:Destroy()
	end

	submitButton.MouseButton1Click:Connect(checkKey)
	keyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			checkKey()
		end
	end)
end

local function createMainGui()
	local screenGui = create("ScreenGui", {
		Name = "JuliaHub",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Parent = PlayerGui,
	})

	create("TextLabel", {
		Name = "Watermark",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(160, 32),
		Position = UDim2.new(1, -12, 0, 10),
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Text = "Julia Hub",
		TextColor3 = Theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		ZIndex = 100,
		Parent = screenGui,
	}, {
		corner(8),
	})

	local fovCircle = create("Frame", {
		Name = "FOVCircle",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Visible = Settings.ShowFOV,
		Parent = screenGui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		stroke(Theme.Text, 2, 0.15),
	})

	local panel = create("Frame", {
		Name = "ControlPanel",
		Size = UDim2.fromOffset(250, 484),
		Position = UDim2.fromOffset(20, 90),
		BackgroundColor3 = Theme.Main,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Visible = true,
		Parent = screenGui,
	}, {
		corner(10),
	})

	create("TextLabel", {
		Size = UDim2.new(1, -20, 0, 32),
		Position = UDim2.fromOffset(10, 8),
		BackgroundTransparency = 1,
		Text = "Julia Hub",
		TextColor3 = Theme.Text,
		TextSize = 20,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	})

	create("TextLabel", {
		Size = UDim2.new(1, -20, 0, 34),
		Position = UDim2.fromOffset(10, 36),
		BackgroundTransparency = 1,
		Text = "K = menu | Right Mouse = camera assist",
		TextColor3 = Theme.Muted,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	})

	local function makeButton(text, y, callback)
		local button = create("TextButton", {
			Size = UDim2.new(1, -20, 0, 30),
			Position = UDim2.fromOffset(10, y),
			BackgroundColor3 = Theme.Button,
			TextColor3 = Theme.Text,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			Text = text,
			AutoButtonColor = true,
			Parent = panel,
		}, {
			corner(8),
		})

		button.MouseButton1Click:Connect(function()
			callback(button)
		end)

		return button
	end

	makeButton("ESP: ON", 76, function(button)
		Settings.ESPEnabled = not Settings.ESPEnabled
		button.Text = "ESP: " .. (Settings.ESPEnabled and "ON" or "OFF")

		if not Settings.ESPEnabled then
			for _, data in pairs(State.ESPObjects) do
				if data.Highlight then
					data.Highlight.Enabled = false
				end

				if data.NameGui then
					data.NameGui.Enabled = false
				end
			end
		end
	end)

	makeButton("Names: ON", 112, function(button)
		Settings.ShowNames = not Settings.ShowNames
		button.Text = "Names: " .. (Settings.ShowNames and "ON" or "OFF")
	end)

	makeButton("Camlock: ON", 148, function(button)
		Settings.CamlockEnabled = not Settings.CamlockEnabled
		button.Text = "Camlock: " .. (Settings.CamlockEnabled and "ON" or "OFF")
	end)

	makeButton("Hard Lock: OFF", 184, function(button)
		Settings.HardLockEnabled = not Settings.HardLockEnabled
		button.Text = "Hard Lock: " .. (Settings.HardLockEnabled and "ON" or "OFF")
	end)

	makeButton("Show FOV: ON", 220, function(button)
		Settings.ShowFOV = not Settings.ShowFOV
		fovCircle.Visible = Settings.ShowFOV
		button.Text = "Show FOV: " .. (Settings.ShowFOV and "ON" or "OFF")
	end)

	makeButton("Team Check: ON", 256, function(button)
		Settings.TeamCheck = not Settings.TeamCheck
		button.Text = "Team Check: " .. (Settings.TeamCheck and "ON" or "OFF")
	end)

	makeButton("Visible Check: ON", 292, function(button)
		Settings.VisibleCheck = not Settings.VisibleCheck
		button.Text = "Visible Check: " .. (Settings.VisibleCheck and "ON" or "OFF")
	end)

	makeButton("ESP Distance: " .. Settings.MaxESPDistance, 328, function(button)
		Settings.MaxESPDistance = cycleDistance(Settings.MaxESPDistance)
		button.Text = "ESP Distance: " .. Settings.MaxESPDistance
	end)

	makeButton("Aim Distance: " .. Settings.MaxAimlockDistance, 364, function(button)
		Settings.MaxAimlockDistance = cycleDistance(Settings.MaxAimlockDistance)
		button.Text = "Aim Distance: " .. Settings.MaxAimlockDistance
	end)

	local fovDown = makeButton("FOV Down", 400, function()
		Settings.FOVRadius = math.max(40, Settings.FOVRadius - 20)
	end)
	fovDown.Size = UDim2.fromOffset(110, 28)

	local fovUp = makeButton("FOV Up", 400, function()
		Settings.FOVRadius = math.min(700, Settings.FOVRadius + 20)
	end)
	fovUp.Size = UDim2.fromOffset(110, 28)
	fovUp.Position = UDim2.fromOffset(130, 400)

	connect(UserInputService.InputBegan, function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = true
		elseif input.KeyCode == Settings.ToggleGuiKey then
			panel.Visible = not panel.Visible
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = false
		end
	end)

	connect(Players.PlayerRemoving, removeESP)

	local function setupPlayer(player)
		if player == LocalPlayer then
			return
		end

		if player.Character then
			createESP(player, screenGui)
		end

		connect(player.CharacterAdded, function()
			task.wait(0.5)
			createESP(player, screenGui)
		end)
	end

	connect(Players.PlayerAdded, setupPlayer)

	for _, player in ipairs(Players:GetPlayers()) do
		setupPlayer(player)
	end

	connect(RunService.RenderStepped, function()
		State.Camera = Workspace.CurrentCamera
		updateESP()

		local mousePosition = UserInputService:GetMouseLocation()
		fovCircle.Size = UDim2.fromOffset(Settings.FOVRadius * 2, Settings.FOVRadius * 2)
		fovCircle.Position = UDim2.fromOffset(mousePosition.X, mousePosition.Y)
		fovCircle.Visible = Settings.ShowFOV

		if Settings.CamlockEnabled and State.HoldingCamlock then
			local targetPart = getClosestTarget()
			if targetPart then
				aimCameraAt(targetPart)
			end
		end
	end)

	screenGui.Destroying:Connect(function()
		cleanupConnections()
	end)
end

createKeyGui()

repeat
	task.wait()
until State.KeyPassed

createMainGui()
