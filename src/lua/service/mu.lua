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

    -- local selector = { id = 'dsdfsadfsdfsdfsdafsdfasd'}
    local selector = {sex = '男'}
    local update = { name = '了打死打fsdafsadf' ,sex = '女' ,edge = 1000000 , id = 'lalalalala'}
    local upsert = 0 
    local multiupdate = 1 --has bug ,multiupdate not work
    local user =  user:new()
    local res , err = user:update_user(selector,update,upsert,multiupdate)
    ngx.say(err)

end

return _M