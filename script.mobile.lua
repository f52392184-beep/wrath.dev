local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local element = {}
element.__index = element

local localPlayer = players.LocalPlayer

local val = {
  BG = Color3.fromRGB(11, 11, 15), Sidebar = Color3.fromRGB(15, 15, 21), Card = Color3.fromRGB(20, 20, 28), CardHover = Color3.fromRGB(26, 26, 36), CardTop = Color3.fromRGB(32, 32, 44), Purple = Color3.fromRGB(128, 58, 255), PurpleDim = Color3.fromRGB(80, 35, 160), PurpleDark = Color3.fromRGB(20, 10, 44), PurpleGlow = Color3.fromRGB(168, 100, 255), TextPrimary = Color3.fromRGB(238, 238, 244), TextSecond = Color3.fromRGB(148, 148, 168), TextMuted = Color3.fromRGB(72, 72, 92), Divider = Color3.fromRGB(28, 28, 40), Border = Color3.fromRGB(38, 38, 54), BorderAccent = Color3.fromRGB(88, 48, 178), Green = Color3.fromRGB(50, 210, 100), Red = Color3.fromRGB(230, 60, 60), PillOff = Color3.fromRGB(32, 32, 46), ScrollBar = Color3.fromRGB(55, 30, 115), NotifBG = Color3.fromRGB(15, 15, 21), }

local val2 = { Bold = Enum.Font.Code, Medium = Enum.Font.Code }

local function helper(val6, val3, val4, val5, val7)
  local create = tweenService:Create(val6, TweenInfo.new(
    val4 or 0.2, val5 or Enum.EasingStyle.Quad, val7 or Enum.EasingDirection.Out
  ), val3)

  create:Play()
  return create
end

local createElement

local function helper2(val9, val8, val10)
  return createElement("UIStroke", { Color = val9 or val.Border, Thickness = val8 or 1 }, val10)
end

local function helper3(val11, val12)
  return createElement("UICorner", { CornerRadius = UDim.new(0, val11 or 6) }, val12)
end

function createElement(val13, val14, val15)
  local instance = Instance.new(val13)

  if val14 then
    for key, value in pairs(val14) do
      instance[key] = value
    end
  end

  if val15 then
    instance.Parent = val15
  end

  return instance
end

local function helper4(val19, val16, val17, val18, val20)
  return createElement("UIPadding", {
    PaddingLeft = UDim.new(0, val19 or 0), PaddingRight = UDim.new(0, val16 or 0), PaddingTop = UDim.new(0, val17 or 0), PaddingBottom = UDim.new(0, val18 or 0), }, val20)
end

