local Camera = SceneMachine.Camera;
local Renderer = SceneMachine.Renderer;
local CameraController = SceneMachine.CameraController;
local Gizmos = SceneMachine.Gizmos;
local Input = SceneMachine.Input;
local Editor = SceneMachine.Editor;
local AM = SceneMachine.Editor.AnimationManager;

print("Running SceneMachine")

local TimeSinceLastUpdate = 0;
SceneMachine.time = 0;

------------------------
--	 	  Start  	  --
------------------------
function SceneMachine.Start()
	SceneMachine.Resources.Initialize("Interface\\AddOns\\scenemachine\\res");
    SceneMachine.Editor.Initialize();
    CameraController.Initialize();
    SceneMachine.CreateStatsFrame();
	Gizmos.Create();
	if (Debug) then Debug.Init(); end
end

local f = CreateFrame("Frame")

local function onevent(self, event, arg1, ...)
    if(event == "ADDON_LOADED" and arg1 == "scenemachine") then
        f:UnregisterEvent("ADDON_LOADED");
        --f:UnregisterEvent("PLAYER_LOGIN");
		SceneMachine.Start();
    end
end

f:RegisterEvent("ADDON_LOADED")
--f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", onevent)

------------------------
-------- UPDATE --------
------------------------
local qty = 0;
local currentAvgFPS = 0;
local resetAvgFPS = 0;
local fps = 0;
function UpdateCumulativeMovingAverageFPS(newFPS)
	-- delay by 5 seconds so we don't get wrong value at start
	if (SceneMachine.time > 5) then
		qty = qty + 1;
		currentAvgFPS = currentAvgFPS + (newFPS - currentAvgFPS)/qty;
	end
	-- reset the average calculation buffer every 5 seconds
	if (SceneMachine.time > resetAvgFPS) then
		resetAvgFPS = SceneMachine.time + 5;
		qty = 0;
		currentAvgFPS = 0;
	end
end

local function SG_UpdateLoop ()
    Renderer.active = true;
	if (SceneMachine.StatsFrame ~= nil and SceneMachine.StatsFrame.text ~= nil)
	then
		fps = GetFramerate();
		UpdateCumulativeMovingAverageFPS(fps);
		SceneMachine.StatsFrame.text:SetText(
			--"FrameBuffer : " .. SceneMachine.UsedFrames .. "/" .. SceneMachine.Renderer.FrameBufferSize .. ", Culled : " .. SceneMachine.CulledFrames .. "\n" ..
			"FPS : " .. floor(fps) .. " Avg. " .. floor(currentAvgFPS) .. "\n"
			--"Time : " .. floor(SceneMachine.time) .. "\n" ..
			--"Renderer : " .. tostring(Renderer.active)
		);
	end
	
	if SceneMachine.preRenderUpdateAction ~= nil then
		SceneMachine.preRenderUpdateAction();
	end

	if (Editor.isOpen) then
		--SceneMachine.deltaTime = 1.0 / GetFramerate();
		--print(GetFramerate())
		Editor.Update();
		Camera.Update();
		CameraController.Update();
		Input.Update();
		Gizmos.Update();
		Renderer.Update();
		AM.Update(SceneMachine.deltaTime);
		if (Debug) then Debug.FlushLinePool(); end
	end
end

local function SG_OnUpdate(self, elapsed)
	TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
	SceneMachine.deltaTime = elapsed;
	SceneMachine.time = SceneMachine.time + SceneMachine.deltaTime;
	SG_UpdateLoop();
end

local SG_UpdateFrame = CreateFrame("frame");
SG_UpdateFrame:SetScript("OnUpdate", SG_OnUpdate);

function SceneMachine.SetPreRenderUpdate(action)
	SceneMachine.preRenderUpdateAction = action;
end