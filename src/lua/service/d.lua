local cjson = require ("cjson")
local user  = require("lua.dao.user")
local random = require("lua.utils.random")


local _M = { _VERSION = '0.1.0'}

function _M.new(slef)
 return setmetatable( {} , { __index = _M } )
end

function _M.feed(slef ,body)

    local 

end

return _M