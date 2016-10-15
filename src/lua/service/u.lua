--[[
    mysql update service demo
]]--

local cjson = require ("cjson")
local user  = require("lua.dao.user")
local random = require("lua.utils.random")

local _M = {_VERSION = '0.1.0'}

function _M.new(self)
    return setmetatable( {} , { __index = _M } )
end

function _M.feed( self,body )

    local info = cjson.decode(body.info)
    local user = user:new()

    local random = random:get_random_number(10000)

    -- ngx.log(ngx.INFO , "random : " .. random)

    local user_info = { 
                        id = random ,
                        nick_name = 'hehr update' ,
                        sex = 1 ,
                        lang = 'eng' , 
                        city = 'shenzhen' ,
                        prov = 'guangdong' ,
                        country = 'china' ,
                        head_imgurl = 'www.baidu.com' ,
                        subscribe_time = ngx.time() ,
                        union_id = 'dsadas' ,
                        remark = 'hehr', 
                        group_id = 0,
                        tagid_list = 'dasda' ,
                        time = ngx.time(),
                        open_id = info.open_id
                        }

    local res , err =  user:update_user( user_info )   

    ngx.say(err)                 

end

return _M