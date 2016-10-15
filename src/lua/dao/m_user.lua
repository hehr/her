--[[
    mongol dao　demo
]]--
local mongol = require("lua.db.mongol")
local conf = require("lua.config.mongol_conf")
local random = require("lua.utils.random")

local _M = { _VERSION = '0.1.0' }

function _M.new( self )
    
    local db = mongol:init({ -- set db operate info 
                        timeout = 1000,
                        port = conf.port, 
                        host = conf.host,
                        user = conf.user,
                        pwd = conf.pwd,
                        db_name = conf.db_name,
                        pool_size = 200,
                        idle_time = 10000,})
    
    if db ~= nil then
        _M.db = db
    end
    
    _M.collection = 'user' --　set collection 

    return setmetatable( {} , { __index = _M } )

end


function _M.insert_user( self , doc )

    if not _M.db  then
        return nil , 'can not get db'
    end


    -- local doc = { name  = random:get_random_id(5) , edge = random:get_random_number(100) }
    
    return _M.db:insert(_M.collection , doc )

end


function _M.query_user( self , query ,returnfields)
    
    if not _M.db  then
        return nil , 'can not get db'
    end
    
    return _M.db:query_one( _M.collection,query,returnfields )

end

function _M.query_users(self,query,returnfields , number)

    if not _M.db  then
        return nil , 'can not get db'
    end
    
    return _M.db:query( _M.collection,query,returnfields,number )

end

function _M.update_user( self, selector , update , upsert　, multiupdate)
    
    if not _M.db  then
        return nil , 'can not get db'
    end

    return _M.db:update( _M.collection,selector,update,upsert,multiupdate) 

end

function _M.delete_user(self, selector ,single_remove )

    if not _M.db  then
        return nil , 'can not get db'
    end

    return _M.db:delete( _M.collection,selector,single_remove )

end

return _M