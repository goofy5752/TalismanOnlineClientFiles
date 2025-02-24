local bDebug    = false
local fForward  = 313.19631958008
local fYaw      = 2.676248550415e-005
local fRoll     = 7.8140516281128
local fUpOffset = 17.5

function OnStart()
    --RenderAddActor("login", "login002")
    ActorAdd("login", "login_xq001")
    ActorPlayPose("login", "scene", true)

    CameraSetProjParams(50, 1.333, 5.0, 6000.0);
    CameraSetPitch(0);
    CameraSetYaw(fYaw);
    CameraSetRoll(fRoll);
    CameraSetForward(fForward);
    CameraSetUpOffset(fUpOffset);

    StageOutputLog("SelectChar OnStart");
end

function OnStop()
    StageOutputLog("SelectChar OnStop");
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

    RenderSetEnvLight(127, 127, 127)
    RenderSetBaseColor(0, 0, 0)

    RenderEnableLight(true)
    RenderSetDirLight(0, 50, 50, 50, 1, 1, 1)
    RenderSetDirLight(1, 150, 150, 150, 1, 1, 1)

    RenderEnableFog(true)
    RenderSetFog(214, 214, 195, 150, 2000)
end

function OnAfterRender()
    if bDebug then
        RenderText(10, 10, 255, 0, 255, "forward "..fForward.."\nyaw     "..fYaw.."\nroll    "..fRoll.."\nup      "..fUpOffset)
    end
end

function OnKeyDown(iKey)
end

function OnBeforeRenderRole() -- 开始渲染角色
    --RenderEnableLight(bool b);
    --RenderSetDirLight(int i, int r, int g, int b, float dx, float dy, float dz)
    --RenderSetEnvLight(int r, int g, int b)
    --RenderEnableFog(bool b)
    --RenderSetFog(int r, int g, int b, float fNear, float fFar)
    --RenderSetBaseColor(int r, int g, int b)

    RenderSetEnvLight(70, 70, 100)
    RenderSetBaseColor(0, 0, 0)

    RenderEnableLight(true)
    RenderSetDirLight(0, 150, 150, 150, 0, 1, -0.1)
    RenderSetDirLight(1, 50, 50, 50, 0, 1, 0)

    RenderEnableFog(true)
    RenderSetFog(256, 256, 256, 400, 5000)
end

function OnAfterRenderRole() -- 结束渲染角色
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