function element:Window(p19, p20)
  local element2 = { _tabs = {}, _activeTab = nil }
  local findFirstChild = localPlayer.PlayerGui:FindFirstChild("DBSB_UI_" .. p19:gsub("%s", ""))

  if findFirstChild then
    findFirstChild:Destroy()
  end

  local val21 = createElement("ScreenGui", {
    Name = "DBSB_UI_" .. p19:gsub("%s", ""), ResetOnSpawn = false, DisplayOrder = 9999, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, }, localPlayer.PlayerGui)

  element2._sg = val21

  local camera = workspace.CurrentCamera
  local initialViewport = camera and camera.ViewportSize or Vector2.new(800, 600)
  local compactMode = userInputService.TouchEnabled or initialViewport.X < 640
  local sidebarWidth = compactMode and 126 or 196
  local initialWidth = math.max(240, math.min(680, initialViewport.X - (compactMode and 16 or 40)))
  local initialHeight = math.max(220, math.min(500, initialViewport.Y - (compactMode and 40 or 80)))

  local parent = createElement("Frame", {
    Size = UDim2.fromOffset(initialWidth, initialHeight),
    Position = UDim2.new(0.5, -initialWidth / 2, 0.5, -initialHeight / 2),
    BackgroundColor3 = val.BG, BorderSizePixel = 0, }, val21)

  local element3 = helper2(val.Border, 1, parent)
  element2._main = parent

  task.spawn(function()
    local total = 0

    while parent.Parent do
      total = total + 0.016
      element3.Color = val.Border:Lerp(val.BorderAccent, (math.sin(total * 1.1) + 1) / 2 * 0.6)
      task.wait(0.016)
    end
  end)

  local val22 = createElement("Frame", {
    Size = UDim2.new(1, -sidebarWidth, 1, 0), Position = UDim2.new(0, sidebarWidth, 0, 0), BackgroundColor3 = val.BG, BorderSizePixel = 0, ZIndex = 1, ClipsDescendants = true, }, parent)

  task.spawn(function()
    for i = 0, math.floor(25) + 1 do
      for j = 0, math.floor(24.2) + 1 do
        createElement("Frame", {
          Size = UDim2.new(0, 1, 0, 1), Position = UDim2.new(0, j * 20, 0, i * 20), BackgroundColor3 = Color3.fromRGB(33, 33, 50), BorderSizePixel = 0, ZIndex = 1, }, val22)
      end
    end
  end)

  local val23 = createElement("Frame", {
    Size = UDim2.new(0, sidebarWidth, 1, 0), BackgroundColor3 = val.Sidebar, BorderSizePixel = 0, ZIndex = 2, }, parent)

  createElement("Frame", {
    Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = val.Divider, BorderSizePixel = 0, ZIndex = 3, }, val23)

  createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = val.PurpleDark, BackgroundTransparency = 0.55, BorderSizePixel = 0, ZIndex = 2, }, val23)

  local val24 = createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3, }, val23)

  local brandTitle = createElement("TextLabel", {
    Size = UDim2.new(0, 96, 0, 22), Position = UDim2.new(0, 14, 0, 13), BackgroundTransparency = 1, Text = p19, TextColor3 = val.TextPrimary, TextSize = 16, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 4, }, val24)

  local val25 = createElement("Frame", {
    Size = UDim2.new(0, 28, 0, 14), Position = UDim2.new(0, 114, 0, 17), BackgroundColor3 = val.PurpleDark, BorderSizePixel = 0, ZIndex = 5, }, val24)

  helper3(3, val25)
  helper2(val.BorderAccent, 1, val25)

  createElement("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "element.0", TextColor3 = val.PurpleGlow, TextSize = 9, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 6, }, val25)

  local brandSubtitle = createElement("TextLabel", {
    Size = UDim2.new(1, -28, 0, 14), Position = UDim2.new(0, 14, 0, 37), BackgroundTransparency = 1, Text = (p20 or ""):upper(), TextColor3 = val.TextMuted, TextSize = 9, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, }, val24)

  local parent2 = createElement("Frame", {
    Size = UDim2.new(0, 30, 0, 1), Position = UDim2.new(0, 14, 1, -1), BackgroundColor3 = val.Purple, BorderSizePixel = 0, ZIndex = 4, }, val24)

  createElement("Frame", {
    Size = UDim2.new(1, -44, 0, 1), Position = UDim2.new(0, 44, 1, -1), BackgroundColor3 = val.Divider, BorderSizePixel = 0, ZIndex = 3, }, val24)

  task.spawn(function()
    local total2 = 0

    while parent2.Parent do
      total2 = total2 + 0.016
      local val26 = math.abs(math.sin(total2 * 0.7))

      parent2.Size = UDim2.new(0, 20 + val26 * 70, 0, 1)
      parent2.BackgroundColor3 = val.Purple:Lerp(val.PurpleGlow, val26)

      task.wait(0.016)
    end
  end)

  local element4 = createElement("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, -110), Position = UDim2.new(0, 0, 0, 76), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), ZIndex = 3, }, val23)

  local element5 = createElement(
    "UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1) }, element4
  )

  helper4(0, 0, 4, 4, element4)

  element5:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    element4.CanvasSize = UDim2.new(0, 0, 0, element5.AbsoluteContentSize.Y + 8)
  end)

  element2._tabList = element4

  local val27 = createElement("Frame", {
    Size = UDim2.new(1, -sidebarWidth, 1, 0), Position = UDim2.new(0, sidebarWidth, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3, }, parent)

  element2._content = val27

  local val28 = createElement("Frame", {
    Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 1, -40), BackgroundColor3 = val.Sidebar, BorderSizePixel = 0, ZIndex = 5, }, val23)

  createElement(
    "Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = val.Divider, BorderSizePixel = 0 }, val28
  )

  local parent3 = createElement("Frame", {
    Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 14, 0.5, -3), BackgroundColor3 = val.Green, BorderSizePixel = 0, ZIndex = 6, }, val28)

  helper3(3, parent3)

  createElement("TextLabel", {
    Size = UDim2.new(0, 40, 1, 0), Position = UDim2.new(0, 24, 0, 0), BackgroundTransparency = 1, Text = "active", TextColor3 = val.TextMuted, TextSize = 9, Font = val2.Bold, ZIndex = 6, }, val28)

  task.spawn(function()
    while parent3.Parent do
      helper(parent3, { BackgroundTransparency = 0.55 }, 0.9, Enum.EasingStyle.Sine)
      task.wait(0.9)
      helper(parent3, { BackgroundTransparency = 0 }, 0.9, Enum.EasingStyle.Sine)
      task.wait(0.9)
    end
  end)

  local element6 = createElement("TextButton", {
    Size = UDim2.new(0, 76, 0, 20), Position = UDim2.new(1, -88, 0.5, -10), BackgroundColor3 = Color3.fromRGB(72, 85, 210), BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 6, }, val28)

  helper3(3, element6)
  helper2(Color3.fromRGB(95, 108, 232), 1, element6)

  createElement("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "â¦ discord", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 9, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 7, }, element6)

  element6.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/A3NVXZsWc9") end)
    element2:Notify("Discord", "Invite copied", 2)
  end)

  local hideButton = createElement("TextButton", {
    Name = "HideMenuButton", Size = UDim2.fromOffset(36, 30), Position = UDim2.new(1, -44, 0, 8),
    BackgroundColor3 = val.CardTop, BorderSizePixel = 0, Text = "×", TextColor3 = val.TextPrimary,
    TextSize = 20, Font = val2.Bold, AutoButtonColor = true, ZIndex = 20, }, parent)
  helper3(6, hideButton)
  helper2(val.Border, 1, hideButton)

  local openButton = createElement("TextButton", {
    Name = "OpenMenuButton", Size = UDim2.fromOffset(78, 42), Position = UDim2.new(1, -92, 1, -58),
    BackgroundColor3 = val.Purple, BorderSizePixel = 0, Text = "MENU", TextColor3 = val.TextPrimary,
    TextSize = 13, Font = val2.Bold, AutoButtonColor = true, Visible = false, ZIndex = 10000, }, val21)
  helper3(9, openButton)
  helper2(val.PurpleGlow, 1, openButton)

  local function setMenuVisible(visible)
    parent.Visible = visible
    openButton.Visible = not visible
    element2._visible = visible
  end

  hideButton.Activated:Connect(function() setMenuVisible(false) end)
  openButton.Activated:Connect(function() setMenuVisible(true) end)

  function element2:SetVisible(visible)
    setMenuVisible(visible == true)
  end

  function element2:Toggle()
    setMenuVisible(not parent.Visible)
  end

  local function updateResponsiveLayout()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end

    local viewport = currentCamera.ViewportSize
    compactMode = userInputService.TouchEnabled or viewport.X < 640
    sidebarWidth = compactMode and math.min(126, math.max(108, math.floor(viewport.X * 0.36))) or 196

    local width = math.max(240, math.min(680, viewport.X - (compactMode and 16 or 40)))
    local height = math.max(220, math.min(500, viewport.Y - (compactMode and 40 or 80)))
    parent.Size = UDim2.fromOffset(width, height)
    parent.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)

    val23.Size = UDim2.new(0, sidebarWidth, 1, 0)
    val22.Size = UDim2.new(1, -sidebarWidth, 1, 0)
    val22.Position = UDim2.new(0, sidebarWidth, 0, 0)
    val27.Size = UDim2.new(1, -sidebarWidth, 1, 0)
    val27.Position = UDim2.new(0, sidebarWidth, 0, 0)

    brandTitle.Size = UDim2.new(0, math.max(48, sidebarWidth - 60), 0, 22)
    brandTitle.TextSize = compactMode and 14 or 16
    val25.Visible = not compactMode
    brandSubtitle.Visible = not compactMode
    element6.Visible = not compactMode
    hideButton.Size = compactMode and UDim2.fromOffset(32, 28) or UDim2.fromOffset(36, 30)
    hideButton.Position = compactMode and UDim2.new(1, -38, 0, 6) or UDim2.new(1, -44, 0, 8)
  end

  updateResponsiveLayout()
  local connectedCamera = workspace.CurrentCamera
  if connectedCamera then
    connectedCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout)
  end
  workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local currentCamera = workspace.CurrentCamera
    if currentCamera then
      currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveLayout)
      updateResponsiveLayout()
    end
  end)

  local dragging, dragStart, startPosition
  val24.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
      dragging = true
      dragStart = input.Position
      startPosition = parent.Position

      input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
          dragging = false
        end
      end)
    end
  end)

  userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
      local delta = input.Position - dragStart
      parent.Position = UDim2.new(
        startPosition.X.Scale, startPosition.X.Offset + delta.X,
        startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
      )
    end
  end)

  userInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightAlt then
      element2:Toggle()
    end
  end)

  local val30 = createElement("Frame", {
    Size = UDim2.new(0, 290, 1, 0), Position = UDim2.new(1, -306, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 9999, }, val21)

  createElement("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 5), }, val30)

  helper4(0, 0, 0, 14, val30)

  element2._nc = 0

  function element2:Notify(text, text2, p22)
    element2._nc = element2._nc + 1
    local val31 = p22 or 3

    local val32 = createElement("Frame", {
      Size = UDim2.new(1, 0, 0, 62), BackgroundColor3 = val.NotifBG, BorderSizePixel = 0, LayoutOrder = element2._nc, ClipsDescendants = true, Position = UDim2.new(1, 8, 0, 0), }, val30)

    helper2(val.BorderAccent, 1, val32)

    createElement(
      "Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = val.BorderAccent, BorderSizePixel = 0 }, val32
    )

    helper3(1, (createElement("Frame", {
      Size = UDim2.new(0, 2, 1, -12), Position = UDim2.new(0, 0, 0, 6), BackgroundColor3 = val.PurpleGlow, BorderSizePixel = 0, }, val32)))

    createElement("TextLabel", {
      Size = UDim2.new(1, -22, 0, 18), Position = UDim2.new(0, 14, 0, 11), BackgroundTransparency = 1, Text = text, TextColor3 = val.TextPrimary, TextSize = 13, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, }, val32)

    createElement("TextLabel", {
      Size = UDim2.new(1, -22, 0, 16), Position = UDim2.new(0, 14, 0, 30), BackgroundTransparency = 1, Text = text2, TextColor3 = val.TextSecond, TextSize = 11, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, }, val32)

    local val33 = createElement("Frame", {
      Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = val.Divider, BorderSizePixel = 0, }, val32)

    local val34 = createElement("Frame", {
      Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = val.Purple, BorderSizePixel = 0, }, val33)

    helper(
      val32, { Position = UDim2.new(0, 0, 0, 0) }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out
    )

    helper(val34, { Size = UDim2.new(0, 0, 1, 0) }, val31, Enum.EasingStyle.Linear)

    task.delay(val31, function()
      helper(
        val32, { Position = UDim2.new(1, 8, 0, 0) }, 0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In
      )

      task.wait(0.25)
      val32:Destroy()
    end)
  end

  function element2:TabDivider(p23)
    local val35 = createElement("Frame", {
      Size = UDim2.new(1, -8, 0, 24), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = #element2._tabs + 0.5, }, element4)

    helper3(2, (createElement("Frame", {
      Size = UDim2.new(0, 4, 0, 4), Position = UDim2.new(0, 10, 0.5, -2), BackgroundColor3 = val.Purple, BorderSizePixel = 0, }, val35)))

    createElement("TextLabel", {
      Size = UDim2.new(1, -22, 1, 0), Position = UDim2.new(0, 20, 0, 0), BackgroundTransparency = 1, Text = (p23 or ""):upper(), TextColor3 = val.TextMuted, TextSize = 8, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val35)

    createElement("Frame", {
      Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 20, 1, -1), BackgroundColor3 = val.Divider, BorderSizePixel = 0, }, val35)
  end

  function element2:Tab(p24)
    local element8 = { _win = element2, _name = p24, _order = #element2._tabs + 1 }

    local val36 = createElement("Frame", {
      Size = UDim2.new(1, -6, 0, 32), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = element8._order, }, element4)

    local val37 = createElement("Frame", {
      Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = val.PurpleDark, BackgroundTransparency = 1, BorderSizePixel = 0, }, val36)

    local val38 = createElement("Frame", {
      Size = UDim2.new(0, 3, 0, 20), Position = UDim2.new(0, 0, 0.5, -10), BackgroundColor3 = val.PurpleGlow, BorderSizePixel = 0, Visible = false, }, val36)

    helper3(1, val38)

    local val39 = createElement("TextLabel", {
      Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = p24, TextColor3 = val.TextMuted, TextSize = 12, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, }, val36)

    local element9 = createElement("ScrollingFrame", {
      Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = val.ScrollBar, CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false, TopImage = "", BottomImage = "", MidImage = "", }, val27)

    local element10 = createElement(
      "UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4) }, element9
    )

    helper4(16, 16, 14, 14, element9)

    element10:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
      element9.CanvasSize = UDim2.new(0, 0, 0, element10.AbsoluteContentSize.Y + 28)
    end)

    element8._scroll = element9
    element8._sl = element10
    element8._order2 = 0

    local function iterate()
      for index, value2 in ipairs(element2._tabs) do
        value2._scroll.Visible = false
        value2._leftBar.Visible = false

        helper(value2._tabBg, { BackgroundTransparency = 1 }, 0.15)
        helper(value2._tabLbl, { TextColor3 = val.TextMuted }, 0.15)

        value2._tabLbl.Font = val2.Medium
      end

      element9.Visible = true
      element9.Position = UDim2.new(0, 10, 0, 0)

      helper(element9, { Position = UDim2.new(0, 0, 0, 0) }, 0.2, Enum.EasingStyle.Quint)
      val38.Visible = true
      element2._activeTab = element8

      helper(val37, { BackgroundTransparency = 0.78 }, 0.15)
      helper(val39, { TextColor3 = val.TextPrimary }, 0.15)

      val39.Font = val2.Bold
    end

    element8._leftBar = val38
    element8._tabBg = val37
    element8._tabLbl = val39
    element8._activate = iterate

    local element11 = createElement("TextButton", {
      Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, }, val36)

    element11.MouseButton1Click:Connect(iterate)

    element11.MouseEnter:Connect(function()
      if element2._activeTab ~= element8 then
        helper(val37, { BackgroundTransparency = 0.92 }, 0.1)
        helper(val39, { TextColor3 = val.TextSecond }, 0.1)
      end
    end)

    element11.MouseLeave:Connect(function()
      if element2._activeTab ~= element8 then
        helper(val37, { BackgroundTransparency = 1 }, 0.1)
        helper(val39, { TextColor3 = val.TextMuted }, 0.1)
      end
    end)

    table.insert(element2._tabs, element8)

    if #element2._tabs == 1 then
      iterate()
    end

    function element8:Section(p25)
      element8._order2 = element8._order2 + 1

      local val40 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = element8._order2, }, element9)

      helper3(1, (createElement("Frame", {
        Size = UDim2.new(0, 3, 0, 13), Position = UDim2.new(0, 0, 0.5, -6.5), BackgroundColor3 = val.Purple, BorderSizePixel = 0, }, val40)))

      createElement("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = p25:upper(), TextColor3 = val.PurpleGlow, TextSize = 9, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val40)

      createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = val.Divider, BorderSizePixel = 0, }, val40)
    end

    function element8:Label(text3)
      element8._order2 = element8._order2 + 1

      local val41 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = element8._order2, }, element9)

      createElement("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text3, TextColor3 = val.TextMuted, TextSize = 10, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, }, val41)
    end

    function element8:Toggle(text4, p26, p27, p28)
      element8._order2 = element8._order2 + 1
      local val42 = p27 or false

      local val43 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, p26 and 50 or 34), BackgroundColor3 = val.Card, BorderSizePixel = 0, LayoutOrder = element8._order2, }, element9)

      local val44 = helper2(val.Border, 1, val43)

      createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = val.CardTop, BorderSizePixel = 0, ZIndex = 2, }, val43)

      createElement("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16), Position = UDim2.new(0, 12, 0, p26 and 6 or 9), BackgroundTransparency = 1, Text = text4, TextColor3 = val.TextPrimary, TextSize = 12, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val43)

      if p26 then
        createElement("TextLabel", {
          Size = UDim2.new(1, -60, 0, 14), Position = UDim2.new(0, 12, 0, 23), BackgroundTransparency = 1, Text = p26, TextColor3 = val.TextMuted, TextSize = 10, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, }, val43)
      end

      local val45 = createElement("Frame", {
        Size = UDim2.new(0, 34, 0, 17), Position = UDim2.new(1, -46, 0.5, -8.5), BackgroundColor3 = val42 and val.Purple or val.PillOff, BorderSizePixel = 0, }, val43)

      helper3(9, val45)
      helper2(val42 and val.BorderAccent or val.Border, 1, val45)

      local val46 = createElement("Frame", {
        Size = UDim2.new(0, 11, 0, 11), Position = UDim2.new(val42 and 1 or 0, val42 and -14 or 3, 0.5, -5.5), BackgroundColor3 = val42 and Color3.fromRGB(255, 255, 255) or val.TextMuted, BorderSizePixel = 0, }, val45)

      helper3(6, val46)

      local function safeCall()
        helper(val45, { BackgroundColor3 = val42 and val.Purple or val.PillOff }, 0.16)

        helper(
          val46, { Position = UDim2.new(val42 and 1 or 0, val42 and -14 or 3, 0.5, -5.5) }, 0.16, Enum.EasingStyle.Quint
        )

        helper(
          val46, { BackgroundColor3 = val42 and Color3.fromRGB(255, 255, 255) or val.TextMuted }, 0.14
        )

        helper(val44, { Color = val42 and val.BorderAccent or val.Border }, 0.14)

        if p28 then
          pcall(p28, val42)
        end
      end

      local element12 = createElement("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, }, val43)

      element12.MouseButton1Click:Connect(function()
        val42 = not val42
        safeCall()
      end)

      element12.MouseEnter:Connect(function() helper(val43, { BackgroundColor3 = val.CardHover }, 0.1) end)
      element12.MouseLeave:Connect(function() helper(val43, { BackgroundColor3 = val.Card }, 0.1) end)

      local element13 = {}

      function element13.Set(p29, p30)
        val42 = p30
        safeCall()
      end

      function element13.Get(p31)
        return val42
      end

      return element13
    end

    function element8:Slider(text5, p32, p33, p34, p35, p36)
      local val47 = p33
      local val48 = p34
      element8._order2 = element8._order2 + 1
      val47 = val47 or 0
      val48 = val48 or 100
      local val49 = math.clamp(p35 or val47, val47, val48)
      local floorVal = val49
      local floorVal2 = math.floor(val47) == val47 and math.floor(val48) == val48 and math.floor(val49) == val49

      local val50 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, p32 and 60 or 48), BackgroundColor3 = val.Card, BorderSizePixel = 0, LayoutOrder = element8._order2, }, element9)

      helper2(val.Border, 1, val50)

      createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = val.CardTop, BorderSizePixel = 0, ZIndex = 2, }, val50)

      createElement("TextLabel", {
        Size = UDim2.new(0.58, 0, 0, 16), Position = UDim2.new(0, 12, 0, p32 and 6 or 4), BackgroundTransparency = 1, Text = text5, TextColor3 = val.TextPrimary, TextSize = 12, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val50)

      if p32 then
        createElement("TextLabel", {
          Size = UDim2.new(0.58, 0, 0, 13), Position = UDim2.new(0, 12, 0, 22), BackgroundTransparency = 1, Text = p32, TextColor3 = val.TextMuted, TextSize = 10, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, }, val50)
      end

      local function helper5(val51)
        return floorVal2 and tostring(math.floor(val51)) or string.format("%.2f", val51)
      end

      local val52 = createElement("Frame", {
        Size = UDim2.new(0, 38, 0, 16), Position = UDim2.new(1, -50, 0, p32 and 6 or 4), BackgroundColor3 = val.PurpleDark, BorderSizePixel = 0, }, val50)

      helper3(3, val52)
      helper2(val.BorderAccent, 1, val52)

      local val53 = createElement("TextLabel", {
        Size = UDim2.new(1, -4, 1, 0), Position = UDim2.new(0, 2, 0, 0), BackgroundTransparency = 1, Text = helper5(floorVal), TextColor3 = val.PurpleGlow, TextSize = 11, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Center, }, val52)

      local val54 = createElement("Frame", {
        Size = UDim2.new(1, -24, 0, 3), Position = UDim2.new(0, 12, 1, -13), BackgroundColor3 = val.Divider, BorderSizePixel = 0, }, val50)

      helper3(2, val54)
      local val55 = (floorVal - val47) / (val48 - val47)

      local val56 = createElement("Frame", {
        Size = UDim2.new(val55, 0, 1, 0), BackgroundColor3 = val.Purple, BorderSizePixel = 0, }, val54)

      helper3(2, val56)

      local val57 = createElement("Frame", {
        Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(val55, -6.5, 0.5, -6.5), BackgroundColor3 = val.PurpleGlow, BorderSizePixel = 0, }, val54)

      helper3(7, val57)
      helper2(val.BorderAccent, 1, val57)

      local function helper6(val58)
        floorVal = val47
          + (val48 - val47) * math.clamp((val58 - val54.AbsolutePosition.X) / val54.AbsoluteSize.X, 0, 1)

        if floorVal2 then
          floorVal = math.floor(floorVal + 0.5)
        end

        floorVal = math.clamp(floorVal, val47, val48)
        local val59 = (floorVal - val47) / (val48 - val47)
        val56.Size = UDim2.new(val59, 0, 1, 0)
        val57.Position = UDim2.new(val59, -6.5, 0.5, -6.5)
        val53.Text = helper5(floorVal)

        if p36 then
          pcall(p36, floorVal)
        end
      end

      local val60 = false

      val54.InputBegan:Connect(function(input5)
        if input5.UserInputType == Enum.UserInputType.MouseButton1 then
          val60 = true
          helper(val57, { Size = UDim2.new(0, 16, 0, 16) }, 0.1)
          helper6(input5.Position.X)
        end
      end)

      val57.InputBegan:Connect(function(input6)
        if input6.UserInputType == Enum.UserInputType.MouseButton1 then
          val60 = true
          helper(val57, { Size = UDim2.new(0, 16, 0, 16) }, 0.1)
        end
      end)

      userInputService.InputChanged:Connect(function(input7)
        if val60 and input7.UserInputType == Enum.UserInputType.MouseMovement then
          helper6(input7.Position.X)
        end
      end)

      userInputService.InputEnded:Connect(function(input8)
        if input8.UserInputType == Enum.UserInputType.MouseButton1 and val60 then
          val60 = false
          helper(val57, { Size = UDim2.new(0, 13, 0, 13) }, 0.1)
        end
      end)

      val50.MouseEnter:Connect(function() helper(val50, { BackgroundColor3 = val.CardHover }, 0.1) end)
      val50.MouseLeave:Connect(function() helper(val50, { BackgroundColor3 = val.Card }, 0.1) end)

      local element14 = {}

      function element14.Set(p39, p40)
        floorVal = math.clamp(p40, val47, val48)
        local val61 = (floorVal - val47) / (val48 - val47)
        val56.Size = UDim2.new(val61, 0, 1, 0)
        val57.Position = UDim2.new(val61, -6.5, 0.5, -6.5)
        val53.Text = helper5(floorVal)

        if p36 then
          pcall(p36, floorVal)
        end
      end

      function element14.Get(p41)
        return floorVal
      end

      return element14
    end

    function element8:Button(text6, p42, p43, p44)
      element8._order2 = element8._order2 + 1

      local val62 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, p42 and 48 or 32), BackgroundColor3 = p44 and val.PurpleDark or val.Card, BorderSizePixel = 0, LayoutOrder = element8._order2, ClipsDescendants = true, }, element9)

      helper2(p44 and val.BorderAccent or val.Border, 1, val62)

      createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = p44 and val.BorderAccent or val.CardTop, BorderSizePixel = 0, ZIndex = 2, }, val62)

      local val63 = createElement("TextLabel", {
        Size = UDim2.new(1, -32, 0, 16), Position = UDim2.new(0, 12, 0, p42 and 6 or 8), BackgroundTransparency = 1, Text = text6, TextColor3 = p44 and val.PurpleGlow or val.TextPrimary, TextSize = 12, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val62)

      if p42 then
        createElement("TextLabel", {
          Size = UDim2.new(1, -32, 0, 13), Position = UDim2.new(0, 12, 0, 24), BackgroundTransparency = 1, Text = p42, TextColor3 = val.TextMuted, TextSize = 10, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, }, val62)
      end

      createElement("TextLabel", {
        Size = UDim2.new(0, 16, 1, 0), Position = UDim2.new(1, -20, 0, 0), BackgroundTransparency = 1, Text = "â¸", TextColor3 = p44 and val.PurpleGlow or val.TextMuted, TextSize = 11, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Center, }, val62)

      local element15 = createElement("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 5, }, val62)

      element15.MouseButton1Click:Connect(function()
        local element16 = userInputService:GetMouseLocation() - val62.AbsolutePosition

        local target = createElement("Frame", {
          Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0, element16.X, 0, element16.Y), BackgroundColor3 = val.Purple, BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 6, }, val62)

        helper3(50, target)

        helper(target, {
          Size = UDim2.new(0, 160, 0, 160), Position = UDim2.new(0, element16.X - 80, 0, element16.Y - 80), BackgroundTransparency = 1, }, 0.45, Enum.EasingStyle.Quad)

        task.delay(0.45, function() target:Destroy() end)
        helper(val62, { BackgroundColor3 = p44 and val.PurpleDim or val.CardHover }, 0.08)

        task.delay(0.15, function()
          helper(val62, { BackgroundColor3 = p44 and val.PurpleDark or val.Card }, 0.15)
        end)
      end)

      element15.MouseEnter:Connect(function()
        helper(val62, { BackgroundColor3 = p44 and val.PurpleDim or val.CardHover }, 0.1)
      end)

      element15.MouseLeave:Connect(function()
        helper(val62, { BackgroundColor3 = p44 and val.PurpleDark or val.Card }, 0.1)
      end)

      local element17 = {}

      function element17.SetLabel(p45, text7)
        val63.Text = text7
      end

      return element17
    end

    return element8
  end

  return element2
end

local currentCamera = workspace.CurrentCamera

local val64 = {
  PlayerESP = false, CarESP = false, ESPDist = true, ESPSpeed = true, SpeedBoost = false, SpeedVal = 200, TurboTorq = false, TorqVal = 50, NoclipCar = false, FlyCar = false, FlyVal = 80, InfHealth = false, NoclipSelf = false, FlySelf = false, FlySpeed = 60, SpeedHack = false, SpeedHackVal = 16, RamPower = 600, }

local function helper7()
  return workspace:FindFirstChild(localPlayer.Name .. " car")
end

local function helper8(val65)
  return workspace:FindFirstChild(val65.Name .. " car")
end

local function helper9(val66)
  return val66 and val66:FindFirstChild("MAIN")
end

local function helper10()
  local object = helper7()
  return object and object:FindFirstChildOfClass("VehicleSeat")
end

local function helper11(val67)
  if not val67 then
    return 0
  else
    local assemblyLinearVelocity = val67.AssemblyLinearVelocity
    return math.floor(Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude)
  end
end

local function helper12(val68, color)
  local val69 = {}

  for k = 1, val68 do
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = color
    line.Thickness = 1.5
    line.Transparency = 1

    val69[k] = line
  end

  return val69
end

local function iterate2(val74, val70, val71, val72, val73, color2)
  local lines = val74.lines
  local val75 = math.max(3, math.min(val72, val73) * 0.25)
  local val76 = val70 - val72 / 2

  lines[1].From = Vector2.new(val76, val71)
  lines[1].To = Vector2.new(val76 + val75, val71)
  lines[2].From = Vector2.new(val76, val71)
  lines[2].To = Vector2.new(val76, val71 + val75)
  lines[3].From = Vector2.new(val76 + val72, val71)
  lines[3].To = Vector2.new(val76 + val72 - val75, val71)
  lines[4].From = Vector2.new(val76 + val72, val71)
  lines[4].To = Vector2.new(val76 + val72, val71 + val75)
  lines[5].From = Vector2.new(val76, val71 + val73)
  lines[5].To = Vector2.new(val76 + val75, val71 + val73)
  lines[6].From = Vector2.new(val76, val71 + val73)
  lines[6].To = Vector2.new(val76, val71 + val73 - val75)
  lines[7].From = Vector2.new(val76 + val72, val71 + val73)
  lines[7].To = Vector2.new(val76 + val72 - val75, val71 + val73)
  lines[8].From = Vector2.new(val76 + val72, val71 + val73)
  lines[8].To = Vector2.new(val76 + val72, val71 + val73 - val75)

  for index2, value3 in ipairs(lines) do
    value3.Color = color2
    value3.Visible = true
  end
end

local function helper13()
  return helper9(helper7())
end

local function iterate3()
  local val77 = {}

  for key2, value4 in pairs(players:GetPlayers()) do
    if value4 ~= localPlayer then
      table.insert(val77, value4)
    end
  end

  return val77
end

local val78 = {}

local function helper14(val79)
  local element18 = val78[val79]

  if not element18 then
    return
  end

  for index3, value5 in ipairs(element18.lines) do
    local object2 = value5
    pcall(function() object2:Remove() end)
  end

  pcall(function() element18.name:Remove() end)
  pcall(function() element18.dist:Remove() end)
  pcall(function() element18.info:Remove() end)

  val78[val79] = nil
end

local function helper15(val80)
  if not val80 then
    return
  end

  for index4, value6 in ipairs(val80.lines) do
    value6.Visible = false
  end

  val80.name.Visible = false
  val80.dist.Visible = false
  val80.info.Visible = false
end

local helper16

local function helper17(val82, val81, val83)
  if not val78[val82] then
    val78[val82] = {
      lines = helper12(8, val81), name = helper16(13, val83), dist = helper16(11, Color3.fromRGB(180, 180, 200)), info = helper16(10, Color3.fromRGB(128, 58, 255)), }
  end

  return val78[val82]
end

function helper16(size, color3)
  local text8 = Drawing.new("Text")
  text8.Visible = false
  text8.Size = size
  text8.Center = true
  text8.Outline = true
  text8.OutlineColor = Color3.new(0, 0, 0)
  text8.Font = 2
  text8.Color = color3

  return text8
end

local function helper18(val84)
  local element19, val85 = currentCamera:WorldToViewportPoint(val84)
  return Vector2.new(element19.X, element19.Y), val85, element19.Z
end

local val86

runService.Heartbeat:Connect(function()
  for key3, value7 in pairs(iterate3()) do
    if val64.PlayerESP then
      local character = value7.Character

      local humanoidRootPart = character
        and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso"))

      local val87 = "plr_" .. value7.Name

      if humanoidRootPart then
        local position3 = humanoidRootPart.Position
        local magnitude = (position3 - currentCamera.CFrame.Position).Magnitude
        local element20, val88, val89 = helper18(position3 + Vector3.new(0, 3.2, 0))
        local element21, v84, val90 = helper18(position3 - Vector3.new(0, 3, 0))

        if val88 and val89 > 0 and val90 > 0 then
          local val91 = math.abs(element21.Y - element20.Y)

          if val91 >= 5 then
            local val92 = math.max(val91 * 0.5, 4)
            local element22 = helper17(val87, Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 255, 255))
            local val93 = val86 == value7

            local color4 = val93
            color4 = val93 and Color3.fromRGB(255, 200, 0)

            local color5 = color4
            color5 = color4 or Color3.fromRGB(255, 60, 60)

            iterate2(element22, element20.X, element20.Y, val92, val91, color5)

            element22.name.Text = value7.Name
            element22.name.Position = Vector2.new(element20.X, element20.Y - 15)
            element22.name.Visible = true

            if val64.ESPDist then
              element22.dist.Text = math.floor(magnitude) .. "m"
              element22.dist.Position = Vector2.new(element20.X, element20.Y + val91 + 3)
              element22.dist.Visible = true
            else
              element22.dist.Visible = false
            end

            element22.info.Visible = false
          else
            helper15(val78[val87])
          end
        else
          helper15(val78[val87])
        end
      elseif val78["plr_" .. value7.Name] then
        helper15(val78["plr_" .. value7.Name])
      end
    elseif val78["plr_" .. value7.Name] then
      helper15(val78["plr_" .. value7.Name])
    end

    if val64.CarESP then
      local element23 = helper9((helper8(value7)))
      local val94 = "car_" .. value7.Name

      if element23 then
        local position4 = element23.Position
        local magnitude2 = (position4 - currentCamera.CFrame.Position).Magnitude
        local element24, val95, val96 = helper18(position4 + Vector3.new(0, 2.5, 0))
        local element25, v96, val97 = helper18(position4 - Vector3.new(0, 1.5, 0))

        if val95 and val96 > 0 and val97 > 0 then
          local val98 = math.abs(element25.Y - element24.Y)

          if val98 >= 4 then
            local val99 = math.max(val98 * 2, 8)
            local element26 = helper17(val94, Color3.fromRGB(128, 58, 255), Color3.fromRGB(200, 150, 255))
            local val100 = val86 == value7

            local color6 = val100
            color6 = val100 and Color3.fromRGB(255, 200, 0)

            local color7 = color6
            color7 = color6 or Color3.fromRGB(128, 58, 255)

            iterate2(element26, element24.X, element24.Y, val99, val98, color7)

            element26.name.Text = value7.Name .. "'s car"
            element26.name.Position = Vector2.new(element24.X, element24.Y - 15)
            element26.name.Visible = true

            if val64.ESPDist then
              element26.dist.Text = math.floor(magnitude2) .. "m"
              element26.dist.Position = Vector2.new(element24.X, element24.Y + val98 + 3)
              element26.dist.Visible = true
            else
              element26.dist.Visible = false
            end

            if val64.ESPSpeed then
              local val101 = helper11(element23)

              element26.info.Text = val101 .. " studs/s"
              element26.info.Position = Vector2.new(element24.X, element24.Y + val98 + (val64.ESPDist and 16 or 3))
              element26.info.Visible = true
            else
              element26.info.Visible = false
            end
          else
            helper15(val78[val94])
          end
        else
          helper15(val78[val94])
        end
      elseif val78["car_" .. value7.Name] then
        helper15(val78["car_" .. value7.Name])
      end
    elseif val78["car_" .. value7.Name] then
      helper15(val78["car_" .. value7.Name])
    end
  end
end)

