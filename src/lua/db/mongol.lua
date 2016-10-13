local  mongol = require("resty.mongol")


local _M = {}

local mt = { __index = _M }

function _M.init(self , opt )

 local port =  opt.port or 27017
 local host = opt.host or '127.0.0.1'
 local user = opt.user or 'root'
 local pwd = opt.pwd or 'root'
 local timeout = opt.timeout or 1000
 local db_name = opt.db_name or 'db'
 local idle_time = opt.idle_time or 10000
 local pool_size = opt.pool_size or 100

 return setmetatable( { 
                        timeout = timeout,
                        port = port , 
                        host = host ,
                        user = user ,
                        pwd = pwd ,
                        db_name = db_name ,
                        pool_size = pool_size ,
                        idle_time = idle_time ,
                         } , mt )

end

local function _connect( self  , is_auth)
   
   local conn = mongol.new()
   conn:set_timeout(self.timeout)
   local ok , err = conn.connect()
   
   if not ok then
     ngx.log(ngx.ERR , "mongol connect err ,error : " .. err )
     return nil , err         
   end

   if is_auth then
       local ok , err = db:auth_scram_sha1(self.user , self.pwd)
        if not ok then
           ngx.log(ngx.ERR , ' db auth error , error : ' .. err)
           return nil , err 
        end
    end

    --Todo  待添加 gridfs 文件支持
    local db  = conn:new_db_handle(self.db_name)
   
    if not db then
        ngx.log(ngx.ERR , 'can not get db')
        return  nil  , 'connect can not get db' 
    end

   return db , 'success' , conn

end

local function _set_keepalive(self , conn )
    
   conn:set_keepalive(self.idle_time , self.pool_size)
    
end



--[[
    is_auth 是否需要授权验证
    collection_name 集合名称
    query 查询条件，如｛ id=12345 ｝
]]--
function _M.select(self , is_auth , collection_name , query )
    
    local db , err , conn = _connect(self , is_auth )

    if not db then
       return nil , err
    end

    local result =  db:get_col(collection_name):find_one(query)

    if not result then
       ngx.log(ngx.ERR ,  ' can not get collection ' )
       return nil , 'can not get collection '    
    end
    
    _set_keepalive( conn ) -- set in pool 

    return result , 'success'

end

--[[
  is_auth 是否需要授权验证
  collection_name 集合
  doc 插入文档　，如　  ｛ name = 'hehr' , sex = 'man' , old = 18   ｝
]]--
function _M.insert(self , is_auth , collection_name , doc )

    local db , err , conn = _connect(is_auth) 

    if not db then
        return false , err 
    end

    local n  , err = db:get_col(collection_name):insert(doc)

    if not n then
        return false , err
    end

    _set_keepalive( conn ) -- set in pool 

    return true , 'success'

end

function _M.update(self)
end

function _M.delete(self)
end



return _M