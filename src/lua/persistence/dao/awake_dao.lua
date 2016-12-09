--[[

    awake collection:

{
　　uuId:	
   awakeId:唤醒唯一标识，
   type:唤醒类型，主唤醒词，自定义唤醒词，快捷唤醒词，oneshot,点击麦克
   time:唤醒时间戳，
   function:唤醒次功能，针对oneshot
   dialogueId:唤醒后产生的对话Id　　　　　　　　　　　　　　 
}

]]--


local mongol = require("lua.db.mongol")
local conf = require("lua.config.mongol_conf")
local cjson = require("cjson.safe")

local _M = {_VERSION = '0.1.0'}

   function _M.new( self )
      
      local db = mongol:init({ -- set db operate info 
                        timeout = 10000,
                        port = conf.port, 
                        host = conf.host,
                        user = conf.user,
                        pwd = conf.pwd,
                        db_name = conf.db_name,
                        pool_size = 10000,
                        idle_time = 10000,})
    
        if db ~= nil then
            _M.db = db
        end
    
        _M.collection = 'awake' --　set collection 

        return setmetatable( {} , { __index = _M } )

   end

   --插入uu
   function _M.insert_awake( self , doc )

       if not _M.db or not doc then
            return nil , 'awake dao can not get db or nil doc'
       end
        
       return _M.db:insert( _M.collection,doc )

   end

return _M