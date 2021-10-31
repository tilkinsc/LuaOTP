
----------------------------------------------------------------
-- Initialization Stuff                                       --
----------------------------------------------------------------


local INTERVAL		= 30;
local DIGITS		= 6;
local BASE32_SECRET	= "JBSWY3DPEHPK3PXP";
local DIGEST 		= "SHA1";



local OTP  = require("otp")
local TOTP = require("totp")
local HOTP = require("hotp")
local UTIL = require("util")


-- Create OTPData struct, which decides the environment
OTP.type = "totp"
local tdata = OTP.new(BASE32_SECRET, DIGITS, DIGEST, 30) -- TODO: needs hmac algo, fix differentiation
OTP.type = "hotp"
local hdata = OTP.new(BASE32_SECRET, DIGITS, DIGEST)


-- Dump data members of struct OTPData tdata
print("\\\\ totp tdata \\\\")
print("tdata.digits: `" .. tdata.digits .. "`")
print("tdata.interval: `" .. tdata.interval .. "`")
-- TODO: print("tdata.bits: `", .. tdata.bits .. "`")
-- TODO: print("tdata.method: `" .. tdata.method .. "`") -- is actually .type
-- TODO: print("tdata.algo: `" .. tdata.algo .. "`")
print("tdata.digest: `" .. tdata.digest .. "`")
print("tdata.secret: `" .. tdata.secret .. "`") -- TODO: base32_secret
print("// totp tdata //\n")

-- Dump data members of struct OTPData hdata
print("\\\\ hotp hdata \\\\")
print("hdata.digits: `" .. hdata.digits .. "`")
-- print("hdata.bits: `" .. hdata.bits .. "`")
-- print("hdata.method: `" .. hdata.method .. "`")
-- print("hdata.algo: `" .. hdata.algo .. "`")
print("hdata.digest: `" .. hdata.digest .. "`")
print("hdata.secret: `" .. hdata.secret .. "`")
print("// hotp hdata //\n")

print("Current Time: `" .. os.time() .. "`")


----------------------------------------------------------------
-- URI Example                                                --
----------------------------------------------------------------

local name1 = "name1"
local name2 = "name2"
local whatever1 = "account@whatever1.com"
local whatever2 = "account@whatever2.com"

local uri1 = OTP.util.build_uri(tdata.secret, name1, nil, whatever1, DIGEST, DIGITS, INTERVAL)
print("TOTP URI 1: `" .. uri1 .. "`\n")

local counter = 52;
local uri2 = OTP.util.build_uri(hdata.secret, name2, counter, whatever2, DIGEST, DIGITS, nil)
print("HOTP URI 2: `" .. uri2 .. "`\n")


----------------------------------------------------------------
-- BASE32 Stuff                                               --
----------------------------------------------------------------

-- seed random generator
math.randomseed(os.time())
math.random(1, 2)

local base32_len = 16

local base32_new_secret = UTIL.random_base32(base32_len, OTP.util.default_chars)
print("Generated BASE32 Secret: `" .. base32_new_secret .. "`")

print("") -- line break for readability


----------------------------------------------------------------
-- TOTP Stuff                                                 --
----------------------------------------------------------------

-- totp.now
local totp_err_1 = TOTP.now(tdata)
print("TOTP Generated: `" .. totp_err_1 .. "`")

-- totp.at
local totp_err_2 = TOTP.at(tdata, 1, 0)
print("TOTP Generated: `" .. totp_err_1 .. "`")


-- Do a verification for a hardcoded code
-- Won't succeed, this code is for a timeblock far into the past
local tv1 = TOTP.verify(tdata, 576203, os.time(), 4)

-- Will succeed, timeblock 0 for JBSWY3DPEHPK3PXP == 282760
local tv2 = TOTP.verify(tdata, 282760, 0, 4)
print("TOTP Verification 1: `" .. tostring(tv1) .. "`")
print("TOTP Verification 2: `" .. tostring(tv2) .. "`")

print("") -- line break for readability


----------------------------------------------------------------
-- HOTP Stuff                                                 --
----------------------------------------------------------------

-- Get HOTP for token 1
--   1. Generate and load hotp key into buffer
--   2. Check for error

local hotp_err_1 = HOTP.at(hdata, 1)
print("HOTP Generated at 1: `" .. hotp_err_1 .. "`")

-- Do a verification for a hardcoded code
-- Will succeed, 1 for JBSWY3DPEHPK3PXP == 996554
local hv = HOTP.verify(hdata, 996554, 1)
print("HOTP Verification 1: `" .. tostring(hv) .. "`")

