local bDebug    = false
local fForward  = 1330.7950439453
local fYaw      = 2.6412308216095e-005
local fRoll     = 1.583224773407
local fUpOffset = 48

function OnStart()
    --RenderAddActor("login", "login002")
    ActorAdd("login", "login_snbyxrjm001")
    ActorPlayPose("login", "scene", true)

    CameraSetProjParams(42, 0, 5.0, 6000.0);
    CameraSetPitch(0);
    CameraSetYaw(fYaw);
    CameraSetRoll(fRoll);
    CameraSetForward(fForward);
    CameraSetUpOffset(fUpOffset);

    StageOutputLog("FM CrateRole OnStart");
end

function OnStop()
    StageOutputLog("FM CrateRole OnStop");
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

    RenderSetEnvLight(70, 70, 100)
    RenderSetBaseColor(0, 0, 0)

    RenderEnableLight(true)
    RenderSetDirLight(0, 150, 150, 150, -1, 1, -1)
    RenderSetDirLight(1, 0, 0, 100, 1, 1, -1)

    RenderEnableFog(true)
    RenderSetFog(100, 100, 250, 0, 10000)
end

function OnAfterRender() -- 结束渲染场景
    if bDebug then
        RenderText(10, 10, 255, 0, 255, "forward "..fForward.."\nyaw     "..fYaw.."\nroll    "..fRoll.."\nup      "..fUpOffset)
    end
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