--[[
    mysql insert service demo
]]--

local cjson = require ("cjson")
local user  = require("lua.dao.user")
local random = require("lua.utils.random")

local _M = { _M = '0.1.0' }

function _M.new(self)
	return setmetatable( {} , { __index = _M } )
end

function _M.feed( self , body )
	
	local user =  user:new()

    local random_id =  random:get_random_id(6)

    local user_info = { open_id = random_id ,
                        nick_name = random_id .. 'hehr' ,
                        sex = 1 ,
                        lang = 'eng' , 
                        city = 'shenzhen' ,
                        prov = 'guangdong' ,
                        country = 'china' ,
                        head_imgurl = '' ,
                        subscribe_time = '' ,
                        union_id = '' ,
                        remark = '', 
                        group_id = 0,
                        tagid_list = '' ,
                        time = ''
                          }

    local res , err = user:insert_user( user_info )

	-- if not res then
	-- 	ngx.say(err)
    --     return
	-- end
    
	ngx.say( err )

end

return _M