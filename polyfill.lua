-- Written by Rabia Alhaffar in 24/February/2021
-- polyfill.lua, Polyfills for Lua and LuaJIT in one file!
-- Updated: 11/April/2021
--[[
MIT License

Copyright (c) 2021 - 2022 Rabia Alhaffar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]

local polyfill = {
  _VERSION = 0.1,
  _AUTHOR = "Rabia Alhaffar (steria773/@Rabios)",
  _AUTHOR_URL = "https://github.com/Rabios",
  _URL = "https://github.com/Rabios/polyfill.lua",
  _LICENSE = "MIT",
  _DATE = "3/March/2021"
}

-- module: bit32
bit32 = bit32 or {}

bit32.bits = 32
bit32.powtab = { 1 }

for b = 1, bit32.bits - 1 do
  bit32.powtab[#bit32.powtab + 1] = math.pow(2, b)
end

-- Functions
-- bit32.band
if not bit32.band then
  bit32.band = function(a, b)
    local result = 0
    for x = 1, bit32.bits do
      result = result + result
      if (a < 0) then
        if (b < 0) then
          result = result + 1
        end
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit32.bor
if not bit32.bor then
  bit32.bor = function(a, b)
    local result = 0
    for x = 1, bit32.bits do
      result = result + result
      if (a < 0) then
        result = result + 1
      elseif (b < 0) then
        result = result + 1
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit32.bnot
if not bit32.bnot then
  bit32.bnot = function(x)
    return bit32.bxor(x, math.pow((bit32.bits or math.floor(math.log(x, 2))), 2) - 1)
  end
end

-- bit32.lshift
if not bit32.lshift then
  bit32.lshift = function(a, n)
    if (n > bit32.bits) then
      a = 0
    else
      a = a * bit32.powtab[n]
    end
    return a
  end
end

-- bit32.rshift
if not bit32.rshift then
  bit32.rshift = function(a, n)
    if (n > bit32.bits) then
      a = 0
    elseif (n > 0) then
      if (a < 0) then
        a = a - bit32.powtab[#bit32.powtab]
        a = a / bit32.powtab[n]
        a = a + bit32.powtab[bit32.bits - n]
      else
        a = a / bit32.powtab[n]
      end
    end
    return a
  end
end

-- bit32.arshift
if not bit32.arshift then
  bit32.arshift = function(a, n)
    if (n >= bit32.bits) then
      if (a < 0) then
        a = -1
      else
        a = 0
      end
    elseif (n > 0) then
      if (a < 0) then
        a = a - bit32.powtab[#bit32.powtab]
        a = a / bit32.powtab[n]
        a = a - bit32.powtab[bit32.bits - n]
      else
        a = a / bit32.powtab[n]
      end
    end
    return a
  end
end

-- bit32.bxor
if not bit32.bxor then
  bit32.bxor = function(a, b)
    local result = 0
    for x = 1, bit32.bits, 1 do
      result = result + result
      if (a < 0) then
        if (b >= 0) then
          result = result + 1
        end
      elseif (b < 0) then
        result = result + 1
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit32.btest
if not bit32.btest then
  bit32.btest = function(a, b)
    return (bit32.band(a, b) ~= 0)
  end
end

-- bit32.lrotate
if not bit32.lrotate then
  bit32.lrotate = function(a, b)
    local bits = bit32.band(b, bit32.bits - 1)
    a = bit32.band(a, 0xffffffff)
    a = bit32.bor(bit32.lshift(a, b), bit32.rshift(a, ((bit32.bits - 1) - b)))
    return bit32.band(n, 0xffffffff)
  end
end

-- bit32.rrotate
if not bit32.rrotate then
  bit32.rrotate = function(a, b)
    return bit32.lrotate(a, -b)
  end
end

-- bit32.extract
if not bit32.extract then
  bit32.extract = function(a, b, c)
    c = c or 1
    return bit32.band(bit32.rshift(a, b, c), math.pow(b, 2) - 1)
  end
end

-- bit32.replace
if not bit32.replace then
  bit32.replace = function(a, b, c, d)
    d = d or 1
    local mask1 = math.pow(d, 2) -1
    b = bit32.band(b, mask1)
    local mask = bit32.bnot(bit32.lshift(mask1, c))
    return bit32.band(n, mask) + bit32.lshift(b, c)
  end
end

-- module: bit
bit = bit or pcall(require, 'bit')

if not bit then
  bit = {}
  bit.bits = 32
  bit.powtab = { 1 }

  for b = 1, bit.bits - 1 do
    bit.powtab[#bit.powtab + 1] = math.pow(2, b)
  end
end

-- Functions
-- bit.band
if not bit.band then
  bit.band = function(a, b)
    local result = 0
    for x = 1, bit.bits do
      result = result + result
      if (a < 0) then
        if (b < 0) then
          result = result + 1
        end
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit.bor
if not bit.bor then
  bit.bor = function(a, b)
    local result = 0
    for x = 1, bit.bits do
      result = result + result
      if (a < 0) then
        result = result + 1
      elseif (b < 0) then
        result = result + 1
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit.bnot
if not bit.bnot then
  bit.bnot = function(x)
    return bit.bxor(x, math.pow((bit.bits or math.floor(math.log(x, 2))), 2) - 1)
  end
end

-- bit.lshift
if not bit.lshift then
  bit.lshift = function(a, n)
    if (n > bit.bits) then
      a = 0
    else
      a = a * bit.powtab[n]
    end
    return a
  end
end

-- bit.rshift
if not bit.rshift then
  bit.rshift = function(a, n)
    if (n > bit.bits) then
      a = 0
    elseif (n > 0) then
      if (a < 0) then
        a = a - bit.powtab[#bit.powtab]
        a = a / bit.powtab[n]
        a = a + bit.powtab[bit.bits - n]
      else
        a = a / bit.powtab[n]
      end
    end
    return a
  end
end

-- bit.arshift
if not bit.arshift then
  bit.arshift = function(a, n)
    if (n >= bit.bits) then
      if (a < 0) then
        a = -1
      else
        a = 0
      end
    elseif (n > 0) then
      if (a < 0) then
        a = a - bit.powtab[#bit.powtab]
        a = a / bit.powtab[n]
        a = a - bit.powtab[bit.bits - n]
      else
        a = a / bit.powtab[n]
      end
    end
    return a
  end
end

-- bit.bxor
if not bit.bxor then
  bit.bxor = function(a, b)
    local result = 0
    for x = 1, bit.bits, 1 do
      result = result + result
      if (a < 0) then
        if (b >= 0) then
          result = result + 1
        end
      elseif (b < 0) then
        result = result + 1
      end
      a = a + a
      b = b + b
    end
    return result
  end
end

-- bit.rol
if not bit.rol then
  bit.rol = function(a, b)
    local bits = bit.band(b, bit.bits - 1)
    a = bit.band(a,0xffffffff)
    a = bit.bor(bit.lshift(a, b), bit.rshift(a, ((bit.bits - 1) - b)))
    return bit.band(n, 0xffffffff)
  end
end

-- bit.ror
if not bit.ror then
  bit.ror = function(a, b)
    return bit.rol(a, -b)
  end
end

-- bit.bswap
if not bit.bswap then
  bit.bswap = function(n)
    local a = bit.band(n, 0xff)
    n = bit.rshift(n, 8)
    local b = bit.band(n, 0xff)
    n = bit.rshift(n, 8)
    local c = bit.band(n, 0xff)
    n = bit.rshift(n, 8)
    local d = bit.band(n, 0xff)
    return bit.lshift(bit.lshift(bit.lshift(a, 8) + b, 8) + c, 8) + d
  end
end

-- bit.tobit
if not bit.tobit then
  bit.tobit = function(n)
    local MOD = 2^32
    n = n % MOD
    if (n >= 0x80000000) then
      n = n - MOD
    end
    return n
  end
end

-- bit.tohex
if not bit.tohex then
  bit.tohex = function(x, n)
    n = n or 8
    local up
    if n <= 0 then
      if n == 0 then
        return ''
      end
      up = true
      n = -n
    end
    x = bit.band(x, 16^n-1)
    return ('%0'..n..(up and 'X' or 'x')):format(x)
  end
end

return polyfill
