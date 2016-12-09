--[[
@anth hehr
仅收集上传数据写入到内存当中，然后直接返回。

 ]]--

local cjson = require("cjson")
local cache = require("lua.cache.cache_dict")


local _M ={}

function _M.new(self)
    return setmetatable( {} , { __index = _M } )
end

function _M.collect( self,data)

    if not data then
        return nil , 'data is nil'
    end

    local cache = cache:new()

    return cache:add(data.reportId,cjson.encode(data)) --这里需要将数据转换成字符串才能存入缓存中

end

return  _M