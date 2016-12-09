--[[
    统计接口上报处理
]]--
local uu = require("lua.dao.uu_dao")
local awake = require("lua.dao.awake_dao")
local location = require("lua.dao.location_dao")
local dialogue = require("lua.dao.dialogue_dao")
local uuid =  require("resty.uuid")
local cjson = require("cjson.safe")


local function insert_uu(self , data)

    local uu = uu:new()

    return uu:insert_uu(data)  

end

local function insert_location(self , data)
     
     local location = location:new()
     
     return location:insert_location({ data }) --这里每次插入的应该是单条数据

end     

local function insert_awake(self,data)

    local awake = awake:new()

    return awake:insert_awake(data)

end

local function insert_dialogue(self,data)

    local dialogue = dialogue:new()

    return dialogue:insert_dialogue(data)

end



local _M = { _VERSION = '0.1.0' }

function _M.new(self)
    return setmetatable( {} , { __index = _M } )
end
     
function _M.process(self,data)

    
    local awakes = {} --唤醒的数据
    local locations = {} --定位数据
    local dialogues = {} --对话数据                
    local uus = {} --公共数据


    for i = 1 , #data.awake , 1 do  --唤醒的次数>=对话的次数


        local uu_data = { collectType = data.collectType ,
                            systemVersion = data.systemVersion,
                            sdkVersion = data.sdkVersion,
                            aiVersion = data.sdkVersion,
                            userType = data.userType,
                            deviceId = data.deviceId,
                            authId = data.authId }

        -- uu_data
        uu_data.uuId = uuid:generate_random()
        uu_data.time = ngx.time()
        uu_data.locationId = uu_data.uuId
        uu_data.awakeId = data.awake[i].awakeId
        uu_data.dialogueId = data.awake[i].dialogueId --这里使用上传数据携带的数据
        table.insert( uus , uu_data )       

        -- awake_data 
        local awake_data = data.awake[i]
        awake_data.uuId =  uu_data.uuId
        table.insert( awakes, awake_data ) 
        
        -- dialogue_data
        if data.dialogue[i] ~= nil then

            local dialogue_data = data.dialogue[i]
            dialogue_data.uuId = uu_data.uuId
            table.insert( dialogues, dialogue_data )
        
        end
        -- location_data
        if i == 1 then

            locations = data.location
            locations.locationId =  uu_data.locationId
            locations.uuId = uu_data.uuId

        end 
           
    end

    local status , err = insert_uu(self,uus) 
    
    if not status then
        return nil , err 
    end

    local status , err = insert_awake(self,awakes)

    if not status then
        return nil , err 
    end
    
    local status , err = insert_dialogue(self,dialogues)

    if not status then
        return nil , err 
    end

    local status , err = insert_location(self,locations)

    if not status then
        return nil , err 
    end

    return true , nil

end

return _M