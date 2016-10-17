--[[
    mysql delete service demo
]]--
local cjson = require ("cjson")
local user  = require("lua.dao.user")
local random = require("resty.random")


local _M = { _VERSION = '0.1.0'}

function _M.new(slef)
    return setmetatable( {} , { __index = _M } )
end

function _M.feed(slef ,body)

    local user = user:new()
    local random = random:number(1,10000)

    local res , err = user:delete_user(random)

    ngx.say(err)

end

return _M