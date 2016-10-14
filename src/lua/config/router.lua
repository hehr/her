local t = require("lua.service.t")
local m = require("lua.service.m")
local u = require("lua.service.u")
local d = require("lua.service.d")
local mi = require("lua.service.mi")

local _M = {

['/t'] = { method = 'GET', object = t:new()},
['/m'] = { method = 'GET', object = m:new()},
['/u'] = { method = 'POST',object = u:new()},
['/d'] = { method = 'POST',object = d:new()},
['/mi'] = {method = 'POST' , object = mi:new()},

}

return _M