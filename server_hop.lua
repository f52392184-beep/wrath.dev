--[[
    Server Hop — Obsidian (doihi/obsidian)
    Language / Язык: English or Русский (select it in Settings / Настройки).

    Features / Возможности:
      - Filter public servers by player count, ping, FPS and server age.
      - The public Roblox server API does not provide server creation time;
        age is checked after joining via DistributedGameTime.
      - Sort by random, player count or ping; skip full/current servers.
      - Manual and automatic hopping, new-server hunt, rejoin and JobId copy.
      - Toggle the UI with Right Ctrl.
]]

--================================================================--
-- Load the UI library (try the configured URL, then the valid fallback).
--================================================================--
local LibraryURLs = {
    -- Configured URL (currently returns 404, but try it first).
    "https://raw.githubusercontent.com/doihi/obsidian/refs/heads/main/library.lua",
    -- Valid path (uppercase L, without refs/heads).
    "https://raw.githubusercontent.com/doihi/obsidian/main/Library.lua",
}

local Library = nil
local loadErrors = {}
for _, url in ipairs(LibraryURLs) do
    local ok, src = pcall(game.HttpGet, game, url)
    if ok and type(src) == "string" and #src > 1000 then
        local chunk, err = loadstring(src)
        if chunk then
            local ok2, lib = pcall(chunk)
            if ok2 and type(lib) == "table" then
                Library = lib
                break
            else
                table.insert(loadErrors, url .. " / load error")
            end
        else
            table.insert(loadErrors, url .. " / syntax: " .. tostring(err))
        end
    else
        table.insert(loadErrors, url .. " / http failed")
    end
end
if not Library then
    error("Could not load the Obsidian library:\n" .. table.concat(loadErrors, "\n"))
end

--================================================================--
-- Services and settings.
--================================================================--
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Settings = {
    MinPlayers = 1,          -- Minimum player count.
    MaxPlayers = 12,         -- Maximum player count.
    MaxPing = 300,           -- Maximum ping in milliseconds.
    MinFPS = 0,              -- Minimum FPS (0 = unlimited).
    MinAgeMin = 0,           -- Minimum server age in minutes.
    MaxAgeMin = 1440,        -- Maximum server age in minutes (1440 = unlimited).
    SearchCount = 100,       -- Maximum number of servers to scan per search.
    RetryDelay = 3,          -- Retry interval in seconds.
    StayMinutes = 0,         -- Auto-hop after this many minutes (0 = off).
    AvoidFull = true,        -- Skip full servers.
    AvoidSame = true,        -- Skip the current server.
    AgeCheck = true,         -- Check server age after joining.
    SortMode = "Random",      -- Stable internal sort key; translated in the UI
    PlaceIdOverride = "",    -- Blank uses the current place.
    Language = "English",     -- UI language: English or Русский
}

local function L(english, russian)
    return Settings.Language == "Русский" and russian or english
end

local SortModes = {
    { Key = "Random", English = "Random", Russian = "Случайно" },
    { Key = "Fewest", English = "Fewest players", Russian = "Сначала малолюдные" },
    { Key = "Most", English = "Most players", Russian = "Сначала многолюдные" },
    { Key = "LowestPing", English = "Lowest ping", Russian = "Минимальный ping" },
}

