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

    local selector = { edge = 18 }
    local update = { name = '网儿码字' ,sex = '女' ,edge = 100 , id = 'ia8wbd'}
    local upsert = 0 --has bug , upsert not work
    local multiupdate = 0 --has bug ,multiupdate not work
    local user =  user:new()
    local res , err = user:update_user(selector , update , upsert　, multiupdate)
    ngx.say(err)

end

return _M