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

    -- local returnfields = {id = '' , edge =''}

    local user = user:new()
    
    local res , err = user:query_user(query,returnfields)

    ngx.say('id:' .. res.id ..' ,edge: ' ..res.edge .. ' , name:'..res.name .. ' ,sex : ' ..res.sex )



    --has bug
    -- local query = { edge = 18 }
    
    -- local returnfields = { }
    
    -- local number = 10

    -- local user = user:new()

    -- local cursor , err = user:query_users( query ) 

    -- if not cursor then
    --     ngx.say(err)
    --     return
    -- end

    -- local index , item = cursor:next()

    -- ngx.log(ngx.INFO , "err  : " .. err)
    -- ngx.log(ngx.INFO , "ind ex : " .. index)
    -- ngx.log(ngx.INFO , "item:" .. type(item)) 

    -- for index , item in cursor:pairs() do
    --     -- ngx.log(ngx.INFO , "ind ex : " .. index)
    --     -- ngx.log(ngx.INFO , "item:" .. type(item))    
    -- end

    

    -- while( true ) do

    --     local index , item = cursor:next()

    --     if not index or not item then
    --         break
    --     end

    --     ngx.log(ngx.INFO , "index : " .. index)
    --     ngx.log(ngx.INFO , "item:" .. type(item))

    -- end


    -- ngx.say('lalal')

end

return _M