local function GetSortModeValues()
    local values = {}
    for _, mode in ipairs(SortModes) do
        values[#values + 1] = Settings.Language == "Русский" and mode.Russian or mode.English
    end
    return values
end

local function GetSortModeLabel()
    for _, mode in ipairs(SortModes) do
        if mode.Key == Settings.SortMode then
            return Settings.Language == "Русский" and mode.Russian or mode.English
        end
    end
    return Settings.SortMode
end

local State = {
    Hopping = false,
    AutoHop = false,
    Status = "Idle",
}

local StatusLabelObj = nil -- Assigned after the UI is created.

local function Notify(title, desc, time)
    pcall(function()
        Library:Notify({ Title = tostring(title), Description = tostring(desc), Time = time or 4 })
    end)
end

local function SetStatus(text)
    State.Status = text
    pcall(function()
        if StatusLabelObj then
            StatusLabelObj:SetText(L("Status: ", "Статус: ") .. text)
        end
    end)
    print("[ServerHop] " .. text)
end

local function GetPlaceId()
    local n = tonumber(Settings.PlaceIdOverride)
    if n and n > 0 then return math.floor(n) end
    return game.PlaceId
end

local function GetServerAgeMinutes()
    local ok, t = pcall(function() return workspace.DistributedGameTime end)
    if ok and type(t) == "number" then
        return t / 60
    end
    return nil
end

--================================================================--
-- Window / tab / bilingual interface
--================================================================--
local Window = Library:CreateWindow({
    Title = "Server Hop",
    Footer = "doihi/obsidian",
    Icon = "server",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
})

local Tab = Window:AddTab({ Name = "Server Hop", Icon = "server", Description = "Server browser and hopping" })
local CondBox = Tab:AddLeftGroupbox("Settings / Настройки")
local RunBox = Tab:AddRightGroupbox("Actions / Действия")
local InfoBox = Tab:AddRightGroupbox("Server info / Информация")
local UI = {}
local DoHop, StartFreshHunt, ToggleAutoHop, RejoinServer, CopyJobId
local UpdatingLanguage = false

UI.Language = CondBox:AddDropdown("Language", {
    Text = "Language / Язык",
    Values = { "English", "Русский" },
    Default = Settings.Language,
    Multi = false,
    Callback = function(value)
        if UpdatingLanguage then return end
        Settings.Language = value == "Русский" and "Русский" or "English"
        if UI.UpdateLanguage then UI.UpdateLanguage() end
    end,
})

UI.MinPlayers = CondBox:AddSlider("MinPlayers", { Text = "Minimum players / Минимум игроков", Default = Settings.MinPlayers, Min = 0, Max = 50, Rounding = 0, Suffix = "", Callback = function(v) Settings.MinPlayers = math.floor(v) end })
UI.MaxPlayers = CondBox:AddSlider("MaxPlayers", { Text = "Maximum players / Максимум игроков", Default = Settings.MaxPlayers, Min = 1, Max = 50, Rounding = 0, Suffix = "", Callback = function(v) Settings.MaxPlayers = math.floor(v) end })
UI.MaxPing = CondBox:AddSlider("MaxPing", { Text = "Maximum ping / Максимальный ping", Default = Settings.MaxPing, Min = 50, Max = 1000, Rounding = 0, Suffix = "ms", Callback = function(v) Settings.MaxPing = math.floor(v) end })
UI.MinFPS = CondBox:AddSlider("MinFPS", { Text = "Minimum FPS (0 = any) / Минимум FPS (0 = любой)", Default = Settings.MinFPS, Min = 0, Max = 60, Rounding = 0, Suffix = "fps", Callback = function(v) Settings.MinFPS = math.floor(v) end })
UI.MinAgeMin = CondBox:AddSlider("MinAgeMin", { Text = "Minimum server age / Возраст сервера от", Default = Settings.MinAgeMin, Min = 0, Max = 720, Rounding = 0, Suffix = "min", Callback = function(v) Settings.MinAgeMin = math.floor(v) end })
UI.MaxAgeMin = CondBox:AddSlider("MaxAgeMin", { Text = "Maximum server age (1440 = unlimited) / Возраст до (1440 = без лимита)", Default = Settings.MaxAgeMin, Min = 5, Max = 1440, Rounding = 0, Suffix = "min", Callback = function(v) Settings.MaxAgeMin = math.floor(v) end })
UI.SearchCount = CondBox:AddSlider("SearchCount", { Text = "Servers to scan / Серверов для проверки", Default = Settings.SearchCount, Min = 20, Max = 500, Rounding = 0, Suffix = "", Callback = function(v) Settings.SearchCount = math.floor(v) end })
UI.RetryDelay = CondBox:AddSlider("RetryDelay", { Text = "Retry interval / Интервал повтора", Default = Settings.RetryDelay, Min = 1, Max = 30, Rounding = 0, Suffix = "s", Callback = function(v) Settings.RetryDelay = math.floor(v) end })
UI.StayMinutes = CondBox:AddSlider("StayMinutes", { Text = "Auto-hop after stay (0 = off) / Авто-переход через (0 = выкл.)", Default = Settings.StayMinutes, Min = 0, Max = 120, Rounding = 0, Suffix = "min", Callback = function(v) Settings.StayMinutes = math.floor(v) end })
UI.AvoidFull = CondBox:AddToggle("AvoidFull", { Text = "Skip full servers / Пропускать заполненные серверы", Default = Settings.AvoidFull, Callback = function(v) Settings.AvoidFull = v and true or false end })
UI.AvoidSame = CondBox:AddToggle("AvoidSame", { Text = "Skip current server / Пропускать текущий сервер", Default = Settings.AvoidSame, Callback = function(v) Settings.AvoidSame = v and true or false end })
UI.AgeCheck = CondBox:AddToggle("AgeCheck", { Text = "Check age after joining / Проверять возраст после входа", Default = Settings.AgeCheck, Callback = function(v) Settings.AgeCheck = v and true or false end })
UI.SortMode = CondBox:AddDropdown("SortMode", { Text = "Server selection / Выбор сервера", Values = GetSortModeValues(), Default = 1, Multi = false, Callback = function(value)
    if UpdatingLanguage then return end
    for _, mode in ipairs(SortModes) do
        if value == mode.English or value == mode.Russian then Settings.SortMode = mode.Key; break end
    end
end })
UI.PlaceId = CondBox:AddInput("PlaceIdOverride", { Text = "PlaceId (blank = current game) / PlaceId (пусто = текущая игра)", Default = "", Placeholder = "e.g. 123456789 / напр. 123456789", Numeric = true, Finished = true, Callback = function(v) Settings.PlaceIdOverride = tostring(v or "") end })

StatusLabelObj = RunBox:AddLabel("Status: Idle / Статус: ожидание", true)
UI.Hop = RunBox:AddButton({ Text = "Hop to a matching server / Перейти на подходящий сервер", Func = function() if DoHop then DoHop() end end })
UI.Fresh = RunBox:AddButton({ Text = "Find a new server (under 1 min) / Найти новый сервер (до 1 мин.)", Func = function() if StartFreshHunt then StartFreshHunt() end end })
UI.Auto = RunBox:AddButton({ Text = "Start/stop auto-hop / Вкл./выкл. автопереход", Func = function() if ToggleAutoHop then ToggleAutoHop() end end })
UI.Rejoin = RunBox:AddButton({ Text = "Rejoin current server / Перезайти на текущий сервер", Func = function() if RejoinServer then RejoinServer() end end })
UI.CopyJob = RunBox:AddButton({ Text = "Copy JobId / Скопировать JobId", Func = function() if CopyJobId then CopyJobId() end end })
UI.InfoPlayers = InfoBox:AddLabel("Players / Игроки: -", true)
UI.InfoAge = InfoBox:AddLabel("Server age / Возраст сервера: -", true)
UI.InfoJob = InfoBox:AddLabel("JobId: -", true)

UI.UpdateLanguage = function()
    UpdatingLanguage = true
    UI.Language:SetText("Language / Язык")
    UI.MinPlayers:SetText(L("Minimum players", "Минимум игроков"))
    UI.MaxPlayers:SetText(L("Maximum players", "Максимум игроков"))
    UI.MaxPing:SetText(L("Maximum ping", "Максимальный ping"))
    UI.MinFPS:SetText(L("Minimum FPS (0 = unlimited)", "Минимум FPS (0 = без ограничений)"))
    UI.MinAgeMin:SetText(L("Minimum server age", "Минимальный возраст сервера"))
    UI.MaxAgeMin:SetText(L("Maximum server age (1440 = unlimited)", "Максимальный возраст (1440 = без ограничений)"))
    UI.SearchCount:SetText(L("Servers to scan", "Количество серверов для проверки"))
    UI.RetryDelay:SetText(L("Retry interval", "Интервал повтора"))
    UI.StayMinutes:SetText(L("Auto-hop after stay (0 = off)", "Автопереход по времени (0 = выкл.)"))
    UI.AvoidFull:SetText(L("Skip full servers", "Пропускать заполненные серверы"))
    UI.AvoidSame:SetText(L("Skip current server", "Пропускать текущий сервер"))
    UI.AgeCheck:SetText(L("Check age after joining", "Проверять возраст после входа"))
    UI.SortMode:SetText(L("Server selection", "Выбор сервера"))
    UI.PlaceId:SetText(L("PlaceId (blank = current game)", "PlaceId (пусто = текущая игра)"))
    UI.Hop:SetText(L("Hop to a matching server", "Перейти на подходящий сервер"))
    UI.Fresh:SetText(L("Find a new server (under 1 min)", "Найти новый сервер (до 1 мин.)"))
    UI.Auto:SetText(L("Start/stop auto-hop", "Включить/выключить автопереход"))
    UI.Rejoin:SetText(L("Rejoin current server", "Перезайти на текущий сервер"))
    UI.CopyJob:SetText(L("Copy JobId", "Скопировать JobId"))
    UI.InfoPlayers:SetText(L("Players: -", "Игроки: -"))
    UI.InfoAge:SetText(L("Server age: -", "Возраст сервера: -"))
    UI.InfoJob:SetText("JobId: -")
    UI.SortMode:SetValues(GetSortModeValues())
    local selected = 1
    for i, mode in ipairs(SortModes) do if mode.Key == Settings.SortMode then selected = i; break end end
    UI.SortMode:SetValue(GetSortModeValues()[selected])
    UpdatingLanguage = false
end
UI.UpdateLanguage()

local function FetchServers(placeId, cursor)
    local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100%s"):format(
        placeId, cursor and ("&cursor=" .. cursor) or ""
    )
    local body = game:HttpGet(url)
    return HttpService:JSONDecode(body)
