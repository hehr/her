--[[
    mongo query service  demo
]]--

local cjson = require("cjson")
local user = require("lua.dao.m_user")

local _M = { _VSERSION = '0.1.0' }

function _M.new(self)
	return setmetatable( {} , { __index = _M } )
end

function _M.feed(self,body)

    local query = { edge = 29 }

    local user = user:new()
    
    local returnfields = {}
    
    local res , err = user:query_user(query,returnfields)

    ngx.say('id:' .. res.id ..' ,edge: ' ..res.edge .. ' , name:'..res.name .. ' ,sex : ' ..res.sex )



    -- local query = { edge = 18 }
    
    -- local returnfields = {}
    
    -- local number = 88

    -- local user = user:new()

    -- local result , err = user:query_users(query,returnfields,number) 

    -- if not result then
    --     ngx.say(err)
    --     return
    -- end

    -- ngx.log(ngx.INFO , "result:" .. result[1].id)
    
    -- ngx.say('lalal')

end

return _M