local t = require("lua.service.t")
local m = require("lua.service.m")
local u = require("lua.service.u")
local d = require("lua.service.d")

local route = {

['/t'] = { method = 'GET', object = t:new()},
['/m'] = { method = 'GET', object = m:new()},
['/u'] = { method = 'POST',object = u:new()},
['/d'] = { method = 'POST',object = d:new()},

}

return route