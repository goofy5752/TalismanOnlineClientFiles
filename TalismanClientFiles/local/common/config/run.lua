OpenFlag = 1; --系统是否开放, 1 : 开放, 0 : 关闭

MatchLastTime = 120 * 60;

MatchBeginTime = 0;
MatchState = 0;

TransportNpc1 = 0;
Door1 = 0;

TransportNpc2 = 0;
Door2 = 0;

Match1MaxSendMedia = 5;
Match2MaxSendMedia = 5;

function OnBeginRun()

    MatchState = 1
    MatchBeginTime = NowSecond()
    
    local PathNodeNpcId = 0
    --初级赛跑路线
    PathNodeNpcId = CreateSceneNpc(1, 5311, 338, -479, 0)
    AddPathNpc(0, 0, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 302, -472, 0)
    AddPathNpc(0, 1, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 300, -427, 0)
    AddPathNpc(0, 2, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 308, -391, 0)
    AddPathNpc(0, 3, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 303, -343, 0)
    AddPathNpc(0, 4, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 313, -300, 0)
    AddPathNpc(0, 5, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 304, -259, 0)
    AddPathNpc(0, 6, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 292, -220, 0)
    AddPathNpc(0, 7, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 287, -183, 0)
    AddPathNpc(0, 8, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 290, -141, 0)
    AddPathNpc(0, 9, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 303, -97, 0)
    AddPathNpc(0, 10, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 329, -101, 0)
    AddPathNpc(0, 11, PathNodeNpcId)


PathNodeNpcId = CreateSceneNpc(1, 5311, 357, -106, 0)
    AddPathNpc(0, 12, PathNodeNpcId)


PathNodeNpcId = CreateSceneNpc(1, 5311, 382, -98, 0)
    AddPathNpc(0, 13, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 407, -78, 0)
    AddPathNpc(0, 14, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 405, -48, 0)
    AddPathNpc(0, 15, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 403, -13, 0)
    AddPathNpc(0, 16, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 395, 25, 0)
    AddPathNpc(0, 17, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 377, 62, 0)
    AddPathNpc(0, 18, PathNodeNpcId)



local rad = math.random(1,2)
if rad == 1 then
    PathNodeNpcId = CreateSceneNpc(1, 5311, 387, 102, 0)
    AddPathNpc(0, 19, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 387, 144, 0)
    AddPathNpc(0, 20, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 346, 170, 0)
    AddPathNpc(0, 21, PathNodeNpcId)
else
    PathNodeNpcId = CreateSceneNpc(1, 5311, 348, 79, 0)
    AddPathNpc(0, 19, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 330, 115, 0)
    AddPathNpc(0, 20, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 331, 157, 0)
    AddPathNpc(0, 21, PathNodeNpcId)
end

PathNodeNpcId = CreateSceneNpc(1, 5311, 306, 189, 0)
    AddPathNpc(0, 22, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 272, 156, 0)
    AddPathNpc(0, 23, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 238, 130, 0)
    AddPathNpc(0, 24, PathNodeNpcId)


local rad = math.random(1,2)
if rad == 1 then
    PathNodeNpcId = CreateSceneNpc(1, 5311, 195, 107, 0)
    AddPathNpc(0, 25, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 148, 103, 0)
    AddPathNpc(0, 26, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 113, 130, 0)
    AddPathNpc(0, 27, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 92, 171, 0)
    AddPathNpc(0, 28, PathNodeNpcId)
else
    PathNodeNpcId = CreateSceneNpc(1, 5311, 218, 136, 0)
    AddPathNpc(0, 25, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 176, 143, 0)
    AddPathNpc(0, 26, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 155, 180, 0)
    AddPathNpc(0, 27, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5311, 118, 188, 0)
    AddPathNpc(0, 28, PathNodeNpcId)
end


