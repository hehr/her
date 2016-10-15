--[[
	mysql query service demo
]]--

local cjson = require ("cjson")
local user  = require("lua.dao.user")

local _M = { _VERSION = '0.1.0' }


function _M.new(self)
	return setmetatable( {} , { __index = _M } )
end


function _M.feed( self , body )
	
	local user =  user:new()

	local res , err = user:query_user_by_device(body.device)

	if not res then
		ngx.say(err)
	end
	
	ngx.say(cjson.encode(res))

end

	

return _M