players.PlayerRemoving:Connect(function(player)
  helper14("plr_" .. player.Name)
  helper14("car_" .. player.Name)
end)

runService.Heartbeat:Connect(function()
  local element27 = helper10()
  local val102 = helper13()
  local object3 = helper7()

  if val64.SpeedBoost and element27 then
    pcall(function() element27.MaxSpeed = val64.SpeedVal end)
  end

  if val64.TurboTorq and element27 then
    pcall(function() element27.Torque = val64.TorqVal end)
  end

  if val64.NoclipCar and object3 then
    for key4, value8 in pairs(object3:GetDescendants()) do
      if value8:IsA("BasePart") and value8.CanCollide then
        value8.CanCollide = false
      end
    end
  end

  if val64.FlyCar and val102 then
    if userInputService:IsKeyDown(Enum.KeyCode.E) then
      pcall(function()
        local assemblyLinearVelocity2 = val102.AssemblyLinearVelocity

        val102.AssemblyLinearVelocity = Vector3.new(
          assemblyLinearVelocity2.X, val64.FlyVal, assemblyLinearVelocity2.Z
        )
      end)
    elseif userInputService:IsKeyDown(Enum.KeyCode.Q) then
      pcall(function()
        local assemblyLinearVelocity3 = val102.AssemblyLinearVelocity

        val102.AssemblyLinearVelocity = Vector3.new(
          assemblyLinearVelocity3.X, -val64.FlyVal, assemblyLinearVelocity3.Z
        )
      end)
    end
  end

  local character2 = localPlayer.Character

  local humanoid = character2
  humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

  if val64.SpeedHack and humanoid then
    humanoid.WalkSpeed = val64.SpeedHackVal
  end

  local health

  if val64.InfHealth and object3 then
    health = object3:FindFirstChild("HEALTH")

    if health then
      pcall(function() health.Value = math.max(health.Value, 99999) end)
    end
  end
end)

