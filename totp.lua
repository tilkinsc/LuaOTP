
-- please point this to proper location
local otp = require("otp.lua")

local totp = {}

totp.at = function(instance, for_time, counter_offset)
	if (for_time == nil) then
		error("No for_time supplied.")
	end
	return otp.generate_otp(instance, totp.timecode(instance, tonumber(for_time)) + (counter_offset or 0))
end

totp.now = function(instance)
	return otp.generate_otp(instance, totp.timecode(instance, os.time()))
end

totp.verify = function(instance, key, for_time, valid_window)
	valid_window = valid_window or 0
	for_time = for_time or os.time()
	
	if (valid_window > 0) then
		for i=-valid_window, valid_window, 1 do
			if (util.strings_equal(tostring(key), tostring(totp.at(instance, for_time, i)))) then
				return true
			end
		end
		return false
	end
	return util.strings_equal(tostring(key), tostring(totp.at(instance, for_time)))
end

totp.as_uri = function(instance, name, issuer_name)
	return util.build_uri(instance.secret, name, nil, issuer_name, instance.digest, instance.digits, instance.interval)
end

totp.timecode = function(instance, for_time)
	return math.floor(for_time/instance.interval)
end

return totp
