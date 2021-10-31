
# Documentation

## otp.lua
This file exposes the main part of the library in which the hotp and totp conventions are concieved.

function otp.new(secret, digits, digest, ...)
Returns a new OTP object used to pass to other OTP functions.
required string secret - base32 encoded string in which OTP codes are generated based on
optional number digits default 6 - how many digits is returned from an OTP generation
optional number digest default "sha1" - the hash used for code generation
situational number {...}[1] - a second interval for timeblocks for generation verification 

function otp.generate_otp(instance, input)
Returns an OTP code. Returns nil if input < 0.
required object instance - otp instance from otp.new()
required input - a value > -1

function otp.byte_secret(instance)
Pads % 8 the secret key in instance state. Returns array of decoded secret base32 bytes.
required object instance - otp instance from otp.new()

function otp.int_to_bytestring(i, padding)
Converts 4-byte integers into a binary string.
required number i - integer to convert
optional number padding default 8 - pad bytes out byte groups to multiples of this number

## totp.lua
This file extends the file otp.lua in a polymorphism way. It exposes timeblock based code generation.

functop totp.at(instance, for_time, counter_offset)
Returns a totp code at a specific time based on state.
required object instance - otp instance from otp.new()
required number for_time - time to generate code from in seconds
optional number counter_offset default 0 - skip this many timeblocks in code generation

function totp.now(instance, override)
Returns a totp code at the current time based on os.time() ignored in favor for override.
required object instance - otp instance from otp.new()
optional number override default os.time() - replacement for os.time()

function totp.valid_until(instance, for_time, valid_window)
Returns the time in seconds that the specified for_time will be invalidated.
required object instance - otp instance from otp.new()
required number for_time - time in seconds for finding out the next invalidation period
optional number valid_window default 0 - timeblocks a code should be active for

function totp.verify(instance, key, for_time, valid_window)
Returns true if key is verified, or within the timeblock specified by valid_window from for_time.
required object instance - otp instance from otp.new()
required number key - otp key to verify
optional number for_time default os.time() - time in seconds to verify the current
optional number valid_window default 0 - timeblocks a code should be active for

## hotp.lua
This file extends the file otp.lua in a polymorphism way. It exposes counter based code generation.

function hotp.at(instance, counter)
Returns the current otp code at a specified counter count.
required object instance - otp instance from otp.new()
required number counter - counter to generate otp code from

function hotp.verify(instance, key, counter)
Returns true if key is verified, or the key code matches the generated otp with counter.
required object instance - otp instance from otp.new()
required number key - otp key to verify
required number counter - counter to generate otp code from to match against key

## util.lua
These are your general util functions for generating a OTP uri and internally used functions.

LinearArray util.default_chars[32]
Base32 characters without 0 and 1 (for confusion sakes).

string util.base_uri[17]
A format containing 3 string replacements for an otpauth uri.

function util.build_args(arr)
Given key-value pairs in arr, creates a uri parameters section in the form of ?key=arr[key]&key2=arr[key2].
required dictionary arr - key-value pairs of uri arguments

function util.encode_url(url)
URL-encodes string url to be url-safe.
required string url - the url to make url-safe

function build_uri(secret, name, initial_count, issuer_name, algorithm, digits, period)
Returns a uri built based on otp data for importing in 3rd party apps or to generate QR codes.
required string secret - base32 secret string for otp code generation
required string name - name to append to the issuer_name with a :
optional number initial_count default nil - if method is hotp, this is a counter, if not then should always be nil
required string issuer_name - the issuer of the otp code
required string algorithm - the hash algorithm used to generate the blob to hmac for the otp code
required number digits - how many digits an otp code should have
required number period - if method is totp, this the timeblock an otp is generated for

function util.arr_reverse(tab)
Reverses a linear array. Returns a new table.
required LinearArray tab - a linear array to reverse the elements in

function util.byte_arr_tostring(arr)
Converts a linear array of numbers into characters into a string. Returns a new table.
required LinearArray arr - a linear array of numbers to convert to char and put in a linear array

function util.str_to_byte(str)
Converts a string into a linear array of bytes. Returns a new table.
required string str - string to break down into a byte array

function util.random_base32(length, chars)
Given charset chars, generates and returns a random base32 string with a length of length.
optional number length default 16 - the length of the base32 string
optional LinearArray chars default util.default_chars - the base32 charset to use

