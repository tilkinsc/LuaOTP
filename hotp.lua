
-- please point this to proper location
local otp = require("otp.lua")

local hotp = {}

hotp.at = function(instance, count)
	return otp.generate_otp(instance, count)
end

hotp.verify = function(instance, key, counter)
	return util.strings_equal(key, hotp.at(instance, counter))
end

hotp.as_uri = function(instance, name, initial_count, issuer_name)
	return util.build_uri(instance.secret, name, initial_count or 0, issuer_name, instance.digest, instance.digits)
end

return hotp
