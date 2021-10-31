--[[
MIT License

Copyright (c) 2021 Cody Tilkins

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

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
