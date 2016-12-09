--[[
@auth hehr
1 数据库持久化操作
2 存储原则：
         1 所有数据按照上传时间戳处理，按照日期数据存储，如: 2016/12/02-customer 等
         2 拆分数据分为 customer , device , location , contacts , music , awake , dialogue 等集合     
]]--
local _M= { _VERSION = '0.1.0' }


function _M.new(self)
    return setmetatable( {} , { __index = _M } )
end

function _M.start(self,data)

    ngx.log(ngx.INFO ,"<><><><><><><><> collector start excute <><><><><><><><><> , data size: " .. #data )

    -- for _ , v in ipairs(data) do

    --     local customer = {}
    --     local device = {}
    --     local location = {}
    --     local contacts = {}
    --     local music = {}
    --     local awake = {}
    --     local dialogue = {}
        
    --     local reportId =  v.reportId
    -- end
    
    return true , nil

end

return _M