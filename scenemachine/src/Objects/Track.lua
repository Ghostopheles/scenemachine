local Math = SceneMachine.Math;
local Vector3 = SceneMachine.Vector3;
local Quaternion = SceneMachine.Quaternion;

SceneMachine.Track = 
{
    objectID = nil, -- keeping a reference for when loading saved data
    name = "New Track",
    animations = {},
    keyframes = {},
}

local Track = SceneMachine.Track;

setmetatable(Track, Track)

local fields = {}

function Track:New(object)
	local v = 
    {
        -- Don't store an object reference, no reason for duplicates in saved data
        --object = object or nil,
        animations = {},
        keysPx = {},
        keysPy = {},
        keysPz = {},
        keysRx = {},
        keysRy = {},
        keysRz = {},
        keysS = {},
    };
    
    if (object) then
        v.objectID = object.id;
        v.name = object.name;
    end

	setmetatable(v, Track)
	return v
end

function Track:ExportData()
    local data = {
        objectID = self.object.id;
        animations = self.animations;
        keysPx = self.keysPx;
        keysPy = self.keysPy;
        keysPz = self.keysPz;
        keysRx = self.keysRx;
        keysRy = self.keysRy;
        keysRz = self.keysRz;
        keysS = self.keysS;
    };

    return data;
end

function Track:ImportData(data)
    if (data == nil) then
        print("Track:ImportData() data was nil.");
        return;
    end

    -- verifying all elements upon import because sometimes the saved variables get corrupted --
    if (data.objectID ~= nil) then
        self.objectID = data.objectID;
    end

    if (data.name ~= nil) then
        self.name = data.name;
    end

    if (data.animations ~= nil) then
        self.animations = data.animations;
    end

    if (data.keysPx) then
        self.keysPx = {};
        for k in pairs(data.keysPx) do
            local key = data.keysPx[k];
            self.keysPx[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysPy) then
        self.keysPy = {};
        for k in pairs(data.keysPy) do
            local key = data.keysPy[k];
            self.keysPy[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysPz) then
        self.keysPz = {};
        for k in pairs(data.keysPz) do
            local key = data.keysPz[k];
            self.keysPz[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysRx) then
        self.keysRx = {};
        for k in pairs(data.keysRx) do
            local key = data.keysRx[k];
            self.keysRx[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysRy) then
        self.keysRy = {};
        for k in pairs(data.keysRy) do
            local key = data.keysRy[k];
            self.keysRy[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysRz) then
        self.keysRz = {};
        for k in pairs(data.keysRz) do
            local key = data.keysRz[k];
            self.keysRz[k] = {
                time = key.time,
                value = key.value
            };
        end
    end

    if (data.keysS) then
        self.keysS = {};
        for k in pairs(data.keysS) do
            local key = data.keysS[k];
            self.keysS[k] = {
                time = key.time,
                value = key.value
            };
        end
    end
end

function Track:SampleAnimation(timeMS)
    -- find anim in range
    if (self.animations) then
        for a in pairs(self.animations) do
            local animation = self.animations[a];
            --{ id, variation, animLength, startT, endT, colorId, name }
            if (animation.startT <= timeMS and animation.endT > timeMS) then
                -- anim is in range
                local animMS = mod(timeMS - animation.startT, animation.animLength);
                local animID = animation.id;
                local variationID = animation.variation;

                return animID, variationID, animMS;
            end
        end
    end

    return -1, -1
end

