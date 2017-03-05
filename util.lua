
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

util.encode_url = function(url, protocol)
	local out = ""
	for i=1, #url do
		local char = url:sub(i,i)
		local byte = string.byte(char)
		local ch = string.gsub(char, "^[%c\"<>#%%%s{}|\\%^~%[%]`]+", function(s)
			return string.format("%%%02x", byte)
		end)
		if(byte > 126)then
			ch = string.format("%%%02x", byte)
		end
		out = out .. ch
	end
	return (protocol or "") .. out
end

util.build_uri = function(secret, name, initial_count, issuer_name, algorithm, digits, period)
	local label = util.encode_url(name)
	label = issuer_name and util.encode_url(issuer_name) .. ':' .. label or ""
	
	algorithm = algorithm and string.upper(algorithm) or ""
	
	local url_args = {
		secret = secret,
		issuer = issuer_name,
		counter = initial_count,
		algorithm = algorithm,
		digits = digits,
		period = period
	}
	return string.format(util.base_uri, initial_count ~= nil and "hotp" or "totp", label, util.build_args(url_args))
end

util.strings_equal = function(s1, s2)
	for i=1, #s1 do
		if(s1:sub(i,i) ~= s2:sub(i,i))then
			return false
		end
	end
	return true
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

return util