PathNodeNpcId = CreateSceneNpc(1, 5311, 107, 212, 0)
    AddPathNpc(0, 29, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 98, 247, 0)
    AddPathNpc(0, 30, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 99, 287, 0)
    AddPathNpc(0, 31, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 97, 325, 0)
    AddPathNpc(0, 32, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 106, 359, 0)
    AddPathNpc(0, 33, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 120, 393, 0)
    AddPathNpc(0, 34, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 133, 424, 0)
    AddPathNpc(0, 35, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 151, 452, 0)
    AddPathNpc(0, 36, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 152, 484, 0)
    AddPathNpc(0, 37, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 152, 524, 0)
    AddPathNpc(0, 38, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 151, 561, 0)
    AddPathNpc(0, 39, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 141, 595, 0)
    AddPathNpc(0, 40, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 148, 631, 0)
    AddPathNpc(0, 41, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 148, 664, 0)
    AddPathNpc(0, 42, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 144, 701, 0)
    AddPathNpc(0, 43, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 143, 740, 0)
    AddPathNpc(0, 44, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 139, 779, 0)
    AddPathNpc(0, 45, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 131, 814, 0)
    AddPathNpc(0, 46, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 126, 852, 0)
    AddPathNpc(0, 47, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 109, 880, 0)
    AddPathNpc(0, 48, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 101, 913, 0)
    AddPathNpc(0, 49, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 123, 939, 0)
    AddPathNpc(0, 50, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5311, 138, 967, 0)
    AddPathNpc(0, 51, PathNodeNpcId)

    PathNodeNpcId = CreateSceneNpc(1, 5310, 142, 1016, 0)
    AddPathNpc(0, 52, PathNodeNpcId)
    
    --高级赛跑路线
    PathNodeNpcId = CreateSceneNpc(1, 5316, 127, -527, 0)
    AddPathNpc(1, 0, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, 127, -507, 0)
    AddPathNpc(1, 1, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, 110, -500, 0)
    AddPathNpc(1, 2, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, 72, -500, 0)
    AddPathNpc(1, 3, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, 33, -500, 0)
    AddPathNpc(1, 4, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, 12, -495, 0)
    AddPathNpc(1, 5, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -13, -488, 0)
    AddPathNpc(1, 6, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -44, -509, 0)
    AddPathNpc(1, 7, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -76, -528, 0)
    AddPathNpc(1, 8, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -110, -531, 0)
    AddPathNpc(1, 9, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -143, -524, 0)
    AddPathNpc(1, 10, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -170, -508, 0)
    AddPathNpc(1, 11, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -202, -500, 0)
    AddPathNpc(1, 12, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -237, -495, 0)
    AddPathNpc(1, 13, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -277, -495, 0)
    AddPathNpc(1, 14, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -315, -501, 0)
    AddPathNpc(1, 15, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -326, -532, 0)
    AddPathNpc(1, 16, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -325, -566, 0)
    AddPathNpc(1, 17, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -325, -599, 0)
    AddPathNpc(1, 18, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -340, -630, 0)
    AddPathNpc(1, 19, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -372, -653, 0)
    AddPathNpc(1, 20, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -410, -668, 0)
    AddPathNpc(1, 21, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -449, -682, 0)
    AddPathNpc(1, 22, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -473, -707, 0)
    AddPathNpc(1, 23, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -467, -741, 0)
    AddPathNpc(1, 24, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -457, -773, 0)
    AddPathNpc(1, 25, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -442, -810, 0)
    AddPathNpc(1, 26, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -436, -848, 0)
    AddPathNpc(1, 27, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -442, -885, 0)
    AddPathNpc(1, 28, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -477, -898, 0)
    AddPathNpc(1, 29, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -510, -912, 0)
    AddPathNpc(1, 30, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -546, -920, 0)
    AddPathNpc(1, 31, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -574, -939, 0)
    AddPathNpc(1, 32, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -590, -966, 0)
    AddPathNpc(1, 33, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -602, -999, 0)
    AddPathNpc(1, 34, PathNodeNpcId)



