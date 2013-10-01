local Plugin = PluginManager():CreatePlugin()
local Toolbar = Plugin:CreateToolbar("Plugins")
local ActivateButton = Toolbar:CreateButton("", "Tool Grip Editor", "wrench_hold.png")
local Mouse = Plugin:GetMouse()

local TRANSPARENCY = 0

local function Create(ty)
	return function(data)
		local obj = Instance.new(ty)
		for k, v in pairs(data) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

local DummyTemplate = Create'Model'{
	Name = "Dummy";
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		TopSurface = Enum.SurfaceType.Smooth;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(2, 1, 1);
		formFactor = Enum.FormFactor.Symmetric;
		CFrame = CFrame.new(0, 4.5, -0.5, -1, 0, 0, 0, 1, 0, 0, 0, -1);
		Name = "Head";
		Locked = true;
		Create'SpecialMesh'{
			Scale = Vector3.new(1.25, 1.25, 1.25);
		};
	};
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(1, 2, 1);
		formFactor = Enum.FormFactor.Symmetric;
		CFrame = CFrame.new(1.5, 3, -0.5, -1, 0, 0, 0, 1, 0, 0, 0, -1);
		Name = "Left Arm";
		Locked = true;
		Create'SpecialMesh'{
			MeshType = Enum.MeshType.FileMesh;
			MeshId = "http://www.roblox.com/asset/?id=27111419";
		};
	};
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(1, 2, 1);
		formFactor = Enum.FormFactor.Symmetric;
		BottomSurface = Enum.SurfaceType.Smooth;
		CFrame = CFrame.new(0.5, 1, -0.5, -1, 0, 0, 0, 1, 0, 0, 0, -1);
		Name = "Left Leg";
		Locked = true;
		Create'SpecialMesh'{
			MeshType = Enum.MeshType.FileMesh;
			MeshId = "http://www.roblox.com/asset/?id=27111857";
		};
	};
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(1, 2, 1);
		formFactor = Enum.FormFactor.Symmetric;
		CFrame = CFrame.new(-1.5, 3.5, 0, -0.99999994, -0, 0, 0, -4.37113883e-008, -1, 0, -1, 4.37113883e-008);
		Name = "Right Arm";
		Locked = true;
		Create'SpecialMesh'{
			MeshType = Enum.MeshType.FileMesh;
			MeshId = "http://www.roblox.com/asset/?id=27111864";
		};
	};
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(1, 2, 1);
		formFactor = Enum.FormFactor.Symmetric;
		BottomSurface = Enum.SurfaceType.Smooth;
		CFrame = CFrame.new(-0.5, 1, -0.5, -1, 0, 0, 0, 1, 0, 0, 0, -1);
		Name = "Right Leg";
		Locked = true;
		Create'SpecialMesh'{
			MeshType = Enum.MeshType.FileMesh;
			MeshId = "http://www.roblox.com/asset/?id=27111882";
		};
	};
	Create'Part'{
		Anchored = true;
		Transparency = TRANSPARENCY;
		BrickColor = BrickColor.new(1002);
		Size = Vector3.new(2, 2, 1);
		formFactor = Enum.FormFactor.Symmetric;
		CFrame = CFrame.new(0, 3, -0.5, -1, 0, -0, -0, 1, -0, -0, 0, -1);
		Name = "Torso";
		Locked = true;
		Create'SpecialMesh'{
			MeshType = Enum.MeshType.FileMesh;
			MeshId = "http://www.roblox.com/asset/?id=27111894";
		};
	};
};

local OverlayTemplate = Create'Part'{
	FormFactor = 'Symmetric';
	Locked = true;
}
local HandlesTemplate = Create'Handles'{
	Color = BrickColor.new("Bright orange");
	Style = 'Resize';
}
local ArcHandlesTemplate = Create'ArcHandles'{
	Color = BrickColor.new("Br. yellowish green");
}

local function CameraLookAt(cf)
	local Camera = Workspace.CurrentCamera
	Camera.Focus = cf
	Camera.CoordinateFrame = CFrame.new(Camera.CoordinateFrame.p,cf.p)
end

local function Snap(number,by)
	if by == 0 then
		return number
	else
		return math.floor(number/by + 0.5)*by
	end