runService.RenderStepped:Connect(function()
  local character3 = localPlayer.Character
  local humanoidRootPart2 = character3 and character3:FindFirstChild("HumanoidRootPart")
  local humanoid2 = character3 and character3:FindFirstChildOfClass("Humanoid")

  if val64.NoclipSelf and character3 then
    for key5, value9 in pairs(character3:GetDescendants()) do
      if value9:IsA("BasePart") then
        value9.CanCollide = false
      end
    end
  end

  if val64.FlySelf and humanoidRootPart2 and humanoid2 then
    humanoid2.PlatformStand = true
    local zero = Vector3.zero
    local cframe = currentCamera.CFrame
    local vector = Vector3.new(cframe.LookVector.X, 0, cframe.LookVector.Z)

    if vector.Magnitude > 0 then
      vector = vector.Unit
    end

    local vector2 = Vector3.new(cframe.RightVector.X, 0, cframe.RightVector.Z)

    if vector2.Magnitude > 0 then
      vector2 = vector2.Unit
    end

    if userInputService:IsKeyDown(Enum.KeyCode.W) then
      zero = zero + vector
    end

    if userInputService:IsKeyDown(Enum.KeyCode.S) then
      zero = zero - vector
    end

    if userInputService:IsKeyDown(Enum.KeyCode.A) then
      zero = zero - vector2
    end

    if userInputService:IsKeyDown(Enum.KeyCode.D) then
      zero = zero + vector2
    end

    if userInputService:IsKeyDown(Enum.KeyCode.Space) then
      zero = zero + Vector3.new(0, 1, 0)
    end

    if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
      zero = zero - Vector3.new(0, 1, 0)
    end

    humanoidRootPart2.AssemblyLinearVelocity = zero.Magnitude > 0 and zero.Unit * val64.FlySpeed
      or Vector3.zero
  elseif not val64.FlySelf and humanoid2 and humanoid2.PlatformStand then
    humanoid2.PlatformStand = false
  end
end)

