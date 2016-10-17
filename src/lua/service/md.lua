--[[
    mongo delete service  demo
]]--

local cjson = require("cjson")
local user = require("lua.dao.m_user")



local _M = { _VSERSION = '0.1.0' }

function _M.new(self)
	return setmetatable( {} , { __index = _M } )
end

function _M.feed(self,body)

    local selector = { sex = '女' }

    local single_remove = 1  -- 1仅删除第一个　0都删除

    local user = user:new()

    local res,err = user:delete_user(selector , single_remove)

    ngx.say(err)

end

return _M