local rad = math.random(1,2)
if rad == 1 then
    PathNodeNpcId = CreateSceneNpc(1, 5316, -600, -1024, 0)
    AddPathNpc(1, 35, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -599, -1047, 0)
    AddPathNpc(1, 36, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -601, -1068, 0)
    AddPathNpc(1, 37, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -621, -1079, 0)
    AddPathNpc(1, 38, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -643, -1082, 0)
    AddPathNpc(1, 39, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -662, -1079, 0)
    AddPathNpc(1, 40, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -685, -1071, 0)
    AddPathNpc(1, 41, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -711, -1070, 0)
    AddPathNpc(1, 42, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -738, -1070, 0)
    AddPathNpc(1, 43, PathNodeNpcId)
else
    PathNodeNpcId = CreateSceneNpc(1, 5316, -625, -1004, 0)
    AddPathNpc(1, 35, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -647, -1005, 0)
    AddPathNpc(1, 36, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -669, -1004, 0)
    AddPathNpc(1, 37, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -692, -999, 0)
    AddPathNpc(1, 38, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -710, -982, 0)
    AddPathNpc(1, 39, PathNodeNpcId)
    pathNodeNpcId = CreateSceneNpc(1, 5316, -733, -987, 0)
    AddPathNpc(1, 40, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -744, -1008, 0)
    AddPathNpc(1, 41, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -752, -1030, 0)
    AddPathNpc(1, 42, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -757, -1054, 0)
    AddPathNpc(1, 43, PathNodeNpcId)
end



PathNodeNpcId = CreateSceneNpc(1, 5316, -765, -1078, 0)
    AddPathNpc(1, 44, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -786, -1093, 0)
    AddPathNpc(1, 45, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -807, -1107, 0)
    AddPathNpc(1, 46, PathNodeNpcId)



local rad = math.random(1,2)
if rad == 1 then
    PathNodeNpcId = CreateSceneNpc(1, 5316, -828, -1105, 0)
    AddPathNpc(1, 47, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -848, -1112, 0)
    AddPathNpc(1, 48, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -864, -1127, 0)
    AddPathNpc(1, 49, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -882, -1138, 0)
    AddPathNpc(1, 50, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -901, -1148, 0)
    AddPathNpc(1, 51, PathNodeNpcId)
else
    pathNodeNpcId = CreateSceneNpc(1, 5316, -828, -1128, 0)
    AddPathNpc(1, 47, PathNodeNpcId)
    pathNodeNpcId = CreateSceneNpc(1, 5316, -831, -1162, 0)
    AddPathNpc(1, 48, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -847, -1189, 0)
    AddPathNpc(1, 49, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -882, -1187, 0)
    AddPathNpc(1, 50, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -905, -1168, 0)
    AddPathNpc(1, 51, PathNodeNpcId)
end



PathNodeNpcId = CreateSceneNpc(1, 5316, -921, -1144, 0)
    AddPathNpc(1, 52, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -930, -1122, 0)
    AddPathNpc(1, 53, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -927, -1099, 0)
    AddPathNpc(1, 54, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -919, -1077, 0)
    AddPathNpc(1, 55, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -931, -1061, 0)
    AddPathNpc(1, 56, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -942, -1045, 0)
    AddPathNpc(1, 57, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -937, -1023, 0)
    AddPathNpc(1, 58, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -934, -1000, 0)
    AddPathNpc(1, 59, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -941, -980, 0)
    AddPathNpc(1, 60, PathNodeNpcId)
    
PathNodeNpcId = CreateSceneNpc(1, 5316, -957, -965, 0)
    AddPathNpc(1, 61, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -964, -944, 0)
    AddPathNpc(1, 62, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -980, -920, 0)
    AddPathNpc(1, 63, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1009, -913, 0)
    AddPathNpc(1, 64, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1033, -897, 0)
    AddPathNpc(1, 65, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1064, -876, 0)
    AddPathNpc(1, 66, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1099, -865, 0)
    AddPathNpc(1, 67, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1133, -868, 0)
    AddPathNpc(1, 68, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1163, -874, 0)
    AddPathNpc(1, 69, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1194, -877, 0)
    AddPathNpc(1, 70, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1207, -903, 0)
    AddPathNpc(1, 71, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1207, -936, 0)
    AddPathNpc(1, 72, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1190, -961, 0)
    AddPathNpc(1, 73, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1172, -985, 0)
    AddPathNpc(1, 74, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1168, -1019, 0)
    AddPathNpc(1, 75, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1161, -1055, 0)
    AddPathNpc(1, 76, PathNodeNpcId)





