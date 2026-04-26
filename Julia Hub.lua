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
	local Lighting = game:GetService("Lighting")
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
					or gui.Name == "RadarMinimap"
				then
					pcall(function()
						gui:Destroy()
					end)
				end
			end
		end
	end
	for _, effectName in ipairs({
		"JuliaBlurFX",
		"JuliaBloomFX",
		"JuliaNightVisionFX",
		"JuliaMonochromeFX",
		"JuliaSaturationFX",
	}) do
		local effect = Lighting:FindFirstChild(effectName)
		if effect then
			pcall(function()
				effect:Destroy()
			end)
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
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAMES_TO_CLEAR = {
	DevCamlockESP = true,
	KeySystemGui = true,
	JuliaHub = true,
	PentagramFlash = true,
	RadarMinimap = true,
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
	ESPMode = "Highlight",
	BoneESPEnabled = false,
	BoneThickness = 2,
	TracersEnabled = false,
	TracerOrigin = "Bottom",
	TracerThickness = 1,
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
	BoxESPDistance = 5000,
	MaxAimlockDistance = 5000,
	DistanceStep = 500,
	MinimumDistance = 500,
	MaximumDistance = 10000,
	HighlightFillTransparency = 0.75,
	HighlightOutlineTransparency = 0,
	CamlockHoldKey = Enum.UserInputType.MouseButton2,
	ToggleGuiKey = Enum.KeyCode.K,
	TargetLockEnabled = true,
	TargetLockKey = Enum.KeyCode.L,
	TargetLockMode = "Crosshair",
	TargetLockSticky = true,
	TargetLockHUD = true,
	ESPUpdateRate = 0.18,
	LineESPUpdateRate = 1 / 45,
	FollowerCloneUpdateRate = 1 / 20,
	FOVUpdateRate = 1 / 30,
	CounterUpdateRate = 1.0,
	LowEndMode = false,
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
	LastLineESPUpdate = 0,
	LastFOVUpdate = 0,
	LastCounterUpdate = 0,
	ActiveKey = nil,
	ActiveKeyNote = nil,
	KeyExpiresAt = nil,
	LockedTargetPlayer = nil,
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

local ActiveTweens = {}
local LineRenderCache = setmetatable({}, { __mode = "k" })

local function tween(object, time, props)
	if not object or not object.Parent then
		return nil
	end
	local previousTween = ActiveTweens[object]
	if previousTween then
		pcall(function()
			previousTween:Cancel()
		end)
	end
	local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local animation = TweenService:Create(object, info, props)
	ActiveTweens[object] = animation
	animation.Completed:Connect(function()
		if ActiveTweens[object] == animation then
			ActiveTweens[object] = nil
		end
	end)
	animation:Play()
	return animation
end

local function setLineFrameVisible(line, visible)
	if not line then
		return
	end
	local state = LineRenderCache[line]
	if not state then
		state = {}
		LineRenderCache[line] = state
	end
	if state.Visible ~= visible then
		line.Visible = visible
		state.Visible = visible
	end
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

local function getKeyTimeLeft()
	if not State.KeyExpiresAt then
		return nil
	end
	if State.KeyExpiresAt == math.huge then
		return math.huge
	end
	return math.max(0, State.KeyExpiresAt - os.time())
end

local function getKeyTimeText()
	local timeLeft = getKeyTimeLeft()
	if timeLeft == nil then
		return "KTL: --"
	end
	if timeLeft == math.huge then
		return "KTL: Lifetime"
	end
	return "KTL: " .. formatTimeLeft(timeLeft)
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
	if partName == "Body" then
		return character:FindFirstChild("UpperTorso")
			or character:FindFirstChild("Torso")
			or character:FindFirstChild("LowerTorso")
			or character:FindFirstChild("HumanoidRootPart")
			or character:FindFirstChild("Head")
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

local function getDistanceFromLocal(root)
	local localRoot = getLocalRoot()
	if not localRoot or not root then
		return 0
	end
	return math.floor((localRoot.Position - root.Position).Magnitude)
end

local function getHealthRatio(character)
	local humanoid = getHumanoid(character)
	if not humanoid or humanoid.MaxHealth <= 0 then
		return 0, 0
	end
	return math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), math.max(0, math.floor(humanoid.Health))
end

local function getHealthColor(ratio)
	local red = math.floor(255 * (1 - ratio))
	local green = math.floor(255 * ratio)
	return Color3.fromRGB(red, green, 70)
end

local R6BonePairs = {
	{ "Head", "Torso" },
	{ "Torso", "Left Arm" },
	{ "Torso", "Right Arm" },
	{ "Torso", "Left Leg" },
	{ "Torso", "Right Leg" },
}

local R15BonePairs = {
	{ "Head", "UpperTorso" },
	{ "UpperTorso", "LowerTorso" },
	{ "UpperTorso", "LeftUpperArm" },
	{ "LeftUpperArm", "LeftLowerArm" },
	{ "LeftLowerArm", "LeftHand" },
	{ "UpperTorso", "RightUpperArm" },
	{ "RightUpperArm", "RightLowerArm" },
	{ "RightLowerArm", "RightHand" },
	{ "LowerTorso", "LeftUpperLeg" },
	{ "LeftUpperLeg", "LeftLowerLeg" },
	{ "LeftLowerLeg", "LeftFoot" },
	{ "LowerTorso", "RightUpperLeg" },
	{ "RightUpperLeg", "RightLowerLeg" },
	{ "RightLowerLeg", "RightFoot" },
}

local function getBonePairs(character)
	local humanoid = getHumanoid(character)
	if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
		return R6BonePairs
	end
	return R15BonePairs
end

local function getScreenVector(camera, worldPosition)
	local projected, onScreen = camera:WorldToViewportPoint(worldPosition)
	if not onScreen or projected.Z <= 0 then
		return nil
	end
	return Vector2.new(projected.X, projected.Y)
end

local function updateLineFrame(line, fromPoint, toPoint, color, thickness)
	if not line or not fromPoint or not toPoint then
		setLineFrameVisible(line, false)
		return
	end

	local delta = toPoint - fromPoint
	local length = delta.Magnitude
	if length < 1 then
		setLineFrameVisible(line, false)
		return
	end

	local width = math.max(1, math.floor(length + 0.5))
	local centerX = math.floor((fromPoint.X + toPoint.X) * 0.5 + 0.5)
	local centerY = math.floor((fromPoint.Y + toPoint.Y) * 0.5 + 0.5)
	local rotation = math.floor(math.deg(math.atan2(delta.Y, delta.X)) * 10 + 0.5) / 10
	local state = LineRenderCache[line]
	if not state then
		state = {}
		LineRenderCache[line] = state
	end
	if state.Width ~= width or state.Thickness ~= thickness then
		line.Size = UDim2.fromOffset(width, thickness)
		state.Width = width
		state.Thickness = thickness
	end
	if state.CenterX ~= centerX or state.CenterY ~= centerY then
		line.Position = UDim2.fromOffset(centerX, centerY)
		state.CenterX = centerX
		state.CenterY = centerY
	end
	if state.Rotation ~= rotation then
		line.Rotation = rotation
		state.Rotation = rotation
	end
	if state.Color ~= color then
		line.BackgroundColor3 = color
		state.Color = color
	end
	setLineFrameVisible(line, true)
end

local function hideLineFrames(lines)
	if not lines then
		return
	end
	for _, line in ipairs(lines) do
		setLineFrameVisible(line, false)
	end
end

local function getTracerOrigin(viewportSize)
	if Settings.TracerOrigin == "Top" then
		return Vector2.new(viewportSize.X * 0.5, 24)
	elseif Settings.TracerOrigin == "Center" then
		return Vector2.new(viewportSize.X * 0.5, viewportSize.Y * 0.5)
	end
	return Vector2.new(viewportSize.X * 0.5, viewportSize.Y - 28)
end

local function buildBoneSegments(character, boneLines)
	local segments = {}
	if not character or not boneLines then
		return segments
	end
	for index, pair in ipairs(getBonePairs(character)) do
		local fromPart = character:FindFirstChild(pair[1])
		local toPart = character:FindFirstChild(pair[2])
		local line = boneLines[index]
		if line and fromPart and toPart and fromPart:IsA("BasePart") and toPart:IsA("BasePart") then
			table.insert(segments, {
				From = fromPart,
				To = toPart,
				Line = line,
			})
		end
	end
	return segments
end

local function getCharacterBox2D(character, camera)
	if not character or not camera then
		return nil
	end

	local root = character:FindFirstChild("HumanoidRootPart")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
		or character:FindFirstChild("LowerTorso")
	if not root or not root:IsA("BasePart") then
		return nil
	end

	local head = character:FindFirstChild("Head")
	local torso = character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
		or character:FindFirstChild("LowerTorso")
		or root
	local foot = character:FindFirstChild("LeftFoot")
		or character:FindFirstChild("RightFoot")
		or character:FindFirstChild("Left Leg")
		or character:FindFirstChild("Right Leg")
		or character:FindFirstChild("LeftLowerLeg")
		or character:FindFirstChild("RightLowerLeg")
		or root

	if not torso:IsA("BasePart") or not foot:IsA("BasePart") then
		return nil
	end

	local topSource = head and head:IsA("BasePart") and head or torso
	local topWorld = topSource.Position + Vector3.new(0, topSource.Size.Y * 0.75, 0)
	local bottomWorld = foot.Position - Vector3.new(0, foot.Size.Y * 0.85, 0)
	local topPoint = camera:WorldToViewportPoint(topWorld)
	local bottomPoint = camera:WorldToViewportPoint(bottomWorld)
	if topPoint.Z <= 0 or bottomPoint.Z <= 0 then
		return nil
	end

	local halfWidthStuds = math.max(torso.Size.X * 0.9, 1.35)
	local leftPoint = camera:WorldToViewportPoint(torso.Position - torso.CFrame.RightVector * halfWidthStuds)
	local rightPoint = camera:WorldToViewportPoint(torso.Position + torso.CFrame.RightVector * halfWidthStuds)
	if leftPoint.Z <= 0 or rightPoint.Z <= 0 then
		return nil
	end

	local height = math.abs(bottomPoint.Y - topPoint.Y)
	if height < 4 then
		return nil
	end

	local width = math.max(math.abs(rightPoint.X - leftPoint.X), height * 0.38)
	local centerX = (leftPoint.X + rightPoint.X) * 0.5
	local minX = centerX - (width * 0.5)
	local maxX = centerX + (width * 0.5)
	local minY = math.min(topPoint.Y, bottomPoint.Y)
	local maxY = math.max(topPoint.Y, bottomPoint.Y)

	local viewport = camera.ViewportSize
	if maxX < 0 or minX > viewport.X or maxY < 0 or minY > viewport.Y then
		return nil
	end

	return minX, minY, maxX, maxY
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
		elseif type(object) == "table" then
			for _, child in ipairs(object) do
				if typeof(child) == "Instance" then
					child:Destroy()
				end
			end
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
	local function createOverlayLine(name, zIndex)
		return create("Frame", {
			Name = name,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(0, 0),
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = zIndex,
			Parent = screenGui,
		})
	end
	local tracerLine = createOverlayLine("TracerESP_" .. player.Name, 108)
	local boneLines = {}
	for index = 1, #R15BonePairs do
		boneLines[index] = createOverlayLine("BoneESP_" .. player.Name .. "_" .. tostring(index), 109)
	end
	local boneSegments = buildBoneSegments(character, boneLines)
	local boxFrame = create("Frame", {
		Name = "BoxESP_" .. player.Name,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 110,
		Parent = screenGui,
	})
	local boxOutline = create("Frame", {
		Name = "BoxOutline",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 111,
		Parent = boxFrame,
	})
	local boxOutlineStroke = stroke(color, 1.5, 0)
	boxOutlineStroke.Parent = boxOutline
	local healthBarBack = create("Frame", {
		Name = "HealthBarBack",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0, -6, 0, 0),
		Size = UDim2.new(0, 4, 1, 0),
		BackgroundColor3 = Color3.fromRGB(15, 15, 15),
		BorderSizePixel = 0,
		ZIndex = 111,
		Parent = boxFrame,
	})
	local healthBarFill = create("Frame", {
		Name = "HealthBarFill",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Theme.Good,
		BorderSizePixel = 0,
		ZIndex = 112,
		Parent = healthBarBack,
	})
	local boxNameLabel = create("TextLabel", {
		Name = "BoxName",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 0, -2),
		Size = UDim2.fromOffset(180, 16),
		BackgroundTransparency = 1,
		Text = player.DisplayName ~= player.Name and (player.DisplayName .. " (@" .. player.Name .. ")") or player.Name,
		TextColor3 = color,
		TextStrokeTransparency = 0.2,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		ZIndex = 112,
		Parent = boxFrame,
	})
	local distanceLabel = create("TextLabel", {
		Name = "DistanceLabel",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, 2),
		Size = UDim2.fromOffset(120, 14),
		BackgroundTransparency = 1,
		Text = "0m",
		TextColor3 = Theme.Text,
		TextStrokeTransparency = 0.25,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		ZIndex = 112,
		Parent = boxFrame,
	})
	local healthLabel = create("TextLabel", {
		Name = "HealthLabel",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(1, 6, 0.5, 0),
		Size = UDim2.fromOffset(42, 14),
		BackgroundTransparency = 1,
		Text = "100",
		TextColor3 = Theme.Good,
		TextStrokeTransparency = 0.25,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 112,
		Parent = boxFrame,
	})
	State.ESPObjects[player] = {
		Highlight = highlight,
		NameGui = nameGui,
		NameLabel = nameLabel,
		TracerLine = tracerLine,
		BoneLines = boneLines,
		BoneSegments = boneSegments,
		BoxFrame = boxFrame,
		BoxOutline = boxOutline,
		BoxOutlineStroke = boxOutlineStroke,
		HealthBarBack = healthBarBack,
		HealthBarFill = healthBarFill,
		BoxNameLabel = boxNameLabel,
		DistanceLabel = distanceLabel,
		HealthLabel = healthLabel,
	}
end

local function updateESP()
	local camera = State.Camera
	local boxMode = Settings.ESPMode == "2D Box"
	local showNames = Settings.ShowNames
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
		local espActive = Settings.ESPEnabled and isEnemy(player)
		local generalShouldShow = espActive and withinDistance(root, Settings.MaxESPDistance)
		local boxShouldShow = generalShouldShow
		if boxMode then
			boxShouldShow = espActive and withinDistance(root, Settings.BoxESPDistance)
		end
		local color = getTeamColor(player)
		local head = character:FindFirstChild("Head")
		local displayName = player.DisplayName ~= player.Name and (player.DisplayName .. " (@" .. player.Name .. ")") or player.Name
		if data.Highlight then
			data.Highlight.Adornee = character
			data.Highlight.FillColor = color
			data.Highlight.OutlineColor = color
			data.Highlight.FillTransparency = Settings.HighlightFillTransparency
			data.Highlight.OutlineTransparency = Settings.HighlightOutlineTransparency
			data.Highlight.Enabled = generalShouldShow and not boxMode
		end
		if data.NameGui then
			data.NameGui.Adornee = head or root
			data.NameGui.MaxDistance = Settings.MaxESPDistance
			data.NameGui.Enabled = generalShouldShow and showNames and not boxMode
		end
		if data.NameLabel then
			data.NameLabel.TextColor3 = color
		end
		if data.BoneLines and not Settings.BoneESPEnabled then
			hideLineFrames(data.BoneLines)
		end
		if data.BoxOutlineStroke then
			data.BoxOutlineStroke.Color = color
		end
		if data.BoxNameLabel then
			data.BoxNameLabel.Text = displayName
			data.BoxNameLabel.TextColor3 = color
			data.BoxNameLabel.Visible = showNames
		end
		if data.BoxFrame then
			local boxVisible = false
			if boxShouldShow and boxMode and camera then
				local minX, minY, maxX, maxY = getCharacterBox2D(character, camera)
				if minX and maxX and maxY then
					local width = math.max(18, math.floor(maxX - minX))
					local height = math.max(30, math.floor(maxY - minY))
					local healthRatio, healthValue = getHealthRatio(character)
					data.BoxFrame.Position = UDim2.fromOffset(math.floor(minX), math.floor(minY))
					data.BoxFrame.Size = UDim2.fromOffset(width, height)
					if data.DistanceLabel then
						data.DistanceLabel.Text = tostring(getDistanceFromLocal(root)) .. "m"
					end
					if data.HealthBarFill then
						data.HealthBarFill.Size = UDim2.new(1, 0, healthRatio, 0)
						data.HealthBarFill.BackgroundColor3 = getHealthColor(healthRatio)
					end
					if data.HealthLabel then
						data.HealthLabel.Text = tostring(healthValue)
						data.HealthLabel.TextColor3 = getHealthColor(healthRatio)
					end
					boxVisible = true
				end
			end
			data.BoxFrame.Visible = boxVisible
		end
	end
end

local function updateLineESP()
	if not Settings.ESPEnabled then
		return
	end
	local camera = State.Camera
	if not camera then
		for _, data in pairs(State.ESPObjects) do
			if data.TracerLine then
				setLineFrameVisible(data.TracerLine, false)
			end
			if data.BoneLines then
				hideLineFrames(data.BoneLines)
			end
		end
		return
	end
	local wantBones = Settings.BoneESPEnabled
	local wantTracers = Settings.TracersEnabled
	if not wantBones and not wantTracers then
		return
	end
	local tracerOrigin = wantTracers and getTracerOrigin(camera.ViewportSize) or nil
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then
			continue
		end
		local data = State.ESPObjects[player]
		if not data then
			continue
		end
		local character = player.Character
		local root = getRoot(player)
		local generalShouldShow = character and root and isEnemy(player) and withinDistance(root, Settings.MaxESPDistance)
		if not generalShouldShow then
			if data.TracerLine then
				setLineFrameVisible(data.TracerLine, false)
			end
			if data.BoneLines then
				hideLineFrames(data.BoneLines)
			end
			continue
		end

		local color = getTeamColor(player)
		local head = character:FindFirstChild("Head")
		local partScreenCache = {}
		local function getCachedPoint(part)
			if not part or not part:IsA("BasePart") then
				return nil
			end
			local cached = partScreenCache[part]
			if cached ~= nil then
				return cached or nil
			end
			local point = getScreenVector(camera, part.Position)
			partScreenCache[part] = point or false
			return point
		end

		if wantTracers and data.TracerLine then
			local tracerPoint = getCachedPoint(head) or getCachedPoint(root)
			if tracerPoint then
				updateLineFrame(data.TracerLine, tracerOrigin, tracerPoint, color, Settings.TracerThickness)
			else
				setLineFrameVisible(data.TracerLine, false)
			end
		elseif data.TracerLine then
			setLineFrameVisible(data.TracerLine, false)
		end

		if wantBones and data.BoneSegments then
			local anyVisible = false
			local usedBoneLines = {}
			for _, segment in ipairs(data.BoneSegments) do
				usedBoneLines[segment.Line] = true
				local fromPoint = getCachedPoint(segment.From)
				local toPoint = getCachedPoint(segment.To)
				if fromPoint and toPoint then
					updateLineFrame(segment.Line, fromPoint, toPoint, color, Settings.BoneThickness)
					anyVisible = true
				else
					setLineFrameVisible(segment.Line, false)
				end
			end
			if data.BoneLines then
				for _, line in ipairs(data.BoneLines) do
					if not usedBoneLines[line] then
						setLineFrameVisible(line, false)
					end
				end
				if not anyVisible then
					hideLineFrames(data.BoneLines)
				end
			end
		elseif data.BoneLines then
			hideLineFrames(data.BoneLines)
		end
	end
