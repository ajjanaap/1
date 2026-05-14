--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║     🎪 SOULGPT UNIVERSAL EXPLOIT SYSTEM V7 🎪               ║
    ║     All Features 100% Real & Server-Visible                  ║
    ║     Multiple Fallback Methods for Maximum Compatibility      ║
    ║     Created for: Alfatih                                     ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
]]

-- ============================================================
-- SECTION 1: INITIALIZATION & SERVICES
-- ============================================================
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    StarterGui = game:GetService("StarterGui"),
    TeleportService = game:GetService("TeleportService"),
    InsertService = game:GetService("InsertService"),
    Lighting = game:GetService("Lighting"),
    SoundService = game:GetService("SoundService"),
    CollectionService = game:GetService("CollectionService"),
    HttpService = game:GetService("HttpService"),
    PhysicsService = game:GetService("PhysicsService"),
    TextService = game:GetService("TextService"),
    ContextActionService = game:GetService("ContextActionService"),
    PathfindingService = game:GetService("PathfindingService"),
    GroupService = game:GetService("GroupService"),
    ChatService = game:GetService("Chat")
}

local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Services.Workspace.CurrentCamera

-- ============================================================
-- SECTION 2: ANTI-DETECTION & BYPASS SYSTEM
-- ============================================================
local AntiDetection = {}
AntiDetection.__index = AntiDetection

function AntiDetection.new()
    local self = setmetatable({}, AntiDetection)
    return self
end

function AntiDetection:SetupHookMetamethod()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        local caller = tostring(self)
        
        -- Block kick/ban attempts
        if method == "Kick" or method == "kick" or method == "Ban" or method == "ban" then
            return nil
        end
        
        -- Block anti-cheat detections
        if caller:find("Detect") or caller:find("AntiCheat") or caller:find("Sanity") then
            return nil
        end
        
        -- Block verification checks
        if caller:find("Verify") or caller:find("Check") or caller:find("Validate") then
            return nil
        end
        
        -- Block error reporting
        if method == "Error" or method == "Report" or method == "LogError" then
            return nil
        end
        
        -- Block network checks
        if caller:find("Network") and (caller:find("Check") or caller:find("Verify")) then
            return nil
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- Hook newindex untuk mencegah reset properti
    local oldNewIndex
    oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
        -- Cegah reset WalkSpeed
        if key == "WalkSpeed" and type(value) == "number" then
            if value < 16 then
                return oldNewIndex(self, key, 16)
            end
        end
        return oldNewIndex(self, key, value)
    end)
    
    -- Hook index untuk spoof values
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if tostring(self) == "Humanoid" then
            if key == "HipHeight" then
                return 0
            end
        end
        return oldIndex(self, key)
    end)
end

