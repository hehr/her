--[[

location collection:

{
    uuId:uu collection 标识
    locationId:定位信息唯一标识	
    time:上传时间，
    city:城市信息，
    country:国家，
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
    
        _M.collection = 'location' --　set collection 

        return setmetatable( {} , { __index = _M } )

   end

   --插入uu
   function _M.insert_location( self , doc )

       if not _M.db or not doc then
            return nil , 'location dao can not get db or nil doc'
       end
        
       return _M.db:insert( _M.collection,doc )

   end

return _M