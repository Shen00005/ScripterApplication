-- not everything is here

function ModPerms(plr)
	local canProceed
	if plr:FindFirstChild('Admin') then
		if plr:FindFirstChild('Admin').Value >= adminPermsValue then
			canProceed = true
			return canProceed
		else
			canProceed = false	
			return canProceed
		end
	else
		canProceed = false
		return canProceed
	end
	
end
function LowMod(plr)
	local canProceed
	if plr:FindFirstChild('Admin') then
		if plr:FindFirstChild('Admin').Value >= 30 then
			canProceed = true
			return canProceed
		else
			canProceed = false	
			return canProceed
		end
	else
		canProceed = false
		return canProceed
	end

end
function RankCheck(plr, target)
	local canProceed
	if plr:FindFirstChild('Admin').Value >= adminPermsValue then
		local TargetPlayer 
		
		local function getTargetID()
			for i,v in pairs(game.Players:GetPlayers()) do
				if v.UserId == tonumber(target) then
					TargetPlayer = v
				end
			end
		end
		getTargetID()
		
		if (TargetPlayer==nil) or  (not TargetPlayer:FindFirstChild('Admin')) then
			if not table.find(admins,target) then
				canProceed = true
			else
				canProceed = false
			end
			-- the target is a member, continue
			
			return canProceed
		else
			-- the target has a rank
			local TragetRankValue = TargetPlayer:FindFirstChild('Admin')
			local PlrRankValue = plr:FindFirstChild('Admin')
			if TragetRankValue.Value == PlrRankValue.Value then
				canProceed = false
				return canProceed
			elseif TragetRankValue.Value >= PlrRankValue.Value then
				-- the player has higher rank
				canProceed = false
				return canProceed
			elseif TragetRankValue.Value <= PlrRankValue.Value then
				-- the player has higher rank
				canProceed = true
				return canProceed
			end
		end
	else
		canProceed = false
		return canProceed
	end
	
end


function IsAnAdamin(plr)
	local canProceed
	if plr:FindFirstChild('Admin').Value >= adminPermsValue then
		canProceed = true
		return canProceed
	else
		canProceed = false
		return canProceed
	end
end
function BanString(plr,target)
	local v = Instance.new('IntValue')
	v.Value = target
	if v.Value == 0 or nil then
		local newtarget
		for _,v in pairs(game.Players:GetPlayers()) do
			if v.Name == target then
				newtarget = v.UserId
				return newtarget
			end
		end
	else
		return target
	end
end
rep.Events.Ban.OnServerEvent:Connect(function(plr, target)

	local Permission = RankCheck(plr,target)
	if Permission == false then
		local data = {
			['content'] = ('Attempt To ban '.. target.. ' By : '..plr.Name..' , '..plr.UserId..' Has Failed due Permissions')
		}
		data = HttpService:JSONEncode(data)
		HttpService:PostAsync(webhookurl, data)
		return
	else
	
	end
	
	local form = {
		['Ban'] = tonumber(target)
	}
	local updatetarget = BanString(plr,target)
	target = updatetarget
	
		
	local success, errorMessage = pcall(function()
		DS:SetAsync(tonumber(target), true)
	end)
	if not success then
		print(errorMessage)
	end
	
	local function addToList(player)
		local data = {}

		data.ID = tonumber(target)
		List:UpdateAsync("KEY_INDEX", function(oldData)
			local data = oldData or {}
			data[tonumber(target)] = true 
			return data
		end)
	end
	addToList()
	
	for i, v in game.Players:GetPlayers() do
		if v.UserId == tonumber(target) then
			v:Kick()
		else

		end
	end
	local data = {
		['content'] = ('Player : '.. target.. ' has been banned by : '..plr.Name..' , '..plr.UserId)
	}
	data = HttpService:JSONEncode(data)
	HttpService:PostAsync(webhookurl, data)
	--end
end)