local rad = math.random(1,2)
if rad == 1 then
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1129, -1073, 0)
    AddPathNpc(1, 77, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1092, -1084, 0)
    AddPathNpc(1, 78, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1073, -1117, 0)
    AddPathNpc(1, 79, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1070, -1153, 0)
    AddPathNpc(1, 80, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1068, -1190, 0)
    AddPathNpc(1, 81, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1079, -1229, 0)
    AddPathNpc(1, 82, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1115, -1248, 0)
    AddPathNpc(1, 83, PathNodeNpcId)
else
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1183, -1074, 0)
    AddPathNpc(1, 77, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1208, -1095, 0)
    AddPathNpc(1, 78, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1218, -1111, 0)
    AddPathNpc(1, 79, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1217, -1142, 0)
    AddPathNpc(1, 80, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1218, -1175, 0)
    AddPathNpc(1, 81, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1212, -1224, 0)
    AddPathNpc(1, 82, PathNodeNpcId)
    PathNodeNpcId = CreateSceneNpc(1, 5316, -1182, -1252, 0)
    AddPathNpc(1, 83, PathNodeNpcId)
end


PathNodeNpcId = CreateSceneNpc(1, 5316, -1138, -1279, 0)
    AddPathNpc(1, 84, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1127, -1318, 0)
    AddPathNpc(1, 85, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1092, -1331, 0)
    AddPathNpc(1, 86, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1083, -1367, 0)
    AddPathNpc(1, 87, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1076, -1395, 0)
    AddPathNpc(1, 88, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1070, -1430, 0)
    AddPathNpc(1, 89, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1055, -1452, 0)
    AddPathNpc(1, 90, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1035, -1473, 0)
    AddPathNpc(1, 91, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1021, -1496, 0)
    AddPathNpc(1, 92, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1014, -1519, 0)
    AddPathNpc(1, 93, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1012, -1545, 0)
    AddPathNpc(1, 94, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1032, -1560, 0)
    AddPathNpc(1, 95, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1053, -1544, 0)
    AddPathNpc(1, 96, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1076, -1529, 0)
    AddPathNpc(1, 97, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1105, -1525, 0)
    AddPathNpc(1, 98, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1132, -1525, 0)
    AddPathNpc(1, 99, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1156, -1537, 0)
    AddPathNpc(1, 100, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1160, -1566, 0)
    AddPathNpc(1, 101, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1163, -1603, 0)
    AddPathNpc(1, 102, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1183, -1623, 0)
    AddPathNpc(1, 103, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1218, -1626, 0)
    AddPathNpc(1, 104, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1221, -1647, 0)
    AddPathNpc(1, 105, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1221, -1670, 0)
    AddPathNpc(1, 106, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1220, -1695, 0)
    AddPathNpc(1, 107, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1201, -1714, 0)
    AddPathNpc(1, 108, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1174, -1714, 0)
    AddPathNpc(1, 109, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1145, -1712, 0)
    AddPathNpc(1, 110, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1122, -1705, 0)
    AddPathNpc(1, 111, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1099, -1718, 0)
    AddPathNpc(1, 112, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1070, -1714, 0)
    AddPathNpc(1, 113, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1041, -1710, 0)
    AddPathNpc(1, 114, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1006, -1715, 0)
    AddPathNpc(1, 115, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -971, -1703, 0)
    AddPathNpc(1, 116, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -937, -1696, 0)
    AddPathNpc(1, 117, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -907, -1713, 0)
    AddPathNpc(1, 118, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -870, -1716, 0)
    AddPathNpc(1, 119, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -865, -1754, 0)
    AddPathNpc(1, 120, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -861, -1791, 0)
    AddPathNpc(1, 121, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -860, -1827, 0)
    AddPathNpc(1, 122, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -857, -1865, 0)
    AddPathNpc(1, 123, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -853, -1896, 0)
    AddPathNpc(1, 124, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -850, -1932, 0)
    AddPathNpc(1, 125, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -837, -1962, 0)
    AddPathNpc(1, 126, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -863, -1980, 0)
    AddPathNpc(1, 127, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -894, -1968, 0)
    AddPathNpc(1, 128, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -931, -1969, 0)
    AddPathNpc(1, 129, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -967, -1969, 0)
    AddPathNpc(1, 130, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -999, -1980, 0)
    AddPathNpc(1, 131, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1033, -1976, 0)
    AddPathNpc(1, 132, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1065, -1984, 0)
    AddPathNpc(1, 133, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1094, -1975, 0)
    AddPathNpc(1, 134, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1104, -1945, 0)
    AddPathNpc(1, 135, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1103, -1916, 0)
    AddPathNpc(1, 136, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1082, -1890, 0)
    AddPathNpc(1, 137, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1082, -1855, 0)
    AddPathNpc(1, 138, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1111, -1834, 0)
    AddPathNpc(1, 139, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1144, -1820, 0)
    AddPathNpc(1, 140, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1180, -1795, 0)
    AddPathNpc(1, 141, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1219, -1797, 0)
    AddPathNpc(1, 142, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1219, -1839, 0)
    AddPathNpc(1, 143, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1220, -1880, 0)
    AddPathNpc(1, 144, PathNodeNpcId)