function Track:AddKeyframe(time, value, keyframes)
    if (not keyframes) then keyframes = {}; end

    for i = 1, #keyframes, 1 do
        if (keyframes[i].time == time) then
            keyframes[i].value = value;
            return;
        end
    end

    keyframes[#keyframes + 1] = { time = time, value = value };
end

function Track:AddFullKeyframe(time, position, rotation, scale)
    self:AddPositionKeyframe(time, position);
    self:AddRotationKeyframe(time, rotation);
    self:AddScaleKeyframe(time, scale);
end

function Track:AddPositionKeyframe(time, position)
    self:AddKeyframe(time, position.x, self.keysPx);
    self:AddKeyframe(time, position.y, self.keysPy);
    self:AddKeyframe(time, position.z, self.keysPz);
    self:SortPositionKeyframes();
end

function Track:AddRotationKeyframe(time, rotation)
    self:AddKeyframe(time, rotation.x, self.keysRx);
    self:AddKeyframe(time, rotation.y, self.keysRy);
    self:AddKeyframe(time, rotation.z, self.keysRz);
    self:SortRotationKeyframes();
end

function Track:AddScaleKeyframe(time, scale)
    self:AddKeyframe(time, scale, self.keysS);
    self:SortScaleKeyframes();
end

function Track:SortPositionKeyframes()
    if (self.keysPx) then
        table.sort(self.keysPx, function(a,b) return a.time < b.time end)
    end
    if (self.keysPy) then
        table.sort(self.keysPy, function(a,b) return a.time < b.time end)
    end
    if (self.keysPz) then
        table.sort(self.keysPz, function(a,b) return a.time < b.time end)
    end
end

function Track:SortRotationKeyframes()
    if (self.keysRx) then
        table.sort(self.keysRx, function(a,b) return a.time < b.time end)
    end
    if (self.keysRy) then
        table.sort(self.keysRy, function(a,b) return a.time < b.time end)
    end
    if (self.keysRz) then
        table.sort(self.keysRz, function(a,b) return a.time < b.time end)
    end
end

function Track:SortScaleKeyframes()
    if (self.keysS) then
        table.sort(self.keysS, function(a,b) return a.time < b.time end)
    end
end

function Track:SortKeyframes()
    self:SortPositionKeyframes();
    self:SortRotationKeyframes();
    self:SortScaleKeyframes();
end

function Track:SampleKey(timeMS, keys)
    if (not keys) then return nil; end
    if (#keys == 0) then return nil; end

    if (#keys == 1) then
        if (keys[1].time == timeMS) then
            return keys[1].value;
        else
            return nil;
        end
    end

    local idx = 1;
    local numTimes = #keys;

    for i = 1, numTimes, 1 do
        if (i + 1 <= numTimes) then
            if (timeMS >= keys[i].time and timeMS < keys[i + 1].time) then
                idx = i;
                break;
            end
        end
        if (i == numTimes) then
            return keys[#keys].value;
        end
        if (i == 1 and timeMS < keys[1].time) then
            return keys[1].value;
        end
    end

    local t1 = keys[idx].time;
    local t2 = keys[idx + 1].time;

    local r = Track:InterpolateAutoBezier(t1, t2, timeMS);

    local v1 = keys[idx].value;
    local v2 = keys[idx + 1].value;
    local result = (v1 + (v2 - v1) * r);
    return result;
end

function Track:SamplePositionXKey(timeMS)
    return Track:SampleKey(timeMS, self.keysPx);
end

function Track:SamplePositionYKey(timeMS)
    return Track:SampleKey(timeMS, self.keysPy);
end

function Track:SamplePositionZKey(timeMS)
    return Track:SampleKey(timeMS, self.keysPz);
end

function Track:SampleRotationXKey(timeMS)
    return Track:SampleKey(timeMS, self.keysRx);
end

function Track:SampleRotationYKey(timeMS)
    return Track:SampleKey(timeMS, self.keysRy);
end

function Track:SampleRotationZKey(timeMS)
    return Track:SampleKey(timeMS, self.keysRz);
end

function Track:SampleScaleKey(timeMS)
    return Track:SampleKey(timeMS, self.keysS);
end

function Track:InterpolateLinear(t1, t2, timeMS)
    return (timeMS - t1) / (t2 - t1);
end

function Track:InterpolateAutoBezier(tA, tB, timeMS)
    local t = (timeMS - tA) / (tB - tA)
    
    --t = interpolationValue
    local t2 = t * t
    local t3 = t2 * t
    
    local previousPoint = 0;
    local nextPoint = 1;
    local previousTangent = 0--tA + (tB - tA) / 3
    local nextTangent = 0--tB - (tB - tA) / 3

    local p = (2 * t3 - 3 * t2 + 1) * previousPoint +
           (t3 - 2 * t2 + t) * previousTangent +
           (-2 * t3 + 3 * t2) * nextPoint +
           (t3 - t2) * nextTangent;

    return p;
end

function Track:SampleRotationKey(timeMS)
    if (not self.keyframes) then
        return nil;
    end

    if (#self.keyframes == 0) then
        return nil;
    end

    if (#self.keyframes == 1) then
        if (self.keyframes[1].time == timeMS) then
            return self.keyframes[1].rotation;
        else
            return nil;
        end
    end

    local idx = 1;
    local numTimes = #self.keyframes;

    for i = 1, numTimes, 1 do
        if (i + 1 <= numTimes) then
            if (timeMS >= self.keyframes[i].time and timeMS < self.keyframes[i + 1].time) then
                idx = i;
                break;
            end
        end
        if (i == numTimes) then
            return self.keyframes[#self.keyframes].rotation;
        end
        if (i == 1 and timeMS < self.keyframes[1].time) then
            return self.keyframes[1].rotation;
        end
    end

    local t1 = self.keyframes[idx].time;
    local t2 = self.keyframes[idx + 1].time;

    local r = (timeMS - t1) / (t2 - t1);
    
    return Quaternion.Interpolate(self.keyframes[idx].rotation, self.keyframes[idx + 1].rotation, r);
end

Track.__tostring = function(self)
	return string.format("Track: %s Anims: %i Keys: %i", self.name, #self.animations, #self.keyframes);
end

Track.__index = function(t,k)
	local var = rawget(Track, k)
		
	if var == nil then							
		var = rawget(fields, k)
		
		if var ~= nil then
			return var(t)	
		end
	end
	
	return var
end