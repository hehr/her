local t = require("lua.service.t")
local m = require("lua.service.m")
local u = require("lua.service.u")
local d = require("lua.service.d")
local mi = require("lua.service.mi")
local mq = require("lua.service.mq")
local md = require("lua.service.md")
local mu = require("lua.service.mu")

local _M = {

['/t'] = {method = 'GET',object = t:new()},
['/m'] = {method = 'GET',object = m:new()},
['/u'] = {method = 'POST',object = u:new()},
['/d'] = {method = 'POST',object = d:new()},
['/mi'] = {method = 'POST',object = mi:new()},
['/mq'] = {method = 'GET',object = mq.new()},
['/md'] = {method = 'POST',object = md.new()},
['/mu'] = {method = 'POST',object = mu.new()},

}

return _M