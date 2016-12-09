local mongol = require("resty.mongol")
local cjson = require("cjson")

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
 local pool_size = opt.pool_size or 10000

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

local function _connect( self , is_auth)
   
   local conn = mongol:new()

   conn:set_timeout( self.timeout)
   
   local ok,err = conn:connect( self.host,self.port)
   
   if not ok then
     ngx.log(ngx.ERR , "mongol connect err ,error : " .. err )
     return  nil,err         
   end

    --Todo  待添加 gridfs 文件支持
    local db  = conn:new_db_handle(self.db_name)
   
    if not db then
        ngx.log(ngx.ERR , 'can not get db')
        return  nil,'connect can not get db' 
    end


    if is_auth then

        local ok , err = db:auth_scram_sha1(self.user , self.pwd)
        
        if not ok then
            ngx.log(ngx.ERR , ' db auth error , error : ' .. err)
            return nil,err  
        end

    end

    return  db,'success',conn

end

local function _set_keepalive( self , conn )
    
   conn:set_keepalive( self.idle_time , self.pool_size )
    
end



--[[
    is_auth 是否需要授权验证,默认不授权
    collection_name 集合名称
    query 查询条件，如｛ id=12345 ｝
    returnfields table like {sex = '男'}，对结果集筛选，返回结果只包含满足条件字段 ,　默认｛｝不对结果进行筛选
    ]]--
function _M.query_one( self,collection_name,query,returnfields,is_auth )
    
    local is_auth = is_auth or false

    local returnfields = returnfields or {}

    local db , err , conn = _connect( self , is_auth )

    if not db then
       return nil , err
    end

    local collection =  db:get_col(collection_name)
    
    if not collection then
        ngx.log(ngx.ERR ,  ' mongol can not get collection ' )
        return nil , 'can not get collection'    
    end

    local result  =  collection:find_one(query ,returnfields)

    if not result then
       ngx.log(ngx.ERR ,  'mongol can not find result' )
       return nil , 'can not find result'    
    end
    
    _set_keepalive( self , conn ) -- set in pool 

    return result , 'success'

end

--[[
    is_auth 是否需要授权，默认不授权
　  returnfields table like {sex = '男'}，对结果集筛选，返回结果只包含满足条件字段 ,　默认｛｝不对结果进行筛选
    num_each_query 结果条目数限制，默认100
]]--
function _M.query( self,collection_name,query,returnfields,num_each_query,is_auth)

    local is_auth = is_auth or false
    local returnfields = returnfields or {}
    local num_each_query = num_each_query or 100

    local db , err , conn = _connect( self , is_auth )

    if not db then
       return nil , err
    end

    local collection =  db:get_col(collection_name)
    
    if not collection then
        ngx.log(ngx.ERR ,  ' mongol can not get collection' )
        return nil , 'can not get collection'    
    end

    local cursor = collection:find(query,returnfields,num_each_query)

    if not cursor then
       ngx.log(ngx.ERR ,  'mongol can not find result' )
       return nil , 'can not find result'    
    end

    local result  = {}

    for index, item in cursor:pairs() do
        table.insert( result, item )
    end
    
     _set_keepalive( self , conn ) -- set in pool 

    return result , 'success'

end

--[[
  collection_name 集合
  doc 插入文档　，如　  ｛ name = 'hehr' , sex = 'man' , old = 18   ｝
  is_auth 是否需要授权验证,默认不授权
  continue_on_error 如果设置，如果一个失败（例如由于重复的入侵检测），数据库将不停止处理其他的大量处理。默认不开启
]]--
function _M.insert(self , collection_name , doc , is_auth , continue_on_error )

    local is_auth = is_auth or false
    local continue_on_error = continue_on_error or 0

    local db , err , conn = _connect( self , is_auth ) 

    if not db then
        ngx.log(ngx.ERR, "mongol connect db err , err: " .. err)
        return false , err 
    end

    local collection =  db:get_col(collection_name)
    
    if not collection then
        ngx.log(ngx.ERR ,  ' mongol can not get collection ' )
        return false , 'can not get collection '    
    end
    local n , err = collection:insert( doc , continue_on_error ,false)

    if not n then
        ngx.log(ngx.ERR, "mongol insert err , err: " .. err)
        return false , err
    end

    _set_keepalive( self , conn ) -- set in pool 

    return true , 'success'

end

--[[
selector 条件
update 内容
is_auth 是否需要授权验证,默认不授权
upsert 　0 or 1　，如果置为１代表如果匹配不到，则插入数据 , 0　相反。 默认　不开启
multiupdate　0 or 1 ,如果置为１代表更新所有匹配到的数据,　0　相反。默认　不开启
]]--
function _M.update(self,collection_name,selector,update,upsert,multiupdate,is_auth)

    local is_auth = is_auth or false
    local upsert = upsert or 0
    local multiupdate = multiupdate or 0

    local db , err , conn = _connect( self,is_auth) 

    if not db then
        return false , err 
    end

    local collection =  db:get_col(collection_name)
    
    if not collection then
        ngx.log(ngx.ERR ,  ' mongol can not get collection' )
        return false , 'can not get collection'    
    end

    local n , err  = collection:update(selector,update,upsert,multiupdate,false)

    if not n then
        ngx.log(ngx.ERR, "mongol update err , err: " .. err)
        return false , err
    end
    
    _set_keepalive( self , conn ) -- set in pool 

    return true ,'success'

end

--[[
   collection_name　集合名称
   selector　条件
   is_auth　是否需要授权验证，默认不开启
   single_remove 0 or 1 ,如果置为１则只删除匹配到的第一条数据。默认开启
]]--
function _M.delete( self,collection_name,selector,single_remove,is_auth )
    
    local is_auth = is_auth or false
    local single_remove = single_remove or 1

    local db , err , conn = _connect(self ,is_auth) 

    if not db then
        return false , err 
    end

    local collection =  db:get_col(collection_name)
    
    if not collection then
        ngx.log(ngx.ERR ,  ' mongol can not get collection ' )
        return nil , 'can not get collection '    
    end

    local n , err = collection:delete(selector,single_remove,false)

    if not n then
        ngx.log(ngx.ERR , 'mongol delete err , err : ' .. err )
        return false , err 
    end

    _set_keepalive( self , conn ) -- set in pool 

    return true ,'success'

end



return _M