end

local function getClosestTarget()
	local lockedTargetPlayer = Settings.TargetLockEnabled and State.LockedTargetPlayer or nil
	if lockedTargetPlayer then
		local lockedPart = getCharacterPart(lockedTargetPlayer, Settings.AimPart)
		local lockedRoot = getRoot(lockedTargetPlayer)
		if lockedPart and lockedRoot and isEnemy(lockedTargetPlayer) then
			local withinAimRange = withinDistance(lockedRoot, Settings.MaxAimlockDistance)
			local visibleForLock = not Settings.VisibleCheck or isVisible(lockedPart)
			if withinAimRange and visibleForLock then
				return lockedPart
			end
			if Settings.TargetLockSticky then
				return nil
			end
		end
		State.LockedTargetPlayer = nil
	end

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

local function getClosestTargetPlayerCandidate()
	local camera = State.Camera
	if not camera then
		return nil, nil
	end
	local mousePosition = UserInputService:GetMouseLocation()
	local closestPlayer = nil
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
			closestPlayer = player
			closestPart = part
		end
	end
	return closestPlayer, closestPart
end

local function getNearestTargetPlayerCandidate()
	local localRoot = getLocalRoot()
	if not localRoot then
		return nil, nil
	end
	local closestPlayer = nil
	local closestPart = nil
	local closestDistance = Settings.MaxAimlockDistance
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
		local distance = (localRoot.Position - root.Position).Magnitude
		if distance < closestDistance then
			closestDistance = distance
			closestPlayer = player
			closestPart = part
		end
	end
	return closestPlayer, closestPart
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
		State.ActiveKey = enteredKey
		State.ActiveKeyNote = keyData.Note
		State.KeyExpiresAt = keyData.Expires
		statusLabel.TextColor3 = Theme.Good
		statusLabel.Text = keyData.Note .. " accepted.\n" .. getKeyTimeText()
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
		DisplayOrder = 999,
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

	local keyTimerLabel = create("TextLabel", {
		Name = "KeyTimer",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(220, 26),
		Position = UDim2.new(1, -12, 0, 48),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = getKeyTimeText(),
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Center,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local radarVisible = true
	local radarConfig = {
		Size = 220,
		Range = 250,
		UpdateRate = 1 / 30,
		BackgroundColor = Color3.fromRGB(17, 20, 29),
		GridColor = Color3.fromRGB(62, 70, 94),
		CenterColor = Color3.fromRGB(255, 255, 255),
		FriendlyFallbackColor = Color3.fromRGB(90, 200, 255),
		EnemyFallbackColor = Color3.fromRGB(255, 95, 95),
		NeutralColor = Color3.fromRGB(200, 200, 200),
		UseCameraFacing = true,
	}
	local radarElapsed = 0
	local radarRadius = radarConfig.Size * 0.5 - 16
	local radarBlips = {}

	local radarFrame = create("Frame", {
		Name = "BasedGPTRadar",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 80),
		Size = UDim2.fromOffset(radarConfig.Size, radarConfig.Size),
		BackgroundColor3 = radarConfig.BackgroundColor,
		BorderSizePixel = 0,
		Visible = radarVisible,
		ZIndex = 100,
		Parent = screenGui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		create("UIStroke", {
			Color = Color3.fromRGB(114, 124, 156),
			Thickness = 2,
			Transparency = 0.15,
		}),
		create("UIPadding", {
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
	})

	local radarInner = create("Frame", {
		Name = "Inner",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 101,
		Parent = radarFrame,
	})

	local function createRadarRing(scale)
		create("Frame", {
			Name = "Ring",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(scale, scale),
			BackgroundTransparency = 1,
			ZIndex = 101,
			Parent = radarInner,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
			create("UIStroke", {
				Color = radarConfig.GridColor,
				Thickness = 1,
				Transparency = 0.35,
			}),
		})
	end

	createRadarRing(1)
	createRadarRing(0.66)
	createRadarRing(0.33)

	create("Frame", {
		Name = "HorizontalLine",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, -12, 0, 1),
		BackgroundColor3 = radarConfig.GridColor,
		BorderSizePixel = 0,
		BackgroundTransparency = 0.35,
		ZIndex = 101,
		Parent = radarInner,
	})

	create("Frame", {
		Name = "VerticalLine",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(0, 1, 1, -12),
		BackgroundColor3 = radarConfig.GridColor,
		BorderSizePixel = 0,
		BackgroundTransparency = 0.35,
		ZIndex = 101,
		Parent = radarInner,
	})

	create("Frame", {
		Name = "CenterDot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = radarConfig.CenterColor,
		BorderSizePixel = 0,
		ZIndex = 103,
		Parent = radarInner,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	})

	local headingMarker = create("Frame", {
		Name = "HeadingMarker",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(4, 24),
		BackgroundColor3 = radarConfig.CenterColor,
		BorderSizePixel = 0,
		ZIndex = 102,
		Parent = radarInner,
	})

	local radarBlipFolder = create("Folder", {
		Name = "Blips",
		Parent = radarInner,
	})

	local fovCircleStroke = stroke(Theme.CurrentAccent, 2, 0.15)
	local fovCircle = create("Frame", {
		Name = "FOVCircle",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Visible = Settings.ShowFOV,
		Parent = screenGui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		fovCircleStroke,
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

	local blurEffect = create("BlurEffect", {
		Name = "JuliaBlurFX",
		Enabled = false,
		Size = 18,
		Parent = Lighting,
	})

	local bloomEffect = create("BloomEffect", {
		Name = "JuliaBloomFX",
		Enabled = false,
		Intensity = 1.4,
		Size = 32,
		Threshold = 0.9,
		Parent = Lighting,
	})

	local nightVisionEffect = create("ColorCorrectionEffect", {
		Name = "JuliaNightVisionFX",
		Enabled = false,
		Brightness = 0.08,
		Contrast = 0.12,
		Saturation = 0.05,
		TintColor = Color3.fromRGB(150, 255, 170),
		Parent = Lighting,
	})

	local monochromeEffect = create("ColorCorrectionEffect", {
		Name = "JuliaMonochromeFX",
		Enabled = false,
		Brightness = 0,
		Contrast = 0.08,
		Saturation = -1,
		Parent = Lighting,
	})

	local saturationEffect = create("ColorCorrectionEffect", {
		Name = "JuliaSaturationFX",
		Enabled = false,
		Brightness = 0.03,
		Contrast = 0.05,
		Saturation = 0.45,
		Parent = Lighting,
	})

	local cinematicTop = create("Frame", {
		Name = "CinematicTopBar",
		Size = UDim2.new(1, 0, 0, 56),
		Position = UDim2.fromOffset(0, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 700,
		Parent = screenGui,
	})

	local cinematicBottom = create("Frame", {
		Name = "CinematicBottomBar",
		AnchorPoint = Vector2.new(0, 1),
		Size = UDim2.new(1, 0, 0, 56),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 700,
		Parent = screenGui,
	})

	local mouseHaloStroke = stroke(Theme.CurrentAccent, 2, 0.15)
	local mouseHalo = create("Frame", {
		Name = "MouseHalo",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(26, 26),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 650,
		Parent = screenGui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		mouseHaloStroke,
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

	local function getRadarCharacterRoot(player)
		local character = player.Character
		if not character or not isAlive(character) then
			return nil
		end
		return character:FindFirstChild("HumanoidRootPart")
	end

	local function getRadarBlipColor(otherPlayer)
		if otherPlayer.Team ~= nil and otherPlayer.TeamColor then
			return otherPlayer.TeamColor.Color
		end
		if not otherPlayer.Neutral and otherPlayer.TeamColor then
			return otherPlayer.TeamColor.Color
		end
		if LocalPlayer.Team ~= nil and otherPlayer.TeamColor == LocalPlayer.TeamColor then
			return radarConfig.FriendlyFallbackColor
		end
		if otherPlayer.Neutral then
			return radarConfig.NeutralColor
		end
		return radarConfig.EnemyFallbackColor
	end

	local function getRadarBlip(player)
		local existing = radarBlips[player]
		if existing then
			return existing
		end

		local blip = create("Frame", {
			Name = player.Name .. "Blip",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(8, 8),
			BorderSizePixel = 0,
			Visible = false,
			ZIndex = 104,
			Parent = radarBlipFolder,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
			create("UIStroke", {
				Thickness = 1,
				Transparency = 0.2,
				Color = Color3.fromRGB(255, 255, 255),
			}),
		})

		radarBlips[player] = blip
		return blip
	end

	local function removeRadarBlip(player)
		local blip = radarBlips[player]
		if not blip then
			return
		end
		radarBlips[player] = nil
		blip:Destroy()
	end

	local worldOffsetToRadar

	local function getRadarBasis(referencePart)
		if radarConfig.UseCameraFacing then
			local camera = Workspace.CurrentCamera
			if camera then
				local look = camera.CFrame.LookVector
				local flatLook = Vector3.new(look.X, 0, look.Z)
				if flatLook.Magnitude > 0.001 then
					local forward = flatLook.Unit
					local right = Vector3.new(-forward.Z, 0, forward.X)
					return forward, right
				end
			end
		end
		local look = referencePart.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if flatLook.Magnitude > 0.001 then
			local forward = flatLook.Unit
			local right = Vector3.new(-forward.Z, 0, forward.X)
			return forward, right
		end
		return Vector3.new(0, 0, -1), Vector3.new(1, 0, 0)
	end

	local function updateRadarHeadingMarker()
		if not headingMarker then
			return
		end
		headingMarker.Position = UDim2.fromScale(0.5, 0.5)
		headingMarker.Rotation = 0
	end

	worldOffsetToRadar = function(offset, forward, right)
		local flatOffset = Vector3.new(offset.X, 0, offset.Z)
		local scale = radarRadius / radarConfig.Range
		local x = flatOffset:Dot(right) * scale
		local y = -flatOffset:Dot(forward) * scale
		return Vector2.new(x, y)
	end

	local function updateRadar()
		if not radarVisible then
			for _, blip in pairs(radarBlips) do
				blip.Visible = false
			end
			return
		end

		local referencePart = getRadarCharacterRoot(LocalPlayer)
		if not referencePart then
			for _, blip in pairs(radarBlips) do
				blip.Visible = false
			end
			return
		end

		local radarForward, radarRight = getRadarBasis(referencePart)
		updateRadarHeadingMarker()
		for _, player in ipairs(Players:GetPlayers()) do
			if player == LocalPlayer then
				continue
			end

			local blip = getRadarBlip(player)
			local otherRoot = getRadarCharacterRoot(player)
			if not otherRoot then
				blip.Visible = false
				continue
			end

			local offset = otherRoot.Position - referencePart.Position
			local distance = Vector3.new(offset.X, 0, offset.Z).Magnitude
			if distance > radarConfig.Range then
				blip.Visible = false
				continue
			end

			local blipPosition = worldOffsetToRadar(offset, radarForward, radarRight)
			local clampedDistance = math.min(blipPosition.Magnitude, radarRadius - 6)
			local direction = blipPosition.Magnitude > 0 and blipPosition.Unit or Vector2.zero
			local finalPosition = direction * clampedDistance

			blip.Position = UDim2.new(0.5, math.round(finalPosition.X), 0.5, math.round(finalPosition.Y))
			blip.BackgroundColor3 = getRadarBlipColor(player)
			blip.Visible = true
		end
	end

	crosshairHolder.Visible = false
	applyCrosshairStyle(currentCrosshairIndex)

	local panel = create("Frame", {
		Name = "ControlPanel",
		Size = UDim2.fromOffset(250, 760),
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

	local dragHandle = create("Frame", {
		Name = "DragHandle",
		Size = UDim2.new(1, 0, 0, 70),
		Position = UDim2.fromOffset(0, 0),
		Active = true,
		BackgroundTransparency = 1,
		ZIndex = 1,
		Parent = panel,
	})

	local PageButtons = { {}, {}, {}, {}, {}, {} }
	local PageDecor = { {}, {}, {}, {}, {}, {} }
	local activePage = 1
	local showNotifier

	local fpsEnabled = false
	local pingEnabled = false
	local fpsFrameCount = 0
	local fpsLastTime = os.clock()
	local fpsValue = 0
	local sliderVisuals = {}
	local panelDragging = false
	local panelDragStart = nil
	local panelStartPosition = nil
	local panelDragInput = nil
	local rainbowAccentEnabled = false
	local savedRainbowTheme = nil
	local lastRainbowAccentUpdate = 0
	local hudClockEnabled = false
	local fovPulseEnabled = false
	local speedHudEnabled = false
	local targetCounterEnabled = false
	local spinPulseEnabled = false
	local blurFXEnabled = false
	local bloomFXEnabled = false
	local nightVisionEnabled = false
	local monochromeEnabled = false
	local saturationBoostEnabled = false
	local cinematicBarsEnabled = false
	local mouseHaloEnabled = false
	local crosshairSpinEnabled = false
	local watermarkPulseEnabled = false
	local radarSpinEnabled = false
	local toolHudEnabled = false
	local directionHudEnabled = false
	local autoEquipToolEnabled = false
	local dajjalSequenceActive = false
	local targetLockNotifyEnabled = true
	local waitingForLockKey = false
	local lockKeyBindButton = nil
	local Cmd = {
		Registry = {},
		Entries = {},
		OutputLines = {},
		History = {},
		AliasCount = 0,
		Visible = false,
		MaxLines = 14,
		Dragging = false,
	}
	local CmdUtility = {
		Noclip = false,
		NoSit = false,
		Float = false,
		Frozen = false,
		LastNoclipUpdate = 0,
		FloatPart = nil,
		SavedCFrame = nil,
		OriginalCollision = {},
	}
	local panelAutoHideOnAim = false
	local panelAutoHiddenByAim = false
	local infiniteJumpEnabled = false
	local bunnyHopEnabled = false
	local antiAFKEnabled = false
	local zoomUnlockEnabled = false
	local walkSpeedOverride = false
	local jumpPowerOverride = false
	local cameraFOVOverride = false
	local walkSpeedValues = { false, 20, 24, 32, 40 }
	local jumpPowerValues = { false, 60, 75, 90, 110 }
	local cameraFOVValues = { false, 80, 90, 100, 110 }
	local defaultWalkSpeed = 16
	local defaultJumpPower = 50
	local defaultCameraFOV = Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView or 70
	local defaultMinZoom = LocalPlayer.CameraMinZoomDistance
	local defaultMaxZoom = LocalPlayer.CameraMaxZoomDistance

	local fpsLabel = create("TextLabel", {
		Name = "FPSCounter",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(120, 26),
		Position = UDim2.new(1, -12, 0, 306),
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
		Position = UDim2.new(1, -12, 0, 338),
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

	local speedLabel = create("TextLabel", {
		Name = "SpeedCounter",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(140, 26),
		Position = UDim2.new(1, -12, 0, 370),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Speed: 0",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local targetCountLabel = create("TextLabel", {
		Name = "TargetCounter",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(140, 26),
		Position = UDim2.new(1, -12, 0, 402),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Targets: 0",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local lockTargetLabel = create("TextLabel", {
		Name = "LockedTargetLabel",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(220, 26),
		Position = UDim2.new(1, -12, 0, 434),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Lock: None",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = Settings.TargetLockHUD,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local toolLabel = create("TextLabel", {
		Name = "ToolHUD",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(180, 26),
		Position = UDim2.new(1, -12, 0, 466),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Tool: Hands",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local directionLabel = create("TextLabel", {
		Name = "DirectionHUD",
		AnchorPoint = Vector2.new(1, 0),
		Size = UDim2.fromOffset(140, 26),
		Position = UDim2.new(1, -12, 0, 498),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.45,
		BorderSizePixel = 0,
		Text = "Dir: N",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		Visible = false,
		ZIndex = 100,
		Parent = screenGui,
	}, { corner(8) })

	local function getTargetDisplayName(player)
		if not player then
			return "None"
		end
		return player.DisplayName ~= player.Name and (player.DisplayName .. " (@" .. player.Name .. ")") or player.Name
	end

	local function getKeyName(keyCode)
		return keyCode and keyCode.Name or "None"
	end

	local function getCompassDirection()
		local camera = Workspace.CurrentCamera or State.Camera
		if not camera then
			return "N"
		end
		local look = camera.CFrame.LookVector
		local angle = math.deg(math.atan2(-look.X, -look.Z))
		local normalized = (angle + 360) % 360
		local directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
		local index = math.floor(((normalized + 22.5) % 360) / 45) + 1
		return directions[index]
	end

	local function getOverrideLabel(name, value)
		return name .. ": " .. (value and tostring(value) or "Default")
	end

	local function applyWalkSpeedSetting()
		local humanoid = getHumanoid(LocalPlayer.Character)
		if not humanoid then
			return
		end
		humanoid.WalkSpeed = walkSpeedOverride or defaultWalkSpeed
	end

	local function applyJumpPowerSetting()
		local humanoid = getHumanoid(LocalPlayer.Character)
		if not humanoid then
			return
		end
		humanoid.JumpPower = jumpPowerOverride or defaultJumpPower
	end

	local function applyCameraFOVSetting()
		local camera = Workspace.CurrentCamera
		if not camera then
			return
		end
		camera.FieldOfView = cameraFOVOverride or defaultCameraFOV
	end

	local function updateLockStatusLabel()
		lockTargetLabel.Text = "Lock: " .. getTargetDisplayName(State.LockedTargetPlayer)
	end

	local function captureMovementDefaults()
		local character = LocalPlayer.Character
		local humanoid = getHumanoid(character)
		if humanoid then
			if not walkSpeedOverride then
				defaultWalkSpeed = humanoid.WalkSpeed
			end
			if not jumpPowerOverride then
				defaultJumpPower = humanoid.JumpPower
			end
		end
		local camera = Workspace.CurrentCamera
		if camera and not cameraFOVOverride then
			defaultCameraFOV = camera.FieldOfView
		end
	end

	local function getCurrentLockCandidate()
		if Settings.TargetLockMode == "Nearest" then
			return getNearestTargetPlayerCandidate()
		end
		return getClosestTargetPlayerCandidate()
	end

	local function clearLockedTarget(silent)
		local previousTarget = State.LockedTargetPlayer
		State.LockedTargetPlayer = nil
		updateLockStatusLabel()
		if not silent and previousTarget and targetLockNotifyEnabled then
			showNotifier("Target unlocked", getTargetDisplayName(previousTarget))
		end
	end

	local function setLockedTarget(player)
		State.LockedTargetPlayer = player
		updateLockStatusLabel()
		if player and targetLockNotifyEnabled then
			showNotifier("Target locked", getTargetDisplayName(player))
		end
	end

	local function updateTopRightLayout()
		watermark.Size = hudClockEnabled and UDim2.fromOffset(220, 32) or UDim2.fromOffset(160, 32)
		local nextY = 80
		radarFrame.Visible = radarVisible
		radarFrame.Position = UDim2.new(1, -12, 0, nextY)
		if radarVisible then
			nextY += radarConfig.Size + 6
		end

		fpsLabel.Position = UDim2.new(1, -12, 0, nextY)
		fpsLabel.Visible = fpsEnabled
		if fpsEnabled then
			nextY += 32
		end

		pingLabel.Position = UDim2.new(1, -12, 0, nextY)
		pingLabel.Visible = pingEnabled
		if pingEnabled then
			nextY += 32
		end

		speedLabel.Position = UDim2.new(1, -12, 0, nextY)
		speedLabel.Visible = speedHudEnabled
		if speedHudEnabled then
			nextY += 32
		end

		targetCountLabel.Position = UDim2.new(1, -12, 0, nextY)
		targetCountLabel.Visible = targetCounterEnabled
		if targetCounterEnabled then
			nextY += 32
		end

		lockTargetLabel.Position = UDim2.new(1, -12, 0, nextY)
		lockTargetLabel.Visible = Settings.TargetLockHUD
		if Settings.TargetLockHUD then
			nextY += 32
		end

		toolLabel.Position = UDim2.new(1, -12, 0, nextY)
		toolLabel.Visible = toolHudEnabled
		if toolHudEnabled then
			nextY += 32
		end

		directionLabel.Position = UDim2.new(1, -12, 0, nextY)
		directionLabel.Visible = directionHudEnabled
	end

	local function updateStyle()
		watermark.BackgroundColor3 = Theme.CurrentAccent
		watermark.BackgroundTransparency = Theme.WatermarkTransparency
		panel.BackgroundTransparency = Theme.PanelTransparency
		panelGradient.Enabled = Theme.GradientEnabled
		panelGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Theme.GradientA),
			ColorSequenceKeypoint.new(1, Theme.GradientB),
		})
		fovCircleStroke.Color = Theme.CurrentAccent
		toolLabel.TextColor3 = Theme.Text
		directionLabel.TextColor3 = Theme.Text
		if Cmd.Launcher then
			Cmd.Launcher.BackgroundColor3 = Theme.CurrentAccent
			Cmd.Launcher.TextColor3 = Theme.Text
		end
		if Cmd.Frame then
			Cmd.Frame.BackgroundColor3 = Theme.Main
			Cmd.Frame.BackgroundTransparency = Theme.PanelTransparency
			local consoleStroke = Cmd.Frame:FindFirstChildOfClass("UIStroke")
			if consoleStroke then
				consoleStroke.Color = Theme.CurrentAccent
			end
		end
		if Cmd.TitleLabel then
			Cmd.TitleLabel.TextColor3 = Theme.Text
		end
		if Cmd.HintLabel then
			Cmd.HintLabel.TextColor3 = Theme.Muted
		end
		if Cmd.OutputLabel then
			Cmd.OutputLabel.TextColor3 = Theme.Text
		end
		if Cmd.InputBox then
			Cmd.InputBox.BackgroundColor3 = Theme.Button
			Cmd.InputBox.BackgroundTransparency = Theme.ButtonTransparency
			Cmd.InputBox.TextColor3 = Theme.Text
		end
		if Cmd.CloseButton then
			Cmd.CloseButton.BackgroundColor3 = Theme.Button
			Cmd.CloseButton.BackgroundTransparency = Theme.ButtonTransparency
			Cmd.CloseButton.TextColor3 = Theme.Text
		end
		for _, pageButtons in ipairs(PageButtons) do
			for _, button in ipairs(pageButtons) do
				if button and button:IsA("TextButton") then
					button.BackgroundTransparency = Theme.ButtonTransparency
				end
			end
		end
		mouseHaloStroke.Color = Theme.CurrentAccent
		applyCrosshairStyle(currentCrosshairIndex)
		for _, sliderParts in ipairs(sliderVisuals) do
			if sliderParts.Frame then
				sliderParts.Frame.BackgroundColor3 = Theme.Button
				sliderParts.Frame.BackgroundTransparency = Theme.ButtonTransparency
			end
			if sliderParts.Title then
				sliderParts.Title.TextColor3 = Theme.Text
			end
			if sliderParts.Value then
				sliderParts.Value.TextColor3 = Theme.CurrentAccent
			end
			if sliderParts.Track then
				sliderParts.Track.BackgroundColor3 = Theme.ButtonHover
			end
			if sliderParts.Fill then
				sliderParts.Fill.BackgroundColor3 = Theme.CurrentAccent
			end
			if sliderParts.Knob then
				sliderParts.Knob.BackgroundColor3 = Theme.Text
			end
			if sliderParts.Header then
				sliderParts.Header.TextColor3 = Theme.Text
			end
		end
	end

	local function registerPageDecor(instance, page)
		page = math.clamp(page or 1, 1, #PageDecor)
		table.insert(PageDecor[page], instance)
		instance.Visible = activePage == page
		return instance
	end

	local function applyPerformanceMode()
		if Settings.LowEndMode then
			Settings.ESPUpdateRate = Settings.ESPMode == "2D Box" and (1 / 22) or 0.14
			Settings.LineESPUpdateRate = 1 / 30
			Settings.FollowerCloneUpdateRate = 1 / 15
			Settings.FOVUpdateRate = 1 / 30
			Settings.CounterUpdateRate = 1.0
			radarConfig.UpdateRate = 1 / 24
		else
			Settings.ESPUpdateRate = Settings.ESPMode == "2D Box" and (1 / 36) or 0.09
			Settings.LineESPUpdateRate = 1 / 60
			Settings.FollowerCloneUpdateRate = 1 / 28
			Settings.FOVUpdateRate = 1 / 60
			Settings.CounterUpdateRate = 0.45
			radarConfig.UpdateRate = 1 / 30
		end
	end

	applyPerformanceMode()

	local function setPage(page)
		activePage = page
		for pageIndex, pageButtons in ipairs(PageButtons) do
			for _, button in ipairs(pageButtons) do
				button.Visible = page == pageIndex
			end
		end
		for pageIndex, pageDecor in ipairs(PageDecor) do
			for _, widget in ipairs(pageDecor) do
				widget.Visible = page == pageIndex
			end
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
		page = math.clamp(page or 1, 1, #PageButtons)
		table.insert(PageButtons[page], button)
		button.Visible = activePage == page
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

	local function formatSmoothingValue(value)
		return string.format("%.2f", value)
	end

	local function formatRangeValue(value)
		return tostring(math.floor(value + 0.5))
	end

	local function makeSliderSection(headerText, sliderText, y, minValue, maxValue, initialValue, onChanged, page, options)
		options = options or {}
		local stepValue = options.Step or 0.01
		local formatter = options.Formatter or formatSmoothingValue
		local header = registerPageDecor(create("TextLabel", {
			Name = headerText:gsub("%s+", "") .. "Header",
			Size = UDim2.new(1, -20, 0, 20),
			Position = UDim2.fromOffset(10, y),
			BackgroundTransparency = 1,
			Text = headerText,
			TextColor3 = Theme.Text,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = panel,
		}), page)

		local frame = registerPageDecor(create("Frame", {
			Name = sliderText:gsub("%s+", "") .. "SliderFrame",
			Size = UDim2.new(1, -20, 0, 52),
			Position = UDim2.fromOffset(10, y + 22),
			Active = true,
			BackgroundColor3 = Theme.Button,
			BackgroundTransparency = Theme.ButtonTransparency,
			BorderSizePixel = 0,
			Parent = panel,
		}, { corner(8) }), page)

		local titleLabel = create("TextLabel", {
			Name = "SliderTitle",
			Size = UDim2.new(1, -70, 0, 18),
			Position = UDim2.fromOffset(10, 6),
			BackgroundTransparency = 1,
			Text = sliderText,
			TextColor3 = Theme.Text,
			TextSize = 13,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = frame,
		})

		local valueLabel = create("TextLabel", {
			Name = "SliderValue",
			Size = UDim2.fromOffset(54, 18),
			Position = UDim2.new(1, -64, 0, 6),
			BackgroundTransparency = 1,
			Text = formatter(initialValue),
			TextColor3 = Theme.CurrentAccent,
			TextSize = 13,
			Font = Enum.Font.GothamBold,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = frame,
		})

		local track = create("Frame", {
			Name = "SliderTrack",
			Size = UDim2.new(1, -20, 0, 6),
			Position = UDim2.fromOffset(10, 34),
			Active = true,
			BackgroundColor3 = Theme.ButtonHover,
			BorderSizePixel = 0,
			Parent = frame,
		}, { corner(999) })

		local fill = create("Frame", {
			Name = "SliderFill",
			Size = UDim2.new(0, 0, 1, 0),
			BackgroundColor3 = Theme.CurrentAccent,
			BorderSizePixel = 0,
			Parent = track,
		}, { corner(999) })

		local knob = create("Frame", {
			Name = "SliderKnob",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.new(0, 0, 0.5, 0),
			Active = true,
			BackgroundColor3 = Theme.Text,
			BorderSizePixel = 0,
			ZIndex = 2,
			Parent = track,
		}, { corner(999) })

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

		connect(UserInputService.InputChanged, function(input)
			if not dragging then
				return
			end
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				setValueFromInput(input)
			end
		end)

		connect(UserInputService.InputEnded, function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		applySliderValue(currentValue)
		return frame
	end

	connect(dragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			panelDragging = true
			panelDragStart = input.Position
			panelStartPosition = panel.Position
			panelDragInput = input
		end
	end)

	connect(dragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			panelDragInput = input
		end
	end)

	connect(UserInputService.InputChanged, function(input)
		if not panelDragging or input ~= panelDragInput or not panelDragStart or not panelStartPosition then
			return
		end
		local delta = input.Position - panelDragStart
		panel.Position = UDim2.fromOffset(
			math.floor(panelStartPosition.X.Offset + delta.X),
			math.floor(panelStartPosition.Y.Offset + delta.Y)
		)
	end)

	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			panelDragging = false
			panelDragStart = nil
			panelStartPosition = nil
			panelDragInput = nil
		end
	end)

	makeButton("ESP: ON", 76, function(button)
		Settings.ESPEnabled = not Settings.ESPEnabled
		button.Text = "ESP: " .. (Settings.ESPEnabled and "ON" or "OFF")
		if not Settings.ESPEnabled then
			for _, data in pairs(State.ESPObjects) do
				if data.Highlight then data.Highlight.Enabled = false end
				if data.NameGui then data.NameGui.Enabled = false end
				if data.BoxFrame then data.BoxFrame.Visible = false end
				if data.TracerLine then data.TracerLine.Visible = false end
				if data.BoneLines then hideLineFrames(data.BoneLines) end
			end
		end
	end, nil, nil, nil, 1)

	makeButton("ESP Mode: Highlight", 112, function(button)
		Settings.ESPMode = Settings.ESPMode == "Highlight" and "2D Box" or "Highlight"
		button.Text = "ESP Mode: " .. Settings.ESPMode
		applyPerformanceMode()
	end, nil, nil, nil, 1)

	makeButton("Names: ON", 148, function(button)
		Settings.ShowNames = not Settings.ShowNames
		button.Text = "Names: " .. (Settings.ShowNames and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Camlock: ON", 184, function(button)
		Settings.CamlockEnabled = not Settings.CamlockEnabled
		button.Text = "Camlock: " .. (Settings.CamlockEnabled and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Hard Lock: OFF", 220, function(button)
		Settings.HardLockEnabled = not Settings.HardLockEnabled
		button.Text = "Hard Lock: " .. (Settings.HardLockEnabled and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Show FOV: ON", 256, function(button)
		Settings.ShowFOV = not Settings.ShowFOV
		fovCircle.Visible = Settings.ShowFOV
		button.Text = "Show FOV: " .. (Settings.ShowFOV and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Team Check: ON", 292, function(button)
		Settings.TeamCheck = not Settings.TeamCheck
		button.Text = "Team Check: " .. (Settings.TeamCheck and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("Visible Check: OFF", 328, function(button)
		Settings.VisibleCheck = not Settings.VisibleCheck
		button.Text = "Visible Check: " .. (Settings.VisibleCheck and "ON" or "OFF")
	end, nil, nil, nil, 1)

	makeButton("ESP Distance: " .. Settings.MaxESPDistance, 364, function(button)
		Settings.MaxESPDistance = cycleDistance(Settings.MaxESPDistance)
		button.Text = "ESP Distance: " .. Settings.MaxESPDistance
	end, nil, nil, nil, 1)

	makeSliderSection("Ranges", "2D Box ESP Range", 400, 500, 10000, Settings.BoxESPDistance, function(value)
		Settings.BoxESPDistance = value
	end, 1, {
		Step = 250,
		Formatter = formatRangeValue,
	})

	makeButton("Aim Distance: " .. Settings.MaxAimlockDistance, 486, function(button)
		Settings.MaxAimlockDistance = cycleDistance(Settings.MaxAimlockDistance)
		button.Text = "Aim Distance: " .. Settings.MaxAimlockDistance
	end, nil, nil, nil, 1)

	makeButton("Aim Part: Head", 522, function(button)
		Settings.AimPart = Settings.AimPart == "Head" and "Body" or "Head"
		button.Text = "Aim Part: " .. Settings.AimPart
	end, nil, nil, nil, 1)

	makeButton("FOV Down", 558, function()
		Settings.FOVRadius = math.max(40, Settings.FOVRadius - 20)
	end, 110, 10, 28, 1)

	makeButton("FOV Up", 558, function()
		Settings.FOVRadius = math.min(700, Settings.FOVRadius + 20)
	end, 110, 130, 28, 1)

	makeSliderSection("Sliders", "Softlock Smoothness", 596, 0.02, 1.00, Settings.SoftLockSmoothing, function(value)
		Settings.SoftLockSmoothing = value
	end, 1, {
		Step = 0.01,
		Formatter = formatSmoothingValue,
	})

	makeButton("Next Page >", 688, function()
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
		if colorIndex > #colorPresets then
			colorIndex = 1
		end
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
			if math.abs(Theme.PanelTransparency - value) < 0.01 then
				current = i
				break
			end
		end
		current += 1
		if current > #values then
			current = 1
		end
		Theme.PanelTransparency = values[current]
		button.Text = "Panel Transparency: " .. tostring(math.floor(Theme.PanelTransparency * 100)) .. "%"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Button Transparency: 0%", 220, function(button)
		local values = { 0, 0.15, 0.3, 0.45 }
		local current = 1
		for i, value in ipairs(values) do
			if math.abs(Theme.ButtonTransparency - value) < 0.01 then
				current = i
				break
			end
		end
		current += 1
		if current > #values then
			current = 1
		end
		Theme.ButtonTransparency = values[current]
		button.Text = "Button Transparency: " .. tostring(math.floor(Theme.ButtonTransparency * 100)) .. "%"
		updateStyle()
	end, nil, nil, nil, 2)

	makeButton("Watermark Transparency: 50%", 256, function(button)
		local values = { 0.5, 0.35, 0.2, 0.65 }
		local current = 1
		for i, value in ipairs(values) do
			if math.abs(Theme.WatermarkTransparency - value) < 0.01 then
				current = i
				break
			end
		end
		current += 1
		if current > #values then
			current = 1
		end
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
		if skyMode > #skyNames then
			skyMode = 1
		end
		button.Text = "Sky/Weather: " .. skyNames[skyMode]
		applySkyMode()
		applyDayNight()
		if fullbrightEnabled then
			applyFullbright()
		end
	end, nil, nil, nil, 2)

	makeButton("Crosshair: OFF", 400, function(button)
		currentCrosshairIndex += 1
		if currentCrosshairIndex > 5 then
			currentCrosshairIndex = 0
		end
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

	local friendNotifierEnabled = false
	local notifiedJuliaUsers = {}
	local spinEnabled = false
	local spinSpeed = 720
	local spinDirection = 1
	local spinSpeeds = { 360, 720, 1080, 1440, 5000, 10000, 25000, 50000 }
	local followerCloneEnabled = false
	local followerCloneGap = 6
	local followerCloneGaps = { 4, 6, 8, 12, 16 }
	local followerCloneModel = nil
	local followerCloneSource = nil
	local followerClonePartLinks = {}
	local followerCloneLastUpdate = 0
	local getFollowerClonePart

	local function isSpinRigReady()
		local character = LocalPlayer.Character
		local humanoid = getHumanoid(character)
		return humanoid ~= nil and (
			humanoid.RigType == Enum.HumanoidRigType.R6
			or humanoid.RigType == Enum.HumanoidRigType.R15
		)
	end

	local function getLocalSpinRoot()
		local character = LocalPlayer.Character
		if not character then
			return nil
		end
		return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
	end

	local function destroyFollowerClone()
		if followerCloneModel then
			followerCloneModel:Destroy()
			followerCloneModel = nil
		end
		followerCloneSource = nil
		followerClonePartLinks = {}
		followerCloneLastUpdate = 0
	end

	local function ensureFollowerClone()
		local character = LocalPlayer.Character
		if not followerCloneEnabled or not character then
			destroyFollowerClone()
			return nil
		end
		if followerCloneModel and followerCloneSource == character and followerCloneModel.Parent then
			return followerCloneModel
		end

		destroyFollowerClone()

		local originalArchivable = character.Archivable
		character.Archivable = true
		local clone = character:Clone()
		character.Archivable = originalArchivable
		if not clone then
			return nil
		end

		clone.Name = "JuliaFollowerClone"
		for _, descendant in ipairs(clone:GetDescendants()) do
			if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript") then
				descendant:Destroy()
			elseif descendant:IsA("Humanoid") then
				descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				descendant.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
				descendant.NameDisplayDistance = 0
				descendant.BreakJointsOnDeath = false
				descendant.AutoRotate = false
			elseif descendant:IsA("BasePart") then
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanTouch = false
				descendant.CanQuery = false
				descendant.CastShadow = false
				descendant.Massless = true
				descendant.Transparency = math.clamp(descendant.Transparency + 0.35, 0.35, 0.8)
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = math.clamp(descendant.Transparency + 0.35, 0.35, 0.85)
			elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
				descendant.Enabled = false
			elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
				descendant.Enabled = false
			end
		end

		clone.Parent = Workspace
		followerCloneModel = clone
		followerCloneSource = character
		followerClonePartLinks = {}
		for _, sourceDescendant in ipairs(character:GetDescendants()) do
			if sourceDescendant:IsA("BasePart") then
				local clonePart = getFollowerClonePart(character, clone, sourceDescendant)
				if clonePart then
					table.insert(followerClonePartLinks, {
						Source = sourceDescendant,
						Clone = clonePart,
					})
				end
			end
		end
		return clone
	end

	getFollowerClonePart = function(sourceCharacter, cloneCharacter, sourcePart)
		if not sourceCharacter or not cloneCharacter or not sourcePart or not sourcePart:IsA("BasePart") then
			return nil
		end

		local sourceAccessory = sourcePart:FindFirstAncestorOfClass("Accessory")
		if sourceAccessory and sourceAccessory.Parent == sourceCharacter then
			local cloneAccessory = cloneCharacter:FindFirstChild(sourceAccessory.Name)
			if cloneAccessory and cloneAccessory:IsA("Accessory") then
				local cloneAccessoryPart = cloneAccessory:FindFirstChild(sourcePart.Name)
				if cloneAccessoryPart and cloneAccessoryPart:IsA("BasePart") then
					return cloneAccessoryPart
				end
			end
		end

		local clonePart = cloneCharacter:FindFirstChild(sourcePart.Name)
		if clonePart and clonePart:IsA("BasePart") then
			return clonePart
		end

		local recursivePart = cloneCharacter:FindFirstChild(sourcePart.Name, true)
		if recursivePart and recursivePart:IsA("BasePart") then
			return recursivePart
		end

		return nil
	end

	local function updateFollowerClone(now)
		if not followerCloneEnabled then
			destroyFollowerClone()
			return
		end
		now = now or os.clock()
		if now - followerCloneLastUpdate < Settings.FollowerCloneUpdateRate then
			return
		end
		followerCloneLastUpdate = now

		local character = LocalPlayer.Character
		local sourceRoot = getLocalSpinRoot()
		if not character or not sourceRoot then
			destroyFollowerClone()
			return
		end

		local clone = ensureFollowerClone()
		if not clone then
			return
		end

		local targetRootCFrame = sourceRoot.CFrame * CFrame.new(0, 0, followerCloneGap)
		for _, link in ipairs(followerClonePartLinks) do
			local sourceDescendant = link.Source
			local clonePart = link.Clone
			if sourceDescendant and clonePart and sourceDescendant.Parent and clonePart.Parent then
				local relativeCFrame = sourceRoot.CFrame:ToObjectSpace(sourceDescendant.CFrame)
				clonePart.CFrame = targetRootCFrame * relativeCFrame
			end
		end
	end

	showNotifier = function(title, message)
		local note = create("TextLabel", {
			Name = "JuliaNotifier",
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.fromOffset(260, 54),
			Position = UDim2.new(1, 280, 0, 116),
			BackgroundColor3 = Color3.fromRGB(20, 20, 25),
			BackgroundTransparency = 0.12,
			BorderSizePixel = 0,
			Text = title .. "\n" .. message,
			TextColor3 = Theme.Text,
			TextSize = 13,
			TextWrapped = true,
			Font = Enum.Font.GothamBold,
			ZIndex = 500,
			Parent = screenGui,
		}, {
			corner(10),
			stroke(Theme.CurrentAccent, 1.5, 0.25),
		})
		tween(note, 0.22, {
			Position = UDim2.new(1, -12, 0, 116),
		})
		task.delay(3, function()
			if note and note.Parent then
				tween(note, 0.22, {
					Position = UDim2.new(1, 280, 0, 116),
				})
				task.delay(0.25, function()
					if note and note.Parent then
						note:Destroy()
					end
				end)
			end
		end)
	end

	local function checkFriendNotifier(player)
		if not friendNotifierEnabled or not player or player == LocalPlayer then
			return
		end
		local isFriend = false
		pcall(function()
			isFriend = LocalPlayer:IsFriendsWith(player.UserId)
		end)
		if isFriend then
			showNotifier("Friend joined", player.DisplayName .. " (@" .. player.Name .. ") is in this server.")
		end
		if player:GetAttribute("JuliaHubUser") == true and not notifiedJuliaUsers[player] then
			notifiedJuliaUsers[player] = true
			showNotifier("Julia user detected", player.DisplayName .. " appears to be using Julia features.")
		end
	end

	local animeGirlVisible = false
	local animeGirl = nil
	local juliaBounceStart = os.clock()
	local juliaBasePosition = UDim2.new(1, -18, 1, -18)
	local outfitSwitching = false
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
	local OutfitDraw = {}

	OutfitDraw.Base = function(parent)
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

	OutfitDraw.Default = function(parent)
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

	OutfitDraw.Beach = function(parent)
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

	OutfitDraw.Playful = function(parent)
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

	OutfitDraw.Military = function(parent)
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

	OutfitDraw.Inspired = function(parent)
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

	OutfitDraw.Teasing = function(parent)
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

	OutfitDraw.Maid = function(parent)
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

	OutfitDraw.ArmsUp = function(parent)
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

	OutfitDraw.Latex = function(parent)
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

	OutfitDraw.Cowprint = function(parent)
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
		OutfitDraw.Base(animeGirl)
		if animeOutfitIndex == 1 then
			OutfitDraw.Default(animeGirl)
		elseif animeOutfitIndex == 2 then
			OutfitDraw.Beach(animeGirl)
		elseif animeOutfitIndex == 3 then
			OutfitDraw.Playful(animeGirl)
		elseif animeOutfitIndex == 4 then
			OutfitDraw.Military(animeGirl)
		elseif animeOutfitIndex == 5 then
			OutfitDraw.Inspired(animeGirl)
		elseif animeOutfitIndex == 6 then
			OutfitDraw.Teasing(animeGirl)
		elseif animeOutfitIndex == 7 then
			OutfitDraw.Maid(animeGirl)
		elseif animeOutfitIndex == 8 then
			OutfitDraw.ArmsUp(animeGirl)
		elseif animeOutfitIndex == 9 then
			OutfitDraw.Latex(animeGirl)
		else
			OutfitDraw.Cowprint(animeGirl)
		end
	end

	local function setAnimeGirlVisible(enabled)
		if not animeGirl then
			createDrawnAnimeGirl()
		end
		animeGirlVisible = enabled
		animeGirl.Visible = enabled
		juliaBounceStart = os.clock()
		if enabled then
			animeGirl.Position = juliaBasePosition
		end
	end

	createDrawnAnimeGirl()

	connect(RunService.Heartbeat, function()
		if not JuliaRunning then
			return
		end
		if animeGirl and animeGirl.Parent and animeGirl.Visible then
			local bounce = math.sin((os.clock() - juliaBounceStart) * 4) * 4
			animeGirl.Position = UDim2.new(1, -18, 1, -18 + bounce)
		end
	end)

	makeButton("< Style Page", 76, function()
		setPage(2)
	end, nil, nil, nil, 3)

	makeButton("Rejoin Server", 112, function(button)
		button.Text = "Rejoining..."
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end, nil, nil, nil, 3)

	makeButton("FPS Counter: OFF", 148, function(button)
		fpsEnabled = not fpsEnabled
		button.Text = "FPS Counter: " .. (fpsEnabled and "ON" or "OFF")
		updateTopRightLayout()
	end, nil, nil, nil, 3)

	makeButton("Ping Counter: OFF", 184, function(button)
		pingEnabled = not pingEnabled
		button.Text = "Ping Counter: " .. (pingEnabled and "ON" or "OFF")
		updateTopRightLayout()
	end, nil, nil, nil, 3)

	makeButton("Radar: ON", 220, function(button)
		radarVisible = not radarVisible
		button.Text = "Radar: " .. (radarVisible and "ON" or "OFF")
		updateTopRightLayout()
		if not radarVisible then
			for _, blip in pairs(radarBlips) do
				blip.Visible = false
			end
		end
	end, nil, nil, nil, 3)

	makeSliderSection("Ranges", "Radar Range", 256, 100, 5000, radarConfig.Range, function(value)
		radarConfig.Range = value
	end, 3, {
		Step = 50,
		Formatter = formatRangeValue,
	})

	makeButton("Spin: OFF", 342, function(button)
		if not isSpinRigReady() then
			button.Text = "Spin: RIG NOT READY"
			task.delay(1.2, function()
				if button and button.Parent then
					button.Text = "Spin: " .. (spinEnabled and "ON" or "OFF")
				end
			end)
			return
		end
		spinEnabled = not spinEnabled
		button.Text = "Spin: " .. (spinEnabled and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Spin Speed: 720", 378, function(button)
		local currentIndex = 1
		for i, value in ipairs(spinSpeeds) do
			if value == spinSpeed then
				currentIndex = i
				break
			end
		end
		currentIndex += 1
		if currentIndex > #spinSpeeds then
			currentIndex = 1
		end
		spinSpeed = spinSpeeds[currentIndex]
		button.Text = "Spin Speed: " .. tostring(spinSpeed)
	end, nil, nil, nil, 3)

	makeButton("Low-End Mode: OFF", 414, function(button)
		Settings.LowEndMode = not Settings.LowEndMode
		applyPerformanceMode()
		button.Text = "Low-End Mode: " .. (Settings.LowEndMode and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Friend Notify: OFF", 450, function(button)
		friendNotifierEnabled = not friendNotifierEnabled
		button.Text = "Friend Notify: " .. (friendNotifierEnabled and "ON" or "OFF")
		if friendNotifierEnabled then
			for _, player in ipairs(Players:GetPlayers()) do
				checkFriendNotifier(player)
			end
		end
	end, nil, nil, nil, 3)

	makeButton("Follower Clone: OFF", 486, function(button)
		followerCloneEnabled = not followerCloneEnabled
		button.Text = "Follower Clone: " .. (followerCloneEnabled and "ON" or "OFF")
		if not followerCloneEnabled then
			destroyFollowerClone()
		end
	end, nil, nil, nil, 3)

	makeButton("Clone Gap: 6", 522, function(button)
		local currentIndex = 1
		for i, value in ipairs(followerCloneGaps) do
			if value == followerCloneGap then
				currentIndex = i
				break
			end
		end
		currentIndex += 1
		if currentIndex > #followerCloneGaps then
			currentIndex = 1
		end
		followerCloneGap = followerCloneGaps[currentIndex]
		button.Text = "Clone Gap: " .. tostring(followerCloneGap)
	end, nil, nil, nil, 3)

	makeButton("Anime Girl: OFF", 558, function(button)
		animeGirlVisible = not animeGirlVisible
		setAnimeGirlVisible(animeGirlVisible)
		button.Text = "Anime Girl: " .. (animeGirlVisible and "ON" or "OFF")
	end, nil, nil, nil, 3)

	makeButton("Outfit: Default", 594, function(button)
		if outfitSwitching then
			return
		end
		outfitSwitching = true
		animeOutfitIndex += 1
		if animeOutfitIndex > #animeOutfitNames then
			animeOutfitIndex = 1
		end
		button.Text = "Outfit: " .. animeOutfitNames[animeOutfitIndex]
		local wasVisible = animeGirlVisible
		createDrawnAnimeGirl()
		animeGirl.Visible = wasVisible
		animeGirl.Position = juliaBasePosition
		juliaBounceStart = os.clock()
		task.delay(0.12, function()
			outfitSwitching = false
		end)
	end, nil, nil, nil, 3)

	makeButton("Back Main", 630, function()
		setPage(1)
	end, 110, 10, 28, 3)

	makeButton("Extras >", 630, function()
		setPage(4)
	end, 110, 130, 28, 3)

	registerPageDecor(create("TextLabel", {
		Name = "PageFourESPHeader",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, 76),
		BackgroundTransparency = 1,
		Text = "ESP Extras / Radar",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), 4)

	makeButton("Bone ESP: OFF", 104, function(button)
		Settings.BoneESPEnabled = not Settings.BoneESPEnabled
		button.Text = "Bone ESP: " .. (Settings.BoneESPEnabled and "ON" or "OFF")
		if not Settings.BoneESPEnabled then
			for _, data in pairs(State.ESPObjects) do
				if data.BoneLines then
					hideLineFrames(data.BoneLines)
				end
			end
		end
	end, nil, nil, nil, 4)

	makeButton("Bone Thickness: 2", 140, function(button)
		Settings.BoneThickness += 1
		if Settings.BoneThickness > 4 then
			Settings.BoneThickness = 1
		end
		button.Text = "Bone Thickness: " .. tostring(Settings.BoneThickness)
	end, nil, nil, nil, 4)

	makeButton("Tracers: OFF", 176, function(button)
		Settings.TracersEnabled = not Settings.TracersEnabled
		button.Text = "Tracers: " .. (Settings.TracersEnabled and "ON" or "OFF")
		if not Settings.TracersEnabled then
			for _, data in pairs(State.ESPObjects) do
				if data.TracerLine then
					data.TracerLine.Visible = false
				end
			end
		end
	end, nil, nil, nil, 4)

	makeButton("Tracer Origin: Bottom", 212, function(button)
		if Settings.TracerOrigin == "Bottom" then
			Settings.TracerOrigin = "Center"
		elseif Settings.TracerOrigin == "Center" then
			Settings.TracerOrigin = "Top"
		else
			Settings.TracerOrigin = "Bottom"
		end
		button.Text = "Tracer Origin: " .. Settings.TracerOrigin
	end, nil, nil, nil, 4)

	makeButton("Tracer Thick: 1", 248, function(button)
		Settings.TracerThickness += 1
		if Settings.TracerThickness > 3 then
			Settings.TracerThickness = 1
		end
		button.Text = "Tracer Thick: " .. tostring(Settings.TracerThickness)
	end, nil, nil, nil, 4)

	makeButton("Radar Facing: Camera", 284, function(button)
		radarConfig.UseCameraFacing = not radarConfig.UseCameraFacing
		button.Text = "Radar Facing: " .. (radarConfig.UseCameraFacing and "Camera" or "Character")
		updateRadar()
	end, nil, nil, nil, 4)

	makeButton("Radar Size: 220", 320, function(button)
		local radarSizes = { 180, 220, 260, 300 }
		local currentIndex = 1
		for i, value in ipairs(radarSizes) do
			if value == radarConfig.Size then
				currentIndex = i
				break
			end
		end
		currentIndex += 1
		if currentIndex > #radarSizes then
			currentIndex = 1
		end
		radarConfig.Size = radarSizes[currentIndex]
		radarFrame.Size = UDim2.fromOffset(radarConfig.Size, radarConfig.Size)
		radarRadius = radarConfig.Size * 0.5 - 16
		button.Text = "Radar Size: " .. tostring(radarConfig.Size)
		updateTopRightLayout()
		updateRadar()
	end, nil, nil, nil, 4)

	registerPageDecor(create("TextLabel", {
		Name = "PageFourFunHeader",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, 372),
		BackgroundTransparency = 1,
		Text = "HUD / Fun / Utility",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), 4)

	makeButton("Rainbow Accent: OFF", 400, function(button)
		rainbowAccentEnabled = not rainbowAccentEnabled
		if rainbowAccentEnabled then
			savedRainbowTheme = {
				CurrentAccent = Theme.CurrentAccent,
				GradientA = Theme.GradientA,
				GradientB = Theme.GradientB,
			}
		elseif savedRainbowTheme then
			Theme.CurrentAccent = savedRainbowTheme.CurrentAccent
			Theme.GradientA = savedRainbowTheme.GradientA
			Theme.GradientB = savedRainbowTheme.GradientB
			savedRainbowTheme = nil
			updateStyle()
		end
		button.Text = "Rainbow Accent: " .. (rainbowAccentEnabled and "ON" or "OFF")
	end, nil, nil, nil, 4)

	makeButton("HUD Clock: OFF", 436, function(button)
		hudClockEnabled = not hudClockEnabled
		button.Text = "HUD Clock: " .. (hudClockEnabled and "ON" or "OFF")
		watermark.Text = hudClockEnabled and ("Julia Hub | " .. os.date("%H:%M:%S")) or "Julia Hub"
		updateTopRightLayout()
	end, nil, nil, nil, 4)

	makeButton("FOV Pulse: OFF", 472, function(button)
		fovPulseEnabled = not fovPulseEnabled
		button.Text = "FOV Pulse: " .. (fovPulseEnabled and "ON" or "OFF")
	end, nil, nil, nil, 4)

	makeButton("Spin Dir: CW", 508, function(button)
		spinDirection = spinDirection == 1 and -1 or 1
		button.Text = "Spin Dir: " .. (spinDirection == 1 and "CW" or "CCW")
	end, nil, nil, nil, 4)

	makeButton("Spin Pulse: OFF", 544, function(button)
		spinPulseEnabled = not spinPulseEnabled
		button.Text = "Spin Pulse: " .. (spinPulseEnabled and "ON" or "OFF")
	end, nil, nil, nil, 4)

	makeButton("Speed HUD: OFF", 580, function(button)
		speedHudEnabled = not speedHudEnabled
		button.Text = "Speed HUD: " .. (speedHudEnabled and "ON" or "OFF")
		updateTopRightLayout()
	end, nil, nil, nil, 4)

	makeButton("Target HUD: OFF", 616, function(button)
		targetCounterEnabled = not targetCounterEnabled
		button.Text = "Target HUD: " .. (targetCounterEnabled and "ON" or "OFF")
		updateTopRightLayout()
	end, nil, nil, nil, 4)

	makeButton("Notify Test", 652, function()
		showNotifier("Julia Hub", "Notification test sent.")
	end, nil, nil, nil, 4)

	makeButton("< Page 3", 688, function()
		setPage(3)
	end, 110, 10, 28, 4)

	makeButton("Utility >", 688, function()
		setPage(5)
	end, 110, 130, 28, 4)

	captureMovementDefaults()

	registerPageDecor(create("TextLabel", {
		Name = "PageFiveTargetHeader",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, 76),
		BackgroundTransparency = 1,
		Text = "Target Lock",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), 5)

	makeButton("Target Lock: ON", 104, function(button)
		Settings.TargetLockEnabled = not Settings.TargetLockEnabled
		button.Text = "Target Lock: " .. (Settings.TargetLockEnabled and "ON" or "OFF")
		if not Settings.TargetLockEnabled then
			clearLockedTarget(true)
		end
	end, nil, nil, nil, 5)

	lockKeyBindButton = makeButton("Lock Key: " .. getKeyName(Settings.TargetLockKey), 140, function(button)
		waitingForLockKey = true
		button.Text = "Lock Key: Press Any Key"
	end, nil, nil, nil, 5)

	makeButton("Lock Pick: Crosshair", 176, function(button)
		Settings.TargetLockMode = Settings.TargetLockMode == "Crosshair" and "Nearest" or "Crosshair"
		button.Text = "Lock Pick: " .. Settings.TargetLockMode
	end, nil, nil, nil, 5)

	makeButton("Lock Sticky: ON", 212, function(button)
		Settings.TargetLockSticky = not Settings.TargetLockSticky
		button.Text = "Lock Sticky: " .. (Settings.TargetLockSticky and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Lock Notify: ON", 248, function(button)
		targetLockNotifyEnabled = not targetLockNotifyEnabled
		button.Text = "Lock Notify: " .. (targetLockNotifyEnabled and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Lock HUD: ON", 284, function(button)
		Settings.TargetLockHUD = not Settings.TargetLockHUD
		button.Text = "Lock HUD: " .. (Settings.TargetLockHUD and "ON" or "OFF")
		updateTopRightLayout()
	end, nil, nil, nil, 5)

	makeButton("Clear Locked Target", 320, function()
		clearLockedTarget()
	end, nil, nil, nil, 5)

	registerPageDecor(create("TextLabel", {
		Name = "PageFiveUtilityHeader",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, 356),
		BackgroundTransparency = 1,
		Text = "Utility / Movement",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), 5)

	makeButton("Hide Panel ADS: OFF", 384, function(button)
		panelAutoHideOnAim = not panelAutoHideOnAim
		button.Text = "Hide Panel ADS: " .. (panelAutoHideOnAim and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Infinite Jump: OFF", 420, function(button)
		infiniteJumpEnabled = not infiniteJumpEnabled
		button.Text = "Infinite Jump: " .. (infiniteJumpEnabled and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Bunny Hop: OFF", 456, function(button)
		bunnyHopEnabled = not bunnyHopEnabled
		button.Text = "Bunny Hop: " .. (bunnyHopEnabled and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Anti-AFK: OFF", 492, function(button)
		antiAFKEnabled = not antiAFKEnabled
		button.Text = "Anti-AFK: " .. (antiAFKEnabled and "ON" or "OFF")
	end, nil, nil, nil, 5)

	makeButton("Zoom Unlock: OFF", 528, function(button)
		zoomUnlockEnabled = not zoomUnlockEnabled
		if zoomUnlockEnabled then
			LocalPlayer.CameraMinZoomDistance = 0.5
			LocalPlayer.CameraMaxZoomDistance = 1000
		else
			LocalPlayer.CameraMinZoomDistance = defaultMinZoom
			LocalPlayer.CameraMaxZoomDistance = defaultMaxZoom
		end
		button.Text = "Zoom Unlock: " .. (zoomUnlockEnabled and "ON" or "OFF")
	end, nil, nil, nil, 5)

	local walkSpeedButton = makeButton(getOverrideLabel("WalkSpeed", walkSpeedOverride), 564, function(button)
		local currentIndex = 1
		for index, value in ipairs(walkSpeedValues) do
			if value == walkSpeedOverride then
				currentIndex = index
				break
			end
		end
		currentIndex += 1
		if currentIndex > #walkSpeedValues then
			currentIndex = 1
		end
		walkSpeedOverride = walkSpeedValues[currentIndex]
		applyWalkSpeedSetting()
		button.Text = getOverrideLabel("WalkSpeed", walkSpeedOverride)
	end, nil, nil, nil, 5)

	local jumpPowerButton = makeButton(getOverrideLabel("JumpPower", jumpPowerOverride), 600, function(button)
		local currentIndex = 1
		for index, value in ipairs(jumpPowerValues) do
			if value == jumpPowerOverride then
				currentIndex = index
				break
			end
		end
		currentIndex += 1
		if currentIndex > #jumpPowerValues then
			currentIndex = 1
		end
		jumpPowerOverride = jumpPowerValues[currentIndex]
		applyJumpPowerSetting()
		button.Text = getOverrideLabel("JumpPower", jumpPowerOverride)
	end, nil, nil, nil, 5)

	local cameraFOVButton = makeButton(getOverrideLabel("Camera FOV", cameraFOVOverride), 636, function(button)
		local currentIndex = 1
		for index, value in ipairs(cameraFOVValues) do
			if value == cameraFOVOverride then
				currentIndex = index
				break
			end
		end
		currentIndex += 1
		if currentIndex > #cameraFOVValues then
			currentIndex = 1
		end
		cameraFOVOverride = cameraFOVValues[currentIndex]
		applyCameraFOVSetting()
		button.Text = getOverrideLabel("Camera FOV", cameraFOVOverride)
	end, nil, nil, nil, 5)

	makeButton("Reset Movement", 672, function()
		walkSpeedOverride = false
		jumpPowerOverride = false
		cameraFOVOverride = false
		if zoomUnlockEnabled then
			LocalPlayer.CameraMinZoomDistance = 0.5
			LocalPlayer.CameraMaxZoomDistance = 1000
		else
			LocalPlayer.CameraMinZoomDistance = defaultMinZoom
			LocalPlayer.CameraMaxZoomDistance = defaultMaxZoom
		end
		local camera = Workspace.CurrentCamera
		if camera then
			applyCameraFOVSetting()
		end
		local humanoid = getHumanoid(LocalPlayer.Character)
		if humanoid then
			applyWalkSpeedSetting()
			applyJumpPowerSetting()
		end
		if walkSpeedButton then
			walkSpeedButton.Text = getOverrideLabel("WalkSpeed", walkSpeedOverride)
		end
		if jumpPowerButton then
			jumpPowerButton.Text = getOverrideLabel("JumpPower", jumpPowerOverride)
		end
		if cameraFOVButton then
			cameraFOVButton.Text = getOverrideLabel("Camera FOV", cameraFOVOverride)
		end
	end, nil, nil, nil, 5)

	makeButton("< Extras", 708, function()
		setPage(4)
	end, 110, 10, 28, 5)

	makeButton("Chaos >", 708, function()
		setPage(6)
	end, 110, 130, 28, 5)

	local function summonDajjalSequence(button)
		if dajjalSequenceActive then
			return
		end
		dajjalSequenceActive = true
		if button then
			button.Text = "Summoning..."
		end

		local overlay = create("Frame", {
			Name = "DajjalSequence",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(10, 0, 0),
			BackgroundTransparency = 0.15,
			BorderSizePixel = 0,
			ZIndex = 900,
			Parent = screenGui,
		})

		local flash = create("Frame", {
			Name = "DajjalFlash",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 20, 20),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 901,
			Parent = overlay,
		})

		local static = create("Frame", {
			Name = "StaticNoise",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.96,
			BorderSizePixel = 0,
			ZIndex = 902,
			Parent = overlay,
		})

		local title = create("TextLabel", {
			Name = "DajjalTitle",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.12),
			Size = UDim2.fromOffset(520, 50),
			BackgroundTransparency = 1,
			Text = "SUMMON THE DAJJAL",
			TextColor3 = Color3.fromRGB(255, 90, 90),
			TextStrokeTransparency = 0,
			TextSize = 28,
			Font = Enum.Font.GothamBlack,
			ZIndex = 905,
			Parent = overlay,
		})

		local subtitle = create("TextLabel", {
			Name = "DajjalSubtitle",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.19),
			Size = UDim2.fromOffset(620, 28),
			BackgroundTransparency = 1,
			Text = "one eye, false throne, dust from the east",
			TextColor3 = Color3.fromRGB(220, 220, 220),
			TextStrokeTransparency = 0.15,
			TextSize = 16,
			Font = Enum.Font.GothamBold,
			ZIndex = 905,
			Parent = overlay,
		})

		local eyeOuter = create("Frame", {
			Name = "DajjalEyeOuter",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(260, 144),
			BackgroundTransparency = 1,
			ZIndex = 904,
			Parent = overlay,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
			stroke(Color3.fromRGB(255, 80, 80), 4, 0.08),
		})

		local eyeInner = create("Frame", {
			Name = "DajjalEyeInner",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(92, 92),
			BackgroundColor3 = Color3.fromRGB(170, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 905,
			Parent = eyeOuter,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local pupil = create("Frame", {
			Name = "DajjalPupil",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(28, 64),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			ZIndex = 906,
			Parent = eyeInner,
		}, {
			create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		})

		local leftPanel = create("Frame", {
			Name = "DajjalLeftPanel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.22, 0.54),
			Size = UDim2.fromOffset(170, 170),
			BackgroundColor3 = Color3.fromRGB(18, 18, 22),
			BackgroundTransparency = 0.18,
			BorderSizePixel = 0,
			Rotation = -8,
			ZIndex = 903,
			Parent = overlay,
		}, {
			corner(12),
			stroke(Color3.fromRGB(255, 80, 80), 2, 0.2),
		})

		local rightPanel = create("Frame", {
			Name = "DajjalRightPanel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.78, 0.54),
			Size = UDim2.fromOffset(170, 170),
			BackgroundColor3 = Color3.fromRGB(18, 18, 22),
			BackgroundTransparency = 0.18,
			BorderSizePixel = 0,
			Rotation = 8,
			ZIndex = 903,
			Parent = overlay,
		}, {
			corner(12),
			stroke(Color3.fromRGB(255, 80, 80), 2, 0.2),
		})

		local leftCaption = create("TextLabel", {
			Name = "LeftCaption",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.15),
			Size = UDim2.new(1, -16, 0, 24),
			BackgroundTransparency = 1,
			Text = "ONE EYED SIGN",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextStrokeTransparency = 0.1,
			TextSize = 14,
			Font = Enum.Font.GothamBlack,
			ZIndex = 904,
			Parent = leftPanel,
		})

		local rightCaption = create("TextLabel", {
			Name = "RightCaption",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.15),
			Size = UDim2.new(1, -16, 0, 24),
			BackgroundTransparency = 1,
			Text = "FALSE THRONE",
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextStrokeTransparency = 0.1,
			TextSize = 14,
			Font = Enum.Font.GothamBlack,
			ZIndex = 904,
			Parent = rightPanel,
		})

		local function makeSigil(parent, position, size, color, transparency, rotation)
			local sigil = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = position,
				Size = size,
				BackgroundColor3 = color,
				BackgroundTransparency = transparency or 0,
				BorderSizePixel = 0,
				Rotation = rotation or 0,
				ZIndex = 904,
				Parent = parent,
			})
			return sigil
		end

		makeSigil(leftPanel, UDim2.fromScale(0.5, 0.55), UDim2.fromOffset(96, 3), Color3.fromRGB(255, 80, 80), 0.15, 0)
		makeSigil(leftPanel, UDim2.fromScale(0.5, 0.55), UDim2.fromOffset(3, 96), Color3.fromRGB(255, 80, 80), 0.15, 0)
		makeSigil(leftPanel, UDim2.fromScale(0.5, 0.55), UDim2.fromOffset(96, 3), Color3.fromRGB(255, 80, 80), 0.15, 45)
		makeSigil(leftPanel, UDim2.fromScale(0.5, 0.55), UDim2.fromOffset(96, 3), Color3.fromRGB(255, 80, 80), 0.15, -45)
		makeSigil(rightPanel, UDim2.fromScale(0.5, 0.58), UDim2.fromOffset(112, 16), Color3.fromRGB(35, 35, 35), 0.05, 0)
		makeSigil(rightPanel, UDim2.fromScale(0.5, 0.48), UDim2.fromOffset(84, 10), Color3.fromRGB(90, 15, 15), 0.05, 0)
		makeSigil(rightPanel, UDim2.fromScale(0.5, 0.68), UDim2.fromOffset(64, 8), Color3.fromRGB(45, 45, 45), 0.05, 0)

		local footer = create("TextLabel", {
			Name = "DajjalFooter",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.86),
			Size = UDim2.fromOffset(540, 34),
			BackgroundTransparency = 1,
			Text = "the watcher arrives",
			TextColor3 = Color3.fromRGB(255, 120, 120),
			TextStrokeTransparency = 0.05,
			TextSize = 20,
			Font = Enum.Font.GothamBold,
			ZIndex = 905,
			Parent = overlay,
		})

		local chantSound = create("Sound", {
			Name = "DajjalHum",
			SoundId = "rbxasset://sounds/uuhhh.wav",
			Volume = 1.2,
			PlaybackSpeed = 0.72,
			Looped = true,
			Parent = overlay,
		})

		local hitSound = create("Sound", {
			Name = "DajjalHit",
			SoundId = "rbxasset://sounds/electronicpingshort.wav",
			Volume = 1,
			PlaybackSpeed = 0.55,
			Parent = overlay,
		})

		pcall(function()
			chantSound:Play()
		end)

		task.spawn(function()
			local phrases = {
				"ONE EYED SIGN",
				"FALSE THRONE",
				"DUST OF THE EAST",
				"THE WATCHER ARRIVES",
				"THE GATE IS OPEN",
			}
			local footerPhrases = {
				"shadows move behind the veil",
				"the sky grows heavy",
				"the drums get closer",
				"the horizon is split",
				"too late to turn back",
			}
			for index, phrase in ipairs(phrases) do
				if not overlay.Parent then
					break
				end
				title.Text = phrase
				subtitle.Text = footerPhrases[index]
				leftCaption.Text = phrase
				rightCaption.Text = footerPhrases[index]:upper()
				leftPanel.Rotation = -8 + (index * 4)
				rightPanel.Rotation = 8 - (index * 4)
				eyeOuter.Size = UDim2.fromOffset(240 + (index * 18), 132 + (index * 10))
				eyeInner.Size = UDim2.fromOffset(86 + (index * 6), 86 + (index * 6))
				pupil.Position = UDim2.new(0.5, math.random(-10, 10), 0.5, math.random(-6, 6))
				flash.BackgroundTransparency = index % 2 == 0 and 0.78 or 0.9
				static.BackgroundTransparency = 0.92 - (index * 0.02)
				overlay.BackgroundColor3 = index % 2 == 0 and Color3.fromRGB(20, 0, 0) or Color3.fromRGB(0, 0, 0)
				pcall(function()
					hitSound:Play()
				end)
				task.wait(0.65)
				flash.BackgroundTransparency = 1
				task.wait(0.3)
			end
			task.wait(0.4)
			if overlay and overlay.Parent then
				overlay:Destroy()
			end
			dajjalSequenceActive = false
			if button and button.Parent then
				button.Text = "Summon the Dajjal"
			end
			LocalPlayer:Kick("The Dajjal has arrived, fool.")
		end)
	end

	registerPageDecor(create("TextLabel", {
		Name = "PageSixChaosHeader",
		Size = UDim2.new(1, -20, 0, 20),
		Position = UDim2.fromOffset(10, 76),
		BackgroundTransparency = 1,
		Text = "Chaos / Utility",
		TextColor3 = Theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	}), 6)

	makeButton("Summon the Dajjal", 104, function(button)
		summonDajjalSequence(button)
	end, nil, nil, nil, 6)

	makeButton("Blur FX: OFF", 140, function(button)
		blurFXEnabled = not blurFXEnabled
		blurEffect.Enabled = blurFXEnabled
		button.Text = "Blur FX: " .. (blurFXEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Bloom FX: OFF", 176, function(button)
		bloomFXEnabled = not bloomFXEnabled
		bloomEffect.Enabled = bloomFXEnabled
		button.Text = "Bloom FX: " .. (bloomFXEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Night Vision: OFF", 212, function(button)
		nightVisionEnabled = not nightVisionEnabled
		nightVisionEffect.Enabled = nightVisionEnabled
		button.Text = "Night Vision: " .. (nightVisionEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Monochrome: OFF", 248, function(button)
		monochromeEnabled = not monochromeEnabled
		monochromeEffect.Enabled = monochromeEnabled
		button.Text = "Monochrome: " .. (monochromeEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Saturation+: OFF", 284, function(button)
		saturationBoostEnabled = not saturationBoostEnabled
		saturationEffect.Enabled = saturationBoostEnabled
		button.Text = "Saturation+: " .. (saturationBoostEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Cinematic Bars: OFF", 320, function(button)
		cinematicBarsEnabled = not cinematicBarsEnabled
		cinematicTop.Visible = cinematicBarsEnabled
		cinematicBottom.Visible = cinematicBarsEnabled
		button.Text = "Cinematic Bars: " .. (cinematicBarsEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Mouse Halo: OFF", 356, function(button)
		mouseHaloEnabled = not mouseHaloEnabled
		mouseHalo.Visible = mouseHaloEnabled
		button.Text = "Mouse Halo: " .. (mouseHaloEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Crosshair Spin: OFF", 392, function(button)
		crosshairSpinEnabled = not crosshairSpinEnabled
		if not crosshairSpinEnabled then
			crosshairHolder.Rotation = 0
		end
		button.Text = "Crosshair Spin: " .. (crosshairSpinEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Watermark Pulse: OFF", 428, function(button)
		watermarkPulseEnabled = not watermarkPulseEnabled
		if not watermarkPulseEnabled then
			updateTopRightLayout()
		end
		button.Text = "Watermark Pulse: " .. (watermarkPulseEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Radar Spin: OFF", 464, function(button)
		radarSpinEnabled = not radarSpinEnabled
		if not radarSpinEnabled then
			radarFrame.Rotation = 0
		end
		button.Text = "Radar Spin: " .. (radarSpinEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Tool HUD: OFF", 500, function(button)
		toolHudEnabled = not toolHudEnabled
		updateTopRightLayout()
		button.Text = "Tool HUD: " .. (toolHudEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Direction HUD: OFF", 536, function(button)
		directionHudEnabled = not directionHudEnabled
		updateTopRightLayout()
		button.Text = "Direction HUD: " .. (directionHudEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Auto Equip: OFF", 572, function(button)
		autoEquipToolEnabled = not autoEquipToolEnabled
		button.Text = "Auto Equip: " .. (autoEquipToolEnabled and "ON" or "OFF")
	end, nil, nil, nil, 6)

	makeButton("Quick Reset", 608, function()
		local humanoid = getHumanoid(LocalPlayer.Character)
		if humanoid then
			humanoid.Health = 0
		end
	end, nil, nil, nil, 6)

	makeButton("< Utility", 708, function()
		setPage(5)
	end, 110, 10, 28, 6)

	makeButton("Back Main", 708, function()
		setPage(1)
	end, 110, 130, 28, 6)

	local function applyLockKeyButtonText()
		if lockKeyBindButton and lockKeyBindButton.Parent then
			lockKeyBindButton.Text = "Lock Key: " .. getKeyName(Settings.TargetLockKey)
		end
	end

	local function toggleTargetLock()
		if not Settings.TargetLockEnabled then
			if targetLockNotifyEnabled then
				showNotifier("Target lock", "Enable target lock first.")
			end
			return
		end
		local candidatePlayer = getCurrentLockCandidate()
		if candidatePlayer then
			if State.LockedTargetPlayer == candidatePlayer then
				clearLockedTarget()
			else
				setLockedTarget(candidatePlayer)
			end
			return
		end
		if State.LockedTargetPlayer then
			clearLockedTarget()
		elseif targetLockNotifyEnabled then
			showNotifier("Target lock", "No valid target found.")
		end
	end

	local function validateLockedTarget()
		local lockedPlayer = State.LockedTargetPlayer
		if not lockedPlayer then
			updateLockStatusLabel()
			return
		end
		local lockedPart = getCharacterPart(lockedPlayer, Settings.AimPart)
		local lockedRoot = getRoot(lockedPlayer)
		if not lockedPart or not lockedRoot or not isEnemy(lockedPlayer) then
			clearLockedTarget(true)
			return
		end
		if not Settings.TargetLockSticky then
			local validDistance = withinDistance(lockedRoot, Settings.MaxAimlockDistance)
			local validVisibility = not Settings.VisibleCheck or isVisible(lockedPart)
			if not validDistance or not validVisibility then
				clearLockedTarget(true)
				return
			end
		end
		updateLockStatusLabel()
	end

	local function applyZoomUnlockState()
		if zoomUnlockEnabled then
			LocalPlayer.CameraMinZoomDistance = 0.5
			LocalPlayer.CameraMaxZoomDistance = 1000
		else
			LocalPlayer.CameraMinZoomDistance = defaultMinZoom
			LocalPlayer.CameraMaxZoomDistance = defaultMaxZoom
		end
	end

	local function initCommandConsole()
	local commandDragHandle = create("Frame", {
		Name = "CommandDragHandle",
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		Active = true,
		ZIndex = 821,
		Parent = screenGui,
	})

	Cmd.Frame = create("Frame", {
		Name = "CommandConsole",
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(380, 250),
		Position = UDim2.new(1, -12, 1, -72),
		BackgroundColor3 = Theme.Main,
		BackgroundTransparency = Theme.PanelTransparency,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 820,
		Parent = screenGui,
	}, {
		corner(10),
		stroke(Theme.CurrentAccent, 1.5, 0.25),
	})
	commandDragHandle.Parent = Cmd.Frame

	Cmd.TitleLabel = create("TextLabel", {
		Name = "CommandTitle",
		Size = UDim2.new(1, -84, 0, 20),
		Position = UDim2.fromOffset(12, 8),
		BackgroundTransparency = 1,
		Text = "Julia Commands",
		TextColor3 = Theme.Text,
		TextSize = 15,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 821,
		Parent = Cmd.Frame,
	})

	Cmd.HintLabel = create("TextLabel", {
		Name = "CommandHint",
		Size = UDim2.new(1, -84, 0, 14),
		Position = UDim2.fromOffset(12, 24),
		BackgroundTransparency = 1,
		Text = "type ;help",
		TextColor3 = Theme.Muted,
		TextSize = 11,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 821,
		Parent = Cmd.Frame,
	})

	Cmd.CloseButton = create("TextButton", {
		Name = "CommandClose",
		Size = UDim2.fromOffset(56, 24),
		Position = UDim2.new(1, -66, 0, 8),
		BackgroundColor3 = Theme.Button,
		BackgroundTransparency = Theme.ButtonTransparency,
		BorderSizePixel = 0,
		Text = "Hide",
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 821,
		Parent = Cmd.Frame,
	}, {
		corner(8),
	})

	local commandOutputFrame = create("Frame", {
		Name = "CommandOutputFrame",
		Size = UDim2.new(1, -24, 1, -94),
		Position = UDim2.fromOffset(12, 44),
		BackgroundColor3 = Color3.fromRGB(12, 12, 16),
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		ZIndex = 821,
		Parent = Cmd.Frame,
	}, {
		corner(8),
	})

	Cmd.OutputLabel = create("TextLabel", {
		Name = "CommandOutput",
		Size = UDim2.new(1, -12, 1, -12),
		Position = UDim2.fromOffset(6, 6),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Theme.Text,
		TextSize = 12,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 822,
		Parent = commandOutputFrame,
	})

	Cmd.InputBox = create("TextBox", {
		Name = "CommandInput",
		Size = UDim2.new(1, -24, 0, 32),
		Position = UDim2.new(0, 12, 1, -44),
		BackgroundColor3 = Theme.Button,
		BackgroundTransparency = Theme.ButtonTransparency,
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = ";help | ;noclip | ;coords",
		PlaceholderColor3 = Theme.Muted,
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.Gotham,
		ClearTextOnFocus = false,
		ZIndex = 822,
		Parent = Cmd.Frame,
	}, {
		corner(8),
	})

	Cmd.Launcher = create("TextButton", {
		Name = "CommandLauncher",
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(72, 32),
		Position = UDim2.new(1, -12, 1, -28),
		BackgroundColor3 = Theme.CurrentAccent,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Text = "Cmd +",
		TextColor3 = Theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		ZIndex = 822,
		Parent = screenGui,
	}, {
		corner(8),
	})

	local function setConsoleVisible(enabled)
		Cmd.Visible = enabled
		if Cmd.Frame then
			Cmd.Frame.Visible = enabled
		end
		if Cmd.Launcher then
			Cmd.Launcher.Text = enabled and "Cmd -" or "Cmd +"
		end
		if enabled and Cmd.InputBox then
			task.defer(function()
				if Cmd.InputBox and Cmd.InputBox.Parent then
					Cmd.InputBox:CaptureFocus()
				end
			end)
		end
	end

	local function appendConsoleLine(text)
		table.insert(Cmd.OutputLines, tostring(text))
		while #Cmd.OutputLines > Cmd.MaxLines do
			table.remove(Cmd.OutputLines, 1)
		end
		if Cmd.OutputLabel then
			Cmd.OutputLabel.Text = table.concat(Cmd.OutputLines, "\n")
		end
	end

	local function normalizeCommandToken(text)
		return tostring(text or ""):lower():gsub("^%s+", ""):gsub("%s+$", ""):gsub("[%s%p_]+", "")
	end

	local function splitCommandWords(text)
		local words = {}
		for token in tostring(text or ""):gmatch("%S+") do
			table.insert(words, token)
		end
		return words
	end

	local function parseToggleValue(token, currentValue)
		local normalized = tostring(token or ""):lower()
		if normalized == "" then
			return not currentValue
		end
		if normalized == "on" or normalized == "true" or normalized == "1" or normalized == "yes" or normalized == "enable" or normalized == "enabled" or normalized == "open" or normalized == "show" or normalized == "start" then
			return true
		end
		if normalized == "off" or normalized == "false" or normalized == "0" or normalized == "no" or normalized == "disable" or normalized == "disabled" or normalized == "close" or normalized == "hide" or normalized == "stop" then
			return false
		end
		return nil
	end

	local function registerCommand(names, usage, description, handler)
		local entry = {
			Names = names,
			Usage = usage,
			Description = description,
			Handler = handler,
		}
		table.insert(Cmd.Entries, entry)
		for _, alias in ipairs(names) do
			Cmd.Registry[normalizeCommandToken(alias)] = entry
			Cmd.AliasCount += 1
		end
	end

	--[[ Disabled duplicated UI-command mirror. The active console now registers utility-only commands below.
	registerCommand({ "help", "cmdhelp", "?" }, "help [command]", "Show command help.", function(args)
		local topic = normalizeCommandToken(args[2])
		if topic ~= "" then
			local entry = Cmd.Registry[topic]
			if not entry then
				return false, "unknown command"
			end
			return true, entry.Usage .. " - " .. entry.Description
		end
		appendConsoleLine("Core: help commands aliases history clear page notify echo")
		appendConsoleLine("Aim: esp espmode camlock hardlock fovradius aimdistance aimpart softsmooth")
		appendConsoleLine("ESP: names teamcheck visiblecheck bones bonethickness tracers tracerorigin tracerthickness")
		appendConsoleLine("Style: gradient color panelalpha buttonalpha watermarkalpha daynight fullbright sky crosshair")
		appendConsoleLine("HUD: fpshud pinghud speedhud targethud lockhud toolhud directionhud hudclock")
		appendConsoleLine("Fun: spin spinspeed spindir clone clonegap animegirl outfit rainbowaccent dajjal")
		appendConsoleLine("FX: blur bloom nightvision monochrome saturation cinematicbars mousehalo crosshairspin radarspin")
		appendConsoleLine("Utility: targetlock lockname clearlock infjump bunnyhop antiafk zoomunlock walkspeed jumppower camfov")
		return true, "registered " .. tostring(#Cmd.Entries) .. " commands with " .. tostring(Cmd.AliasCount) .. " aliases."
	end)

	registerCommand({ "commands", "cmds", "list" }, "commands", "Show the primary command names.", function()
		local primary = {}
		for _, entry in ipairs(Cmd.Entries) do
			table.insert(primary, entry.Names[1])
		end
		table.sort(primary)
		appendConsoleLine(table.concat(primary, ", "))
		return true, tostring(#primary) .. " primary commands."
	end)

	registerCommand({ "aliases", "aliascount" }, "aliases", "Show alias count.", function()
		return true, tostring(Cmd.AliasCount) .. " aliases registered."
	end)

	registerCommand({ "history", "recent" }, "history", "Show recent entered commands.", function()
		if #Cmd.History == 0 then
			return true, "no command history yet."
		end
		local startIndex = math.max(1, #Cmd.History - 5)
		for index = startIndex, #Cmd.History do
			appendConsoleLine(Cmd.History[index])
		end
		return true, "showing recent commands."
	end)

	registerCommand({ "clear", "cls", "flush" }, "clear", "Clear console output.", function()
		table.clear(Cmd.OutputLines)
		Cmd.OutputLabel.Text = ""
		return true, "console cleared."
	end)

	registerCommand({ "echo", "sayline" }, "echo <text>", "Echo text into the console.", function(args)
		local message = table.concat(args, " ", 2)
		if message == "" then
			return false, "text required"
		end
		return true, message
	end)

	registerCommand({ "console", "cmdbar", "terminal" }, "console [open/close]", "Toggle the command console.", function(args)
		local nextValue = parseToggleValue(args[2], Cmd.Visible)
		if nextValue == nil then
			return false, "use open/close/on/off"
		end
		setConsoleVisible(nextValue)
		return true, "console: " .. (nextValue and "OPEN" or "CLOSED")
	end)

	registerCommand({ "page", "menu", "tab" }, "page <1-6|main|style|fun|extras|utility|chaos>", "Switch visible page.", function(args)
		local page = setPageByToken(args[2] or "")
		if not page then
			return false, "invalid page"
		end
		return true, "page: " .. tostring(page)
	end)

	registerCommand({ "notify", "toast", "popup" }, "notify <text>", "Show a local notification.", function(args)
		local message = table.concat(args, " ", 2)
		if message == "" then
			return false, "text required"
		end
		showNotifier("Julia Commands", message)
		return true, "notification sent."
	end)

	registerCommand({ "keytime", "ktl", "keyleft" }, "keytime", "Show remaining key time.", function()
		return true, getKeyTimeText()
	end)

	registerCommand({ "rejoin", "serverhop", "rj" }, "rejoin", "Rejoin the current server.", function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
		return true, "rejoining..."
	end)

	registerCommand({ "quickreset", "resetme", "die" }, "quickreset", "Reset your character.", function()
		local humanoid = getHumanoid(LocalPlayer.Character)
		if not humanoid then
			return false, "character not ready"
		end
		humanoid.Health = 0
		return true, "resetting character."
	end)

	registerCommand({ "espmode", "modeesp", "boxmode" }, "espmode <highlight/2dbox>", "Switch ESP mode.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "highlight" then
			Settings.ESPMode = "Highlight"
		elseif wanted == "2dbox" or wanted == "box" or wanted == "boxesp" then
			Settings.ESPMode = "2D Box"
		else
			return false, "use highlight or 2dbox"
		end
		applyPerformanceMode()
		return true, "esp mode: " .. Settings.ESPMode
	end)

	registerCommand({ "aimpart", "hitpart", "targetpart" }, "aimpart <head/body>", "Set aim part.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "head" then
			Settings.AimPart = "Head"
		elseif wanted == "body" or wanted == "torso" then
			Settings.AimPart = "Body"
		else
			return false, "use head or body"
		end
		return true, "aim part: " .. Settings.AimPart
	end)

	registerCommand({ "tracerorigin", "tracerfrom", "traceorigin" }, "tracerorigin <bottom/center/top>", "Set tracer origin.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "bottom" then
			Settings.TracerOrigin = "Bottom"
		elseif wanted == "center" or wanted == "middle" then
			Settings.TracerOrigin = "Center"
		elseif wanted == "top" then
			Settings.TracerOrigin = "Top"
		else
			return false, "use bottom, center, or top"
		end
		return true, "tracer origin: " .. Settings.TracerOrigin
	end)

	registerCommand({ "daynight", "timeofday", "clockmode" }, "daynight <day/night>", "Toggle day or night.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "day" then
			dayMode = true
		elseif wanted == "night" then
			dayMode = false
		else
			return false, "use day or night"
		end
		applyDayNight()
		return true, "time: " .. (dayMode and "Day" or "Night")
	end)

	registerCommand({ "sky", "weather", "skymode" }, "sky <clear/sunset/storm/purple/soft>", "Set sky style.", function(args)
		local label = setSkyModeByName(args[2] or "")
		if not label then
			return false, "invalid sky mode"
		end
		return true, "sky: " .. label
	end)

	registerCommand({ "crosshair", "reticle", "xh" }, "crosshair <off/dot/circle/star/diamond/anime>", "Set crosshair style.", function(args)
		local label = setCrosshairByName(args[2] or "")
		if not label then
			return false, "invalid crosshair"
		end
		return true, "crosshair: " .. label
	end)

	registerCommand({ "color", "accent", "theme" }, "color <red/purple/blue/green/pink>", "Set accent color preset.", function(args)
		local label = setColorPresetByName(args[2] or "")
		if not label then
			return false, "invalid color preset"
		end
		return true, "color: " .. label
	end)

	registerCommand({ "radarfacing", "radarface", "rfacing" }, "radarfacing <camera/character>", "Set radar facing mode.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "camera" then
			radarConfig.UseCameraFacing = true
		elseif wanted == "character" or wanted == "body" then
			radarConfig.UseCameraFacing = false
		else
			return false, "use camera or character"
		end
		updateRadar()
		return true, "radar facing: " .. (radarConfig.UseCameraFacing and "Camera" or "Character")
	end)

	registerCommand({ "spindir", "spindirection", "spinway" }, "spindir <cw/ccw>", "Set spin direction.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "cw" or wanted == "clockwise" then
			spinDirection = 1
		elseif wanted == "ccw" or wanted == "counterclockwise" or wanted == "anticlockwise" then
			spinDirection = -1
		else
			return false, "use cw or ccw"
		end
		return true, "spin dir: " .. (spinDirection == 1 and "CW" or "CCW")
	end)

	registerCommand({ "lockmode", "lockpick", "targetpick" }, "lockmode <crosshair/nearest>", "Set target lock mode.", function(args)
		local wanted = normalizeCommandToken(args[2])
		if wanted == "crosshair" then
			Settings.TargetLockMode = "Crosshair"
		elseif wanted == "nearest" then
			Settings.TargetLockMode = "Nearest"
		else
			return false, "use crosshair or nearest"
		end
		return true, "lock mode: " .. Settings.TargetLockMode
	end)

	registerCommand({ "lockname", "lockplayer", "target" }, "lockname <player>", "Lock onto a player by name.", function(args)
		local query = table.concat(args, " ", 2)
		local player = resolvePlayerQuery(query)
		if not player then
			return false, "player not found"
		end
		setLockedTarget(player)
		return true, "locked: " .. getTargetDisplayName(player)
	end)

	registerCommand({ "clearlock", "unlock", "targetclear" }, "clearlock", "Clear locked target.", function()
		clearLockedTarget()
		return true, "locked target cleared."
	end)

	registerCommand({ "outfit", "animeoutfit", "dress" }, "outfit <name>", "Set anime outfit.", function(args)
		local label = setOutfitByName(table.concat(args, " ", 2))
		if not label then
			return false, "unknown outfit"
		end
		return true, "outfit: " .. label
	end)

	registerCommand({ "resetstyle", "styledefault", "stylereset" }, "resetstyle", "Reset style settings.", function()
		Theme.CurrentAccent = Color3.fromRGB(255, 40, 40)
		Theme.GradientA = Color3.fromRGB(255, 40, 40)
		Theme.GradientB = Color3.fromRGB(60, 90, 160)
		Theme.PanelTransparency = 0.08
		Theme.ButtonTransparency = 0
		Theme.WatermarkTransparency = 0.5
		Theme.GradientEnabled = false
		rainbowAccentEnabled = false
		setCrosshairByName("off")
		updateStyle()
		return true, "style reset."
	end)

	registerCommand({ "resetmovement", "movementreset", "resetmove" }, "resetmovement", "Reset movement overrides.", function()
		walkSpeedOverride = false
		jumpPowerOverride = false
		cameraFOVOverride = false
		applyZoomUnlockState()
		applyWalkSpeedSetting()
		applyJumpPowerSetting()
		applyCameraFOVSetting()
		return true, "movement overrides reset."
	end)

	registerCommand({ "allhud", "hudall", "hudstack" }, "allhud <on/off>", "Toggle all HUD counters.", function(args)
		local nextValue = parseToggleValue(args[2], fpsEnabled and pingEnabled and speedHudEnabled and targetCounterEnabled)
		if nextValue == nil then
			return false, "use on/off"
		end
		fpsEnabled = nextValue
		pingEnabled = nextValue
		speedHudEnabled = nextValue
		targetCounterEnabled = nextValue
		Settings.TargetLockHUD = nextValue
		toolHudEnabled = nextValue
		directionHudEnabled = nextValue
		updateTopRightLayout()
		return true, "all hud: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "allesp", "espall", "combatvisuals" }, "allesp <on/off>", "Toggle esp, names, bones, and tracers together.", function(args)
		local nextValue = parseToggleValue(args[2], Settings.ESPEnabled and Settings.ShowNames)
		if nextValue == nil then
			return false, "use on/off"
		end
		Settings.ESPEnabled = nextValue
		Settings.ShowNames = nextValue
		Settings.BoneESPEnabled = nextValue
		Settings.TracersEnabled = nextValue
		if not nextValue then
			for _, data in pairs(State.ESPObjects) do
				if data.Highlight then data.Highlight.Enabled = false end
				if data.NameGui then data.NameGui.Enabled = false end
				if data.BoxFrame then data.BoxFrame.Visible = false end
				if data.TracerLine then data.TracerLine.Visible = false end
				if data.BoneLines then hideLineFrames(data.BoneLines) end
			end
		end
		return true, "all esp: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "allfx", "fxall", "visualfx" }, "allfx <on/off>", "Toggle the page-6 effect stack.", function(args)
		local nextValue = parseToggleValue(args[2], blurFXEnabled or bloomFXEnabled or nightVisionEnabled)
		if nextValue == nil then
			return false, "use on/off"
		end
		blurFXEnabled = nextValue
		bloomFXEnabled = nextValue
		nightVisionEnabled = nextValue
		monochromeEnabled = nextValue
		saturationBoostEnabled = nextValue
		cinematicBarsEnabled = nextValue
		mouseHaloEnabled = nextValue
		crosshairSpinEnabled = nextValue
		watermarkPulseEnabled = nextValue
		radarSpinEnabled = nextValue
		blurEffect.Enabled = blurFXEnabled
		bloomEffect.Enabled = bloomFXEnabled
		nightVisionEffect.Enabled = nightVisionEnabled
		monochromeEffect.Enabled = monochromeEnabled
		saturationEffect.Enabled = saturationBoostEnabled
		cinematicTop.Visible = cinematicBarsEnabled
		cinematicBottom.Visible = cinematicBarsEnabled
		updateTopRightLayout()
		return true, "all fx: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "dajjal", "summon", "summondajjal" }, "dajjal", "Trigger the scary summon sequence.", function()
		summonDajjalSequence()
		return true, "summoning..."
	end)

	addToggleCommand({ "esp", "toggleesp", "enemyesp" }, "esp [on/off]", "Toggle ESP.", function()
		return Settings.ESPEnabled
	end, function(value)
		Settings.ESPEnabled = value
		if not value then
			for _, data in pairs(State.ESPObjects) do
				if data.Highlight then data.Highlight.Enabled = false end
				if data.NameGui then data.NameGui.Enabled = false end
				if data.BoxFrame then data.BoxFrame.Visible = false end
			end
		end
	end)
	addToggleCommand({ "names", "shownames", "nameesp" }, "names [on/off]", "Toggle name ESP.", function()
		return Settings.ShowNames
	end, function(value)
		Settings.ShowNames = value
	end)
	addToggleCommand({ "camlock", "aimlock", "softlock" }, "camlock [on/off]", "Toggle camlock.", function()
		return Settings.CamlockEnabled
	end, function(value)
		Settings.CamlockEnabled = value
	end)
	addToggleCommand({ "hardlock", "hardaim", "snaplock" }, "hardlock [on/off]", "Toggle hard lock.", function()
		return Settings.HardLockEnabled
	end, function(value)
		Settings.HardLockEnabled = value
	end)
	addToggleCommand({ "showfov", "fov", "fovcircle" }, "showfov [on/off]", "Toggle FOV circle.", function()
		return Settings.ShowFOV
	end, function(value)
		Settings.ShowFOV = value
		fovCircle.Visible = value
	end)
	addToggleCommand({ "teamcheck", "teams", "tc" }, "teamcheck [on/off]", "Toggle team check.", function()
		return Settings.TeamCheck
	end, function(value)
		Settings.TeamCheck = value
	end)
	addToggleCommand({ "visiblecheck", "vischeck", "vc" }, "visiblecheck [on/off]", "Toggle visibility check.", function()
		return Settings.VisibleCheck
	end, function(value)
		Settings.VisibleCheck = value
	end)
	addToggleCommand({ "bones", "boneesp", "skeleton" }, "bones [on/off]", "Toggle bone ESP.", function()
		return Settings.BoneESPEnabled
	end, function(value)
		Settings.BoneESPEnabled = value
	end)
	addToggleCommand({ "tracers", "trace", "lines" }, "tracers [on/off]", "Toggle tracers.", function()
		return Settings.TracersEnabled
	end, function(value)
		Settings.TracersEnabled = value
		if not value then
			for _, data in pairs(State.ESPObjects) do
				if data.TracerLine then
					data.TracerLine.Visible = false
				end
			end
		end
	end)
	addToggleCommand({ "gradient", "grad", "panelgradient" }, "gradient [on/off]", "Toggle panel gradient.", function()
		return Theme.GradientEnabled
	end, function(value)
		Theme.GradientEnabled = value
		updateStyle()
	end)
	addToggleCommand({ "fullbright", "fb", "bright" }, "fullbright [on/off]", "Toggle fullbright.", function()
		return fullbrightEnabled
	end, function(value)
		fullbrightEnabled = value
		applyFullbright()
	end)
	addToggleCommand({ "radar", "minimap", "map" }, "radar [on/off]", "Toggle radar.", function()
		return radarVisible
	end, function(value)
		radarVisible = value
		updateTopRightLayout()
		if not value then
			for _, blip in pairs(radarBlips) do
				blip.Visible = false
			end
		end
	end)
	addToggleCommand({ "fpshud", "fpscounter", "fps" }, "fpshud [on/off]", "Toggle FPS HUD.", function()
		return fpsEnabled
	end, function(value)
		fpsEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "pinghud", "pingcounter", "ping" }, "pinghud [on/off]", "Toggle ping HUD.", function()
		return pingEnabled
	end, function(value)
		pingEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "speedhud", "speedcounter", "speedometer" }, "speedhud [on/off]", "Toggle speed HUD.", function()
		return speedHudEnabled
	end, function(value)
		speedHudEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "targethud", "targetcounter", "enemyscan" }, "targethud [on/off]", "Toggle target counter HUD.", function()
		return targetCounterEnabled
	end, function(value)
		targetCounterEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "lockhud", "lockcounter", "lockstatus" }, "lockhud [on/off]", "Toggle lock HUD.", function()
		return Settings.TargetLockHUD
	end, function(value)
		Settings.TargetLockHUD = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "lowend", "performance", "potato" }, "lowend [on/off]", "Toggle low-end mode.", function()
		return Settings.LowEndMode
	end, function(value)
		Settings.LowEndMode = value
		applyPerformanceMode()
	end)
	addToggleCommand({ "friendnotify", "friends", "friendalerts" }, "friendnotify [on/off]", "Toggle friend notifier.", function()
		return friendNotifierEnabled
	end, function(value)
		friendNotifierEnabled = value
	end)
	addToggleCommand({ "spin", "spinbot", "whirl" }, "spin [on/off]", "Toggle spinning.", function()
		return spinEnabled
	end, function(value)
		spinEnabled = value
	end)
	addToggleCommand({ "clone", "followerclone", "afterclone" }, "clone [on/off]", "Toggle follower clone.", function()
		return followerCloneEnabled
	end, function(value)
		followerCloneEnabled = value
		if not value then
			destroyFollowerClone()
		end
	end)
	addToggleCommand({ "animegirl", "waifu", "julia" }, "animegirl [on/off]", "Toggle anime girl.", function()
		return animeGirlVisible
	end, function(value)
		setAnimeGirlVisible(value)
	end)
	addToggleCommand({ "rainbowaccent", "rainbow", "rgb" }, "rainbowaccent [on/off]", "Toggle rainbow accent.", function()
		return rainbowAccentEnabled
	end, function(value)
		rainbowAccentEnabled = value
		if value then
			savedRainbowTheme = {
				CurrentAccent = Theme.CurrentAccent,
				GradientA = Theme.GradientA,
				GradientB = Theme.GradientB,
			}
		elseif savedRainbowTheme then
			Theme.CurrentAccent = savedRainbowTheme.CurrentAccent
			Theme.GradientA = savedRainbowTheme.GradientA
			Theme.GradientB = savedRainbowTheme.GradientB
			savedRainbowTheme = nil
			updateStyle()
		end
	end)
	addToggleCommand({ "hudclock", "clock", "timehud" }, "hudclock [on/off]", "Toggle HUD clock.", function()
		return hudClockEnabled
	end, function(value)
		hudClockEnabled = value
		watermark.Text = hudClockEnabled and ("Julia Hub | " .. os.date("%H:%M:%S")) or "Julia Hub"
		updateTopRightLayout()
	end)
	addToggleCommand({ "fovpulse", "pulsefov", "breathingfov" }, "fovpulse [on/off]", "Toggle FOV pulse.", function()
		return fovPulseEnabled
	end, function(value)
		fovPulseEnabled = value
	end)
	addToggleCommand({ "spinpulse", "pulsespin", "spinwave" }, "spinpulse [on/off]", "Toggle spin pulse.", function()
		return spinPulseEnabled
	end, function(value)
		spinPulseEnabled = value
	end)
	addToggleCommand({ "targetlock", "locksystem", "stickylock" }, "targetlock [on/off]", "Toggle target lock system.", function()
		return Settings.TargetLockEnabled
	end, function(value)
		Settings.TargetLockEnabled = value
		if not value then
			clearLockedTarget(true)
		end
	end)
	addToggleCommand({ "locksticky", "sticklock", "persistlock" }, "locksticky [on/off]", "Toggle sticky target lock.", function()
		return Settings.TargetLockSticky
	end, function(value)
		Settings.TargetLockSticky = value
	end)
	addToggleCommand({ "locknotify", "targetnotify", "lockalerts" }, "locknotify [on/off]", "Toggle target lock notifications.", function()
		return targetLockNotifyEnabled
	end, function(value)
		targetLockNotifyEnabled = value
	end)
	addToggleCommand({ "panelads", "hidepanelads", "adsmenu" }, "panelads [on/off]", "Hide panel while ADS.", function()
		return panelAutoHideOnAim
	end, function(value)
		panelAutoHideOnAim = value
	end)
	addToggleCommand({ "infjump", "infinitejump", "superjump" }, "infjump [on/off]", "Toggle infinite jump.", function()
		return infiniteJumpEnabled
	end, function(value)
		infiniteJumpEnabled = value
	end)
	addToggleCommand({ "bunnyhop", "bhop", "autohop" }, "bunnyhop [on/off]", "Toggle bunny hop.", function()
		return bunnyHopEnabled
	end, function(value)
		bunnyHopEnabled = value
	end)
	addToggleCommand({ "antiafk", "antikick", "idleprotect" }, "antiafk [on/off]", "Toggle anti-AFK.", function()
		return antiAFKEnabled
	end, function(value)
		antiAFKEnabled = value
	end)
	addToggleCommand({ "zoomunlock", "unlockzoom", "freezoom" }, "zoomunlock [on/off]", "Toggle zoom unlock.", function()
		return zoomUnlockEnabled
	end, function(value)
		zoomUnlockEnabled = value
		applyZoomUnlockState()
	end)
	addToggleCommand({ "blur", "blurfx", "frost" }, "blur [on/off]", "Toggle blur effect.", function()
		return blurFXEnabled
	end, function(value)
		blurFXEnabled = value
		blurEffect.Enabled = value
	end)
	addToggleCommand({ "bloom", "bloomfx", "glow" }, "bloom [on/off]", "Toggle bloom effect.", function()
		return bloomFXEnabled
	end, function(value)
		bloomFXEnabled = value
		bloomEffect.Enabled = value
	end)
	addToggleCommand({ "nightvision", "nv", "greenvision" }, "nightvision [on/off]", "Toggle night vision.", function()
		return nightVisionEnabled
	end, function(value)
		nightVisionEnabled = value
		nightVisionEffect.Enabled = value
	end)
	addToggleCommand({ "monochrome", "mono", "bw" }, "monochrome [on/off]", "Toggle monochrome.", function()
		return monochromeEnabled
	end, function(value)
		monochromeEnabled = value
		monochromeEffect.Enabled = value
	end)
	addToggleCommand({ "saturation", "sat", "saturationplus" }, "saturation [on/off]", "Toggle saturation boost.", function()
		return saturationBoostEnabled
	end, function(value)
		saturationBoostEnabled = value
		saturationEffect.Enabled = value
	end)
	addToggleCommand({ "cinematicbars", "bars", "moviebars" }, "cinematicbars [on/off]", "Toggle cinematic bars.", function()
		return cinematicBarsEnabled
	end, function(value)
		cinematicBarsEnabled = value
		cinematicTop.Visible = value
		cinematicBottom.Visible = value
	end)
	addToggleCommand({ "mousehalo", "halo", "cursorring" }, "mousehalo [on/off]", "Toggle mouse halo.", function()
		return mouseHaloEnabled
	end, function(value)
		mouseHaloEnabled = value
		mouseHalo.Visible = value
	end)
	addToggleCommand({ "crosshairspin", "reticlespin", "xspin" }, "crosshairspin [on/off]", "Toggle crosshair spin.", function()
		return crosshairSpinEnabled
	end, function(value)
		crosshairSpinEnabled = value
		if not value then
			crosshairHolder.Rotation = 0
		end
	end)
	addToggleCommand({ "watermarkpulse", "pulsemark", "logopulse" }, "watermarkpulse [on/off]", "Toggle watermark pulse.", function()
		return watermarkPulseEnabled
	end, function(value)
		watermarkPulseEnabled = value
		if not value then
			updateTopRightLayout()
		end
	end)
	addToggleCommand({ "radarspin", "mapspin", "rotateradar" }, "radarspin [on/off]", "Toggle radar spin.", function()
		return radarSpinEnabled
	end, function(value)
		radarSpinEnabled = value
		if not value then
			radarFrame.Rotation = 0
		end
	end)
	addToggleCommand({ "toolhud", "toolname", "weaponhud" }, "toolhud [on/off]", "Toggle tool HUD.", function()
		return toolHudEnabled
	end, function(value)
		toolHudEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "directionhud", "compass", "dirhud" }, "directionhud [on/off]", "Toggle direction HUD.", function()
		return directionHudEnabled
	end, function(value)
		directionHudEnabled = value
		updateTopRightLayout()
	end)
	addToggleCommand({ "autoequip", "equipauto", "autotool" }, "autoequip [on/off]", "Toggle auto-equip.", function()
		return autoEquipToolEnabled
	end, function(value)
		autoEquipToolEnabled = value
	end)

	addNumberCommand({ "espdistance", "esprange", "highlightdistance" }, "espdistance <500-10000>", "Set highlight ESP distance.", function()
		return Settings.MaxESPDistance
	end, function(value)
		Settings.MaxESPDistance = value
	end, 500, 10000, 500, formatRangeValue)
	addNumberCommand({ "boxrange", "boxdistance", "2dboxrange" }, "boxrange <500-10000>", "Set 2D box ESP range.", function()
		return Settings.BoxESPDistance
	end, function(value)
		Settings.BoxESPDistance = value
	end, 500, 10000, 250, formatRangeValue)
	addNumberCommand({ "aimdistance", "aimrange", "lockdistance" }, "aimdistance <500-10000>", "Set aim distance.", function()
		return Settings.MaxAimlockDistance
	end, function(value)
		Settings.MaxAimlockDistance = value
	end, 500, 10000, 500, formatRangeValue)
	addNumberCommand({ "fovradius", "fovsize", "aimfov" }, "fovradius <40-700>", "Set FOV radius.", function()
		return Settings.FOVRadius
	end, function(value)
		Settings.FOVRadius = value
	end, 40, 700, 10, formatRangeValue)
	addNumberCommand({ "softsmooth", "softsmoothing", "smoothness" }, "softsmooth <0.02-1.00>", "Set softlock smoothness.", function()
		return Settings.SoftLockSmoothing
	end, function(value)
		Settings.SoftLockSmoothing = value
	end, 0.02, 1, 0.01, formatSmoothingValue)
	addNumberCommand({ "bonethickness", "bonesize", "skeletonthick" }, "bonethickness <1-4>", "Set bone thickness.", function()
		return Settings.BoneThickness
	end, function(value)
		Settings.BoneThickness = value
	end, 1, 4, 1, formatRangeValue)
	addNumberCommand({ "tracerthickness", "tracerthick", "linethick" }, "tracerthickness <1-3>", "Set tracer thickness.", function()
		return Settings.TracerThickness
	end, function(value)
		Settings.TracerThickness = value
	end, 1, 3, 1, formatRangeValue)
	addNumberCommand({ "radarrange", "radardistance", "maprange" }, "radarrange <100-5000>", "Set radar range.", function()
		return radarConfig.Range
	end, function(value)
		radarConfig.Range = value
	end, 100, 5000, 50, formatRangeValue)
	addNumberCommand({ "radarsize", "mapsize", "radarscale" }, "radarsize <180-300>", "Set radar size.", function()
		return radarConfig.Size
	end, function(value)
		radarConfig.Size = value
		radarFrame.Size = UDim2.fromOffset(radarConfig.Size, radarConfig.Size)
		radarRadius = radarConfig.Size * 0.5 - 16
		updateTopRightLayout()
		updateRadar()
	end, 180, 300, 20, formatRangeValue)
	addNumberCommand({ "spinspeed", "spinrate", "rpm" }, "spinspeed <360-50000>", "Set spin speed.", function()
		return spinSpeed
	end, function(value)
		spinSpeed = value
	end, 360, 50000, 10, formatRangeValue)
	addNumberCommand({ "clonegap", "followgap", "cloneoffset" }, "clonegap <4-16>", "Set follower clone gap.", function()
		return followerCloneGap
	end, function(value)
		followerCloneGap = value
	end, 4, 16, 1, formatRangeValue)
	addNumberCommand({ "walkspeed", "ws", "speed" }, "walkspeed <16-200>", "Set walkspeed override.", function()
		return walkSpeedOverride or defaultWalkSpeed
	end, function(value)
		walkSpeedOverride = value
		applyWalkSpeedSetting()
	end, 16, 200, 1, formatRangeValue)
	addNumberCommand({ "jumppower", "jp", "jump" }, "jumppower <50-200>", "Set jump power override.", function()
		return jumpPowerOverride or defaultJumpPower
	end, function(value)
		jumpPowerOverride = value
		applyJumpPowerSetting()
	end, 50, 200, 1, formatRangeValue)
	addNumberCommand({ "camfov", "camerafov", "viewfov" }, "camfov <60-120>", "Set camera FOV override.", function()
		return cameraFOVOverride or defaultCameraFOV
	end, function(value)
		cameraFOVOverride = value
		applyCameraFOVSetting()
	end, 60, 120, 1, formatRangeValue)
	addNumberCommand({ "panelalpha", "paneltransparency", "panelopacity" }, "panelalpha <0.08-0.50>", "Set panel transparency.", function()
		return Theme.PanelTransparency
	end, function(value)
		Theme.PanelTransparency = value
		updateStyle()
	end, 0.08, 0.5, 0.01, formatSmoothingValue)
	addNumberCommand({ "buttonalpha", "buttontransparency", "buttonopacity" }, "buttonalpha <0.00-0.45>", "Set button transparency.", function()
		return Theme.ButtonTransparency
	end, function(value)
		Theme.ButtonTransparency = value
		updateStyle()
	end, 0, 0.45, 0.01, formatSmoothingValue)
	addNumberCommand({ "watermarkalpha", "markalpha", "logoalpha" }, "watermarkalpha <0.20-0.65>", "Set watermark transparency.", function()
		return Theme.WatermarkTransparency
	end, function(value)
		Theme.WatermarkTransparency = value
		updateStyle()
	end, 0.2, 0.65, 0.01, formatSmoothingValue)
	]]

	table.clear(Cmd.Registry)
	table.clear(Cmd.Entries)
	Cmd.AliasCount = 0

	local function getUtilityRoot()
		return getLocalRoot()
	end

	local function getUtilityHumanoid()
		return getHumanoid(LocalPlayer.Character)
	end

	local function setNoclipEnabled(enabled)
		CmdUtility.Noclip = enabled
		if not enabled then
			for part, originalValue in pairs(CmdUtility.OriginalCollision) do
				if part and part.Parent then
					part.CanCollide = originalValue
				end
			end
			table.clear(CmdUtility.OriginalCollision)
		end
	end

	local function setFloatEnabled(enabled)
		CmdUtility.Float = enabled
		if not enabled then
			if CmdUtility.FloatPart then
				CmdUtility.FloatPart:Destroy()
				CmdUtility.FloatPart = nil
			end
			return
		end
		if not CmdUtility.FloatPart or not CmdUtility.FloatPart.Parent then
			CmdUtility.FloatPart = create("Part", {
				Name = "JuliaCommandFloatPad",
				Anchored = true,
				CanCollide = true,
				CanTouch = false,
				CanQuery = false,
				Size = Vector3.new(7, 0.35, 7),
				Transparency = 0.25,
				Color = Theme.CurrentAccent,
				Material = Enum.Material.Neon,
				Parent = Workspace,
			})
		end
	end

	local function setFreezeEnabled(enabled)
		local root = getUtilityRoot()
		if not root then
			return false
		end
		CmdUtility.Frozen = enabled
		root.Anchored = enabled
		return true
	end

	local function listTools()
		local names = {}
		local character = LocalPlayer.Character
		local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
		if character then
			for _, item in ipairs(character:GetChildren()) do
				if item:IsA("Tool") then
					table.insert(names, item.Name)
				end
			end
		end
		if backpack then
			for _, item in ipairs(backpack:GetChildren()) do
				if item:IsA("Tool") then
					table.insert(names, item.Name)
				end
			end
		end
		table.sort(names)
		return #names > 0 and table.concat(names, ", ") or "no tools found"
	end

	local function findTool(query)
		local wanted = normalizeCommandToken(query)
		if wanted == "" then
			return nil
		end
		local containers = { LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }
		for _, container in ipairs(containers) do
			if container then
				for _, item in ipairs(container:GetChildren()) do
					if item:IsA("Tool") and normalizeCommandToken(item.Name):find(wanted, 1, true) then
						return item
					end
				end
			end
		end
		return nil
	end

	registerCommand({ "help", "?", "cmdhelp" }, "help [command]", "Show utility console help.", function(args)
		local topic = normalizeCommandToken(args[2])
		if topic ~= "" then
			local entry = Cmd.Registry[topic]
			if not entry then
				return false, "unknown command"
			end
			return true, entry.Usage .. " - " .. entry.Description
		end
		appendConsoleLine("Core: help commands clear history echo")
		appendConsoleLine("Movement: noclip clip float unfloat freeze unfreeze nosit")
		appendConsoleLine("Position: savepos loadpos coords faceup")
		appendConsoleLine("Tools: tools equip unequip")
		appendConsoleLine("Info: serverinfo charinfo keytime")
		return true, tostring(#Cmd.Entries) .. " utility commands ready."
	end)

	registerCommand({ "commands", "cmds", "list" }, "commands", "List command names.", function()
		local primary = {}
		for _, entry in ipairs(Cmd.Entries) do
			table.insert(primary, entry.Names[1])
		end
		table.sort(primary)
		appendConsoleLine(table.concat(primary, ", "))
		return true, tostring(#primary) .. " commands."
	end)

	registerCommand({ "clear", "cls" }, "clear", "Clear console output.", function()
		table.clear(Cmd.OutputLines)
		Cmd.OutputLabel.Text = ""
		return true, "cleared."
	end)

	registerCommand({ "history", "recent" }, "history", "Show recent commands.", function()
		if #Cmd.History == 0 then
			return true, "no history yet."
		end
		for index = math.max(1, #Cmd.History - 5), #Cmd.History do
			appendConsoleLine(Cmd.History[index])
		end
		return true, "recent commands shown."
	end)

	registerCommand({ "echo", "print" }, "echo <text>", "Print text in the console.", function(args)
		local message = table.concat(args, " ", 2)
		return message ~= "" and true or false, message ~= "" and message or "text required"
	end)

	registerCommand({ "noclip", "nc" }, "noclip [on/off]", "Walk through local collision.", function(args)
		local nextValue = parseToggleValue(args[2], CmdUtility.Noclip)
		if nextValue == nil then
			return false, "use on/off"
		end
		setNoclipEnabled(nextValue)
		return true, "noclip: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "clip", "unnoclip" }, "clip", "Turn noclip off.", function()
		setNoclipEnabled(false)
		return true, "noclip: OFF"
	end)

	registerCommand({ "float", "platform" }, "float [on/off]", "Toggle a small local platform under you.", function(args)
		local nextValue = parseToggleValue(args[2], CmdUtility.Float)
		if nextValue == nil then
			return false, "use on/off"
		end
		setFloatEnabled(nextValue)
		return true, "float: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "unfloat", "nofloat" }, "unfloat", "Remove the float platform.", function()
		setFloatEnabled(false)
		return true, "float: OFF"
	end)

	registerCommand({ "freeze", "anchor" }, "freeze", "Anchor your root part.", function()
		local ok = setFreezeEnabled(true)
		return ok, ok and "frozen." or "character not ready"
	end)

	registerCommand({ "unfreeze", "unanchor" }, "unfreeze", "Unanchor your root part.", function()
		local ok = setFreezeEnabled(false)
		return ok, ok and "unfrozen." or "character not ready"
	end)

	registerCommand({ "nosit", "antisit" }, "nosit [on/off]", "Prevent your humanoid from sitting.", function(args)
		local nextValue = parseToggleValue(args[2], CmdUtility.NoSit)
		if nextValue == nil then
			return false, "use on/off"
		end
		CmdUtility.NoSit = nextValue
		return true, "nosit: " .. (nextValue and "ON" or "OFF")
	end)

	registerCommand({ "savepos", "markpos" }, "savepos", "Save your current position.", function()
		local root = getUtilityRoot()
		if not root then
			return false, "character not ready"
		end
		CmdUtility.SavedCFrame = root.CFrame
		return true, "position saved."
	end)

	registerCommand({ "loadpos", "backpos", "returnpos" }, "loadpos", "Return to saved position.", function()
		local root = getUtilityRoot()
		if not root or not CmdUtility.SavedCFrame then
			return false, "no saved position"
		end
		root.CFrame = CmdUtility.SavedCFrame
		return true, "returned to saved position."
	end)

	registerCommand({ "coords", "pos", "whereami" }, "coords", "Show your current coordinates.", function()
		local root = getUtilityRoot()
		if not root then
			return false, "character not ready"
		end
		local p = root.Position
		return true, string.format("X %.1f | Y %.1f | Z %.1f", p.X, p.Y, p.Z)
	end)

	registerCommand({ "faceup", "upright" }, "faceup", "Set your root upright.", function()
		local root = getUtilityRoot()
		if not root then
			return false, "character not ready"
		end
		root.CFrame = CFrame.new(root.Position)
		return true, "upright."
	end)

	registerCommand({ "sit" }, "sit", "Sit your humanoid.", function()
		local humanoid = getUtilityHumanoid()
		if not humanoid then
			return false, "character not ready"
		end
		humanoid.Sit = true
		return true, "sitting."
	end)

	registerCommand({ "unsit", "stand" }, "unsit", "Stand up.", function()
		local humanoid = getUtilityHumanoid()
		if not humanoid then
			return false, "character not ready"
		end
		humanoid.Sit = false
		humanoid:ChangeState(Enum.HumanoidStateType.Running)
		return true, "standing."
	end)

	registerCommand({ "tools", "toolbox" }, "tools", "List local tools.", function()
		return true, listTools()
	end)

	registerCommand({ "equip", "equiptool" }, "equip <tool>", "Equip a tool by partial name.", function(args)
		local tool = findTool(table.concat(args, " ", 2))
		local humanoid = getUtilityHumanoid()
		if not tool or not humanoid then
			return false, "tool or character not found"
		end
		humanoid:EquipTool(tool)
		return true, "equipped: " .. tool.Name
	end)

	registerCommand({ "unequip", "sheathe" }, "unequip", "Unequip current tools.", function()
		local humanoid = getUtilityHumanoid()
		if not humanoid then
			return false, "character not ready"
		end
		humanoid:UnequipTools()
		return true, "tools unequipped."
	end)

	registerCommand({ "serverinfo", "jobinfo" }, "serverinfo", "Show place and server info.", function()
		return true, "place " .. tostring(game.PlaceId) .. " | players " .. tostring(#Players:GetPlayers()) .. " | job " .. tostring(game.JobId)
	end)

	registerCommand({ "charinfo", "riginfo" }, "charinfo", "Show character health and rig.", function()
		local humanoid = getUtilityHumanoid()
		if not humanoid then
			return false, "character not ready"
		end
		return true, "health " .. math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth) .. " | rig " .. humanoid.RigType.Name
	end)

	registerCommand({ "keytime", "ktl" }, "keytime", "Show key time left.", function()
		return true, getKeyTimeText()
	end)

	local function executeCommand(text)
		local cleaned = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if cleaned == "" then
			return
		end
		if cleaned:sub(1, 1) == ";" or cleaned:sub(1, 1) == ":" or cleaned:sub(1, 1) == "." then
			cleaned = cleaned:sub(2)
		end
		local args = splitCommandWords(cleaned)
		local commandName = normalizeCommandToken(args[1])
		if commandName == "" then
			return
		end
		table.insert(Cmd.History, cleaned)
		appendConsoleLine("> " .. cleaned)
		local entry = Cmd.Registry[commandName]
		if not entry then
			appendConsoleLine("unknown command. type help.")
			return
		end
		local ok, success, message = pcall(entry.Handler, args)
		if not ok then
			appendConsoleLine("error: " .. tostring(success))
			return
		end
		if success then
			appendConsoleLine(tostring(message or "ok"))
		else
			appendConsoleLine("fail: " .. tostring(message or "command rejected"))
		end
	end

	local function submitCommandInput()
		local text = Cmd.InputBox and Cmd.InputBox.Text or ""
		if tostring(text):gsub("%s+", "") == "" then
			return
		end
		Cmd.InputBox.Text = ""
		executeCommand(text)
		task.defer(function()
			if Cmd.Visible and Cmd.InputBox and Cmd.InputBox.Parent then
				Cmd.InputBox:CaptureFocus()
			end
		end)
	end

	connect(Cmd.Launcher.MouseButton1Click, function()
		setConsoleVisible(not Cmd.Visible)
	end)
	connect(Cmd.CloseButton.MouseButton1Click, function()
		setConsoleVisible(false)
	end)
	connect(commandDragHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Cmd.Dragging = true
			Cmd.DragStart = input.Position
			Cmd.StartPosition = Cmd.Frame.Position
			Cmd.DragInput = input
		end
	end)
	connect(commandDragHandle.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			Cmd.DragInput = input
		end
	end)
	connect(UserInputService.InputChanged, function(input)
		if not Cmd.Dragging or input ~= Cmd.DragInput or not Cmd.DragStart or not Cmd.StartPosition then
			return
		end
		local delta = input.Position - Cmd.DragStart
		Cmd.Frame.Position = UDim2.new(
			Cmd.StartPosition.X.Scale,
			math.floor(Cmd.StartPosition.X.Offset + delta.X),
			Cmd.StartPosition.Y.Scale,
			math.floor(Cmd.StartPosition.Y.Offset + delta.Y)
		)
	end)
	connect(Cmd.InputBox.FocusLost, function(enterPressed)
		if enterPressed then
			submitCommandInput()
		end
	end)
	connect(UserInputService.InputBegan, function(input)
		if not Cmd.Visible or not Cmd.InputBox or not Cmd.InputBox:IsFocused() then
			return
		end
		if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
			submitCommandInput()
		end
	end)

	appendConsoleLine("Julia command console ready.")
	appendConsoleLine("Type ;help for categories.")
	Cmd.HintLabel.Text = tostring(#Cmd.Entries) .. " commands / " .. tostring(Cmd.AliasCount) .. " aliases"
	updateStyle()
	end

	initCommandConsole()

	updateLockStatusLabel()
	updateTopRightLayout()

	connect(UserInputService.InputBegan, function(input, gameProcessed)
		if not JuliaRunning then
			return
		end
		if waitingForLockKey then
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
				waitingForLockKey = false
				if input.KeyCode ~= Enum.KeyCode.Escape then
					Settings.TargetLockKey = input.KeyCode
				end
				applyLockKeyButtonText()
			end
			return
		end
		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = true
			if panelAutoHideOnAim and panel.Visible then
				panel.Visible = false
				panelAutoHiddenByAim = true
			end
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Settings.TargetLockKey then
			toggleTargetLock()
			return
		end
		if gameProcessed then
			return
		elseif input.KeyCode == Settings.ToggleGuiKey then
			panel.Visible = not panel.Visible
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		if not JuliaRunning then
			return
		end
		if input.UserInputType == Settings.CamlockHoldKey then
			State.HoldingCamlock = false
			if panelAutoHiddenByAim then
				panel.Visible = true
				panelAutoHiddenByAim = false
			end
		end
	end)

	connect(UserInputService.JumpRequest, function()
		if not JuliaRunning or not infiniteJumpEnabled then
			return
		end
		local humanoid = getHumanoid(LocalPlayer.Character)
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	connect(LocalPlayer.Idled, function()
		if not antiAFKEnabled then
			return
		end
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end)

	connect(Players.PlayerRemoving, function(player)
		if player == State.LockedTargetPlayer then
			clearLockedTarget(true)
		end
		removeESP(player)
		removeRadarBlip(player)
	end)

	connect(LocalPlayer.CharacterAdded, function()
		task.wait(0.5)
		CmdUtility.Frozen = false
		table.clear(CmdUtility.OriginalCollision)
		captureMovementDefaults()
		if zoomUnlockEnabled then
			LocalPlayer.CameraMinZoomDistance = 0.5
			LocalPlayer.CameraMaxZoomDistance = 1000
		end
		local camera = Workspace.CurrentCamera
		if camera and cameraFOVOverride then
			camera.FieldOfView = cameraFOVOverride
		end
		if followerCloneEnabled then
			destroyFollowerClone()
			updateFollowerClone(os.clock())
		end
	end)

	local function setupPlayer(player)
		if player == LocalPlayer then
			return
		end
		getRadarBlip(player)
		if player.Character then
			createESP(player, screenGui)
		end
		connect(player.CharacterAdded, function()
			if not JuliaRunning then
				return
			end
			task.wait(0.5)
			if JuliaRunning then
				createESP(player, screenGui)
			end
		end)
	end

	connect(Players.PlayerAdded, function(player)
		setupPlayer(player)
		checkFriendNotifier(player)
		connect(player:GetAttributeChangedSignal("JuliaHubUser"), function()
			checkFriendNotifier(player)
		end)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		setupPlayer(player)
		if player ~= LocalPlayer then
			connect(player:GetAttributeChangedSignal("JuliaHubUser"), function()
				checkFriendNotifier(player)
			end)
		end
	end

	connect(RunService.RenderStepped, function(deltaTime)
		if not JuliaRunning then
			return
		end

		local now = os.clock()
		fpsFrameCount += 1
		if now - State.LastCounterUpdate >= Settings.CounterUpdateRate then
			State.LastCounterUpdate = now
			validateLockedTarget()
			keyTimerLabel.Text = getKeyTimeText()
			watermark.Text = hudClockEnabled and ("Julia Hub | " .. os.date("%H:%M:%S")) or "Julia Hub"
			if fpsEnabled then
				fpsValue = math.floor(fpsFrameCount / math.max(now - fpsLastTime, 0.001))
				fpsLabel.Text = "FPS: " .. tostring(fpsValue)
			end
			fpsFrameCount = 0
			fpsLastTime = now
			if pingEnabled then
				local pingText = "--"
				pcall(function()
					pingText = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
				end)
				pingLabel.Text = "Ping: " .. pingText
			end
			if speedHudEnabled then
				local localRoot = getLocalRoot()
				local speedValue = 0
				if localRoot then
					local velocity = localRoot.AssemblyLinearVelocity
					speedValue = math.floor(Vector3.new(velocity.X, 0, velocity.Z).Magnitude + 0.5)
				end
				speedLabel.Text = "Speed: " .. tostring(speedValue)
			end
			if targetCounterEnabled then
				local targetCount = 0
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and isEnemy(player) then
						local root = getRoot(player)
						if root and withinDistance(root, Settings.MaxESPDistance) then
							targetCount += 1
						end
					end
				end
				targetCountLabel.Text = "Targets: " .. tostring(targetCount)
			end
			if toolHudEnabled or autoEquipToolEnabled then
				local character = LocalPlayer.Character
				local counterHumanoid = getHumanoid(character)
				local equippedTool = character and character:FindFirstChildOfClass("Tool")
				local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
				local backpackTool = backpack and backpack:FindFirstChildOfClass("Tool")
				if autoEquipToolEnabled and not equippedTool and backpackTool and counterHumanoid then
					counterHumanoid:EquipTool(backpackTool)
					equippedTool = character and character:FindFirstChildOfClass("Tool")
				end
				if toolHudEnabled then
					toolLabel.Text = "Tool: " .. ((equippedTool and equippedTool.Name) or "Hands")
				end
			end
			if directionHudEnabled then
				directionLabel.Text = "Dir: " .. getCompassDirection()
			end
		end

		State.Camera = Workspace.CurrentCamera
		local currentCamera = State.Camera
		local localHumanoid = getHumanoid(LocalPlayer.Character)
		local mousePosition = UserInputService:GetMouseLocation()

		if CmdUtility.Noclip and now - (CmdUtility.LastNoclipUpdate or 0) >= 0.08 then
			CmdUtility.LastNoclipUpdate = now
			local character = LocalPlayer.Character
			if character then
				for _, descendant in ipairs(character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if CmdUtility.OriginalCollision[descendant] == nil then
							CmdUtility.OriginalCollision[descendant] = descendant.CanCollide
						end
						descendant.CanCollide = false
					end
				end
			end
		end
		if CmdUtility.NoSit and localHumanoid and localHumanoid.Sit then
			localHumanoid.Sit = false
			localHumanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
		if CmdUtility.Float then
			local root = getLocalRoot()
			if root then
				if not CmdUtility.FloatPart or not CmdUtility.FloatPart.Parent then
					CmdUtility.FloatPart = create("Part", {
						Name = "JuliaCommandFloatPad",
						Anchored = true,
						CanCollide = true,
						CanTouch = false,
						CanQuery = false,
						Size = Vector3.new(7, 0.35, 7),
						Transparency = 0.25,
						Color = Theme.CurrentAccent,
						Material = Enum.Material.Neon,
						Parent = Workspace,
					})
				end
				if CmdUtility.FloatPart then
					CmdUtility.FloatPart.Color = Theme.CurrentAccent
					CmdUtility.FloatPart.CFrame = CFrame.new(root.Position - Vector3.new(0, 3.35, 0))
				end
			end
		end

		if currentCamera and cameraFOVOverride and math.abs(currentCamera.FieldOfView - cameraFOVOverride) > 0.05 then
			currentCamera.FieldOfView = cameraFOVOverride
		end
		if localHumanoid then
			if walkSpeedOverride and math.abs(localHumanoid.WalkSpeed - walkSpeedOverride) > 0.05 then
				localHumanoid.WalkSpeed = walkSpeedOverride
			end
			if jumpPowerOverride and math.abs(localHumanoid.JumpPower - jumpPowerOverride) > 0.05 then
				localHumanoid.JumpPower = jumpPowerOverride
			end
			if bunnyHopEnabled and localHumanoid.MoveDirection.Magnitude > 0.05 and localHumanoid.FloorMaterial ~= Enum.Material.Air then
				localHumanoid.Jump = true
			end
		end

		if rainbowAccentEnabled and now - lastRainbowAccentUpdate >= (Settings.LowEndMode and 0.14 or 0.08) then
			lastRainbowAccentUpdate = now
			local hue = (now * 0.12) % 1
			Theme.CurrentAccent = Color3.fromHSV(hue, 0.8, 1)
			Theme.GradientA = Theme.CurrentAccent
			Theme.GradientB = Color3.fromHSV((hue + 0.12) % 1, 0.75, 0.9)
			updateStyle()
		end

		if now - State.LastESPUpdate >= Settings.ESPUpdateRate then
			State.LastESPUpdate = now
			updateESP()
		end

		if (Settings.BoneESPEnabled or Settings.TracersEnabled) and now - State.LastLineESPUpdate >= Settings.LineESPUpdateRate then
			State.LastLineESPUpdate = now
			updateLineESP()
		end

		radarElapsed += deltaTime
		if radarElapsed >= radarConfig.UpdateRate then
			radarElapsed = 0
			updateRadar()
		end

		if Settings.ShowFOV then
			if now - State.LastFOVUpdate >= Settings.FOVUpdateRate then
				State.LastFOVUpdate = now
				local visualFOVRadius = Settings.FOVRadius
				if fovPulseEnabled then
					visualFOVRadius = math.max(40, Settings.FOVRadius * (1 + 0.08 * math.sin(now * 4)))
				end
				fovCircle.Size = UDim2.fromOffset(visualFOVRadius * 2, visualFOVRadius * 2)
				fovCircle.Position = UDim2.fromOffset(mousePosition.X, mousePosition.Y)
			end
			if not fovCircle.Visible then
				fovCircle.Visible = true
			end
		else
			if fovCircle.Visible then
				fovCircle.Visible = false
			end
		end

		if mouseHaloEnabled then
			mouseHalo.Visible = true
			local haloSize = 26 + math.floor((math.sin(now * 5) * 0.5 + 0.5) * 8)
			mouseHalo.Size = UDim2.fromOffset(haloSize, haloSize)
			mouseHalo.Position = UDim2.fromOffset(mousePosition.X, mousePosition.Y)
		elseif mouseHalo.Visible then
			mouseHalo.Visible = false
		end

		if crosshairSpinEnabled then
			crosshairHolder.Rotation = (crosshairHolder.Rotation + (deltaTime * 110)) % 360
		elseif crosshairHolder.Rotation ~= 0 then
			crosshairHolder.Rotation = 0
		end

		if watermarkPulseEnabled then
			local baseWidth = hudClockEnabled and 220 or 160
			local pulse = math.floor((math.sin(now * 4) * 0.5 + 0.5) * 14)
			watermark.Size = UDim2.fromOffset(baseWidth + pulse, 32)
		end

		if radarSpinEnabled then
			radarFrame.Rotation = (now * 28) % 360
		elseif radarFrame.Rotation ~= 0 then
			radarFrame.Rotation = 0
		end

		if Settings.CamlockEnabled and State.HoldingCamlock then
			local targetPart = getClosestTarget()
			if targetPart then
				aimCameraAt(targetPart)
			end
		end

		if spinEnabled and isSpinRigReady() then
			local spinRoot = getLocalSpinRoot()
			if spinRoot then
				local effectiveSpinSpeed = spinSpeed
				if spinPulseEnabled then
					effectiveSpinSpeed = spinSpeed * (0.7 + 0.3 * (0.5 + 0.5 * math.sin(now * 4)))
				end
				spinRoot.CFrame = spinRoot.CFrame * CFrame.Angles(0, math.rad(effectiveSpinSpeed * deltaTime * spinDirection), 0)
			end
		end

		if followerCloneEnabled or followerCloneModel then
			updateFollowerClone(now)
		end
	end)

	screenGui.Destroying:Connect(function()
		destroyFollowerClone()
		if CmdUtility.Frozen then
			local root = getLocalRoot()
			if root then
				root.Anchored = false
			end
			CmdUtility.Frozen = false
		end
		CmdUtility.Noclip = false
		for part, originalValue in pairs(CmdUtility.OriginalCollision) do
			if part and part.Parent then
				part.CanCollide = originalValue
			end
		end
		table.clear(CmdUtility.OriginalCollision)
		if CmdUtility.FloatPart then
			CmdUtility.FloatPart:Destroy()
			CmdUtility.FloatPart = nil
		end
		LocalPlayer.CameraMinZoomDistance = defaultMinZoom
		LocalPlayer.CameraMaxZoomDistance = defaultMaxZoom
		local camera = Workspace.CurrentCamera
		if camera then
			camera.FieldOfView = defaultCameraFOV
		end
		Lighting.ClockTime = originalLighting.ClockTime
		Lighting.Brightness = originalLighting.Brightness
		Lighting.Ambient = originalLighting.Ambient
		Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.FogStart = originalLighting.FogStart
		Lighting.FogColor = originalLighting.FogColor
		mouseHalo.Visible = false
		cinematicTop.Visible = false
		cinematicBottom.Visible = false
		radarFrame.Rotation = 0
		crosshairHolder.Rotation = 0
		pcall(function()
			blurEffect:Destroy()
		end)
		pcall(function()
			bloomEffect:Destroy()
		end)
		pcall(function()
			nightVisionEffect:Destroy()
		end)
		pcall(function()
			monochromeEffect:Destroy()
		end)
		pcall(function()
			saturationEffect:Destroy()
		end)
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
