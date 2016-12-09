--[[
    
    用户信息集合

    {
   　role:角色，  　//admin(管理员),user(项目经理，技术支持),customer（客户）		
   　userName:用户名,
　　　pwd:密码，  //md5加密
   　time:注册时间,
   　phoneNum:手机号, //18520037669,
　　　Email:邮箱,	
 　　}

]]--
local mongol = require("lua.db.mongol")
local conf = require("lua.config.mongol_conf")
local cjson = require("cjson")

local _M = { _VERSION = '0.1.0' }

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
    
    _M.collection = 'user' --　set collection 

    return setmetatable( {} , { __index = _M } )

end


function _M.insert_user( self , doc )

    if not _M.db or not doc then
        return nil , 'user dao can not get db or nil doc'
    end

    return _M.db:insert(_M.collection,doc )

end


function _M.query_user( self,query,returnfields)
    
    if not _M.db or not query or not returnfields then
        return nil , 'user dao can not get db or bad query'
    end
    
    return _M.db:query_one( _M.collection,query,returnfields )

end

function _M.query_users(self,query,returnfields,number)

    if not _M.db or not query or not returnfields then
        return nil , 'user dao can not get db'
    end
    
    return _M.db:query( _M.collection,query,returnfields,number)

end

function _M.update_user( self,selector,update,upsert,multiupdate)
    
    if not _M.db  then
        return nil , 'user dao can not get db'
    end

    return _M.db:update( _M.collection,selector,update,upsert,multiupdate,false ) 

end

return _M