end

local function CollectCandidates(placeId)
    local minP = math.min(Settings.MinPlayers, Settings.MaxPlayers)
    local maxP = math.max(Settings.MinPlayers, Settings.MaxPlayers)
    local currentJob = game.JobId
    local found = {}
    local cursor = nil
    local scanned = 0

    SetStatus((L("Searching... (%d-%d players)", "Поиск... (игроков: %d–%d)")):format(minP, maxP))

    while scanned < Settings.SearchCount do
        local data
        local ok, err = pcall(function()
            data = FetchServers(placeId, cursor)
        end)
        if not ok or type(data) ~= "table" or type(data.data) ~= "table" then
            Notify("Server Hop", L("Could not fetch the server list: ", "Не удалось получить список серверов: ") .. tostring(err or data), 4)
            break
        end

        for _, srv in ipairs(data.data) do
            scanned += 1
            if scanned > Settings.SearchCount then break end
            local id = srv.id
            local playing = tonumber(srv.playing) or 0
            local maxPlayers = tonumber(srv.maxPlayers) or 0
            local ping = tonumber(srv.ping) or 0
            local fps = tonumber(srv.fps) or 60
            if id and playing >= minP and playing <= maxP then
                if Settings.AvoidFull and maxPlayers > 0 and playing >= maxPlayers then
                    -- Skip full servers.
                elseif Settings.AvoidSame and id == currentJob then
                    -- Skip the current server.
                elseif ping > Settings.MaxPing then
                    -- Skip servers above the ping limit.
                elseif Settings.MinFPS > 0 and fps < Settings.MinFPS then
                    -- Skip servers below the FPS limit.
                else
                    table.insert(found, srv)
                end
            end
        end

        if data.nextPageCursor and data.nextPageCursor ~= "" and data.nextPageCursor ~= cursor then
            cursor = data.nextPageCursor
        else
            break
        end
        if #found >= 25 then break end -- Stop after collecting enough candidates.
        task.wait(0.2)
    end

    return found, scanned
