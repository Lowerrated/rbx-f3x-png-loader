local function gettool()
	local tools = {}
	local thetool
	for _, v in pairs(game:GetService("Players").LocalPlayer:GetDescendants()) do
		if v:IsA("Tool") then
			table.insert(tools, v)
		end
	end
	for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			table.insert(tools, v)
		end
	end
	for _, tool in pairs(tools) do
		local handle = tool:FindFirstChild("Handle")
		if handle then
			local decal = handle:FindFirstChildOfClass("Decal")
			if decal then
				if string.find(decal.Texture, "129748355") then
					thetool = tool
				end
			end
		end
	end
	return thetool
end
local ScreenGui = Instance.new("ScreenGui")
local l__InputUrl__1 = Instance.new("TextBox");
local ServerEndpoint = gettool():WaitForChild("SyncAPI"):WaitForChild("ServerEndpoint")
local CorePackagesFolder = Instance.new("Folder")
CorePackagesFolder.Parent = workspace
CorePackagesFolder.Name = "PNGLoaderModule"
ScreenGui.Parent = game:GetService("CoreGui")
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	ServerEndpoint = gettool():WaitForChild("SyncAPI"):WaitForChild("ServerEndpoint")
end)
l__InputUrl__1.Parent = ScreenGui
l__InputUrl__1.Size = UDim2.new(1, 0, 0.025, 0)
l__InputUrl__1.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
l__InputUrl__1.Font = Enum.Font.SourceSansBold
l__InputUrl__1.TextScaled = true
l__InputUrl__1.PlaceholderText = "Paste the URL to a PNG file here."
l__InputUrl__1.Name = "InputUrl"
l__InputUrl__1.TextColor3 = Color3.fromRGB(0, 0, 0)
l__InputUrl__1.AnchorPoint = Vector2.new(0, 1)
l__InputUrl__1.Position = UDim2.new(0, 0, 1, 0)
l__InputUrl__1.Text = ""
local l__GetPngFile__2 = {
	InvokeServer = function(link)
		local returning
		local success, err = pcall(function()
			returning = game:HttpGetAsync(link)
		end)
		if success then
			return true, returning
		end
		if err then
			return false, err
		end
	end,
}
local function u3(p1)
	local v3 = "[Error] " .. tostring(p1);
	l__InputUrl__1.Text = v3;
	l__InputUrl__1.TextColor3 = Color3.new(1, 0, 0);
	delay(2, function()
		if l__InputUrl__1.Text == v3 then
			l__InputUrl__1.Text = "";
		end;
	end);
end;
for _, v in pairs(game:GetObjects("rbxassetid://11306417113")[1]:GetChildren()) do
	v:Clone().Parent = CorePackagesFolder
end
local u4 = loadstring("local script = game.".. CorePackagesFolder:GetFullName().. "\n" ..game:GetObjects("rbxassetid://11306417113")[1].Source)();
local l__RunService__5 = game:GetService("RunService");
l__InputUrl__1.Focused:Connect(function()
	l__InputUrl__1.TextColor3 = Color3.new(1, 1, 1);
end);
l__InputUrl__1.FocusLost:Connect(function(enter)
	if enter then
		local v4 = nil;
		local link = l__InputUrl__1.Text
		l__InputUrl__1.Text = "Loading...";
		local v5 = nil;
		v5, v4 = l__GetPngFile__2.InvokeServer(link);
		if not v5 then
			u3(v4);
			return;
		end;
		local v6, v7 = pcall(function()
			return u4.new(v4);
		end);
		if not v6 then
			u3(v7);
			return;
		end;
		local v8 = 0;
		local l__Width__9 = v7.Width;
		local l__Height__10 = v7.Height;
		local v11 = Vector3.new(-l__Width__9 / 2, 0, -l__Height__10 / 2);
		local at = game:GetService("Players").LocalPlayer.Character.Head.Position
		local v12 = ServerEndpoint:InvokeServer("CreateGroup", "Model", workspace, {})
		ServerEndpoint:InvokeServer("SetName", {v12}, "_PNG")
		local v13 = true;
		for v14 = 1, l__Height__10 do
			for v15 = 1, l__Width__9 do
				local v16, v17 = v7:GetPixel(v15, v14);
				if v17 > 0 then
					spawn(function()
						local v18 = (1 + 5 * (v16.r * 0.2126 + v16.g * 0.7152 + v16.b * 0.0722)) * (v17 / 255);
						local v19 = ServerEndpoint:InvokeServer("CreatePart", "Normal", CFrame.new(), v12)
						local transparency = 1 - v17 / 255
						v19.Position = at + v11 + Vector3.new(v15, v18 / 2, v14);
						ServerEndpoint:InvokeServer("SyncMove", {{CFrame = v19.CFrame, Part = v19}})
						if transparency > 0 then
							ServerEndpoint:InvokeServer("SyncMaterial", {{Part = v19, Transparency = transparency}})
						end
						ServerEndpoint:InvokeServer("SyncResize", {{CFrame = v19.CFrame, Part = v19, Size = Vector3.new(1, v18, 1)}})
						ServerEndpoint:InvokeServer("SyncColor", {{Color = v16, Part = v19, UnionColoring = true}})
						v8 = v8 + 1;
						if v8 % 1000 == 0 then
							l__RunService__5.Heartbeat:Wait();
						end;
					end)
				end;
				if v12.Parent ~= workspace then
					break;
				end;
			end;
			if v12.Parent ~= workspace then
				v13 = false;
				break;
			end;
		end;
		if v13 and not l__InputUrl__1:IsFocused() then
			l__InputUrl__1.Text = "Done!";
			l__InputUrl__1.TextColor3 = Color3.new(0, 1, 0);
			wait(1);
			if l__InputUrl__1.Text == "Done!" and not l__InputUrl__1:IsFocused() then
				l__InputUrl__1.Text = "";
			end;
		end;
	end
end);
