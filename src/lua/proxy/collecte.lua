--[[
    数据上报接口
]]--
local cjson = require("cjson")
local error_conf = require("lua.config.error_conf")
local report =  require("lua.collector.report")

local _M ={ _VERSION = '0.1.0' }

    function _M.new(self)
        return setmetatable( {} , { __index = _M } )
    end

    --数据校验
    function _M.feed(self , body)

        local data = cjson.decode( ngx.unescape_uri(body) ) 

        --数据校验
        if not data or 
           not data.reportId or
           not data.reportTime or 
           not data.customer or 
           not data.device or 
           not data.mic or 
           not data.music or 
           not data.contacts or 
           not data.location or 
           not data.awake or 
           not data.dialogue or 
           not data.other then

           ngx.say(cjson.encode(error_conf.param_error)) --参数非法  
           return

        end  

        local report = report:new()

        local ok , err = report:collect(data)

        if not ok then

            ngx.log(ngx.ERR, " report error , check report chunk , error : " .. err)
            ngx.say(cjson.encode(error_conf.process_error)) --数据处理错误
            return

        end

        ngx.say(cjson.encode(error_conf.collect_success))

    end

return _M