end

local CoreGui = Game:GetService("CoreGui")
local OFFSET = CFrame.new(0, -1, 0, 1, 0, -0, 0, 0, 1, 0, -1, -0)
local currentObjects = {}
local function HandleTool(tool,handle)
	local dummy = DummyTemplate:Clone()
	table.insert(currentObjects,dummy)
	dummy.Archivable = false

	local arm = dummy["Right Arm"]

	dummy.Parent = Workspace
	dummy:MoveTo(handle.Position)

	local dummyHandle = handle:Clone()
	dummyHandle.Archivable = false
	dummyHandle.Locked = true;
	dummyHandle.Anchored = true;
	dummyHandle.Transparency = TRANSPARENCY;
	dummyHandle.CFrame = arm.CFrame * OFFSET * tool.Grip:inverse()
	dummyHandle.Parent = dummy

	do
		local overlay = OverlayTemplate:Clone()
		table.insert(currentObjects,overlay)
		overlay.Size = Vector3.new(4,4,4)
		dummyHandle.Changed:connect(function(p)
			overlay.CFrame = dummyHandle.CFrame
		end)
		overlay.CFrame = dummyHandle.CFrame

		local handles = HandlesTemplate:Clone()
		table.insert(currentObjects,handles)
		handles.Archivable = false
		handles.Adornee = overlay
		local origin
		handles.MouseButton1Down:connect(function(face)
		--	origin = dummyHandle.CFrame
			origin = tool.Grip:inverse()
		end)
		handles.MouseDrag:connect(function(face,distance)
			local rdis = distance
			local pos = Vector3.FromNormalId(face)*rdis
		--	dummyHandle.CFrame = origin + pos
			tool.Grip = (origin * CFrame.new(pos)):inverse()
			dummyHandle.CFrame = arm.CFrame * OFFSET * tool.Grip:inverse()
		end)
		handles.Parent = CoreGui
	end
	do
		local overlay = OverlayTemplate:Clone()
		table.insert(currentObjects,overlay)
		overlay.Size = Vector3.new(1,1,1)
		dummyHandle.Changed:connect(function(p)
			overlay.CFrame = dummyHandle.CFrame
		end)
		overlay.CFrame = dummyHandle.CFrame

		local arcHandles = ArcHandlesTemplate:Clone()
		table.insert(currentObjects,arcHandles)
		arcHandles.Archivable = false
		arcHandles.Adornee = overlay
		local origin
		arcHandles.MouseButton1Down:connect(function(axis)
		--	origin = dummyHandle.CFrame
			origin = tool.Grip:inverse()
		end)
		arcHandles.MouseDrag:connect(function(axis,angle)
			local rdis = angle
			local snapped = Snap(angle,math.pi/2)
			if math.abs(angle - snapped) < math.pi/64 then
				rdis = snapped
			end
			local a = Vector3.FromAxis(axis)*rdis
			local new = CFrame.Angles(a.x,a.y,a.z)
		--	dummyHandle.CFrame = origin * new
			tool.Grip = (origin * new):inverse()
			dummyHandle.CFrame = arm.CFrame * OFFSET * tool.Grip:inverse()
		end)
		arcHandles.Parent = CoreGui
	end
	CameraLookAt(dummyHandle.CFrame)
end

local function CleanUp()
	for k,object in pairs(currentObjects) do
		object:Destroy()
	end
end

local pluginActive = false
local Selection = Game:GetService("Selection")
local function CheckSelection()
	if pluginActive then
		CleanUp()
		local tool = Selection:Get()[1]
		if tool and tool:IsA"Tool" then
			local handle = tool:FindFirstChild("Handle")
			if handle and handle:IsA"BasePart" then
				HandleTool(tool,handle)
			end
		end
	end
end
Selection.SelectionChanged:connect(CheckSelection)

local function Activate()
	pluginActive = true
	Plugin:Activate(true)
	ActivateButton:SetActive(true)
	CheckSelection()
end

local function Deactivate()
	pluginActive = false
	ActivateButton:SetActive(false)
	CleanUp()
end

ActivateButton.Click:connect(function()
	if pluginActive then
		Deactivate()
	else
		Activate()
	end
end)

Plugin.Deactivation:connect(Deactivate)
