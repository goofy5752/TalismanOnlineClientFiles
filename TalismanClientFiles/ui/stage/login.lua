local bDebug    = false
local fForward  = 370.00210571289
local fYaw      = -0.7501380443573
local fRoll     = 4.1629686355591
local fUpOffset = 241

function OnStart()
    --RenderAddActor("login", "sdl_lintest")
    ActorAdd("login", "login001")
    ActorPlayPose("login", "scene", true)

    CameraSetProjParams(50, 1.333, 5.0, 10000.0);
    CameraSetPitch(0);
    CameraSetYaw(fYaw);
    CameraSetRoll(fRoll);
    CameraSetForward(fForward);
    CameraSetUpOffset(fUpOffset);

    PlayMusic("thematic.ogg");

    StageOutputLog("Login OnStart");
end

function OnStop()
    StageOutputLog("Login OnStop");
end

local iFogR = 104;
local iFogG = 165;
local iFogB = 247;

--local iFogRi = 17;
--local iFogGi = 157;
--local iFogBi = 236;

function OnTick(iDelta)
    --StageOutputLog("OnTick");
end

function OnBeforeRender() -- 开始渲染场景
    --RenderEnableLight(bool b);
    --RenderSetDirLight(int i, int r, int g, int b, float dx, float dy, float dz)
    --RenderSetEnvLight(int r, int g, int b)
    --RenderEnableFog(bool b)
    --RenderSetFog(int r, int g, int b, float fNear, float fFar)
    --RenderSetBaseColor(int r, int g, int b)

    RenderSetEnvLight(150, 150, 150)
    RenderSetBaseColor(0, 0, 0)

    RenderEnableLight(false)
    RenderSetDirLight(0, 150, 150, 150, -1, 1, -1)
    RenderSetDirLight(1, 0, 0, 100, 1, 1, -1)

    RenderEnableFog(false)
    RenderSetFog(255, 255, 255, 0, 10000)
end

function OnAfterRender() -- 结束渲染场景
    if bDebug then
        RenderText(10, 10, 255, 0, 255, "forward "..fForward.."\nyaw     "..fYaw.."\nroll    "..fRoll.."\nup      "..fUpOffset)
    end
end

function OnKeyDown(iKey)
end

function OnMouseWheel(iDelta)
    if bDebug then
        fForward = fForward + iDelta*0.01
        CameraSetForward(fForward);
    end
end

function OnMouseLDown(x, y)
end

function OnMouseLUp(x, y)
end

function OnMouseLDrag(x, y, ix, iy)
    if bDebug then
        fYaw = fYaw + 3.14159*ix/180.0
        fRoll = fRoll - 3.14159*iy/180.0
        CameraSetYaw(fYaw);
        CameraSetRoll(fRoll);
    end
end

function OnMouseRDrag(x, y, ix, iy)
    if bDebug then
        fUpOffset = fUpOffset - iy;
        CameraSetUpOffset(fUpOffset);
    end
end