local val103 = {}
local val104

local function iterate4()
  local element28 = val104

  if not element28 then
    return
  else
    local scroll = element28._scroll

    for key6, value10 in pairs(val103) do
      if value10 and value10.Parent then
        value10:Destroy()
      end

      val103[key6] = nil
    end

    for key7, value11 in pairs((iterate3())) do
      local val105 = value11
      local val106 = val86 == val105
      local val107 = helper8(val105)
      local val108 = helper9(val107)
      local val109 = val108 and helper11(val108) or nil
      element28._order2 = element28._order2 + 1

      local val110 = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = val106 and val.PurpleDark or val.Card, BorderSizePixel = 0, LayoutOrder = element28._order2, }, scroll)

      helper2(val106 and val.BorderAccent or val.Border, 1, val110)

      createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = val.CardTop, BorderSizePixel = 0, ZIndex = 2, }, val110)

      helper3(4, (createElement("Frame", {
        Size = UDim2.new(0, 8, 0, 8), Position = UDim2.new(0, 10, 0, 10), BackgroundColor3 = val107 and val.Purple or val.TextMuted, BorderSizePixel = 0, ZIndex = 3, }, val110)))

      createElement("TextLabel", {
        Size = UDim2.new(1, -60, 0, 16), Position = UDim2.new(0, 26, 0, 7), BackgroundTransparency = 1, Text = val105.Name, TextColor3 = val106 and val.TextPrimary or val.TextSecond, TextSize = 12, Font = val2.Bold, TextXAlignment = Enum.TextXAlignment.Left, }, val110)

      createElement("TextLabel", {
        Size = UDim2.new(1, -60, 0, 13), Position = UDim2.new(0, 26, 0, 26), BackgroundTransparency = 1, Text = val109 and val109 .. " studs/s" or "no car", TextColor3 = val.TextMuted, TextSize = 10, Font = val2.Medium, TextXAlignment = Enum.TextXAlignment.Left, }, val110)

      local element29 = createElement("TextButton", {
        Size = UDim2.new(0, 46, 0, 22), Position = UDim2.new(1, -52, 0.5, -11), BackgroundColor3 = val106 and val.Purple or val.Input, Text = val106 and "â On" or "Select", TextColor3 = val106 and Color3.fromRGB(255, 255, 255) or val.TextMuted, TextSize = 9, Font = val2.Bold, AutoButtonColor = false, ZIndex = 5, BorderSizePixel = 0, }, val110)

      helper3(4, element29)
      helper2(val106 and val.BorderAccent or val.Border, 1, element29)

      element29.MouseButton1Click:Connect(function()
        val86 = val86 == val105 and nil or val105
        iterate4()
      end)

      val110.MouseEnter:Connect(function()
        if val86 ~= val105 then
          helper(val110, { BackgroundColor3 = val.CardHover }, 0.1)
        end
      end)

      val110.MouseLeave:Connect(function()
        if val86 ~= val105 then
          helper(val110, { BackgroundColor3 = val.Card }, 0.1)
        end
      end)

      val103[val105.Name] = val110
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, element28._sl.AbsoluteContentSize.Y + 28)
    return
  end
