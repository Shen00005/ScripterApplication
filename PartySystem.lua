rep.Remote.CreateTeam.OnServerEvent:Connect(function(player,gate,minlevel)
    if tonumber(minlevel) <= player.Stats1.Level.Value then
        local teamsFolder = workspace.Teams
        local new = Instance.new('Folder',teamsFolder)
        local partyOwner = Instance.new('ObjectValue', new)
        partyOwner.Name = 'TeamLeader'
        partyOwner.Value = player
        new.Name = player.Name..'-'..gate
        local gui = player.PlayerGui.Gate
        gui.Party.Visible = true
        gui.Frame.Visible = false
        gui.Party.Team.Value = new
        print(gui.Party.Team.Value)
        for _,v in pairs(game.Players:GetPlayers()) do
            if v~= player then
                local JpARTY = rep.GUI.JoinParty:Clone()
                JpARTY.Parent = v.PlayerGui.Gate.Frame.ScrollingFrame
                JpARTY.Party.Value = new
            end
        end
    end
end)
for _,v in pairs(workspace.Teams:GetChildren()) do
    print(v.Name)
end
rep.Remote.JoinParty.OnServerEvent:Connect(function(player, party)
    local powner = party:FindFirstChild('TeamLeader')
    local str = string.split(party.Name, '-')
    local gate = str[2]
    local GateRank,description,minLevel,RecLevel = World:GetGateData(gate)
    if player.Stats1.Level.Value >= tonumber(minLevel) then
        if not party:FindFirstChild(player.Name) then
            local New = Instance.new('ObjectValue', party)
            local gui = player.PlayerGui.Gate
            gui.Party.Team.Value = party
            New.Name = player.Name
            New.Value = player
        end
    end
end)
rep.Remote.KickPlayer.OnServerEvent:Connect(function(player,party,target)
    local powner = party:FindFirstChild('TeamLeader')
    if powner.Value == player then
        print(1)
        if party:FindFirstChild(target) then
            print(2)
            party:FindFirstChild(target):Destroy()
            local ui = player.PlayerGui.Gate.Party
            if ui.ScrollingFrame:FindFirstChild(target) then
                print(3)
                ui.ScrollingFrame:FindFirstChild(target):Destroy()
            end
        end
    end
end)
function TeleportToServer(party,PlaceID)
    local playerList = {}
    for _,v in pairs(party:GetChildren()) do
        if v:IsA('ObjectValue') then
            
            if v.Value then
                table.insert(playerList,v.Value)
            end
        end
    end

    local success, result = pcall(function()
        return TeleportService:TeleportPartyAsync(PlaceID, playerList)
    end)

    if success then
        local jobId = result
        print("Players teleported to", jobId)
    else
        warn(result)
    end
end
rep.Remote.StartDungeon.OnServerEvent:Connect(function(player,party)
    local powner = party:FindFirstChild('TeamLeader')
    local str = string.split(party.Name,'-')
    local gate = str[2]
    warn(gate)
    if powner.Value == player then
        local PlaceID = World:GetGateID(gate)
        TeleportToServer(party,PlaceID)
    end
end)