rep.Events.Invisible.OnServerEvent:Connect(function(plr, target)
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	if target == nil or target == '' then
		if  not (plr.Character:FindFirstChild('Head').Transparency == 1) then
			-- Not Invisible
			local char = plr.Character:GetChildren()
			for i=1, #char do
				if char[i]:IsA('Part') or char[i]:IsA('BasePart') then
					char[i].Transparency = 1
				else
					-- not a part
				end
			end
			
		else
			-- Invisible
			local char = plr.Character:GetChildren()
			for i=1, #char do
				if char[i]:IsA('Part') or char[i]:IsA('BasePart') then
					char[i].Transparency = 0
				else
					-- not a part
				end
			end
		end
	else
		local char = game.Workspace[tostring(target)]
		if not (char:FindFirstChild('Head').Transparency == 1) then
			-- Not Invisible
			local chars = char:GetChildren()
			for i=1, #chars do
				if chars[i]:IsA('Part') or chars[i]:IsA('BasePart') then
					chars[i].Transparency = 1
				else
					-- not a part
				end
			end
			
		else
			-- Invisible 
			
			local chars = char:GetChildren()
			for i=1, #chars do
				if chars[i]:IsA('Part') or chars[i]:IsA('BasePart') then
					chars[i].Transparency = 0
				else
					-- not a part
				end
			end
			
		end
	end
	
end)
rep.Events.SetSpeed.OnServerEvent:Connect(function(plr, target)
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	if (target == nil) or (target == '') then
		
	end
end)

rep.Events.BTools.OnServerEvent:Connect(function(plr)
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	local backpack = plr.Backpack
	local btools = ss.Tools["Building Tools"]:Clone()
	btools.Parent = backpack
end)
rep.Events.ChatLog.OnServerEvent:Connect(function(plr)
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	
	local chatLog = ss.ChatLog:Clone()
	if not plr.PlayerGui:FindFirstChild('ChatLog') then
		chatLog.Parent = plr.PlayerGui
		chatLog.InInventory.Value = true
	else
		plr.PlayerGui:FindFirstChild('ChatLog'):Destroy()
	end
	
end)

rep.Events.ShowBans.OnServerEvent:Connect(function(plr)
	local perms = ModPerms(plr)
	if perms == true then
		
	else
		return
	end
	local newData = List:GetAsync("KEY_INDEX")
	local newChilds = plr.PlayerGui.BansList.Frame.ScrollingFrame:GetChildren()
	for i=1,#newChilds do
		if newChilds[i]:IsA('Frame') then
			newChilds[i]:Destroy()
		end
	end
	if newData then
		for key,value in pairs(newData) do
			local clone = rep.Guis.BanListTemplate:Clone()
			clone.Parent = plr.PlayerGui.BansList.Frame.ScrollingFrame
			clone.PlayerID.Text = key
		end
	end
end)



rep.Events.Unban.OnServerEvent:Connect(function(plr, target)
	local perms = ModPerms(plr)
	if perms == true then

	else
		return -- not a mod+
	end
	local BansListData = List
	local newData = List:GetAsync("KEY_INDEX")
	for key,value in pairs(newData) do
		if tostring(target) == key then
			local data = {}
			data = newData
			data[key] = nil

			BansListData:UpdateAsync("KEY_INDEX", function(oldData)
				local data = oldData or {}
				data[tostring(key)] = nil
				return data
			end)
			print('unbanning...')
			if TempBan:GetAsync(tonumber(target)) then
				TempBan:RemoveAsync(tonumber(target))
			end
			if DS:GetAsync(tonumber(target)) then
				DS:RemoveAsync(tonumber(target))
			end
			
			--print(BansListData:GetAsync("KEY_INDEX"))
			
			print('New Data :')
			print(game:GetService('DataStoreService'):GetDataStore('BansList'):GetAsync("KEY_INDEX"))
			
			local Info = {
				['content'] = ('Player : '.. target.. ' has been unbanned by : '..plr.Name..' , '..plr.UserId)
			}
			data = HttpService:JSONEncode(Info)
			HttpService:PostAsync(webhookurlunban, data)
		end
	end
end)





rep.Events.ServerLock.OnServerEvent:Connect(function(plr)
	local rank = IsAnAdamin(plr)
	if rank == false then
		return
	else
		
	end
	
	rep.ServerLocked.Value = true
end)
