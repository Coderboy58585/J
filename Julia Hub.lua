local GLOBAL_ENV = (typeof(getgenv) == "function" and getgenv()) or _G

if GLOBAL_ENV.JuliaHubCleanup then
	pcall(GLOBAL_ENV.JuliaHubCleanup)
end

local JuliaRunning = true
local JuliaCleaningUp = false
local JuliaConnections = {}

local function TrackConnection(connection)
	table.insert(JuliaConnections, connection)
	return connection
end

GLOBAL_ENV.JuliaHubCleanup = function()
	if JuliaCleaningUp then
		return
	end

	JuliaCleaningUp = true
	JuliaRunning = false

	for _, connection in ipairs(JuliaConnections) do
		if connection and connection.Connected then
			pcall(function()
				connection:Disconnect()
			end)
		end
	end

	table.clear(JuliaConnections)

	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

		if PlayerGui then
			for _, gui in ipairs(PlayerGui:GetChildren()) do
				if gui.Name == "DevCamlockESP"
					or gui.Name == "KeySystemGui"
					or gui.Name == "JuliaHub"
					or gui.Name == "PentagramFlash"
					or gui.Name == "JuliaHubLite"
					or gui.Name == "JuliaLiteFlash"
				then
					pcall(function()
						gui:Destroy()
					end)
				end
			end
		end
	end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
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
	VisibleCheck = false,

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

	ESPUpdateRate = 0.08,
}

local Theme = {
	Main = Color3.fromRGB(25, 25, 30),
	Button = Color3.fromRGB(45, 45, 55),
	ButtonHover = Color3.fromRGB(58, 58, 70),
	ButtonClick = Color3.fromRGB(75, 75, 90),
	Accent = Color3.fromRGB(60, 90, 160),
	Text = Color3.fromRGB(255, 255, 255),
	Muted = Color3.fromRGB(180, 180, 180),
	Good = Color3.fromRGB(120, 255, 140),
	Bad = Color3.fromRGB(255, 100, 100),
	Red = Color3.fromRGB(255, 40, 40),
	CurrentAccent = Color3.fromRGB(255, 40, 40),
	GradientA = Color3.fromRGB(255, 40, 40),
	GradientB = Color3.fromRGB(60, 90, 160),
	PanelTransparency = 0.08,
	ButtonTransparency = 0,
	WatermarkTransparency = 0.5,
	GradientEnabled = false,
}

local State = {
	KeyPassed = false,
	HoldingCamlock = false,
	ESPObjects = {},
	Camera = Workspace.CurrentCamera,
	LastESPUpdate = 0,
}

local function connect(signal, callback)
	return TrackConnection(signal:Connect(callback))
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

local function tween(object, time, props)
	local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local animation = TweenService:Create(object, info, props)
	animation:Play()
	return animation
end

local function cleanKey(text)
	text = tostring(text or "")
	local result = {}

	for i = 1, #text do
		local char = text:sub(i, i)
		if char ~= " " and char ~= "\t" and char ~= "\n" and char ~= "\r" then
			table.insert(result, char)
		end
	end

	return table.concat(result):upper()
end

local function pad2(number)
	number = math.floor(number)
	return number < 10 and ("0" .. tostring(number)) or tostring(number)
end

local function formatTimeLeft(seconds)
	if seconds == math.huge then
		return "Lifetime"
	end

	seconds = math.max(0, math.floor(seconds))
	local days = math.floor(seconds / 86400)
	seconds = seconds - (days * 86400)
	local hours = math.floor(seconds / 3600)
	seconds = seconds - (hours * 3600)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - (minutes * 60)

	return tostring(days) .. "d " .. pad2(hours) .. "h " .. pad2(minutes) .. "m " .. pad2(seconds) .. "s"
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
		or character:FindFirstChild("Head")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
		or character:FindFirstChild("HumanoidRootPart")
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

	local targetCharacter = targetPart:FindFirstAncestorOfClass("Model")
	if not targetCharacter then
		return true
	end

	local origin = camera.CFrame.Position
	local direction = targetPart.Position - origin

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { localCharacter }
	params.IgnoreWater = true

	local result = Workspace:Raycast(origin, direction, params)

	if not result then
		return true
	end

	if result.Instance:IsDescendantOf(targetCharacter) then
		return true
	end

	local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
	return hitModel and hitModel == targetCharacter
end

