# LuaOTP

This module is part of a chain of OTP libraries all written in different languages. See https://github.com/OTPLibraries

A simple One Time Password (OTP) library in lua

Compatible with Authy and Google Authenticator. Full support for QR code url is provided.


## Libraries Needed

In order to utilize this library, you will need the following libraries:
* bit32 (already there in Lua 5.3, no config required)
* basexx
* sha1

I am sure you can get them through LuaRocks stuff, but...
Here you can obtain them:
>[bit32](http://www.snpedia.com/extensions/Scribunto/engines/LuaCommon/lualib/bit32.lua)

>[basexx](https://github.com/aiq/basexx/blob/master/lib/basexx.lua)

>[sha1](https://github.com/kikito/sha1.lua)


## Configuration

You will need to configure the paths of the requires of this library. I am guessing you don't compile everything into one directory, but whatever. It is simple and quick. Everything is already preconfigured to be manipulated there, just replace the path.

When it comes down to it, this library will convert your integer numbers to string and do a comparison byte by byte. There is no need for expensive testing - nobody knows what is going on except the key holders and the key can't be reversed because we only send a small part of the hmac. That being said, there is no support for digits > 9 yet - as this is half an int's limit.


_____________

## License

This library is licensed under GNU General Public License v3.0.

bit32 is licensed by Lua under MIT, see the full license [here](https://www.lua.org/license.html)

basexx is licensed by aiq under MIT, see the full license [here](https://github.com/aiq/basexx/blob/master/LICENSE)

sha1 is licensed by 'Enrique García Cota + Eike Decker + Jeffrey Friedl' under a custom license, see the full license [here](https://github.com/kikito/sha1.lua/blob/master/MIT-LICENSE.txt)


## Usage

To use this library, pick either TOTP or HOTP then use the provided files - giving the functions what they need. The only thing you really need to pay attention is settings. Check out the test file, as it will tell you what the default requirements is for Google Authenticator, but you should always be using Authy (it is the most lenient).


## TODO

* Add comments - there are lacking comments, should match up to COTP's style
* Remove the dependancy on basexx - I have an implementation found in COTP and JOTP that can be ported.
* bit32 isn't actually an external dependancy, but depending on the version you prefer, it is
* sha1 make sure we aren't infringing anything with this

