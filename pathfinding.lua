-- the goal of this is that when the script  function(condition verified), the npc will choose random, location and will go to it.

repeat wait() until script.Parent.Parent.Name == 'Road'
local cr = script.Parent.OnRoadX.Value
script.Parent.HumanoidRootPart.CFrame = script.Parent.Parent[cr].CFrame
local work = game.Workspace
local currenttime = 0
local pathfindingService = game:GetService("PathfindingService")
local cango = false
local humanoid = script.Parent.Humanoid
local hrp = script.Parent.HumanoidRootPart
local currentroad = script.Parent.OnRoadX
local pathfindingService = game:GetService("PathfindingService")
function showPath(path)
	local waypoints = path:GetWaypoints()
	for _, waypoint in ipairs(waypoints) do
		local part = Instance.new("Part", game.Workspace)
		part.Shape = Enum.PartType.Ball
		part.Material = Enum.Material.Neon
		part.Anchored = true
		part.CanCollide = false
		part.Size = Vector3.new(5,5,5)
		part.Position = waypoint.Position
		part.Transparency = 0
		game:GetService("Debris"):AddItem(part, 5)

	end
end

function createPath(target)
	local agentParams = {
		AgentHeight = 2,
		AgentRadius = 1,
		AgentCanJump = true,
		Costs = {
			Plastic = 2000,
			Brick = 1,
			Granite = 5,
		},
	}

	local path = pathfindingService:CreatePath(agentParams)
	path:ComputeAsync(hrp.Position, target.Position)
	if path.Status == Enum.PathStatus.Success then
		local waypoints = path:GetWaypoints()
		return path, waypoints
	end
end

function main()
	local road1 = script.Parent.Parent.road1
	local road2 = script.Parent.Parent.road2
	
	local positions = {
		['road1'] = {math.random(road1.Position.X - (road1.Size.X/2),  road1.Position.X + (road1.Size.X/2)), road1.Position.Y+ 1,math.random(road1.Position.Z - (road1.Size.Z/2),  road1.Position.Z+ (road1.Size.Z/2))},
		['road2'] = {math.random(road2.Position.X - (road2.Size.X/2),  road2.Position.X + (road2.Size.X/2)), road2.Position.Y+ 1,math.random(road2.Position.Z - (road2.Size.Z/2),  road2.Position.Z+ (road2.Size.Z/2))},
	}
	local crossthewaychance = math.random(1,100)
	if crossthewaychance < 10 then
		if currentroad.Value == 'road1' then
			currentroad.Value = 'road2'
		elseif currentroad.Value == 'road2' then
			currentroad.Value = 'road1'			
		end		
	else
		currentroad = currentroad
	end
	
	--local posX = math.random(10,54)
	--local posZ = math.random(134, 139)
	--local PosY = 1.5
	local chosenRoad = positions[currentroad.Value]
	local newPart = Instance.new('Part')
	newPart.Anchored = true
	newPart.CanCollide = false
	newPart.Transparency = 1
	newPart.Name = 'NPCTarget'
	--warn(chosenRoad)
	--warn(positions)
	--warn()
	newPart.Position = Vector3.new(chosenRoad[1], chosenRoad[2], chosenRoad[3])
	newPart.Parent = workspace
	local target = newPart
	if target then
		local path,waypoints = createPath(target)
		if  path and waypoints then
			for _, waypoint in ipairs(waypoints) do
				if waypoint.Action == Enum.PathWaypointAction.Jump then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				humanoid:MoveTo(waypoint.Position)
				humanoid.MoveToFinished:Wait(2)
				cango = false
				newPart:Destroy()
			end 
		end
	end
	
	
end

while true do
	main()
	wait(6)
end