end

task.spawn(function()
  while true do
    task.wait(1)

    if val104 then
      for key8, value12 in pairs(val103) do
        if value12 and value12.Parent then
          local findFirstChild2 = players:FindFirstChild(key8)

          if findFirstChild2 then
            local val111 = helper8(findFirstChild2)
            local val112 = helper9(val111)
            local val113 = {}

            for key9, value13 in pairs(value12:GetChildren()) do
              if value13:IsA("TextLabel") then
                table.insert(val113, value13)
              end
            end

            table.sort(val113, function(p61, p62)
              return p61.Position.Y.Offset < p62.Position.Y.Offset
            end)

            if val113[2] then
              val113[2].Text = val112 and helper11(val112) .. " studs/s" or "no car"
            end

            for key10, value14 in pairs(value12:GetChildren()) do
              if value14:IsA("Frame") and value14.Size.X.Offset == 8 then
                value14.BackgroundColor3 = val111 and val.Purple or val.TextMuted
              end
            end
          end
        end
      end
    end
  end
end)

players.PlayerAdded:Connect(function()
  task.wait(1)
  iterate4()
end)

players.PlayerRemoving:Connect(function(player2)
  if val86 == player2 then
    val86 = nil
  end

  task.wait(0.1)
  iterate4()
end)