local function cycleDistance(current)
	current = current + Settings.DistanceStep
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

		local shouldShow = Settings.ESPEnabled and isEnemy(player) and withinDistance(root, Settings.MaxESPDistance)
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
		{ 1, 3 }, { 3, 5 }, { 5, 2 }, { 2, 4 }, { 4, 1 },
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
			if not JuliaRunning then
				break
			end

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

		if flashGui then
			flashGui:Destroy()
		end
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
	}, { corner(12) })

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
	}, { corner(8) })

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
		AutoButtonColor = false,
		Parent = frame,
	}, { corner(8) })

	local checking = false

	connect(submitButton.MouseEnter, function()
		tween(submitButton, 0.12, {
			BackgroundColor3 = Color3.fromRGB(75, 105, 180),
			Size = UDim2.new(1, -34, 0, 40),
			Position = UDim2.fromOffset(17, 187),
		})
	end)

	connect(submitButton.MouseLeave, function()
		tween(submitButton, 0.12, {
			BackgroundColor3 = Theme.Accent,
			Size = UDim2.new(1, -40, 0, 38),
			Position = UDim2.fromOffset(20, 188),
		})
	end)

	connect(submitButton.MouseButton1Down, function()
		tween(submitButton, 0.07, {
			BackgroundColor3 = Color3.fromRGB(45, 75, 145),
			Size = UDim2.new(1, -48, 0, 34),
			Position = UDim2.fromOffset(24, 190),
		})
	end)

	connect(submitButton.MouseButton1Up, function()
		tween(submitButton, 0.1, {
			BackgroundColor3 = Color3.fromRGB(75, 105, 180),
			Size = UDim2.new(1, -34, 0, 40),
			Position = UDim2.fromOffset(17, 187),
		})
	end)

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

	connect(submitButton.MouseButton1Click, checkKey)
	connect(keyBox.FocusLost, function(enterPressed)
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

	local watermark = create("TextLabel", {
		Name = "Watermark",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(160, 32),
		Position = UDim2.new(1, -12, 0, 10),
		BackgroundColor3 = Theme.CurrentAccent,
		BackgroundTransparency = Theme.WatermarkTransparency,
		BorderSizePixel = 0,
		Text = "Julia Hub",
		TextColor3 = Theme.Text,
		TextSize = 16,
		Font = Enum.Font.GothamBold,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

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

	local crosshairHolder = create("Frame", {
		Name = "CrosshairHolder",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(90, 90),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 200,
		Parent = screenGui,
	})

	local crosshairEnabled = false
	local currentCrosshairIndex = 1
	local crosshairNames = { "OFF", "Dot", "Circle", "Star", "Diamond", "Anime" }
	local skyMode = 1
	local skyNames = { "Clear", "Sunset", "Storm", "Purple", "Soft" }
	local dayMode = true
	local fullbrightEnabled = false

	local originalLighting = {
		ClockTime = Lighting.ClockTime,
		Brightness = Lighting.Brightness,
		Ambient = Lighting.Ambient,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart,
		FogColor = Lighting.FogColor,
	}

	local function clearCrosshair()
		for _, child in ipairs(crosshairHolder:GetChildren()) do
			child:Destroy()
		end
	end

	local function crossLine(name, size, position, rotation)
		return create("Frame", {
			Name = name,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = size,
			Position = position,
			Rotation = rotation or 0,
			BackgroundColor3 = Theme.CurrentAccent,
			BorderSizePixel = 0,
			ZIndex = 201,
			Parent = crosshairHolder,
		})
	end

	local function applyCrosshairStyle(index)
		clearCrosshair()
		crosshairHolder.Visible = crosshairEnabled

		if not crosshairEnabled then
			return
		end

		if index == 1 then
			create("Frame", {
				Name = "Dot",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(7, 7),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundColor3 = Theme.CurrentAccent,
				BorderSizePixel = 0,
				ZIndex = 201,
				Parent = crosshairHolder,
			}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
		elseif index == 2 then
			create("Frame", {
				Name = "Circle",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(34, 34),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				ZIndex = 201,
				Parent = crosshairHolder,
			}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }), stroke(Theme.CurrentAccent, 2, 0) })
		elseif index == 3 then
			crossLine("Top", UDim2.fromOffset(3, 18), UDim2.fromOffset(45, 24))
			crossLine("Bottom", UDim2.fromOffset(3, 18), UDim2.fromOffset(45, 66))
			crossLine("Left", UDim2.fromOffset(18, 3), UDim2.fromOffset(24, 45))
			crossLine("Right", UDim2.fromOffset(18, 3), UDim2.fromOffset(66, 45))
			crossLine("SparkOne", UDim2.fromOffset(12, 2), UDim2.fromOffset(30, 30), 45)
			crossLine("SparkTwo", UDim2.fromOffset(12, 2), UDim2.fromOffset(60, 30), -45)
		elseif index == 4 then
			crossLine("DiamondTop", UDim2.fromOffset(24, 3), UDim2.fromOffset(36, 36), 45)
			crossLine("DiamondRight", UDim2.fromOffset(24, 3), UDim2.fromOffset(54, 36), -45)
			crossLine("DiamondBottomRight", UDim2.fromOffset(24, 3), UDim2.fromOffset(54, 54), 45)
			crossLine("DiamondBottomLeft", UDim2.fromOffset(24, 3), UDim2.fromOffset(36, 54), -45)
		else
			create("TextLabel", {
				Name = "AnimeFace",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(90, 42),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Text = "♡ ◕‿◕ ♡",
				TextColor3 = Theme.CurrentAccent,
				TextStrokeTransparency = 0.25,
				TextSize = 22,
				Font = Enum.Font.GothamBold,
				ZIndex = 202,
				Parent = crosshairHolder,
			})
		end
	end

	local function applySkyMode()
		if skyMode == 1 then
			Lighting.FogEnd = 100000
			Lighting.FogStart = 0
			Lighting.FogColor = Color3.fromRGB(192, 192, 192)
			Lighting.Ambient = Color3.fromRGB(120, 120, 120)
			Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
		elseif skyMode == 2 then
			Lighting.FogEnd = 900
			Lighting.FogStart = 60
			Lighting.FogColor = Color3.fromRGB(255, 140, 85)
			Lighting.Ambient = Color3.fromRGB(180, 95, 70)
			Lighting.OutdoorAmbient = Color3.fromRGB(170, 90, 70)
		elseif skyMode == 3 then
			Lighting.FogEnd = 350
			Lighting.FogStart = 20
			Lighting.FogColor = Color3.fromRGB(70, 75, 90)
			Lighting.Ambient = Color3.fromRGB(65, 65, 75)
			Lighting.OutdoorAmbient = Color3.fromRGB(45, 45, 55)
		elseif skyMode == 4 then
			Lighting.FogEnd = 650
			Lighting.FogStart = 35
			Lighting.FogColor = Color3.fromRGB(120, 70, 180)
			Lighting.Ambient = Color3.fromRGB(100, 60, 145)
			Lighting.OutdoorAmbient = Color3.fromRGB(80, 50, 120)
		else
			Lighting.FogEnd = 1200
			Lighting.FogStart = 80
			Lighting.FogColor = Color3.fromRGB(190, 220, 255)
			Lighting.Ambient = Color3.fromRGB(160, 180, 210)
			Lighting.OutdoorAmbient = Color3.fromRGB(150, 175, 205)
		end
	end

	local function applyDayNight()
		Lighting.ClockTime = dayMode and 14 or 0
	end

	local function applyFullbright()
		if fullbrightEnabled then
			Lighting.Brightness = 3
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			Lighting.FogEnd = 100000
		else
			Lighting.Brightness = originalLighting.Brightness
			applySkyMode()
			applyDayNight()
		end
	end

	crosshairHolder.Visible = false
	applyCrosshairStyle(currentCrosshairIndex)

	local panel = create("Frame", {
		Name = "ControlPanel",
		Size = UDim2.fromOffset(250, 520),
		Position = UDim2.fromOffset(20, 90),
		BackgroundColor3 = Theme.Main,
		BackgroundTransparency = Theme.PanelTransparency,
		BorderSizePixel = 0,
		Visible = true,
		Parent = screenGui,
	}, { corner(10) })

	local panelGradient = create("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.GradientA),
			ColorSequenceKeypoint.new(1, Theme.GradientB),
		}),
		Rotation = 35,
		Enabled = Theme.GradientEnabled,
		Parent = panel,
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

	local pageOneButtons = {}
	local pageTwoButtons = {}
	local pageThreeButtons = {}
	local activePage = 1

	local function updateStyle()
		watermark.BackgroundColor3 = Theme.CurrentAccent
		watermark.BackgroundTransparency = Theme.WatermarkTransparency
		panel.BackgroundTransparency = Theme.PanelTransparency
		panelGradient.Enabled = Theme.GradientEnabled
		panelGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.GradientA),
			ColorSequenceKeypoint.new(1, Theme.GradientB),
		})

		for _, button in ipairs(pageOneButtons) do
			if button and button:IsA("TextButton") then
				button.BackgroundTransparency = Theme.ButtonTransparency
			end
		end

		for _, button in ipairs(pageTwoButtons) do
			if button and button:IsA("TextButton") then
				button.BackgroundTransparency = Theme.ButtonTransparency
			end
		end

		for _, button in ipairs(pageThreeButtons) do
			if button and button:IsA("TextButton") then
				button.BackgroundTransparency = Theme.ButtonTransparency
			end
		end

		applyCrosshairStyle(currentCrosshairIndex)
	end

	local function setPage(page)
		activePage = page

		for _, button in ipairs(pageOneButtons) do
			button.Visible = page == 1
		end

		for _, button in ipairs(pageTwoButtons) do
			button.Visible = page == 2
		end

		for _, button in ipairs(pageThreeButtons) do
			button.Visible = page == 3
		end
	end

	local function makeButton(text, y, callback, width, x, height, page)
		local buttonWidth = width
		local buttonX = x or 10
		local buttonHeight = height or 30

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

		local normalPos = UDim2.fromOffset(buttonX, y)
		local hoverPos = UDim2.fromOffset(buttonX - 2, y - 1)
		local clickPos = UDim2.fromOffset(buttonX + 5, y + 2)

		local button = create("TextButton", {
			Size = normalSize,
			Position = normalPos,
			BackgroundColor3 = Theme.Button,
			BackgroundTransparency = Theme.ButtonTransparency,
			TextColor3 = Theme.Text,
			TextSize = 14,
			Font = Enum.Font.Gotham,
			Text = text,
			AutoButtonColor = false,
			Parent = panel,
		}, { corner(8) })

		if page == 3 then
			table.insert(pageThreeButtons, button)
			button.Visible = activePage == 3
		elseif page == 2 then
			table.insert(pageTwoButtons, button)
			button.Visible = activePage == 2
		else
			table.insert(pageOneButtons, button)
			button.Visible = activePage == 1
		end

		connect(button.MouseEnter, function()
			tween(button, 0.12, {
				BackgroundColor3 = Theme.ButtonHover,
				Size = hoverSize,
				Position = hoverPos,
			})
		end)

		connect(button.MouseLeave, function()
			tween(button, 0.12, {
				BackgroundColor3 = Theme.Button,
				Size = normalSize,
				Position = normalPos,
			})
		end)

		connect(button.MouseButton1Down, function()
			tween(button, 0.07, {
				BackgroundColor3 = Theme.ButtonClick,
				Size = clickSize,
				Position = clickPos,
			})
		end)

		connect(button.MouseButton1Up, function()
			tween(button, 0.1, {
				BackgroundColor3 = Theme.ButtonHover,
				Size = hoverSize,
				Position = hoverPos,
			})
		end)

		connect(button.MouseButton1Click, function()
			callback(button)
		end)

		return button
	end

	makeButton("ESP: ON", 76, function(button)
		Settings.ESPEnabled = not Settings.ESPEnabled
		button.Text = "ESP: " .. (Settings.ESPEnabled and "ON" or "OFF")

		if not Settings.ESPEnabled then
			for _, data in pairs(State.ESPObjects) do
				if data.Highlight then data.Highlight.Enabled = false end
				if data.NameGui then data.NameGui.Enabled = false end
			end
		end
	end, nil, nil, nil, 1)

	makeButton("Names: ON", 112, function(button)
		Settings.ShowNames = not Settings.ShowNames
		button.Text = "Names: " .. (Settings.ShowNames and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Camlock: ON", 148, function(button)
		Settings.CamlockEnabled = not Settings.CamlockEnabled
		button.Text = "Camlock: " .. (Settings.CamlockEnabled and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Hard Lock: OFF", 184, function(button)
		Settings.HardLockEnabled = not Settings.HardLockEnabled
		button.Text = "Hard Lock: " .. (Settings.HardLockEnabled and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Show FOV: ON", 220, function(button)
		Settings.ShowFOV = not Settings.ShowFOV
		fovCircle.Visible = Settings.ShowFOV
		button.Text = "Show FOV: " .. (Settings.ShowFOV and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Team Check: ON", 256, function(button)
		Settings.TeamCheck = not Settings.TeamCheck
		button.Text = "Team Check: " .. (Settings.TeamCheck and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Visible Check: OFF", 292, function(button)
		Settings.VisibleCheck = not Settings.VisibleCheck
		button.Text = "Visible Check: " .. (Settings.VisibleCheck and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("ESP Distance: " .. Settings.MaxESPDistance, 328, function(button)
		Settings.MaxESPDistance = cycleDistance(Settings.MaxESPDistance)
		button.Text = "ESP Distance: " .. Settings.MaxESPDistance
	end, nil, nil, nil, 1)

	makeButton("Aim Distance: " .. Settings.MaxAimlockDistance, 364, function(button)
		Settings.MaxAimlockDistance = cycleDistance(Settings.MaxAimlockDistance)
		button.Text = "Aim Distance: " .. Settings.MaxAimlockDistance
	end, nil, nil, nil, 1)

	makeButton("FOV Down", 400, function()
		Settings.FOVRadius = math.max(40, Settings.FOVRadius - 20)
	end, 110, 10, 28, 1)

	makeButton("FOV Up", 400, function()
		Settings.FOVRadius = math.min(700, Settings.FOVRadius + 20)
	end, 110, 130, 28, 1)

	makeButton("Next Page >", 444, function()
		setPage(2)
	end, nil, nil, nil, 1)

	local colorIndex = 1
	local colorPresets = {
		{ Name = "Red", A = Color3.fromRGB(255, 40, 40), B = Color3.fromRGB(60, 90, 160) },
		{ Name = "Purple", A = Color3.fromRGB(180, 80, 255), B = Color3.fromRGB(80, 35, 160) },
		{ Name = "Blue", A = Color3.fromRGB(70, 140, 255), B = Color3.fromRGB(20, 50, 140) },
		{ Name = "Green", A = Color3.fromRGB(60, 220, 130), B = Color3.fromRGB(20, 110, 70) },
		{ Name = "Pink", A = Color3.fromRGB(255, 80, 170), B = Color3.fromRGB(120, 30, 90) },
	}

	makeButton("< Main Page", 76, function()
		setPage(1)
	end, nil, nil, nil, 2)

	makeButton("Gradient: OFF", 112, function(button)
		Theme.GradientEnabled = not Theme.GradientEnabled
		button.Text = "Gradient: " .. (Theme.GradientEnabled and "ON" or "OFF")
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Color: Red", 148, function(button)
		colorIndex += 1
		if colorIndex > #colorPresets then colorIndex = 1 end
		local preset = colorPresets[colorIndex]
		Theme.CurrentAccent = preset.A
		Theme.GradientA = preset.A
		Theme.GradientB = preset.B
		button.Text = "Color: " .. preset.Name
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Panel Transparency: 8%", 184, function(button)
		local values = { 0.08, 0.2, 0.35, 0.5 }
		local current = 1
		for i, value in ipairs(values) do
			if math.abs(Theme.PanelTransparency - value) < 0.01 then current = i break end
		end
		current += 1
		if current > #values then current = 1 end
		Theme.PanelTransparency = values[current]
		button.Text = "Panel Transparency: " .. tostring(math.floor(Theme.PanelTransparency * 100)) .. "%"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Button Transparency: 0%", 220, function(button)
		local values = { 0, 0.15, 0.3, 0.45 }
		local current = 1
		for i, value in ipairs(values) do
			if math.abs(Theme.ButtonTransparency - value) < 0.01 then current = i break end
		end
		current += 1
		if current > #values then current = 1 end
		Theme.ButtonTransparency = values[current]
		button.Text = "Button Transparency: " .. tostring(math.floor(Theme.ButtonTransparency * 100)) .. "%"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Watermark Transparency: 50%", 256, function(button)
		local values = { 0.5, 0.35, 0.2, 0.65 }
		local current = 1
		for i, value in ipairs(values) do
			if math.abs(Theme.WatermarkTransparency - value) < 0.01 then current = i break end
		end
		current += 1
		if current > #values then current = 1 end
		Theme.WatermarkTransparency = values[current]
		button.Text = "Watermark Transparency: " .. tostring(math.floor(Theme.WatermarkTransparency * 100)) .. "%"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Time: Day", 292, function(button)
		dayMode = not dayMode
		button.Text = "Time: " .. (dayMode and "Day" or "Night")
		applyDayNight()
	end, nil, nil, nil, 2)

	makeButton("Fullbright: OFF", 328, function(button)
		fullbrightEnabled = not fullbrightEnabled
		button.Text = "Fullbright: " .. (fullbrightEnabled and "ON" or "OFF")
		applyFullbright()
	end, nil, nil, nil, 2)

	makeButton("Sky/Weather: Clear", 364, function(button)
		skyMode += 1
		if skyMode > #skyNames then skyMode = 1 end
		button.Text = "Sky/Weather: " .. skyNames[skyMode]
		applySkyMode()
		applyDayNight()
		if fullbrightEnabled then applyFullbright() end
	end, nil, nil, nil, 2)

	makeButton("Crosshair: OFF", 400, function(button)
		currentCrosshairIndex += 1
		if currentCrosshairIndex > 5 then currentCrosshairIndex = 0 end
		crosshairEnabled = currentCrosshairIndex ~= 0
		local label = crosshairEnabled and crosshairNames[currentCrosshairIndex + 1] or "OFF"
		button.Text = "Crosshair: " .. label
		applyCrosshairStyle(currentCrosshairIndex)
	end, nil, nil, nil, 2)

	makeButton("Reset Style", 436, function(button)
		Theme.CurrentAccent = Color3.fromRGB(255, 40, 40)
		Theme.GradientA = Color3.fromRGB(255, 40, 40)
		Theme.GradientB = Color3.fromRGB(60, 90, 160)
		Theme.PanelTransparency = 0.08
		Theme.ButtonTransparency = 0
		Theme.WatermarkTransparency = 0.5
		Theme.GradientEnabled = false
		crosshairEnabled = false
		currentCrosshairIndex = 1
		button.Text = "Reset Style"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Next Page >", 472, function()
		setPage(3)
	end, nil, nil, nil, 2)

	local fpsEnabled = false
	local pingEnabled = false
	local fpsFrameCount = 0
	local fpsLastTime = os.clock()
	local fpsValue = 0

	local fpsLabel = create("TextLabel", {
		Name = "FPSCounter",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(120, 26),
		Position = UDim2.new(1, -12, 0, 48),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "FPS: --",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local pingLabel = create("TextLabel", {
		Name = "PingCounter",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(120, 26),
		Position = UDim2.new(1, -12, 0, 80),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Ping: --",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local animeGirlVisible = false
	local animeGirl = nil
	local animeOutfitIndex = 1
	local animeOutfitNames = {
		"Default",
		"Beach",
		"Playful",
		"Military",
		"Inspired",
		"Teasing",
		"Maid",
		"Arms Up",
		"Latex",
		"Cowprint",
	}

	local function makeDrawPart(parent, name, size, position, color, zIndex, radius, rotation)
		return create("Frame", {
			Name = name,
			Size = size,
			Position = position,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			ZIndex = zIndex or 300,
			Rotation = rotation or 0,
			Parent = parent,
		}, radius and {
			create("UICorner", { CornerRadius = radius }),
		} or nil)
	end

	local function addJuliaBase(parent)
		local shadow = makeDrawPart(parent, "Shadow", UDim2.fromOffset(150, 24), UDim2.fromOffset(24, 204), Color3.fromRGB(0, 0, 0), 299, UDim.new(1, 0))
		shadow.BackgroundTransparency = 0.55

		makeDrawPart(parent, "HairBack", UDim2.fromOffset(128, 142), UDim2.fromOffset(31, 18), Color3.fromRGB(55, 28, 75), 300, UDim.new(0, 58))
		makeDrawPart(parent, "HairLeft", UDim2.fromOffset(42, 116), UDim2.fromOffset(21, 55), Color3.fromRGB(45, 23, 66), 301, UDim.new(0, 24), -10)
		makeDrawPart(parent, "HairRight", UDim2.fromOffset(42, 116), UDim2.fromOffset(126, 55), Color3.fromRGB(45, 23, 66), 301, UDim.new(0, 24), 10)

		local face = makeDrawPart(parent, "Face", UDim2.fromOffset(104, 108), UDim2.fromOffset(43, 45), Color3.fromRGB(255, 214, 199), 302, UDim.new(1, 0))
		create("UIStroke", {
			Color = Color3.fromRGB(120, 65, 100),
			Thickness = 2,
			Transparency = 0.15,
			Parent = face,
		})

		makeDrawPart(parent, "Bang1", UDim2.fromOffset(36, 62), UDim2.fromOffset(47, 31), Color3.fromRGB(68, 35, 92), 304, UDim.new(0, 18), 22)
		makeDrawPart(parent, "Bang2", UDim2.fromOffset(38, 68), UDim2.fromOffset(76, 26), Color3.fromRGB(68, 35, 92), 304, UDim.new(0, 18), -8)
		makeDrawPart(parent, "Bang3", UDim2.fromOffset(34, 58), UDim2.fromOffset(106, 34), Color3.fromRGB(68, 35, 92), 304, UDim.new(0, 18), -24)

		local leftEye = makeDrawPart(parent, "LeftEye", UDim2.fromOffset(18, 24), UDim2.fromOffset(65, 89), Color3.fromRGB(80, 55, 130), 305, UDim.new(1, 0))
		local rightEye = makeDrawPart(parent, "RightEye", UDim2.fromOffset(18, 24), UDim2.fromOffset(106, 89), Color3.fromRGB(80, 55, 130), 305, UDim.new(1, 0))

		makeDrawPart(leftEye, "Sparkle", UDim2.fromOffset(6, 6), UDim2.fromOffset(4, 4), Color3.fromRGB(255, 255, 255), 306, UDim.new(1, 0))
		makeDrawPart(rightEye, "Sparkle", UDim2.fromOffset(6, 6), UDim2.fromOffset(4, 4), Color3.fromRGB(255, 255, 255), 306, UDim.new(1, 0))

		local blushLeft = makeDrawPart(parent, "BlushLeft", UDim2.fromOffset(20, 8), UDim2.fromOffset(55, 121), Color3.fromRGB(255, 135, 160), 305, UDim.new(1, 0), -8)
		blushLeft.BackgroundTransparency = 0.25

		local blushRight = makeDrawPart(parent, "BlushRight", UDim2.fromOffset(20, 8), UDim2.fromOffset(115, 121), Color3.fromRGB(255, 135, 160), 305, UDim.new(1, 0), 8)
		blushRight.BackgroundTransparency = 0.25

		create("TextLabel", {
			Name = "Mouth",
			Size = UDim2.fromOffset(40, 24),
			Position = UDim2.fromOffset(75, 122),
			BackgroundTransparency = 1,
			Text = "ᴗ",
			TextColor3 = Color3.fromRGB(115, 55, 80),
			TextSize = 24,
			Font = Enum.Font.GothamBold,
			ZIndex = 306,
			Parent = parent,
		})

		makeDrawPart(parent, "Neck", UDim2.fromOffset(28, 24), UDim2.fromOffset(81, 144), Color3.fromRGB(245, 190, 178), 301, UDim.new(0, 8))
	end

	local function addDefaultOutfit(parent)
		local body = makeDrawPart(parent, "Body", UDim2.fromOffset(106, 72), UDim2.fromOffset(42, 160), Color3.fromRGB(255, 80, 135), 300, UDim.new(0, 26))
		create("UIStroke", { Color = Color3.fromRGB(150, 35, 85), Thickness = 2, Transparency = 0.1, Parent = body })

		makeDrawPart(parent, "CollarLeft", UDim2.fromOffset(38, 12), UDim2.fromOffset(59, 163), Color3.fromRGB(255, 240, 245), 303, UDim.new(0, 8), 18)
		makeDrawPart(parent, "CollarRight", UDim2.fromOffset(38, 12), UDim2.fromOffset(93, 163), Color3.fromRGB(255, 240, 245), 303, UDim.new(0, 8), -18)
		makeDrawPart(parent, "BowLeft", UDim2.fromOffset(34, 22), UDim2.fromOffset(58, 176), Color3.fromRGB(115, 55, 150), 303, UDim.new(0, 12), -18)
		makeDrawPart(parent, "BowRight", UDim2.fromOffset(34, 22), UDim2.fromOffset(98, 176), Color3.fromRGB(115, 55, 150), 303, UDim.new(0, 12), 18)
		makeDrawPart(parent, "BowCenter", UDim2.fromOffset(18, 18), UDim2.fromOffset(86, 178), Color3.fromRGB(90, 40, 120), 304, UDim.new(1, 0))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia",
			TextColor3 = Theme.CurrentAccent,
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addBeachOutfit(parent)
		local leftArm = makeDrawPart(parent, "LeftArm", UDim2.fromOffset(24, 66), UDim2.fromOffset(30, 158), Color3.fromRGB(255, 214, 199), 299, UDim.new(0, 16), 10)
		local rightArm = makeDrawPart(parent, "RightArm", UDim2.fromOffset(24, 66), UDim2.fromOffset(136, 158), Color3.fromRGB(255, 214, 199), 299, UDim.new(0, 16), -10)
		leftArm.BackgroundTransparency = 0.02
		rightArm.BackgroundTransparency = 0.02

		local torso = makeDrawPart(parent, "Torso", UDim2.fromOffset(92, 78), UDim2.fromOffset(49, 158), Color3.fromRGB(255, 214, 199), 300, UDim.new(0, 24))
		create("UIStroke", { Color = Color3.fromRGB(130, 85, 95), Thickness = 1.5, Transparency = 0.2, Parent = torso })

		local topLeft = makeDrawPart(parent, "BeachTopLeft", UDim2.fromOffset(30, 24), UDim2.fromOffset(55, 165), Color3.fromRGB(255, 95, 145), 304, UDim.new(0, 12), -10)
		local topRight = makeDrawPart(parent, "BeachTopRight", UDim2.fromOffset(30, 24), UDim2.fromOffset(103, 165), Color3.fromRGB(255, 95, 145), 304, UDim.new(0, 12), 10)
		create("UIStroke", { Color = Color3.fromRGB(170, 45, 95), Thickness = 1.5, Transparency = 0.1, Parent = topLeft })
		create("UIStroke", { Color = Color3.fromRGB(170, 45, 95), Thickness = 1.5, Transparency = 0.1, Parent = topRight })

		makeDrawPart(parent, "TopCenter", UDim2.fromOffset(10, 10), UDim2.fromOffset(89, 174), Color3.fromRGB(255, 120, 170), 305, UDim.new(1, 0))
		makeDrawPart(parent, "TopStrap", UDim2.fromOffset(4, 22), UDim2.fromOffset(92, 151), Color3.fromRGB(255, 95, 145), 304, UDim.new(1, 0))

		local cover = makeDrawPart(parent, "BeachCover", UDim2.fromOffset(108, 38), UDim2.fromOffset(41, 198), Color3.fromRGB(255, 240, 245), 302, UDim.new(0, 20), -2)
		cover.BackgroundTransparency = 0.18
		create("UIStroke", { Color = Color3.fromRGB(255, 185, 210), Thickness = 1.5, Transparency = 0.15, Parent = cover })

		makeDrawPart(parent, "FlowerCenter", UDim2.fromOffset(10, 10), UDim2.fromOffset(138, 58), Color3.fromRGB(255, 220, 90), 308, UDim.new(1, 0))
		makeDrawPart(parent, "FlowerPetal1", UDim2.fromOffset(12, 12), UDim2.fromOffset(132, 52), Color3.fromRGB(255, 150, 200), 307, UDim.new(1, 0))
		makeDrawPart(parent, "FlowerPetal2", UDim2.fromOffset(12, 12), UDim2.fromOffset(144, 52), Color3.fromRGB(255, 150, 200), 307, UDim.new(1, 0))
		makeDrawPart(parent, "FlowerPetal3", UDim2.fromOffset(12, 12), UDim2.fromOffset(132, 64), Color3.fromRGB(255, 150, 200), 307, UDim.new(1, 0))
		makeDrawPart(parent, "FlowerPetal4", UDim2.fromOffset(12, 12), UDim2.fromOffset(144, 64), Color3.fromRGB(255, 150, 200), 307, UDim.new(1, 0))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Beach",
			TextColor3 = Color3.fromRGB(255, 130, 170),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addPlayfulOutfit(parent)
		local body = makeDrawPart(parent, "Body", UDim2.fromOffset(106, 72), UDim2.fromOffset(42, 160), Color3.fromRGB(245, 95, 165), 300, UDim.new(0, 26))
		create("UIStroke", { Color = Color3.fromRGB(160, 45, 115), Thickness = 2, Transparency = 0.1, Parent = body })

		makeDrawPart(parent, "ShoulderLeft", UDim2.fromOffset(44, 14), UDim2.fromOffset(48, 160), Color3.fromRGB(255, 185, 220), 304, UDim.new(0, 10), 12)
		makeDrawPart(parent, "ShoulderRight", UDim2.fromOffset(44, 14), UDim2.fromOffset(99, 160), Color3.fromRGB(255, 185, 220), 304, UDim.new(0, 10), -12)
		makeDrawPart(parent, "Heart", UDim2.fromOffset(18, 18), UDim2.fromOffset(86, 178), Color3.fromRGB(255, 65, 130), 305, UDim.new(1, 0))

		create("TextLabel", {
			Name = "Wink",
			Size = UDim2.fromOffset(28, 24),
			Position = UDim2.fromOffset(104, 87),
			BackgroundTransparency = 1,
			Text = "˘",
			TextColor3 = Color3.fromRGB(80, 55, 130),
			TextSize = 22,
			Font = Enum.Font.GothamBold,
			ZIndex = 309,
			Parent = parent,
		})

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Playful",
			TextColor3 = Color3.fromRGB(255, 110, 180),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addMilitaryOutfit(parent)
		local body = makeDrawPart(parent, "Body", UDim2.fromOffset(108, 78), UDim2.fromOffset(41, 158), Color3.fromRGB(72, 105, 65), 300, UDim.new(0, 24))
		create("UIStroke", { Color = Color3.fromRGB(38, 60, 38), Thickness = 2, Transparency = 0.1, Parent = body })

		makeDrawPart(parent, "HatTop", UDim2.fromOffset(74, 20), UDim2.fromOffset(58, 26), Color3.fromRGB(72, 105, 65), 309, UDim.new(0, 12))
		makeDrawPart(parent, "HatBrim", UDim2.fromOffset(86, 8), UDim2.fromOffset(52, 42), Color3.fromRGB(50, 76, 45), 310, UDim.new(0, 6))
		makeDrawPart(parent, "EpauletLeft", UDim2.fromOffset(32, 10), UDim2.fromOffset(48, 164), Color3.fromRGB(95, 125, 70), 304, UDim.new(0, 6), 10)
		makeDrawPart(parent, "EpauletRight", UDim2.fromOffset(32, 10), UDim2.fromOffset(110, 164), Color3.fromRGB(95, 125, 70), 304, UDim.new(0, 6), -10)

		for i = 1, 4 do
			makeDrawPart(parent, "Button" .. i, UDim2.fromOffset(8, 8), UDim2.fromOffset(91, 174 + (i - 1) * 12), Color3.fromRGB(25, 25, 25), 305, UDim.new(1, 0))
		end

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Military",
			TextColor3 = Color3.fromRGB(130, 180, 100),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addInspiredOutfit(parent)
		local coat = makeDrawPart(parent, "GreenCoat", UDim2.fromOffset(114, 80), UDim2.fromOffset(38, 156), Color3.fromRGB(55, 100, 78), 300, UDim.new(0, 20))
		create("UIStroke", { Color = Color3.fromRGB(30, 60, 45), Thickness = 2, Transparency = 0.1, Parent = coat })
		makeDrawPart(parent, "Turtleneck", UDim2.fromOffset(42, 38), UDim2.fromOffset(74, 148), Color3.fromRGB(20, 20, 24), 304, UDim.new(0, 10))
		makeDrawPart(parent, "CoatLapLeft", UDim2.fromOffset(40, 64), UDim2.fromOffset(54, 164), Color3.fromRGB(45, 86, 66), 305, UDim.new(0, 12), 12)
		makeDrawPart(parent, "CoatLapRight", UDim2.fromOffset(40, 64), UDim2.fromOffset(96, 164), Color3.fromRGB(45, 86, 66), 305, UDim.new(0, 12), -12)

		makeDrawPart(parent, "GlassesLeft", UDim2.fromOffset(20, 16), UDim2.fromOffset(63, 91), Color3.fromRGB(18, 18, 20), 309, UDim.new(1, 0))
		makeDrawPart(parent, "GlassesRight", UDim2.fromOffset(20, 16), UDim2.fromOffset(107, 91), Color3.fromRGB(18, 18, 20), 309, UDim.new(1, 0))
		makeDrawPart(parent, "GlassesBridge", UDim2.fromOffset(24, 3), UDim2.fromOffset(83, 98), Color3.fromRGB(18, 18, 20), 309, UDim.new(1, 0))

		for i = 1, 4 do
			makeDrawPart(parent, "CoatButton" .. i, UDim2.fromOffset(8, 8), UDim2.fromOffset(i % 2 == 0 and 103 or 79, 178 + math.floor((i - 1) / 2) * 22), Color3.fromRGB(18, 18, 20), 306, UDim.new(1, 0))
		end

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Inspired",
			TextColor3 = Color3.fromRGB(90, 160, 120),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end


	local function addTeasingOutfit(parent)
		local body = makeDrawPart(parent, "Body", UDim2.fromOffset(106, 72), UDim2.fromOffset(42, 160), Color3.fromRGB(220, 70, 135), 300, UDim.new(0, 26))
		create("UIStroke", { Color = Color3.fromRGB(135, 30, 85), Thickness = 2, Transparency = 0.1, Parent = body })

		makeDrawPart(parent, "OffShoulderLeft", UDim2.fromOffset(44, 13), UDim2.fromOffset(47, 161), Color3.fromRGB(255, 185, 220), 304, UDim.new(0, 10), 14)
		makeDrawPart(parent, "OffShoulderRight", UDim2.fromOffset(44, 13), UDim2.fromOffset(99, 161), Color3.fromRGB(255, 185, 220), 304, UDim.new(0, 10), -14)
		makeDrawPart(parent, "WaistRibbon", UDim2.fromOffset(58, 10), UDim2.fromOffset(66, 204), Color3.fromRGB(95, 35, 125), 305, UDim.new(0, 7))
		makeDrawPart(parent, "RibbonLeft", UDim2.fromOffset(24, 16), UDim2.fromOffset(70, 211), Color3.fromRGB(115, 55, 150), 306, UDim.new(0, 9), -18)
		makeDrawPart(parent, "RibbonRight", UDim2.fromOffset(24, 16), UDim2.fromOffset(96, 211), Color3.fromRGB(115, 55, 150), 306, UDim.new(0, 9), 18)

		create("TextLabel", {
			Name = "Wink",
			Size = UDim2.fromOffset(28, 24),
			Position = UDim2.fromOffset(104, 87),
			BackgroundTransparency = 1,
			Text = "˘",
			TextColor3 = Color3.fromRGB(80, 55, 130),
			TextSize = 22,
			Font = Enum.Font.GothamBold,
			ZIndex = 309,
			Parent = parent,
		})

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Teasing",
			TextColor3 = Color3.fromRGB(255, 105, 180),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addMaidOutfit(parent)
		local dress = makeDrawPart(parent, "MaidDress", UDim2.fromOffset(108, 76), UDim2.fromOffset(41, 160), Color3.fromRGB(35, 35, 45), 300, UDim.new(0, 24))
		create("UIStroke", { Color = Color3.fromRGB(15, 15, 22), Thickness = 2, Transparency = 0.1, Parent = dress })

		makeDrawPart(parent, "Apron", UDim2.fromOffset(62, 62), UDim2.fromOffset(64, 166), Color3.fromRGB(245, 245, 250), 304, UDim.new(0, 18))
		makeDrawPart(parent, "ApronTop", UDim2.fromOffset(48, 20), UDim2.fromOffset(71, 160), Color3.fromRGB(255, 255, 255), 305, UDim.new(0, 10))
		makeDrawPart(parent, "MaidCollarLeft", UDim2.fromOffset(34, 12), UDim2.fromOffset(61, 158), Color3.fromRGB(255, 255, 255), 306, UDim.new(0, 8), 16)
		makeDrawPart(parent, "MaidCollarRight", UDim2.fromOffset(34, 12), UDim2.fromOffset(95, 158), Color3.fromRGB(255, 255, 255), 306, UDim.new(0, 8), -16)
		makeDrawPart(parent, "MaidBowLeft", UDim2.fromOffset(25, 16), UDim2.fromOffset(71, 178), Color3.fromRGB(80, 45, 110), 307, UDim.new(0, 8), -18)
		makeDrawPart(parent, "MaidBowRight", UDim2.fromOffset(25, 16), UDim2.fromOffset(95, 178), Color3.fromRGB(80, 45, 110), 307, UDim.new(0, 8), 18)
		makeDrawPart(parent, "MaidBowCenter", UDim2.fromOffset(12, 12), UDim2.fromOffset(89, 180), Color3.fromRGB(65, 35, 95), 308, UDim.new(1, 0))
		makeDrawPart(parent, "Headband", UDim2.fromOffset(74, 10), UDim2.fromOffset(58, 38), Color3.fromRGB(255, 255, 255), 309, UDim.new(0, 7))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Maid",
			TextColor3 = Color3.fromRGB(240, 240, 255),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addArmsUpOutfit(parent)
		local torso = makeDrawPart(parent, "SleevelessTop", UDim2.fromOffset(94, 76), UDim2.fromOffset(48, 160), Color3.fromRGB(125, 80, 210), 300, UDim.new(0, 24))
		create("UIStroke", { Color = Color3.fromRGB(70, 40, 145), Thickness = 2, Transparency = 0.1, Parent = torso })

		makeDrawPart(parent, "RaisedArmLeft", UDim2.fromOffset(22, 82), UDim2.fromOffset(34, 97), Color3.fromRGB(255, 214, 199), 304, UDim.new(0, 15), -28)
		makeDrawPart(parent, "RaisedArmRight", UDim2.fromOffset(22, 82), UDim2.fromOffset(134, 97), Color3.fromRGB(255, 214, 199), 304, UDim.new(0, 15), 28)
		makeDrawPart(parent, "LeftHand", UDim2.fromOffset(20, 20), UDim2.fromOffset(24, 89), Color3.fromRGB(255, 214, 199), 305, UDim.new(1, 0))
		makeDrawPart(parent, "RightHand", UDim2.fromOffset(20, 20), UDim2.fromOffset(146, 89), Color3.fromRGB(255, 214, 199), 305, UDim.new(1, 0))
		makeDrawPart(parent, "UnderarmLeft", UDim2.fromOffset(16, 12), UDim2.fromOffset(53, 151), Color3.fromRGB(245, 185, 175), 306, UDim.new(1, 0), -8)
		makeDrawPart(parent, "UnderarmRight", UDim2.fromOffset(16, 12), UDim2.fromOffset(121, 151), Color3.fromRGB(245, 185, 175), 306, UDim.new(1, 0), 8)
		makeDrawPart(parent, "TopTrim", UDim2.fromOffset(70, 10), UDim2.fromOffset(60, 158), Color3.fromRGB(180, 145, 255), 305, UDim.new(0, 8))
		makeDrawPart(parent, "WaistBand", UDim2.fromOffset(70, 10), UDim2.fromOffset(60, 207), Color3.fromRGB(85, 50, 175), 305, UDim.new(0, 8))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Arms Up",
			TextColor3 = Color3.fromRGB(190, 160, 255),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end


	local function addLatexOutfit(parent)
		local body = makeDrawPart(parent, "LatexBody", UDim2.fromOffset(106, 72), UDim2.fromOffset(42, 160), Color3.fromRGB(18, 18, 24), 300, UDim.new(0, 26))
		create("UIStroke", {
			Color = Color3.fromRGB(120, 120, 145),
			Thickness = 2,
			Transparency = 0.15,
			Parent = body,
		})

		makeDrawPart(parent, "LatexNeck", UDim2.fromOffset(42, 18), UDim2.fromOffset(74, 150), Color3.fromRGB(12, 12, 18), 304, UDim.new(0, 8))

		local shine1 = makeDrawPart(parent, "LatexShine1", UDim2.fromOffset(18, 54), UDim2.fromOffset(61, 169), Color3.fromRGB(255, 255, 255), 305, UDim.new(0, 10), 8)
		shine1.BackgroundTransparency = 0.72

		local shine2 = makeDrawPart(parent, "LatexShine2", UDim2.fromOffset(12, 40), UDim2.fromOffset(112, 172), Color3.fromRGB(255, 255, 255), 305, UDim.new(0, 8), -8)
		shine2.BackgroundTransparency = 0.78

		makeDrawPart(parent, "LatexSleeveLeft", UDim2.fromOffset(28, 54), UDim2.fromOffset(31, 162), Color3.fromRGB(18, 18, 24), 302, UDim.new(0, 16), 10)
		makeDrawPart(parent, "LatexSleeveRight", UDim2.fromOffset(28, 54), UDim2.fromOffset(131, 162), Color3.fromRGB(18, 18, 24), 302, UDim.new(0, 16), -10)
		makeDrawPart(parent, "LatexBelt", UDim2.fromOffset(70, 10), UDim2.fromOffset(60, 207), Color3.fromRGB(55, 55, 70), 306, UDim.new(0, 8))
		makeDrawPart(parent, "LatexBuckle", UDim2.fromOffset(16, 12), UDim2.fromOffset(87, 206), Color3.fromRGB(180, 180, 200), 307, UDim.new(0, 4))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Latex",
			TextColor3 = Color3.fromRGB(210, 210, 235),
			TextStrokeTransparency = 0.25,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function addCowprintOutfit(parent)
		local body = makeDrawPart(parent, "CowprintTopBase", UDim2.fromOffset(106, 72), UDim2.fromOffset(42, 160), Color3.fromRGB(250, 250, 245), 300, UDim.new(0, 26))
		create("UIStroke", {
			Color = Color3.fromRGB(55, 55, 55),
			Thickness = 2,
			Transparency = 0.15,
			Parent = body,
		})

		makeDrawPart(parent, "CowSpot1", UDim2.fromOffset(30, 20), UDim2.fromOffset(56, 168), Color3.fromRGB(25, 25, 25), 304, UDim.new(1, 0), -12)
		makeDrawPart(parent, "CowSpot2", UDim2.fromOffset(24, 26), UDim2.fromOffset(105, 174), Color3.fromRGB(25, 25, 25), 304, UDim.new(1, 0), 14)
		makeDrawPart(parent, "CowSpot3", UDim2.fromOffset(22, 16), UDim2.fromOffset(78, 202), Color3.fromRGB(25, 25, 25), 304, UDim.new(1, 0), 8)

		makeDrawPart(parent, "CowTrimTop", UDim2.fromOffset(76, 8), UDim2.fromOffset(57, 160), Color3.fromRGB(30, 30, 30), 305, UDim.new(0, 8))
		makeDrawPart(parent, "CowTrimBottom", UDim2.fromOffset(76, 8), UDim2.fromOffset(57, 224), Color3.fromRGB(30, 30, 30), 305, UDim.new(0, 8))
		makeDrawPart(parent, "CowSleeveLeft", UDim2.fromOffset(28, 46), UDim2.fromOffset(31, 166), Color3.fromRGB(250, 250, 245), 302, UDim.new(0, 16), 10)
		makeDrawPart(parent, "CowSleeveRight", UDim2.fromOffset(28, 46), UDim2.fromOffset(131, 166), Color3.fromRGB(250, 250, 245), 302, UDim.new(0, 16), -10)

		makeDrawPart(parent, "CowEarLeft", UDim2.fromOffset(20, 28), UDim2.fromOffset(48, 32), Color3.fromRGB(250, 250, 245), 308, UDim.new(0, 12), -28)
		makeDrawPart(parent, "CowEarRight", UDim2.fromOffset(20, 28), UDim2.fromOffset(122, 32), Color3.fromRGB(250, 250, 245), 308, UDim.new(0, 12), 28)
		makeDrawPart(parent, "CowEarSpot", UDim2.fromOffset(12, 12), UDim2.fromOffset(126, 40), Color3.fromRGB(25, 25, 25), 309, UDim.new(1, 0))

		create("TextLabel", {
			Name = "NameTag",
			Size = UDim2.fromOffset(170, 24),
			Position = UDim2.fromOffset(10, 0),
			BackgroundTransparency = 1,
			Text = "Julia Cowprint",
			TextColor3 = Color3.fromRGB(245, 245, 245),
			TextStrokeTransparency = 0.2,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 310,
			Parent = parent,
		})
	end

	local function createDrawnAnimeGirl()
		local wasVisible = animeGirlVisible
		local oldPosition = animeGirl and animeGirl.Position or UDim2.new(1, -18, 1, -18)

		if animeGirl then
			animeGirl:Destroy()
		end

		animeGirl = create("Frame", {
			Name = "DrawnAnimeGirl",
			AnchorPoint = Vector2.new(1, 1),
			Size = UDim2.fromOffset(190, 235),
			Position = oldPosition,
			BackgroundTransparency = 1,
			Visible = wasVisible,
			ZIndex = 300,
			Parent = screenGui,
		})

		addJuliaBase(animeGirl)

		if animeOutfitIndex == 1 then
			addDefaultOutfit(animeGirl)
		elseif animeOutfitIndex == 2 then
			addBeachOutfit(animeGirl)
		elseif animeOutfitIndex == 3 then
			addPlayfulOutfit(animeGirl)
		elseif animeOutfitIndex == 4 then
			addMilitaryOutfit(animeGirl)
		elseif animeOutfitIndex == 5 then
			addInspiredOutfit(animeGirl)
		elseif animeOutfitIndex == 6 then
			addTeasingOutfit(animeGirl)
		elseif animeOutfitIndex == 7 then
			addMaidOutfit(animeGirl)
		elseif animeOutfitIndex == 8 then
			addArmsUpOutfit(animeGirl)
		elseif animeOutfitIndex == 9 then
			addLatexOutfit(animeGirl)
		else
			addCowprintOutfit(animeGirl)
		end

		task.spawn(function()
			local thisGirl = animeGirl
			while JuliaRunning and thisGirl and thisGirl.Parent do
				if thisGirl.Visible then
					tween(thisGirl, 0.45, { Position = UDim2.new(1, -18, 1, -24) })
					task.wait(0.45)
					tween(thisGirl, 0.45, { Position = UDim2.new(1, -18, 1, -18) })
					task.wait(0.45)
				else
					task.wait(0.2)
				end
			end
		end)
	end

	local function setAnimeGirlVisible(enabled)
		if not animeGirl then
			createDrawnAnimeGirl()
		end

		animeGirlVisible = enabled
		animeGirl.Visible = enabled

		if enabled then
			animeGirl.Position = UDim2.new(1, 210, 1, -18)
			tween(animeGirl, 0.35, { Position = UDim2.new(1, -18, 1, -18) })
		end
	end

	createDrawnAnimeGirl()

	makeButton("< Style Page", 76, function()
		setPage(2)
	end, nil, nil, nil, 3)

	makeButton("Rejoin Server", 112, function(button)
		button.Text = "Rejoining..."
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end, nil, nil, nil, 3)

	makeButton("FPS Counter: OFF", 148, function(button)
		fpsEnabled = not fpsEnabled
		fpsLabel.Visible = fpsEnabled
		button.Text = "FPS Counter: " .. (fpsEnabled and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Ping Counter: OFF", 184, function(button)
		pingEnabled = not pingEnabled
		pingLabel.Visible = pingEnabled
		button.Text = "Ping Counter: " .. (pingEnabled and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Anime Girl: OFF", 220, function(button)
		animeGirlVisible = not animeGirlVisible
		setAnimeGirlVisible(animeGirlVisible)
		button.Text = "Anime Girl: " .. (animeGirlVisible and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Outfit: Default", 256, function(button)
		animeOutfitIndex += 1
		if animeOutfitIndex > #animeOutfitNames then
			animeOutfitIndex = 1
		end

		button.Text = "Outfit: " .. animeOutfitNames[animeOutfitIndex]
		createDrawnAnimeGirl()
	end, nil, nil, nil, 3)

	makeButton("Hide Anime Girl", 292, function(button)
		setAnimeGirlVisible(false)
		button.Text = "Hide Anime Girl"
	end, nil, nil, nil, 3)

	makeButton("Back To Main", 328, function()
		setPage(1)
	end, nil, nil, nil, 3)

	connect(UserInputService.InputBegan, function(input, gameProcessed)
		if not JuliaRunning then return end
		if gameProcessed then return end

		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = true
		elseif input.KeyCode == Settings.ToggleGuiKey then
			panel.Visible = not panel.Visible
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if not JuliaRunning then return end
		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = false
		end
	end)

	connect(Players.PlayerRemoving, removeESP)

	local function setupPlayer(player)
		if player == LocalPlayer then return end

		if player.Character then
			createESP(player, screenGui)
		end

		connect(player.CharacterAdded, function()
			if not JuliaRunning then return end
			task.wait(0.5)
			if JuliaRunning then
				createESP(player, screenGui)
			end
		end)
	end

	connect(Players.PlayerAdded, setupPlayer)

	for _, player in ipairs(Players:GetPlayers()) do
		setupPlayer(player)
	end

	connect(RunService.RenderStepped, function()
		if not JuliaRunning then return end

		fpsFrameCount += 1
		local fpsNow = os.clock()

		if fpsNow - fpsLastTime >= 0.5 then
			fpsValue = math.floor(fpsFrameCount / (fpsNow - fpsLastTime))
			fpsFrameCount = 0
			fpsLastTime = fpsNow

			if fpsEnabled then
				fpsLabel.Text = "FPS: " .. tostring(fpsValue)
			end

			if pingEnabled then
				local pingText = "--"
				pcall(function()
					pingText = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
				end)
				pingLabel.Text = "Ping: " .. pingText
			end
		end

		State.Camera = Workspace.CurrentCamera

		local now = os.clock()
		if now - State.LastESPUpdate >= Settings.ESPUpdateRate then
			State.LastESPUpdate = now
			updateESP()
		end

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
		Lighting.ClockTime = originalLighting.ClockTime
		Lighting.Brightness = originalLighting.Brightness
		Lighting.Ambient = originalLighting.Ambient
		Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.FogStart = originalLighting.FogStart
		Lighting.FogColor = originalLighting.FogColor

		if GLOBAL_ENV.JuliaHubCleanup then
			GLOBAL_ENV.JuliaHubCleanup()
		end
	end)
end

createKeyGui()

repeat
	task.wait()
until State.KeyPassed or not JuliaRunning

if JuliaRunning then
	createMainGui()
end