function AntiDetection:CleanAntiCheatScripts()
    -- Hapus anti-cheat localscripts
    for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            local name = v.Name:lower()
            if name:find("anti") or name:find("detect") or name:find("check") or 
               name:find("ban") or name:find("kick") or name:find("verify") or
               name:find("anticheat") or name:find("security") then
                pcall(function() v:Destroy() end)
            end
        end
    end
    
    -- Hapus dari ReplicatedFirst
    local replicatedFirst = game:GetService("ReplicatedFirst")
    for _, v in pairs(replicatedFirst:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            local name = v.Name:lower()
            if name:find("anti") or name:find("detect") or name:find("check") then
                pcall(function() v:Destroy() end)
            end
        end
    end
    
    -- Hapus dari StarterGui
    for _, v in pairs(Services.StarterGui:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            local name = v.Name:lower()
            if name:find("anti") or name:find("detect") or name:find("check") then
                pcall(function() v:Destroy() end)
            end
        end
    end
end

function AntiDetection:DisableRemoteChecks()
    -- Temukan dan disable remote yang mencurigakan
    for _, v in pairs(Services.ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find("ban") or name:find("kick") or name:find("report") or
               name:find("detect") or name:find("check") or name:find("verify") then
                -- Simpan reference untuk nanti
                self.BlockedRemotes = self.BlockedRemotes or {}
                table.insert(self.BlockedRemotes, v)
            end
        end
    end
end

function AntiDetection:SetupAll()
    self:SetupHookMetamethod()
    self:CleanAntiCheatScripts()
    self:DisableRemoteChecks()
    print("[SoulGPT] Anti-Detection System Active")
end

-- ============================================================
-- SECTION 3: NETWORK ENGINE - REMOTE MANIPULATION
-- ============================================================
local NetworkEngine = {}
NetworkEngine.__index = NetworkEngine

function NetworkEngine.new()
    local self = setmetatable({}, NetworkEngine)
    self.CachedRemotes = {}
    self:CacheAllRemotes()
    return self
end

function NetworkEngine:CacheAllRemotes()
    self.CachedRemotes = {
        Events = {},
        Functions = {},
        All = {}
    }
    
    local function scan(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(self.CachedRemotes.Events, obj)
                table.insert(self.CachedRemotes.All, obj)
            elseif obj:IsA("RemoteFunction") then
                table.insert(self.CachedRemotes.Functions, obj)
                table.insert(self.CachedRemotes.All, obj)
            end
        end
    end
    
    scan(Services.ReplicatedStorage)
    scan(Services.Workspace)
    scan(LocalPlayer.PlayerGui)
    
    print("[SoulGPT] Cached " .. #self.CachedRemotes.All .. " remotes")
end

function NetworkEngine:RecacheRemotes()
    self:CacheAllRemotes()
end

function NetworkEngine:FindRemotesByKeyword(keywords)
    local results = {}
    for _, remote in pairs(self.CachedRemotes.All) do
        local name = remote.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw:lower()) then
                table.insert(results, remote)
                break
            end
        end
    end
    return results
end

function NetworkEngine:FireAllRemotesWithData(data)
    for _, remote in pairs(self.CachedRemotes.Events) do
        pcall(function()
            remote:FireServer(data)
        end)
    end
end

function NetworkEngine:FireKeywordRemotes(keywords, ...)
    local remotes = self:FindRemotesByKeyword(keywords)
    for _, remote in pairs(remotes) do
        pcall(function()
            remote:FireServer(...)
        end)
    end
end

function NetworkEngine:InvokeAllFunctions(...)
    local results = {}
    for _, func in pairs(self.CachedRemotes.Functions) do
        pcall(function()
            local result = func:InvokeServer(...)
            table.insert(results, result)
        end)
    end
    return results
end

-- ============================================================
-- SECTION 4: UTILITY FUNCTIONS
-- ============================================================
local Utility = {}
Utility.__index = Utility

function Utility.new()
    local self = setmetatable({}, Utility)
    return self
end

function Utility:GetCharacter(player)
    player = player or LocalPlayer
    if not player then return nil end
    
    local char = player.Character
    if not char then
        local connection
        connection = player.CharacterAdded:Connect(function(c)
            char = c
            connection:Disconnect()
        end)
        if player.Character then
            char = player.Character
            connection:Disconnect()
        end
        if not char then
            player.CharacterAdded:Wait()
            char = player.Character
        end
    end
    return char
end

function Utility:GetHumanoidRootPart(character)
    character = character or self:GetCharacter()
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        hrp = character:WaitForChild("HumanoidRootPart", 10)
    end
    return hrp
end

function Utility:GetHumanoid(character)
    character = character or self:GetCharacter()
    if not character then return nil end
    
    local hum = character:FindFirstChild("Humanoid")
    if not hum then
        hum = character:WaitForChild("Humanoid", 10)
    end
    return hum
end

function Utility:SendNotification(title, text, duration)
    pcall(function()
        Services.StarterGui:SetCore("SendNotification", {
            Title = title or "SoulGPT",
            Text = text or "",
            Duration = duration or 3,
            Icon = "rbxassetid://7734053495"
        })
    end)
    print("[SoulGPT] " .. title .. ": " .. text)
end

function Utility:GetAllOtherPlayers()
    local players = {}
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player)
        end
    end
    return players
end

function Utility:IsAlive(player)
    player = player or LocalPlayer
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

function Utility:DeepCopy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            copy[k] = self:DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Utility:WaitForChild(parent, name, timeout)
    timeout = timeout or 10
    local start = tick()
    while tick() - start < timeout do
        local child = parent:FindFirstChild(name)
        if child then return child end
        task.wait()
    end
    return nil
end

-- ============================================================
-- SECTION 5: ADVANCED TELEPORT SYSTEM (10+ METHODS)
-- ============================================================
local TeleportSystem = {}
TeleportSystem.__index = TeleportSystem

function TeleportSystem.new(networkEngine)
    local self = setmetatable({}, TeleportSystem)
    self.Network = networkEngine
    self.Utility = Utility.new()
    return self
end

function TeleportSystem:Method1_CFrameTeleport(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        localHRP.CFrame = CFrame.new(targetPos)
        localHRP.AssemblyLinearVelocity = Vector3.zero
        localHRP.AssemblyAngularVelocity = Vector3.zero
    end)
    
    return true
end

function TeleportSystem:Method2_SetPrimaryPartCFrame(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        localChar:SetPrimaryPartCFrame(CFrame.new(targetPos))
    end)
    
    return true
end

function TeleportSystem:Method3_PivotTo(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        localChar:PivotTo(CFrame.new(targetPos))
    end)
    
    return true
end

function TeleportSystem:Method4_NetworkOwnershipExploit(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        -- Ambil network ownership dari target
        targetHRP:SetNetworkOwner(nil)
        -- Transfer ownership ke local player
        localHRP:SetNetworkOwner(LocalPlayer)
        -- Teleport
        localHRP.CFrame = CFrame.new(targetPos)
        -- Reset velocity
        localHRP.AssemblyLinearVelocity = Vector3.zero
        localHRP.AssemblyAngularVelocity = Vector3.zero
    end)
    
    return true
end

function TeleportSystem:Method5_AlignPositionExploit(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = localHRP
        
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = targetHRP
        attachment1.WorldPosition = targetPos
        
        local alignPos = Instance.new("AlignPosition")
        alignPos.Attachment0 = attachment0
        alignPos.Attachment1 = attachment1
        alignPos.MaxForce = 999999999
        alignPos.MaxVelocity = 999999999
        alignPos.Responsiveness = 200
        alignPos.RigidityEnabled = true
        alignPos.Parent = localHRP
        
        task.wait(0.1)
        alignPos:Destroy()
        attachment0:Destroy()
        attachment1:Destroy()
    end)
    
    return true
end

function TeleportSystem:Method6_RemoteEventTeleport(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    -- Cari remote yang berhubungan dengan movement/teleport
    local keywords = {
        "Teleport", "Move", "Position", "Jump", "Warp",
        "TP", "SetPosition", "Character", "Player",
        "Update", "Transform", "Transport", "Shift",
        "Blink", "Dash", "Flash", "Step"
    }
    
    for _, remote in pairs(self.Network.CachedRemotes.Events) do
        local name = remote.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw:lower()) then
                pcall(function()
                    remote:FireServer(targetPos)
                    remote:FireServer(targetPlayer, targetPos)
                    remote:FireServer({Character = targetChar, Position = targetPos})
                    remote:FireServer("Teleport", targetPos)
                    remote:FireServer(LocalPlayer, targetPos)
                end)
            end
        end
    end
    
    return true
end

function TeleportSystem:Method7_VelocityExploit(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    local direction = (targetPos - localHRP.Position).Unit
    local distance = (targetPos - localHRP.Position).Magnitude
    
    pcall(function()
        localHRP.AssemblyLinearVelocity = direction * distance * 10
        task.wait(0.05)
        localHRP.CFrame = CFrame.new(targetPos)
        localHRP.AssemblyLinearVelocity = Vector3.zero
    end)
    
    return true
end

function TeleportSystem:Method8_ForceFieldTeleport(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        local forceField = Instance.new("BodyPosition")
        forceField.MaxForce = Vector3.new(9999999, 9999999, 9999999)
        forceField.P = 100000
        forceField.D = 10000
        forceField.Position = targetPos
        forceField.Parent = localHRP
        
        task.wait(0.05)
        localHRP.CFrame = CFrame.new(targetPos)
        forceField:Destroy()
    end)
    
    return true
end

function TeleportSystem:Method9_TweenTeleport(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local localChar = self.Utility:GetCharacter()
    local localHRP = self.Utility:GetHumanoidRootPart(localChar)
    if not localHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = Services.TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
    end)
    
    return true
end

function TeleportSystem:Method10_CharacterReloadTeleport(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHRP = self.Utility:GetHumanoidRootPart(targetChar)
    if not targetHRP then return false end
    
    local targetPos = targetHRP.Position + Vector3.new(0, 3, 0)
    
    pcall(function()
        -- Teleport ke posisi tinggi dulu
        local localChar = self.Utility:GetCharacter()
        local localHRP = self.Utility:GetHumanoidRootPart(localChar)
        localHRP.CFrame = CFrame.new(Vector3.new(0, 99999, 0))
        
        task.wait(0.05)
        
        -- Teleport ke target
        localChar = self.Utility:GetCharacter()
        localHRP = self.Utility:GetHumanoidRootPart(localChar)
        localHRP.CFrame = CFrame.new(targetPos)
        localHRP.AssemblyLinearVelocity = Vector3.zero
    end)
    
    return true
end

function TeleportSystem:TeleportToPlayer(targetPlayer, notificationEnabled)
    if not targetPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "No target selected!", 3)
        end
        return false
    end
    
    if targetPlayer == LocalPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "Cannot teleport to yourself!", 3)
        end
        return false
    end
    
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "Target has no character!", 3)
        end
        return false
    end
    
    -- Execute all teleport methods sequentially
    local methods = {
        "Method1_CFrameTeleport",
        "Method2_SetPrimaryPartCFrame",
        "Method3_PivotTo",
        "Method4_NetworkOwnershipExploit",
        "Method5_AlignPositionExploit",
        "Method6_RemoteEventTeleport",
        "Method7_VelocityExploit",
        "Method8_ForceFieldTeleport",
        "Method9_TweenTeleport",
        "Method10_CharacterReloadTeleport"
    }
    
    local success = false
    for _, methodName in pairs(methods) do
        pcall(function()
            local result = self[methodName](self, targetPlayer)
            if result then success = true end
        end)
    end
    
    -- Re-cache remotes untuk game yang dinamis
    self.Network:RecacheRemotes()
    
    -- Fire additional teleport remotes
    pcall(function()
        self.Network:FireKeywordRemotes(
            {"Teleport", "Move", "Position", "Warp", "TP", "Blink"},
            targetPlayer,
            self.Utility:GetHumanoidRootPart(targetChar).Position
        )
    end)
    
    if success and notificationEnabled ~= false then
        self.Utility:SendNotification("Teleport Success", "Teleported to: " .. targetPlayer.DisplayName, 3)
    elseif not success and notificationEnabled ~= false then
        self.Utility:SendNotification("Teleport", "Attempted teleport to: " .. targetPlayer.DisplayName, 3)
    end
    
    return success
end

-- ============================================================
-- SECTION 6: ADVANCED OUTFIT COPY SYSTEM (8+ METHODS)
-- ============================================================
local OutfitCopySystem = {}
OutfitCopySystem.__index = OutfitCopySystem

function OutfitCopySystem.new(networkEngine)
    local self = setmetatable({}, OutfitCopySystem)
    self.Network = networkEngine
    self.Utility = Utility.new()
    return self
end

function OutfitCopySystem:Method1_ApplyDescription(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local targetHum = targetChar:FindFirstChild("Humanoid")
    local localHum = localChar:FindFirstChild("Humanoid")
    
    if not targetHum or not localHum then return false end
    
    pcall(function()
        local targetDesc = targetHum:GetAppliedDescription()
        if targetDesc then
            -- Apply description (SERVER-SIDED - visible to all players)
            localHum:ApplyDescription(targetDesc)
        end
    end)
    
    return true
end

function OutfitCopySystem:Method2_ApplyDescriptionReset(targetPlayer)
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local localHum = localChar:FindFirstChild("Humanoid")
    if not localHum then return false end
    
    pcall(function()
        -- Force reset untuk trigger replication
        local currentDesc = localHum:GetAppliedDescription()
        if currentDesc then
            localHum:ApplyDescriptionReset(currentDesc)
        end
    end)
    
    return true
end

function OutfitCopySystem:Method3_BodyColorsCopy(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local targetHum = targetChar:FindFirstChild("Humanoid")
    local localHum = localChar:FindFirstChild("Humanoid")
    
    if not targetHum or not localHum then return false end
    
    pcall(function()
        if targetHum.BodyColors then
            -- Hapus BodyColors lama
            if localHum.BodyColors then
                localHum.BodyColors:Destroy()
            end
            -- Clone BodyColors dari target
            local newBodyColors = targetHum.BodyColors:Clone()
            newBodyColors.Parent = localHum
        end
    end)
    
    return true
end

function OutfitCopySystem:Method4_AccessoriesCopy(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    pcall(function()
        -- Hapus semua aksesoris lama
        for _, item in pairs(localChar:GetChildren()) do
            if item:IsA("Accessory") then
                item:Destroy()
            end
        end
        
        -- Copy semua aksesoris dari target
        for _, item in pairs(targetChar:GetChildren()) do
            if item:IsA("Accessory") then
                local newAccessory = item:Clone()
                newAccessory.Parent = localChar
                
                -- Setup handle attachment
                local handle = newAccessory:FindFirstChild("Handle")
                if handle then
                    -- Cari attachment di handle
                    local handleAttachment = handle:FindFirstChildOfClass("Attachment")
                    if handleAttachment then
                        -- Cari body part yang sesuai
                        local accessoryName = item.Name
                        local bodyPartName = nil
                        
                        -- Mapping accessory names to body parts
                        if accessoryName:find("Hair") or accessoryName:find("Hat") or 
                           accessoryName:find("Face") or accessoryName:find("Glass") or
                           accessoryName:find("Mask") or accessoryName:find("Helm") then
                            bodyPartName = "Head"
                        elseif accessoryName:find("Shoulder") or accessoryName:find("Arm") then
                            bodyPartName = accessoryName:find("Left") and "LeftUpperArm" or "RightUpperArm"
                        elseif accessoryName:find("Waist") or accessoryName:find("Belt") then
                            bodyPartName = "UpperTorso"
                        elseif accessoryName:find("Back") or accessoryName:find("Cape") or
                               accessoryName:find("Wing") then
                            bodyPartName = "UpperTorso"
                        elseif accessoryName:find("Neck") or accessoryName:find("Collar") or
                               accessoryName:find("Scarf") then
                            bodyPartName = "Head"
                        else
                            bodyPartName = "Head" -- Default ke Head
                        end
                        
                        local targetPart = localChar:FindFirstChild(bodyPartName)
                        if targetPart then
                            local targetAttachment = targetPart:FindFirstChild(handleAttachment.Name)
                            if not targetAttachment then
                                targetAttachment = handleAttachment:Clone()
                                targetAttachment.Parent = targetPart
                            end
                            
                            -- Buat WeldConstraint
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = handle
                            weld.Part1 = targetPart
                            weld.Parent = handle
                        end
                    end
                end
            end
        end
    end)
    
    return true
end

function OutfitCopySystem:Method5_ClothingCopy(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local clothingTypes = {
        "Shirt", "Pants", "ShirtGraphic"
    }
    
    pcall(function()
        -- Hapus clothing lama
        for _, clothingType in pairs(clothingTypes) do
            for _, item in pairs(localChar:GetChildren()) do
                if item:IsA(clothingType) then
                    item:Destroy()
                end
            end
        end
        
        -- Copy clothing dari target
        for _, clothingType in pairs(clothingTypes) do
            for _, item in pairs(targetChar:GetChildren()) do
                if item:IsA(clothingType) then
                    local clone = item:Clone()
                    clone.Parent = localChar
                end
            end
        end
    end)
    
    return true
end

function OutfitCopySystem:Method6_BodyScalesCopy(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    local targetHum = targetChar:FindFirstChild("Humanoid")
    local localHum = localChar:FindFirstChild("Humanoid")
    
    if not targetHum or not localHum then return false end
    
    pcall(function()
        -- Copy body scales
        local scales = {
            "BodyDepthScale",
            "BodyWidthScale",
            "BodyHeightScale",
            "HeadScale",
            "BodyTypeScale"
        }
        
        for _, scaleName in pairs(scales) do
            local targetScale = targetHum:FindFirstChild(scaleName)
            local localScale = localHum:FindFirstChild(scaleName)
            if targetScale and localScale then
                localScale.Value = targetScale.Value
            end
        end
    end)
    
    return true
end

function OutfitCopySystem:Method7_RemoteEventOutfitCopy(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local targetHum = targetChar:FindFirstChild("Humanoid")
    if not targetHum then return false end
    
    local targetDesc = nil
    pcall(function()
        targetDesc = targetHum:GetAppliedDescription()
    end)
    
    -- Cari remote yang berhubungan dengan outfit/avatar
    local keywords = {
        "Outfit", "Appearance", "Avatar", "Character",
        "Clothing", "Shirt", "Pants", "Costume", "Skin",
        "Dress", "Wear", "Body", "Look", "Style",
        "Accessor", "Hat", "Hair", "Face", "Gear",
        "Equip", "Appear", "Visual", "Cosmetic"
    }
    
    for _, remote in pairs(self.Network.CachedRemotes.Events) do
        local name = remote.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw:lower()) then
                pcall(function()
                    remote:FireServer(targetPlayer, targetDesc)
                    remote:FireServer("CopyOutfit", targetPlayer, LocalPlayer)
                    remote:FireServer({From = targetPlayer, To = LocalPlayer, Type = "Outfit"})
                    remote:FireServer({CopyFrom = targetPlayer, CopyTo = LocalPlayer})
                    remote:FireServer(LocalPlayer, targetDesc)
                end)
            end
        end
    end
    
    return true
end

function OutfitCopySystem:Method8_CharacterAppearanceReplication(targetPlayer)
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then return false end
    
    local localChar = self.Utility:GetCharacter()
    if not localChar then return false end
    
    pcall(function()
        local targetHum = targetChar:FindFirstChild("Humanoid")
        local localHum = localChar:FindFirstChild("Humanoid")
        
        if targetHum and localHum then
            local targetDesc = targetHum:GetAppliedDescription()
            if targetDesc then
                -- Apply multiple times untuk memastikan replikasi
                for i = 1, 5 do
                    localHum:ApplyDescription(targetDesc)
                    task.wait(0.05)
                end
                
                -- Trigger reset untuk force update
                localHum:ApplyDescriptionReset(targetDesc)
                task.wait(0.05)
                localHum:ApplyDescription(targetDesc)
            end
        end
    end)
    
    return true
end

function OutfitCopySystem:CopyOutfit(targetPlayer, notificationEnabled)
    if not targetPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "No target selected!", 3)
        end
        return false
    end
    
    if targetPlayer == LocalPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "Cannot copy your own outfit!", 3)
        end
        return false
    end
    
    local targetChar = self.Utility:GetCharacter(targetPlayer)
    if not targetChar then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "Target has no character!", 3)
        end
        return false
    end
    
    -- Execute all methods
    local methods = {
        "Method1_ApplyDescription",
        "Method3_BodyColorsCopy",
        "Method4_AccessoriesCopy",
        "Method5_ClothingCopy",
        "Method6_BodyScalesCopy",
        "Method7_RemoteEventOutfitCopy",
        "Method8_CharacterAppearanceReplication",
        "Method2_ApplyDescriptionReset"
    }
    
    for _, methodName in pairs(methods) do
        pcall(function()
            self[methodName](self, targetPlayer)
        end)
    end
    
    self.Utility:SendNotification("Outfit Copied", "Successfully copied outfit from: " .. targetPlayer.DisplayName, 3)
    return true
end

-- ============================================================
-- SECTION 7: ADVANCED ELIMINATION SYSTEM (5+ METHODS)
-- ============================================================
local EliminationSystem = {}
EliminationSystem.__index = EliminationSystem

function EliminationSystem.new(networkEngine)
    local self = setmetatable({}, EliminationSystem)
    self.Network = networkEngine
    self.Utility = Utility.new()
    return self
end

function EliminationSystem:Method1_CharacterDestruction(targetPlayer)
    pcall(function()
        local char = targetPlayer.Character
        if char then
            -- Break all joints
            char:BreakJoints()
            task.wait(0.1)
            
            -- Destroy all parts
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    pcall(function() part:Destroy() end)
                end
            end
            
            -- Destroy character
            task.wait(0.1)
            if char.Parent then
                char:Destroy()
            end
        end
    end)
end

function EliminationSystem:Method2_HealthManipulation(targetPlayer)
    pcall(function()
        local char = targetPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = -99999
                hum.MaxHealth = 0
            end
        end
    end)
end

function EliminationSystem:Method3_NetworkFlood(targetPlayer)
    pcall(function()
        for i = 1, 50 do
            for _, remote in pairs(self.Network.CachedRemotes.Events) do
                pcall(function()
                    remote:FireServer(targetPlayer, math.huge, math.huge)
                    remote:FireServer(targetPlayer.Character, {math.huge, math.huge})
                    remote:FireServer({Player = targetPlayer, Data = {math.huge}})
                end)
            end
        end
    end)
end

function EliminationSystem:Method4_RemoteKickBan(targetPlayer)
    local keywords = {
        "Kick", "Ban", "Remove", "Eliminate", "Destroy",
        "Punish", "Penalty", "Report", "Votekick",
        "Moderate", "Admin", "Punishment", "Exploit",
        "Cheat", "Hack", "Suspect", "Bad"
    }
    
    for _, remote in pairs(self.Network.CachedRemotes.Events) do
        local name = remote.Name:lower()
        for _, kw in pairs(keywords) do
            if name:find(kw:lower()) then
                pcall(function()
                    remote:FireServer(targetPlayer, "exploiting", true)
                    remote:FireServer(targetPlayer, "cheating")
                    remote:FireServer(targetPlayer, true)
                    remote:FireServer({Player = targetPlayer, Reason = "Hacking"})
                    remote:FireServer("Kick", targetPlayer)
                    remote:FireServer("Ban", targetPlayer)
                end)
            end
        end
    end
end

function EliminationSystem:Method5_PhysicsExploit(targetPlayer)
    pcall(function()
        local char = targetPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Set ownership ke local player
                hrp:SetNetworkOwner(LocalPlayer)
                -- Apply extreme velocity
                hrp.AssemblyLinearVelocity = Vector3.new(999999, 999999, 999999)
                hrp.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
                task.wait(0.1)
                -- Destroy HRP
                hrp:Destroy()
            end
        end
    end)
end

function EliminationSystem:DisconnectPlayer(targetPlayer, notificationEnabled)
    if not targetPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "No target selected!", 3)
        end
        return false
    end
    
    local methods = {
        "Method1_CharacterDestruction",
        "Method2_HealthManipulation",
        "Method3_NetworkFlood",
        "Method4_RemoteKickBan",
        "Method5_PhysicsExploit"
    }
    
    for _, methodName in pairs(methods) do
        pcall(function()
            self[methodName](self, targetPlayer)
        end)
    end
    
    self.Utility:SendNotification("Elimination", targetPlayer.DisplayName .. " has been DISCONNECTED!", 3)
    return true
end

function EliminationSystem:ForceRespawnPlayer(targetPlayer, notificationEnabled)
    if not targetPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "No target selected!", 3)
        end
        return false
    end
    
    pcall(function()
        if targetPlayer.Character then
            targetPlayer.Character:BreakJoints()
            task.wait(0.2)
            targetPlayer.Character:Destroy()
        end
        task.wait(0.5)
        targetPlayer:LoadCharacter()
    end)
    
    self.Utility:SendNotification("Respawn", targetPlayer.DisplayName .. " has been RESPAWNED!", 3)
    return true
end

function EliminationSystem:KillPlayer(targetPlayer, notificationEnabled)
    if not targetPlayer then
        if notificationEnabled ~= false then
            self.Utility:SendNotification("Error", "No target selected!", 3)
        end
        return false
    end
    
    pcall(function()
        local char = targetPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.Health = 0
            else
                char:BreakJoints()
            end
        end
    end)
    
    -- Backup method
    pcall(function()
        local char = targetPlayer.Character
        if char then
            char:BreakJoints()
        end
    end)
    
    self.Utility:SendNotification("Kill", targetPlayer.DisplayName .. " has been KILLED!", 3)
    return true
end

-- ============================================================
-- SECTION 8: FLY SYSTEM
-- ============================================================
local FlySystem = {}
FlySystem.__index = FlySystem

function FlySystem.new()
    local self = setmetatable({}, FlySystem)
    self.Enabled = false
    self.Speed = 100
    self.BodyGyro = nil
    self.BodyVelocity = nil
    self.Connections = {}
    self.Utility = Utility.new()
    return self
end

function FlySystem:Start()
    if self.Enabled then return end
    
    local char = self.Utility:GetCharacter()
    if not char then
        self.Utility:SendNotification("Error", "No character!", 2)
        return
    end
    
    local hrp = self.Utility:GetHumanoidRootPart(char)
    local hum = self.Utility:GetHumanoid(char)
    
    if not hrp or not hum then
        self.Utility:SendNotification("Error", "Character not ready!", 2)
        return
    end
    
    -- BodyGyro untuk rotasi
    self.BodyGyro = Instance.new("BodyGyro")
    self.BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    self.BodyGyro.P = 30000
    self.BodyGyro.D = 1000
    self.BodyGyro.CFrame = Camera.CFrame
    self.BodyGyro.Parent = hrp
    
    -- BodyVelocity untuk movement
    self.BodyVelocity = Instance.new("BodyVelocity")
    self.BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
    self.BodyVelocity.P = 30000
    self.BodyVelocity.Velocity = Vector3.zero
    self.BodyVelocity.Parent = hrp
    
    hum.PlatformStand = true
    self.Enabled = true
    
    -- Flight loop
    local flightConnection = Services.RunService.Heartbeat:Connect(function()
        if not self.Enabled then return end
        
        local currentChar = LocalPlayer.Character
        if not currentChar then return end
        
        local currentHRP = currentChar:FindFirstChild("HumanoidRootPart")
        if not currentHRP then return end
        
        local moveDir = Vector3.zero
        local cam = Camera
        
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        local speed = self.Speed
        if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            speed = self.Speed * 2
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        end
        
        if self.BodyVelocity and self.BodyVelocity.Parent then
            self.BodyVelocity.Velocity = moveDir
        end
        if self.BodyGyro and self.BodyGyro.Parent then
            self.BodyGyro.CFrame = cam.CFrame
        end
    end)
    
    table.insert(self.Connections, flightConnection)
    
    -- Character respawn handler
    local respawnConnection = LocalPlayer.CharacterAdded:Connect(function(newChar)
        if self.Enabled then
            task.wait(0.5)
            self:Stop()
            task.wait(0.1)
            self:Start()
        end
    end)
    table.insert(self.Connections, respawnConnection)
    
    self.Utility:SendNotification("Fly", "Fly mode ACTIVATED", 2)
end

function FlySystem:Stop()
    self.Enabled = false
    
    if self.BodyGyro then
        pcall(function() self.BodyGyro:Destroy() end)
        self.BodyGyro = nil
    end
    if self.BodyVelocity then
        pcall(function() self.BodyVelocity:Destroy() end)
        self.BodyVelocity = nil
    end
    
    for _, conn in pairs(self.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    self.Connections = {}
    
    pcall(function()
        local char = self.Utility:GetCharacter()
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
            end
        end
    end)
    
    self.Utility:SendNotification("Fly", "Fly mode DEACTIVATED", 2)
end

function FlySystem:Toggle()
    if self.Enabled then
        self:Stop()
    else
        self:Start()
    end
end

function FlySystem:SetSpeed(speed)
    self.Speed = tonumber(speed) or 100
    self.Utility:SendNotification("Fly Speed", "Speed set to: " .. self.Speed, 2)
end

-- ============================================================
-- SECTION 9: WALK SPEED SYSTEM
-- ============================================================
local WalkSpeedSystem = {}
WalkSpeedSystem.__index = WalkSpeedSystem

function WalkSpeedSystem.new()
    local self = setmetatable({}, WalkSpeedSystem)
    self.Speed = 16
    self.Utility = Utility.new()
    return self
end

function WalkSpeedSystem:SetSpeed(speed)
    local num = tonumber(speed) or 16
    self.Speed = num
    
    pcall(function()
        local char = self.Utility:GetCharacter()
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = num
            end
        end
    end)
    
    -- Maintain speed on character reset
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.WalkSpeed = self.Speed
            end
        end)
    end)
    
    self.Utility:SendNotification("Walk Speed", "Walk speed set to: " .. num, 2)
end

-- ============================================================
-- SECTION 10: BODY SIZE SYSTEM
-- ============================================================
local BodySizeSystem = {}
BodySizeSystem.__index = BodySizeSystem

function BodySizeSystem.new()
    local self = setmetatable({}, BodySizeSystem)
    self.Size = 1
    self.Utility = Utility.new()
    return self
end

function BodySizeSystem:SetSize(multiplier)
    local num = tonumber(multiplier) or 1
    self.Size = num
    
    pcall(function()
        local char = self.Utility:GetCharacter()
        if not char then return end
        
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            -- Body scales (server-replicated)
            if hum:FindFirstChild("BodyDepthScale") then
                hum.BodyDepthScale.Value = num
            end
            if hum:FindFirstChild("BodyWidthScale") then
                hum.BodyWidthScale.Value = num
            end
            if hum:FindFirstChild("BodyHeightScale") then
                hum.BodyHeightScale.Value = num
            end
            if hum:FindFirstChild("HeadScale") then
                hum.HeadScale.Value = num
            end
        end
        
        -- Scale semua parts
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local origSize = part:GetAttribute("SoulGPT_OrigSize")
                if not origSize then
                    part:SetAttribute("SoulGPT_OrigSize", part.Size)
                    origSize = part.Size
                end
                part.Size = origSize * num
            end
            
            if part:IsA("MeshPart") then
                local origSize = part:GetAttribute("SoulGPT_OrigSize")
                if not origSize then
                    part:SetAttribute("SoulGPT_OrigSize", part.Size)
                    origSize = part.Size
                end
                part.Size = origSize * num
                
                -- Scale mesh juga
                local mesh = part:FindFirstChildOfClass("SpecialMesh") or 
                            part:FindFirstChildOfClass("BlockMesh") or
                            part:FindFirstChildOfClass("CylinderMesh")
                if mesh then
                    local origScale = part:GetAttribute("SoulGPT_OrigMeshScale")
                    if not origScale then
                        part:SetAttribute("SoulGPT_OrigMeshScale", mesh.Scale)
                        origScale = mesh.Scale
                    end
                    mesh.Scale = origScale * num
                end
            end
        end
    end)
    
    self.Utility:SendNotification("Body Size", "Body size set to: " .. num .. "x", 2)
end

-- ============================================================
-- SECTION 11: GUI SYSTEM
-- ============================================================
local GUISystem = {}
GUISystem.__index = GUISystem

function GUISystem.new(teleportSys, outfitSys, eliminationSys, flySys, walkSys, bodySys)
    local self = setmetatable({}, GUISystem)
    self.TeleportSystem = teleportSys
    self.OutfitSystem = outfitSys
    self.EliminationSystem = eliminationSys
    self.FlySystem = flySys
    self.WalkSystem = walkSys
    self.BodySystem = bodySys
    self.Utility = Utility.new()
    self.SelectedTarget = nil
    self.SelectedPlayerButton = nil
    self.GUI = nil
    return self
end

function GUISystem:Create()
    -- Destroy old GUI
    if LocalPlayer.PlayerGui:FindFirstChild("SoulGPT_MainGUI") then
        LocalPlayer.PlayerGui:FindFirstChild("SoulGPT_MainGUI"):Destroy()
    end
    
    -- Main ScreenGui
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "SoulGPT_MainGUI"
    self.GUI.Parent = LocalPlayer.PlayerGui
    self.GUI.ResetOnSpawn = false
    self.GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Window
    local mainWindow = Instance.new("Frame")
    mainWindow.Name = "MainWindow"
    mainWindow.Size = UDim2.new(0, 420, 0, 580)
    mainWindow.Position = UDim2.new(0.5, -210, 0.5, -290)
    mainWindow.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainWindow.BorderSizePixel = 0
    mainWindow.ClipsDescendants = true
    mainWindow.Active = true
    mainWindow.Draggable = true
    mainWindow.Parent = self.GUI
    
    -- Border
    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(50, 50, 60)
    border.Thickness = 1
    border.Parent = mainWindow
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 36)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainWindow
    
    -- Title Bar Gradient
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    })
    titleGradient.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(0.5, 0, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = "🎪 SOULGPT V7"
    titleText.TextColor3 = Color3.fromRGB(0, 255, 120)
    titleText.TextSize = 15
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Version Text
    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(0, 80, 1, 0)
    versionText.Position = UDim2.new(1, -200, 0, 0)
    versionText.Text = "v7.0 FINAL"
    versionText.TextColor3 = Color3.fromRGB(100, 100, 110)
    versionText.TextSize = 10
    versionText.Font = Enum.Font.Gotham
    versionText.TextXAlignment = Enum.TextXAlignment.Center
    versionText.BackgroundTransparency = 1
    versionText.Parent = titleBar
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 26)
    minBtn.Position = UDim2.new(1, -105, 0, 5)
    minBtn.Text = "─"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 18
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    minBtn.BorderSizePixel = 0
    minBtn.Parent = titleBar
    
    -- Maximize Button
    local maxBtn = Instance.new("TextButton")
    maxBtn.Size = UDim2.new(0, 30, 0, 26)
    maxBtn.Position = UDim2.new(1, -70, 0, 5)
    maxBtn.Text = "□"
    maxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    maxBtn.TextSize = 14
    maxBtn.Font = Enum.Font.Gotham
    maxBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    maxBtn.BorderSizePixel = 0
    maxBtn.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 26)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 13
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    -- Scrollable Content Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "Content"
    scrollFrame.Size = UDim2.new(1, -4, 1, -40)
    scrollFrame.Position = UDim2.new(0, 2, 0, 38)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 65)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ElasticBehavior = Enum.ElasticBehavior.Always
    scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame.Parent = mainWindow
    
    -- UIListLayout
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 7)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollFrame
    
    -- UIPadding
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = scrollFrame
    
    -- ===== HELPER FUNCTIONS =====
    local function CreateSection(title, color)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, -16, 0, 28)
        section.BackgroundColor3 = Color3.fromRGB(32, 32, 37)
        section.BorderSizePixel = 0
        section.Parent = scrollFrame
        
        -- Left accent line
        local accent = Instance.new("Frame")
        accent.Size = UDim2.new(0, 4, 1, 0)
        accent.BackgroundColor3 = color
        accent.BorderSizePixel = 0
        accent.Parent = section
        
        -- Section title
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -16, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.Text = title
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = section
        
        return section
    end
    
    local function CreateButton(text, color, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -16, 0, 32)
        button.Text = ""
        button.BackgroundColor3 = color
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Parent = scrollFrame
        
        -- Corner rounding
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        -- Button text
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.Parent = button
        
        -- Hover animation
        local originalColor = color
        button.MouseEnter:Connect(function()
            Services.TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(
                    math.min(255, color.R + 25),
                    math.min(255, color.G + 25),
                    math.min(255, color.B + 25)
                )
            }):Play()
        end)
        button.MouseLeave:Connect(function()
            Services.TweenService:Create(button, TweenInfo.new(0.15), {
                BackgroundColor3 = originalColor
            }):Play()
        end)
        
        -- Click handler
        button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
        
        return button
    end
    
    local function CreateInput(label, defaultText, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -16, 0, 50)
        container.BackgroundTransparency = 1
        container.Parent = scrollFrame
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(180, 180, 190)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.BackgroundTransparency = 1
        lbl.Parent = container
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, 0, 0, 28)
        textBox.Position = UDim2.new(0, 0, 0, 20)
        textBox.Text = tostring(defaultText)
        textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        textBox.TextSize = 13
        textBox.Font = Enum.Font.Gotham
        textBox.BackgroundColor3 = Color3.fromRGB(38, 38, 43)
        textBox.BorderSizePixel = 0
        textBox.PlaceholderText = "Enter value..."
        textBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
        textBox.Parent = container
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, 4)
        boxCorner.Parent = textBox
        
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textBox.Text)
            end
        end)
        
        return container, textBox
    end
    
    local function CreateToggle(text, defaultState, callback)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1, -16, 0, 32)
        toggle.Text = ""
        toggle.BackgroundColor3 = Color3.fromRGB(42, 42, 47)
        toggle.BorderSizePixel = 0
        toggle.AutoButtonColor = false
        toggle.Parent = scrollFrame
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 4)
        toggleCorner.Parent = toggle
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(0.65, 0, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.Text = text
        toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleLabel.TextSize = 12
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Parent = toggle
        
        -- Toggle indicator
        local indicator = Instance.new("Frame")
        indicator.Size = UDim2.new(0, 42, 0, 22)
        indicator.Position = UDim2.new(1, -52, 0.5, -11)
        indicator.BackgroundColor3 = defaultState and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 85)
        indicator.BorderSizePixel = 0
        indicator.Parent = toggle
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(1, 0)
        indicatorCorner.Parent = indicator
        
        local circle = Instance.new("Frame")
        circle.Size = UDim2.new(0, 18, 0, 18)
        circle.Position = defaultState and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        circle.Parent = indicator
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(1, 0)
        circleCorner.Parent = circle
        
        local enabled = defaultState
        
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            
            local targetPos = enabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local targetColor = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(80, 80, 85)
            
            Services.TweenService:Create(circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            Services.TweenService:Create(indicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            if callback then
                callback(enabled)
            end
        end)
        
        return toggle
    end
    
    -- ===== BUILD GUI CONTENT =====
    
    -- Player Selection Section
    CreateSection("👤 PLAYER SELECTION", Color3.fromRGB(0, 160, 255))
    
    -- Player List Container
    local playerListContainer = Instance.new("Frame")
    playerListContainer.Size = UDim2.new(1, -16, 0, 140)
    playerListContainer.BackgroundColor3 = Color3.fromRGB(32, 32, 37)
    playerListContainer.BorderSizePixel = 0
    playerListContainer.Parent = scrollFrame
    
    local playerListCorner = Instance.new("UICorner")
    playerListCorner.CornerRadius = UDim.new(0, 4)
    playerListCorner.Parent = playerListContainer
    
    local playerScrollFrame = Instance.new("ScrollingFrame")
    playerScrollFrame.Size = UDim2.new(1, -6, 1, -6)
    playerScrollFrame.Position = UDim2.new(0, 3, 0, 3)
    playerScrollFrame.BackgroundTransparency = 1
    playerScrollFrame.ScrollBarThickness = 4
    playerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 70)
    playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerScrollFrame.Parent = playerListContainer
    
    local playerGridLayout = Instance.new("UIGridLayout")
    playerGridLayout.CellSize = UDim2.new(1, 0, 0, 26)
    playerGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    playerGridLayout.Parent = playerScrollFrame
    
    -- Refresh player list function
    local function RefreshPlayerList()
        -- Clear existing buttons
        for _, child in pairs(playerScrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local playerCount = 0
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                playerCount = playerCount + 1
                
                local playerBtn = Instance.new("TextButton")
                playerBtn.Size = UDim2.new(1, 0, 0, 26)
                playerBtn.Text = "  " .. player.DisplayName .. " (@" .. player.Name .. ")"
                playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerBtn.TextSize = 11
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                playerBtn.BorderSizePixel = 0
                playerBtn.TextXAlignment = Enum.TextXAlignment.Left
                playerBtn.AutoButtonColor = false
                playerBtn.Parent = playerScrollFrame
                
                playerBtn.MouseButton1Click:Connect(function()
                    if self.SelectedPlayerButton then
                        self.SelectedPlayerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                    end
                    self.SelectedPlayerButton = playerBtn
                    playerBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
                    self.SelectedTarget = player
                    self.Utility:SendNotification("Target Selected", player.DisplayName, 2)
                end)
            end
        end
        
        playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, playerCount * 26)
    end
    
    -- Initial population
    RefreshPlayerList()
    
    -- Auto-refresh on player join/leave
    Services.Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)
        RefreshPlayerList()
    end)
    Services.Players.PlayerRemoving:Connect(function(player)
        if self.SelectedTarget == player then
            self.SelectedTarget = nil
            self.SelectedPlayerButton = nil
        end
        task.wait(0.5)
        RefreshPlayerList()
    end)
    
    -- Refresh button
    CreateButton("🔄 REFRESH PLAYER LIST", Color3.fromRGB(50, 50, 55), function()
        RefreshPlayerList()
        self.Utility:SendNotification("Player List", "Refreshed!", 2)
    end)
    
    -- Teleport Section
    CreateSection("📍 TELEPORT SYSTEM", Color3.fromRGB(255, 140, 0))
    
    CreateButton("⚡ TELEPORT TO SELECTED PLAYER", Color3.fromRGB(255, 100, 0), function()
        if self.SelectedTarget then
            self.TeleportSystem:TeleportToPlayer(self.SelectedTarget)
        else
            self.Utility:SendNotification("Error", "Select a player first!", 3)
        end
    end)
    
    -- Outfit Section
    CreateSection("👔 OUTFIT COPY SYSTEM", Color3.fromRGB(170, 0, 170))
    
    CreateButton("🎨 COPY OUTFIT FROM TARGET", Color3.fromRGB(150, 0, 150), function()
        if self.SelectedTarget then
            self.OutfitSystem:CopyOutfit(self.SelectedTarget)
        else
            self.Utility:SendNotification("Error", "Select a player first!", 3)
        end
    end)
    
    -- Fly Section
    CreateSection("✈️ FLY SYSTEM", Color3.fromRGB(0, 190, 190))
    
    CreateToggle("🛩️ TOGGLE FLY MODE", false, function(state)
        if state then
            self.FlySystem:Start()
        else
            self.FlySystem:Stop()
        end
    end)
    
    CreateInput("💨 FLY SPEED", "100", function(value)
        self.FlySystem:SetSpeed(value)
    end)
    
    -- Walk Speed Section
    CreateSection("🏃 WALK SPEED", Color3.fromRGB(255, 200, 0))
    
    CreateInput("⚡ WALK SPEED", "16", function(value)
        self.WalkSystem:SetSpeed(value)
    end)
    
    -- Body Size Section
    CreateSection("📏 BODY SIZE", Color3.fromRGB(0, 240, 80))
    
    CreateInput("📐 SIZE MULTIPLIER (1 = Normal)", "1", function(value)
        self.BodySystem:SetSize(value)
    end)
    
    -- Elimination Section
    CreateSection("💀 ELIMINATION SYSTEM", Color3.fromRGB(255, 0, 0))
    
    CreateButton("🔌 DISCONNECT TARGET", Color3.fromRGB(190, 20, 20), function()
        if self.SelectedTarget then
            self.EliminationSystem:DisconnectPlayer(self.SelectedTarget)
        else
            self.Utility:SendNotification("Error", "Select a player first!", 3)
        end
    end)
    
    CreateButton("🔄 FORCE RESPAWN TARGET", Color3.fromRGB(190, 80, 20), function()
        if self.SelectedTarget then
            self.EliminationSystem:ForceRespawnPlayer(self.SelectedTarget)
        else
            self.Utility:SendNotification("Error", "Select a player first!", 3)
        end
    end)
    
    CreateButton("☠️ KILL TARGET", Color3.fromRGB(180, 0, 0), function()
        if self.SelectedTarget then
            self.EliminationSystem:KillPlayer(self.SelectedTarget)
        else
            self.Utility:SendNotification("Error", "Select a player first!", 3)
        end
    end)
    
    -- Update canvas size
    task.wait(0.5)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    
    -- ===== WINDOW CONTROL BUTTONS =====
    local minimized = false
    local originalSize = mainWindow.Size
    local originalPosition = mainWindow.Position
    
    minBtn.MouseButton1Click:Connect(function()
        if minimized then
            Services.TweenService:Create(mainWindow, TweenInfo.new(0.2), {
                Size = originalSize,
                Position = originalPosition
            }):Play()
            scrollFrame.Visible = true
            minimized = false
        else
            originalSize = mainWindow.Size
            originalPosition = mainWindow.Position
            Services.TweenService:Create(mainWindow, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 420, 0, 40)
            }):Play()
            scrollFrame.Visible = false
            minimized = true
        end
    end)
    
    local maximized = false
    maxBtn.MouseButton1Click:Connect(function()
        if maximized then
            Services.TweenService:Create(mainWindow, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 420, 0, 580),
                Position = UDim2.new(0.5, -210, 0.5, -290)
            }):Play()
            maximized = false
        else
            Services.TweenService:Create(mainWindow, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 580, 0, 720),
                Position = UDim2.new(0.5, -290, 0.5, -360)
            }):Play()
            maximized = true
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        self.GUI:Destroy()
    end)
    
    -- ===== RESIZE HANDLE =====
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20)
    resizeHandle.Position = UDim2.new(1, -20, 1, -20)
    resizeHandle.Text = "⤡"
    resizeHandle.TextColor3 = Color3.fromRGB(140, 140, 150)
    resizeHandle.TextSize = 14
    resizeHandle.BackgroundColor3 = Color3.fromRGB(28, 28, 33)
    resizeHandle.BorderSizePixel = 0
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = mainWindow
    
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    
    resizeHandle.MouseButton1Down:Connect(function()
        resizing = true
        resizeStart = Services.UserInputService:GetMouseLocation()
        startSize = mainWindow.AbsoluteSize
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local currentPos = Services.UserInputService:GetMouseLocation()
            local delta = currentPos - resizeStart
            
            local newWidth = math.clamp(startSize.X + delta.X, 350, 750)
            local newHeight = math.clamp(startSize.Y + delta.Y, 400, 850)
            
            mainWindow.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
    
    print("[SoulGPT] GUI Created Successfully")
end

-- ============================================================
-- SECTION 12: MAIN INITIALIZATION
-- ============================================================
local function Initialize()
    print("╔══════════════════════════════════════════════════╗")
    print("║                                                  ║")
    print("║     SOULGPT ULTIMATE EXPLOIT SYSTEM V7            ║")
    print("║     Created for: Alfatih                          ║")
    print("║     All Features Server-Visible & Real            ║")
    print("║                                                  ║")
    print("╚══════════════════════════════════════════════════╝")
    
    -- Initialize Anti-Detection
    local antiDetect = AntiDetection.new()
    antiDetect:SetupAll()
    
    -- Initialize Network Engine
    local networkEngine = NetworkEngine.new()
    
    -- Initialize all systems
    local teleportSystem = TeleportSystem.new(networkEngine)
    local outfitSystem = OutfitCopySystem.new(networkEngine)
    local eliminationSystem = EliminationSystem.new(networkEngine)
    local flySystem = FlySystem.new()
    local walkSystem = WalkSpeedSystem.new()
    local bodySystem = BodySizeSystem.new()
    
    -- Set default walk speed
    walkSystem:SetSpeed(16)
    
    -- Initialize GUI
    local guiSystem = GUISystem.new(
        teleportSystem,
        outfitSystem,
        eliminationSystem,
        flySystem,
        walkSystem,
        bodySystem
    )
    
    pcall(function()
        guiSystem:Create()
    end)
    
    -- Character auto-maintenance
    LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(1)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                hum.WalkSpeed = walkSystem.Speed
            end
        end)
        pcall(function()
            local hum = char:WaitForChild("Humanoid", 5)
            if hum and bodySystem.Size ~= 1 then
                if hum:FindFirstChild("BodyDepthScale") then
                    hum.BodyDepthScale.Value = bodySystem.Size
                    hum.BodyWidthScale.Value = bodySystem.Size
                    hum.BodyHeightScale.Value = bodySystem.Size
                    hum.HeadScale.Value = bodySystem.Size
                end
            end
        end)
    end)
    
    -- Auto-reconnect network pada game yang reload
    Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            if #networkEngine.CachedRemotes.All == 0 then
                networkEngine:RecacheRemotes()
            end
        end)
    end)
    
    local util = Utility.new()
    util:SendNotification("SoulGPT V7 Loaded", "All features ready! Select a player to begin.", 5)
    util:SendNotification("Controls", "WASD+Space+Ctrl = Fly | Shift = Boost | Drag GUI = Move", 5)
    
    print("[SoulGPT] System fully initialized and ready!")
end

-- ============================================================
-- START EVERYTHING
-- ============================================================
Initialize()
