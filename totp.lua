
-- please point this to proper location
local otp = require("otp")

local totp = {}

totp.at = function(instance, for_time, counter_offset)
	return otp.generate_otp(instance, totp.timecode(instance, tonumber(for_time)) + (counter_offset or 0))
end

totp.now = function(instance, override)
	return otp.generate_otp(instance, totp.timecode(instance, override or os.time()))
end

totp.valid_until = function(instance, for_time, valid_window)
	valid_window = valid_window or 0
	return for_time + ((self.interval + 1) * valid_window)
end

totp.verify = function(instance, key, for_time, valid_window)
	valid_window = valid_window or 0
	for_time = for_time or os.time()
	
	if (valid_window > 0) then
		for i=-valid_window, valid_window, 1 do
			if (tostring(key) == tostring(totp.at(instance, for_time, i))) then
				return true
			end
		end
		return false
	end
	return tostring(key) == tostring(totp.at(instance, for_time))
end

totp.timecode = function(instance, for_time)
	return math.floor(for_time/instance.interval)
end

return totp