end

local function PickServer(list)
    if #list == 0 then return nil end
    if Settings.SortMode == "Fewest" then
        table.sort(list, function(a, b) return (a.playing or 0) < (b.playing or 0) end)
        return list[1]
    elseif Settings.SortMode == "Most" then
        table.sort(list, function(a, b) return (a.playing or 0) > (b.playing or 0) end)
        return list[1]
    elseif Settings.SortMode == "LowestPing" then
        table.sort(list, function(a, b) return (a.ping or 9999) < (b.ping or 9999) end)
        return list[1]
    else
        return list[math.random(1, #list)]
    end
end

DoHop = function()
    if State.Hopping then
        Notify("Server Hop", L("A hop is already in progress.", "Переход уже выполняется."), 3)
        return
    end
    State.Hopping = true

    task.spawn(function()
        local ok, err = pcall(function()
            local placeId = GetPlaceId()
            local list, scanned = CollectCandidates(placeId)
            if #list == 0 then
                SetStatus(L(("No match found (scanned: %d)"):format(scanned), ("Подходящих серверов нет (проверено: %d)"):format(scanned)))
                Notify("Server Hop", L(("No matching server (scanned: %d)\nPlayers %d-%d / Sort: %s"):format(
                    scanned,
                    math.min(Settings.MinPlayers, Settings.MaxPlayers),
                    math.max(Settings.MinPlayers, Settings.MaxPlayers),
                    GetSortModeLabel()
                ), ("Подходящий сервер не найден (проверено: %d)\nИгроков %d–%d / Сортировка: %s"):format(
                    scanned,
                    math.min(Settings.MinPlayers, Settings.MaxPlayers),
                    math.max(Settings.MinPlayers, Settings.MaxPlayers),
                    GetSortModeLabel()
                )), 5)
            else
                local target = PickServer(list)
                SetStatus(L(("Hopping → %d players, %d ms, %d FPS (%d candidates)"):format(
                    target.playing or 0, target.ping or 0, math.floor(target.fps or 0), #list), ("Переход → %d игроков, %d мс, %d FPS (кандидатов: %d)"):format(target.playing or 0, target.ping or 0, math.floor(target.fps or 0), #list)))
                Notify("Server Hop", L(("Joining: %d/%d players, %d ms\nJobId: %s..."):format(
                    target.playing or 0, target.maxPlayers or 0, target.ping or 0,
                    string.sub(tostring(target.id), 1, 8)
                ), ("Вход: %d/%d игроков, %d мс\nJobId: %s..."):format(target.playing or 0, target.maxPlayers or 0, target.ping or 0, string.sub(tostring(target.id), 1, 8))), 4)
                task.wait(0.5)
                TeleportService:TeleportToPlaceInstance(placeId, target.id, LocalPlayer)
            end
        end)
        if not ok then
            SetStatus(L("Error: ", "Ошибка: ") .. tostring(err))
            Notify("Server Hop", L("Error: ", "Ошибка: ") .. tostring(err), 5)
        end
        State.Hopping = false
    end)
end

-- Build a queued snippet for finding a new server (age under one minute).
-- The public server API has no creation timestamp, so age is checked after joining.
-- If too old, the snippet queues itself again; the hunt stops after at most 8 minutes.
local function BuildFreshHuntSnippet(placeId, minP, maxP, maxPing, minFps, expiry, language)
    local tpl = [[
local SELF = __SELF__
local LANGUAGE = {LANGUAGE}
task.wait(12)
if os.time() > {EXPIRY} then return end
local PlayersSvc = game:GetService("Players")
local TeleportSvc = game:GetService("TeleportService")
local HttpSvc = game:GetService("HttpService")
local age = nil
pcall(function() age = workspace.DistributedGameTime / 60 end)
if age and age <= 1 then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Server Hop",
            Text = LANGUAGE == "Русский" and ("Новый сервер: возраст " .. string.format("%.1f", age) .. " мин.") or ("New server found: age " .. string.format("%.1f", age) .. " min."),
            Duration = 6,
        })
    end)
    return
end
local cursor, scanned, found, currentJob = nil, 0, {}, game.JobId
while scanned < 200 do
    local ok, data = pcall(function()
        local u = "https://games.roblox.com/v1/games/{PLACEID}/servers/Public?sortOrder=Asc&limit=100"
        if cursor then u = u .. "&cursor=" .. cursor end
        return HttpSvc:JSONDecode(game:HttpGet(u))
    end)
    if not ok or type(data) ~= "table" or type(data.data) ~= "table" then break end
    for _, s in ipairs(data.data) do
        scanned = scanned + 1
        if scanned > 200 then break end
        local p = tonumber(s.playing) or 0
        local m = tonumber(s.maxPlayers) or 0
        local pg = tonumber(s.ping) or 0
        local fp = tonumber(s.fps) or 60
        if s.id and s.id ~= currentJob and p >= {MINP} and p <= {MAXP} and not (m > 0 and p >= m) and pg <= {MAXPING} and ({MINFPS} <= 0 or fp >= {MINFPS}) then
            found[#found + 1] = s
        end
    end
    if #found >= 10 then break end
    if data.nextPageCursor and data.nextPageCursor ~= "" then
        cursor = data.nextPageCursor
    else
        break
    end
    task.wait(0.2)
end
if #found == 0 then return end
local t = found[math.random(1, #found)]
local qFn = (queue_on_teleport or (syn and syn.queue_on_teleport))
if qFn then
    pcall(function() qFn((SELF:gsub("__SELF__", string.format("%q", SELF)))) end)
end
pcall(function() TeleportSvc:TeleportToPlaceInstance({PLACEID}, t.id, PlayersSvc.LocalPlayer) end)
]]
    local src = tpl
    src = src:gsub("{EXPIRY}", tostring(expiry))
    src = src:gsub("{PLACEID}", tostring(placeId))
    src = src:gsub("{MINP}", tostring(minP))
    src = src:gsub("{MAXP}", tostring(maxP))
    src = src:gsub("{MAXPING}", tostring(maxPing))
    src = src:gsub("{MINFPS}", tostring(minFps))
    src = src:gsub("{LANGUAGE}", function() return string.format("%q", language or "English") end)
    -- Replace only the first marker; the runtime-chain marker remains for the next hop.
    local quoted = string.format("%q", src)
    src = (src:gsub("__SELF__", function() return quoted end, 1))
    return src
end

StartFreshHunt = function()
        -- Nothing to do if the current server is already new.
        local curAge = GetServerAgeMinutes()
        if curAge and curAge <= 1 then
            Notify("Server Hop", L(("This server is already new (age %.1f min). "):format(curAge), ("Этот сервер уже новый (возраст %.1f мин.)."):format(curAge)), 4)
            SetStatus(L(("Already in a new server (age %.1f min)"):format(curAge), ("Вы уже на новом сервере (возраст %.1f мин.)"):format(curAge)))
            return
        end
        -- Set the age filter to 0-1 minute and reflect it in the UI.
        Settings.MinAgeMin = 0
        Settings.MaxAgeMin = 1
        Settings.AgeCheck = true
        pcall(function() Library.Options["MinAgeMin"]:SetValue(0) end)
        pcall(function() Library.Options["MaxAgeMin"]:SetValue(1) end)
        pcall(function() Library.Toggles["AgeCheck"]:SetValue(true) end)

        -- Queue continuation across teleports when supported by the executor.
        local placeId = GetPlaceId()
        local minP = math.min(Settings.MinPlayers, Settings.MaxPlayers)
        local maxP = math.max(Settings.MinPlayers, Settings.MaxPlayers)
        local qFn = (queue_on_teleport or (syn and syn.queue_on_teleport))
        local queued = false
        if qFn then
            queued = pcall(function()
                qFn(BuildFreshHuntSnippet(placeId, minP, maxP, Settings.MaxPing, Settings.MinFPS, os.time() + 8 * 60, Settings.Language))
            end)
        end
        if queued then
            Notify("Server Hop", L("New-server hunt started: hopping until a server under 1 minute is found (up to 8 min).", "Поиск нового сервера запущен: переходы до сервера младше 1 минуты (до 8 мин.)."), 5)
            SetStatus(L("Hunting for a server under 1 minute old...", "Ищем сервер младше 1 минуты..."))
        else
            Notify("Server Hop", L("Hopping once (this executor cannot queue the script across teleports).", "Выполняется один переход (исполнитель не поддерживает продолжение скрипта после телепорта)."), 5)
            SetStatus(L("Hopping to find a new server...", "Переход в поиске нового сервера..."))
        end
        DoHop()
end

ToggleAutoHop = function()
        State.AutoHop = not State.AutoHop
        Notify("Server Hop", State.AutoHop and L("Auto-hop started.", "Автопереход включён.") or L("Auto-hop stopped.", "Автопереход выключен."), 3)
        SetStatus(State.AutoHop and L("Auto-hopping...", "Выполняется автопереход...") or L("Idle", "Ожидание"))
        if State.AutoHop then
            task.spawn(function()
                while State.AutoHop do
                    DoHop()
                    -- Wait for DoHop to finish before retrying.
                    local waited = 0
                    while State.Hopping and waited < 30 do task.wait(1) waited += 1 end
                    if not State.AutoHop then break end
                    -- A successful teleport ends this script; retry only if it failed.
                    
                    task.wait(math.clamp(Settings.RetryDelay * 3, 5, 60))
                    if not State.AutoHop then break end
                end
            end)
        end
end

RejoinServer = function()
        local placeId = GetPlaceId()
        Notify("Server Hop", L("Rejoining this server.", "Повторный вход на этот сервер."), 3)
        task.wait(0.5)
        pcall(function()
            if #Players:GetPlayers() <= 1 then
                TeleportService:Teleport(placeId, LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(placeId, game.JobId, LocalPlayer)
            end
        end)
end

CopyJobId = function()
        pcall(function() setclipboard(game.JobId) end)
        Notify("Server Hop", L("JobId copied.", "JobId скопирован."), 3)
end

--================================================================--
-- Current server information (auto-updated).
--================================================================--
task.spawn(function()
    local joinTick = os.clock()
    while true do
        pcall(function()
            local n = #Players:GetPlayers()
            local maxP = Players.MaxPlayers
            UI.InfoPlayers:SetText(L(("Players: %d / %d"):format(n, maxP), ("Игроки: %d / %d"):format(n, maxP)))
            local age = GetServerAgeMinutes()
            if age then
                UI.InfoAge:SetText(L(("Server age: %.1f min"):format(age), ("Возраст сервера: %.1f мин."):format(age)))
            else
                UI.InfoAge:SetText(L("Server age: unknown", "Возраст сервера: неизвестен"))
            end
            UI.InfoJob:SetText("JobId: " .. string.sub(game.JobId, 1, 13) .. "...")
        end)

        -- Check age after joining; hop again if it is outside the selected range.
        if Settings.AgeCheck then
            local age = GetServerAgeMinutes()
            -- Avoid checking during the first 10 seconds after loading.
            if age and (os.clock() - joinTick) > 10 and not State.Hopping then
                local lo = math.min(Settings.MinAgeMin, Settings.MaxAgeMin)
                local hi = math.max(Settings.MinAgeMin, Settings.MaxAgeMin)
                -- A maximum of 1440 minutes means no effective upper bound.
                local outOfRange = (age < lo) or (hi < 1440 and age > hi)
                if outOfRange then
                    Notify("Server Hop", L(("Server age %.1f min is outside the range (%d-%s min); hopping again."):format(age, lo, hi >= 1440 and "∞" or tostring(hi)), ("Возраст сервера %.1f мин. вне диапазона (%d–%s мин.); выполняется новый переход."):format(age, lo, hi >= 1440 and "∞" or tostring(hi))), 5)
                    SetStatus(L("Age out of range; hopping again...", "Возраст вне диапазона; выполняется новый переход..."))
                    task.wait(Settings.RetryDelay)
                    DoHop()
                end
            end
        end

        -- Auto-hop after the configured stay duration (when StayMinutes > 0).
        if Settings.StayMinutes > 0 and (os.clock() - joinTick) > (Settings.StayMinutes * 60) then
            Notify("Server Hop", L(("Auto-hopping after %d minutes."):format(Settings.StayMinutes), ("Автопереход после %d мин."):format(Settings.StayMinutes)), 4)
            DoHop()
            joinTick = os.clock() -- Reset the timer in case the hop fails.
        end

        task.wait(2)
    end
end)

SetStatus(L("Idle", "Ожидание"))
Notify("Server Hop", L("Loaded. Adjust the filters to get started.", "Загружено. Настройте фильтры, чтобы начать."), 4)
print("Server Hop loaded.")
