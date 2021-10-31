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

local util = {}

util.default_chars = {
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
	'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
	'U', 'V', 'W', 'X', 'Y', 'Z', '2', '3', '4', '5',
	'6', '7'
}

util.base_uri = "otpauth://%s/%s%s"

util.build_args = function(arr)
	local out = "?"
	for i, v in pairs(arr)do
		out = out .. i .. '=' .. util.encode_url(v) .. '&'
	end
	return string.sub(out, 1, #out-1)
end

util.encode_url = function(url)
	local out = ""
	for i=1, #url do
		local ch = url:sub(i,i)
		local by = string.byte(ch)
		local ch = string.gsub(ch, "^[%c\"<>#%%%s{}|\\%^~%[%]`]+", function(s)
			return string.format("%%%02x", by)
		end)
		if(by > 126)then
			ch = string.format("%%%02x", by)
		end
		out = out .. ch
	end
	return out
end

util.build_uri = function(secret, name, initial_count, issuer_name, algorithm, digits, period)
	local label = util.encode_url(name)
	label = issuer_name and (util.encode_url(issuer_name) .. ':' .. label) or ""
	
	algorithm = algorithm and string.upper(algorithm) or ""
	
	local url_args = {
		secret = tostring(secret),
		issuer = issuer_name,
		counter = tostring(initial_count),
		algorithm = algorithm,
		digits = tostring(digits)
	}
	if(initial_count == nil) then
		url_args.period = tostring(period)
	end
	return string.format(util.base_uri, initial_count ~= nil and "hotp" or "totp", label, util.build_args(url_args))
end

util.arr_reverse = function(tab)
    local out = {}
    for i=1, #tab do
		out[i] = tab[1+#tab - i]
	end
    return out
end

util.byte_arr_tostring = function(arr)
	local out = ""
	for i=1, #arr do
		out = out .. string.char(arr[i])
	end
	return out
end

util.str_to_byte = function(str)
	local out = {}
	for i=1, #str do
		out[i] = string.byte(str:sub(i,i))
	end
	return out
end

util.random_base32 = function(length, chars)
	length = length or 16
	chars = chars or util.default_chars
	local out = ""
	for i=1, length do
		out = out .. chars[math.random(1, #chars)]
	end
	return out
end

return util
