# LuaOTP
A simple One Time Password (OTP) library in lua

Compatible with Authy and Google Authenticator.


In order to utilize this library, you will need the following libraries:
bit32 (already there in Lua 5.3, no config required)
basexx
sha1

I am sure you can get them through LuaRocks stuff, but...
Here you can obtain them:
[bit32](http://www.snpedia.com/extensions/Scribunto/engines/LuaCommon/lualib/bit32.lua)
[basexx](https://github.com/aiq/basexx/blob/master/lib/basexx.lua)
[sha1](https://github.com/kikito/sha1.lua)

You will need to configure the paths of the requires of this library. I am guessing you don't compile everything into one directory, but whatever. It is simple and quick. Everything is already preconfigured to be manipulated there, just replace the path.


This was actually a spawn off pyotp, but I would necessarily say the code was copied. Things in python aren't in lua, therefore I had to make the methods myself. However, credits will go to the module for providing a guideline of what to do. [Here](https://github.com/pyotp/pyotp) you can find pyotp and realize how different it really is.