PathNodeNpcId = CreateSceneNpc(1, 5316, -1219, -1924, 0)
    AddPathNpc(1, 145, PathNodeNpcId)

    PathNodeNpcId = CreateSceneNpc(1, 5310, -1225, -1956, 0)
    AddPathNpc(1, 146, PathNodeNpcId)

    
    TransportNpc1 = CreateSceneNpc(1, 5308, 253, -537, 4)
    --Door1 = CreateSceneNpc(1, 5314, 324, -477, 4)
    
    TransportNpc2 = CreateSceneNpc(1, 5309, 253, -534, 4)
    --Door2 = CreateSceneNpc(1, 5314, 127, -521, 8)

    local LAN_Run_Reg = L("msg_script_run_registe"); -- "赛跑比赛现在开始报名，有兴趣参加者可以在成都广场找NPC初级和高级赛跑管理者报名，比赛开始！";
	--SendMedia("test", 6)
    --print(LAN_Run_Reg)
    SendMedia(LAN_Run_Reg, 6)
    --Bulletin(LAN_Run_Reg)
    --print("1")
end

function OnEndRun()
	MatchBeginTime = 0;
	MatchState = 0;
end

--掉线后上线还原操作
function OnUserEnterWorld(nUserId)
    AddEffect(0, nUserId, 2303)
end

function OnUserPrepareRun(nUserId)
    if GetCreLev(nUserId) <= 40 then
        SvrAcceptTask(nUserId, 1673)
        AddEffect(0, nUserId, 2303)
	 --IfCreRideThenUnRide(nUserId)
	 --StopUseItemAndSkill(nUserId,1,1)
        CreSetPositionById(nUserId, 338, -479, 1)
        SetUserRunInfo(nUserId, 0, 0)        --初级赛跑设置初始路点
    else
        SvrAcceptTask(nUserId, 1674)
        AddEffect(0, nUserId, 2303)
        --IfCreRideThenUnRide(nUserId)
        --StopUseItemAndSkill(nUserId,1,1)
        CreSetPositionById(nUserId, 126, -528, 1)
        SetUserRunInfo(nUserId, 1, 0)        --高级赛跑设置初始路点

    end
end

function OnUserEndRun(nUserId)
    RemoveEffect(nUserId, 2303)