localPlayer:GetMouse().Button1Down:Connect(function()
  local target = localPlayer:GetMouse().Target

  if not target then
    return
  end

  for key11, value15 in pairs(iterate3()) do
    local character4 = value15.Character
    local val114 = helper8(value15)

    if character4 and target:IsDescendantOf(character4) or val114 and target:IsDescendantOf(val114) then
      val86 = val86 == value15 and nil or value15
      iterate4()
      return
    end
  end
end)

local window = element:Window("DBSB.su", "Car Crash Simulator V3")
window:TabDivider("Visual")

local esp = window:Tab("ESP")
esp:Section("Players")

esp:Toggle("Player ESP", "Show players on foot", false, function(p63)
  val64.PlayerESP = p63

  if not p63 then
    for key12, value16 in pairs(iterate3()) do
      helper15(val78["plr_" .. value16.Name])
    end
  end
end)

esp:Toggle("Car ESP", "Show player cars", false, function(p64)
  val64.CarESP = p64

  if not p64 then
    for key13, value17 in pairs(iterate3()) do
      helper15(val78["car_" .. value17.Name])
    end
  end
end)

esp:Toggle("Show Distance", "Distance label on boxes", true, function(espDist)
  val64.ESPDist = espDist
end)

esp:Toggle("Show Speed", "Car speed in studs/s", true, function(espSpeed)
  val64.ESPSpeed = espSpeed
end)

window:TabDivider("Vehicle")

local myCar = window:Tab("My Car")
myCar:Section("Engine")

myCar:Toggle("Speed Boost", "Increase your VehicleSeat MaxSpeed", false, function(p65)
  val64.SpeedBoost = p65
  local element30

  if not p65 then
    element30 = helper10()

    if element30 then
      pcall(function() element30.MaxSpeed = 100 end)
    end
  end
end)

myCar:Slider("Max Speed", "Speed value (studs/s)", 100, 2000, 200, function(speedVal)
  val64.SpeedVal = speedVal
end)

myCar:Toggle("Turbo Torque", "Increase acceleration torque", false, function(p66)
  val64.TurboTorq = p66
  local element31

  if not p66 then
    element31 = helper10()

    if element31 then
      pcall(function() element31.Torque = 10 end)
    end
  end
end)

myCar:Slider("Torque Value", "Torque amount", 10, 200, 50, function(torqVal)
  val64.TorqVal = torqVal
end)

myCar:Toggle("Infinite Health", "Keep car health at max", false, function(infHealth)
  val64.InfHealth = infHealth
end)

myCar:Section("Movement")

myCar:Toggle("Noclip Car", "Drive through other cars and walls", false, function(p67)
  val64.NoclipCar = p67

  if not p67 then
    local object4 = helper7()

    if object4 then
      for key14, value18 in pairs(object4:GetDescendants()) do
        local element32 = value18

        if element32:IsA("BasePart") then
          pcall(function() element32.CanCollide = true end)
        end
      end
    end
  end
end)

myCar:Toggle("Fly Car", "E = up  //  Q = down", false, function(flyCar) val64.FlyCar = flyCar end)

myCar:Slider("Fly Power", "Vertical velocity force", 20, 300, 80, function(flyVal)
  val64.FlyVal = flyVal
end)

myCar:Section("Actions")

myCar:Button("Flip My Car", "Rotate car 180 degrees", function()
  local element33 = helper13()

  if not element33 then
    window:Notify("Car", "Not in a car", 2)
    return
  end

  pcall(function() element33.CFrame = element33.CFrame * CFrame.Angles(0, 0, math.pi) end)
  window:Notify("Car", "Flipped!", 2)
end)

myCar:Button("Launch My Car", "Send car flying upward", function()
  local element34 = helper13()

  if not element34 then
    window:Notify("Car", "Not in a car", 2)
    return
  end

  pcall(function()
    element34.AssemblyLinearVelocity = Vector3.new(
      math.random(-100, 100), 300, math.random(-100, 100)
    )
  end)

  window:Notify("Car", "Launched!", 2)
end)

myCar:Button("Teleport Car To Me", "Bring your car to your position", function()
  local element35 = helper13()

  local humanoidRootPart3 = localPlayer.Character
    and localPlayer.Character:FindFirstChild("HumanoidRootPart")

  if not element35 or not humanoidRootPart3 then
    window:Notify("Car", "No car or no character", 2)
    return
  end

  pcall(function()
    element35.CFrame = CFrame.new(humanoidRootPart3.Position + Vector3.new(0, 4, 0))
  end)

  window:Notify("Car", "Teleported car to you", 2)
end)

window:TabDivider("Self")

local object5 = window:Tab("Self")
object5:Section("Movement")

