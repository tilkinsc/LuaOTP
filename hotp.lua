
-- please point this to proper location
local otp = require("otp")

local hotp = {}

hotp.at = function(instance, count)
	return otp.generate_otp(instance, count)
end

hotp.verify = function(instance, key, counter)
	return tostring(key) == tostring(hotp.at(instance, counter))
end

return hotp