end

function On1MinTimer(dwNow)
    if MatchState == 0 then
        local DayOfWeek = GetServerDayOfWeek();
        local NowHour = GetServerHour();
        if NowHour == 20 and (DayOfWeek == 1 or DayOfWeek == 3 or DayOfWeek == 5) then  --比赛开始时间 周一，周三，周五20点整开始比赛
            BeginRun()
        end
    elseif MatchState == 1 then
	
        if (dwNow - MatchBeginTime) > 1 * 1 then
            	
		MatchState = 2

            --AddSceneEffect(TransportNpc1, "eff_nation_fire1", 311, -468)
            --Disappear(TransportNpc1)
            --TransportNpc1 = 0;
            --Die(Door1)
            --Door1 = 0

            --AddSceneEffect(TransportNpc2, "eff_nation_fire1", 131, -518)
            --Disappear(TransportNpc2)
            --TransportNpc2 = 0;
            --Die(Door2)
            --Door2 = 0
            
	     local LAN_Run_Begin = L("msg_script_run_begin"); -- "赛跑比赛现在开始，沿着比赛路线前进，依次经过比赛记录点，直到到达比赛终点！"
	     --print(LAN_Run_Begin)
            --SendMedia(LAN_Run_Begin, 6)
        end
    else
    	if (dwNow - MatchBeginTime) > 120 * 60 then
    		EndRun()
    	end
    end
end

function OnFinishRun(nUserId, nPathIdx, nRank)
    local LAN_Run_Win1 = L("msg_script_run_win1"); -- "恭喜"
    local LAN_Run_Win2 = L("msg_script_run_win2"); -- "获得了初级赛跑比赛第"
    local LAN_Run_Win3 = L("msg_script_run_win3"); -- "获得了高级赛跑比赛第"
    --print(nRank)
    --print(Match1MaxSendMedia)
    --print(nPathIdx)
    --print(LAN_Run_Win1);
    --print(LAN_Run_Win2);
    --print(LAN_Run_Win3);
    
    
    
    if nPathIdx == 0 then
        if nRank <= Match1MaxSendMedia then
            local strName = GetCreName(nUserId)
            local strMedia = LAN_Run_Win1..strName..LAN_Run_Win2..nRank
            
            SendMedia(strMedia, 6)
        end
        
        if nRank <= Match1MaxSendMedia then
     		AddNimbus(nUserId, 50000, 0)
    	 end
        
        if SvrCanFinishTask(nUserId, 1673) ~= 0 then
             SvrFinishTask(nUserId, 1673)
        end
    elseif nPathIdx == 1 then
        if nRank <= Match2MaxSendMedia then
            local strName = GetCreName(nUserId)
            local strMedia = LAN_Run_Win1..strName..LAN_Run_Win3..nRank
            SendMedia(strMedia, 6)
        end
        
	 if nRank <= Match2MaxSendMedia then
     		AddNimbus(nUserId, 100000, 0)
    	 end
        
	 if SvrCanFinishTask(nUserId, 1674) ~= 0 then
            SvrFinishTask(nUserId, 1674)
        end
    end    
end

function OnUserCancelTask(nUserId, nTaskId)
    if nTaskId == 1673 then
    	SetUserRunInfo(nUserId, 255, 255)
    end
    if nTaskId == 1674 then
    	SetUserRunInfo(nUserId, 255, 255)
    end
end

function OnReachPathNode(nUserId, nPathIdx, nPathNodeIdx, nRank)

end

function GetRunPathName(nPathIdx)
    local LAN_Run_Low = L("msg_script_run_low"); -- "初级赛跑"
    local LAN_Run_High = L("msg_script_run_high"); -- "高级赛跑"
    if nPathIdx == 0 then
        return LAN_Run_Low
    else
        return LAN_Run_High
    end
end

function GetPathPathNodeTotalCount(nPathIdx)
       if nPathIdx == 0 then
          return 52
       else
          return 146
       end
end