object5:Toggle("Noclip", "Walk through objects", false, function(p68)
  val64.NoclipSelf = p68

  if not p68 then
    local character5 = localPlayer.Character

    if character5 then
      for key15, value19 in pairs(character5:GetDescendants()) do
        local element36 = value19

        if element36:IsA("BasePart") then
          pcall(function() element36.CanCollide = true end)
        end
      end
    end
  end
end)

object5:Toggle("Fly", "WASD + Space/Ctrl to fly", false, function(flySelf)
  val64.FlySelf = flySelf
end)

object5:Slider("Fly Speed", "Movement speed while flying", 10, 300, 60, function(flySpeed)
  val64.FlySpeed = flySpeed
end)

object5:Section("Speed")

object5:Toggle("Speed Hack", "Override your walk speed", false, function(p69)
  val64.SpeedHack = p69

  if not p69 then
    local humanoid3 = localPlayer.Character
      and localPlayer.Character:FindFirstChildOfClass("Humanoid")

    if humanoid3 then
      humanoid3.WalkSpeed = 16
    end
  end
end)

object5:Slider("Walk Speed", "Speed on foot (default 16)", 0, 100, 16, function(speedHackVal)
  val64.SpeedHackVal = speedHackVal
end)

object5:Button("Teleport To Car", "Get to your car position", function()
  local element37 = helper13()

  local humanoidRootPart4 = localPlayer.Character
    and localPlayer.Character:FindFirstChild("HumanoidRootPart")

  if not element37 or not humanoidRootPart4 then
    window:Notify("Self", "No car found", 2)
    return
  end

  pcall(function()
    humanoidRootPart4.CFrame = CFrame.new(element37.Position + Vector3.new(0, 4, 0))
  end)
end)

window:TabDivider("Players")

local playerList = window:Tab("Player List")
playerList:Section("Players")
playerList:Label("Click a player or their car in-world to select")
playerList:Label("Auto-updates on join/leave // yellow ESP = selected")
playerList:Button("Refresh", nil, function() iterate4() end)

val104 = playerList
iterate4()
window:TabDivider("Troll")

local troll = window:Tab("Troll")
troll:Section("Ram Settings")

troll:Slider("Ram Power", "Impulse force for all ram actions (default 600)", 100, 10000, 600, function(ramPower)
  val64.RamPower = ramPower
end)

troll:Section("Using Your Car")
troll:Label("Select a target in Player List or click them in-world")

troll:Button("Ram Target", "Launch your car into them", function()
  local val115 = helper13()
  local unit

  if not val115 then
    window:Notify("Troll", "Not in a car", 2)
    return
  elseif not val86 then
    window:Notify("Troll", "No target selected", 2)
    return
  else
    local humanoidRootPart5 = helper9(helper8(val86))
      or val86.Character and val86.Character:FindFirstChild("HumanoidRootPart")

    if not humanoidRootPart5 then
      window:Notify("Troll", "Target has no car or character", 2)
      return
    end

    unit = (humanoidRootPart5.Position - val115.Position).Unit
    pcall(function() val115.AssemblyLinearVelocity = unit * 600 end)
    window:Notify("Troll", "Ramming " .. val86.Name, 2)
    return
  end
end, true)

troll:Button("Launch At Target", "Arc your car into them", function()
  if not helper13() then
    window:Notify("Troll", "Not in a car", 2)
    return
  elseif not val86 then
    window:Notify("Troll", "No target selected", 2)
    return
  else
    if not (helper9(helper8(val86)) or val86.Character and val86.Character:FindFirstChild("HumanoidRootPart")) then
      window:Notify("Troll", "Target has no car or character", 2)
      return
    end

    window:Notify("Troll", "Launched at " .. val86.Name, 2)
    return
  end
end)

troll:Button("Teleport Car To Target", "Move your car next to theirs", function()
  local val116 = helper13()

  if not val116 then
    window:Notify("Troll", "Not in a car", 2)
    return
  end

  if not val86 then
    window:Notify("Troll", "No target selected", 2)
    return
  end

  local element38 = helper9(helper8(val86))

  if not element38 then
    window:Notify("Troll", "Target has no car", 2)
    return
  end

  pcall(function() val116.CFrame = element38.CFrame + Vector3.new(0, 6, 0) end)
  window:Notify("Troll", "Teleported to " .. val86.Name, 2)
end)

troll:Section("Self")

troll:Button("Teleport To Target", "Teleport yourself to selected player", function()
  local humanoidRootPart6

  if not val86 then
    window:Notify("Troll", "No target selected", 2)
    return
  else
    humanoidRootPart6 = localPlayer.Character
      and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    local character6 = val86.Character

    local humanoidRootPart7 = character6
      and (character6:FindFirstChild("HumanoidRootPart") or character6:FindFirstChild("Torso"))

    if not humanoidRootPart6 or not humanoidRootPart7 then
      window:Notify("Troll", "Target has no character", 2)
      return
    end

    pcall(function()
      humanoidRootPart6.CFrame = humanoidRootPart7.CFrame + Vector3.new(0, 3, 0)
    end)

    window:Notify("Troll", "Teleported to " .. val86.Name, 2)
    return
  end
end)

task.spawn(function()
  while true do
    task.wait(0.3)

    if not userInputService:IsKeyDown(Enum.KeyCode.E) then
    elseif not val86 then
    elseif not helper13() then
    elseif not helper9(helper8(val86)) then
      if val86.Character then
        val86.Character:FindFirstChild("HumanoidRootPart")
      end
    end
  end
end)

task.wait(1)

window:Notify("DBSB.su", "Car Crash Simulator V3 // RightAlt to toggle", 4)

task.spawn(function()
  task.wait(2)

  if not localPlayer.Character then
    localPlayer.CharacterAdded:Wait()
  end

  local anchor = Instance.new("Tool")
  anchor.Name = "Anchor"
  anchor.RequiresHandle = true
  anchor.CanBeDropped = false
  anchor.ToolTip = "Freezes you in place"

  local handle = Instance.new("Part")
  handle.Name = "Handle"
  handle.Size = Vector3.new(1, 1, 1)
  handle.BrickColor = BrickColor.new("Dark stone grey")
  handle.Material = Enum.Material.Metal
  handle.CanCollide = false
  handle.Parent = anchor

  local specialMesh = Instance.new("SpecialMesh")
  specialMesh.MeshType = Enum.MeshType.Brick
  specialMesh.Scale = Vector3.new(0.8, 0.8, 0.8)
  specialMesh.Parent = handle

  anchor.Parent = localPlayer.Backpack

  local function helper19(val117)
    local character7 = localPlayer.Character

    if not character7 then
      return
    else
      local humanoidRootPart8 = character7:FindFirstChild("HumanoidRootPart")
      local val118 = not humanoidRootPart8
      local humanoid4 = character7:FindFirstChildOfClass("Humanoid")

      if val118 or not humanoid4 then
        return
      end

      if val117 then
        for key16, value20 in pairs(humanoid4:GetPlayingAnimationTracks()) do
          value20:Stop(0)
        end

        humanoidRootPart8.Anchored = true

        humanoid4.WalkSpeed = 0
        humanoid4.JumpPower = 0
      else
        humanoidRootPart8.Anchored = false
        humanoid4.WalkSpeed = 16
        humanoid4.JumpPower = 50
      end

      return
    end
  end

  anchor.Equipped:Connect(function() helper19(true) end)
  anchor.Unequipped:Connect(function() helper19(false) end)

  localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    anchor.Parent = localPlayer.Backpack
  end)
end)