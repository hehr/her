--[[

  公共信息集合/每一次上传都会直接产生一次数据

  {　　
    uuId:标识用户一次行为的唯一id
    collectType:服务端采集还是sdk客户端采集  
    systemVersion:系统版本，
    sdkVersion:采集sdk版本，
    aiVersion:AIOS版本,
    userType:用户类型，     
    deviceId:设备唯一标识， 
    authId:客户标识，
    time:上传时间，
    locationId:定位信息唯一id,
    awakeId:唤醒唯一标识,
    dialogueId:对话唯一标识,			
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
                        idle_time = 0,})
    
        if db ~= nil then
            _M.db = db
        end
    
        _M.collection = 'uu' --　set collection 

        return setmetatable( {} , { __index = _M } )

   end

   --插入uu
   function _M.insert_uu( self , doc )

       if not _M.db or not doc then
            return nil , 'uu dao can not get db or nil doc'
       end
        
       return _M.db:insert( _M.collection,doc )

   end

   function _M.query_uus(self , query,returnfields,num_each_query,is_auth)
      
      if not _M.db or not query then
        return nil , 'uu dao can not get db or nil query'
      end 

      return _M.db:query(_M.collection,query,returnfields,num_each_query,is_auth )  

   end

return _M