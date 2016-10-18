local http = require("resty.http")
local cjson = require("cjson")

local _M = {_VERSION = '0.1.0'}

--[[
example: param = { url = 'https://www.google.com' , method='GET' , ssl_verify = false , headers = nil , query = { sid = 10300 , encode='utf-8' } , body = {grant_type = "client_credential"} }
]]--


function _M.new( self,param )

    local  url = param.url
    
    if not url then
         return nil , 'IllegalArgument'
    end

    local  method =  param.method or 'GET'

    if method == 'GET' then
        if  not param.query then
            return nil , 'IllegalArgument'
        end
    end

    local query = param.query

    if method == 'POST' then
        if not param.body then
            return nil , 'IllegalArgument'
        end
    end

    local body = param.body

    if body then
        body = cjson.encode(body)
    end

    local  ssl_verify = param.ssl_verify  or true --false is https　　
    local  headers =  param.headers or {["Content-Type"] = "application/x-www-form-urlencoded"}

    return setmetatable( { 
        url = url,
        method = method,
        ssl_verify = ssl_verify,
        headers = header,
        query = query,
        body = body,
    },{ __index = _M }) ,'success'

end

function _M.http_request( self )

    local params = { url = self.url , method = self.method , body = self.body , ssl_verify = self.ssl_verify , headers = self.headers ,query = self.query }

    return http.new():request_uri( self.url , params )

end

return _M