--[[
    http demo
]]--
local cjson = require ("cjson")
local http  = require("lua.utils.http")


local _M = { _VERSION = '0.1.0'}

function _M.new(slef)
    return setmetatable( {} , { __index = _M } )
end

function _M.feed(slef ,body)

    
    local appId = ''
    local appKey = ''
    local tstr = { vehNum = '' }
    
    local query = {sid=10302 , encode='utf-8' , reqData =  cjson.encode(tstr) , timestamp = ngx.time() , appId = appId , appKey = appKey}
    
    local param = { url = 'http://114.210.25.56:8080/gates' , method='GET' , query = query  }
    
    local http_client , err = http:new(param)
    
    if not http_client then
        ngx.say(err)
    end    
    local res , err = http_client:http_request()
    ngx.say(res.body)

end

return _M