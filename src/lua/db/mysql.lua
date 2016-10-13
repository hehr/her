local cjson = require ("cjson")
local mysql = require("resty.mysql")

local _M = { _VERSION = '0.1.0' }

local mt = { __index = _M }

function _M.init( self,opt )
    local timeout = opt.timeout or 1000 --1s
    local port = opt.port or 3306
    local host  = opt.host or '127.0.0.1'
    local idle_time = opt.idle_time or 10000 --10s
    local pool_size = opt.pool_size or 100 
    local user  = opt.user or 'root'
    local pwd = opt.pwd or 'root'
    local db_name = opt.db_name or 'db'
    local max_packet_size = opt.max_packet_size or 1024*1024

    return setmetatable({   timeout = timeout , 
                            port = port,
                            host = host , 
                            idle_time = idle_time ,
                            pool_size = pool_size ,
                            user = user ,
                            pwd = pwd ,
                            db_name =db_name ,
                            max_packet_size = max_packet_size ,
                            } , mt ) 

end

local function _connect( self )

    local  db , err =  mysql:new()
    
    if not db then
        ngx.log(ngx.ERR , 'msyql new  error :' .. err)
        return nil , err
    end

    db:set_timeout(self.timeout)

    local ok, err = db:connect{
                        host = self.host,
                        port = self.port,
                        database = self.db_name,
                        user = self.user,
                        password = self.pwd,
                        max_packet_size = self.max_packet_size }
    if not ok then
    ngx.log(ngx.ERR , 'msyql connect error :' .. err   )	
    return nil , err 
    end 

    return db , 'success'

end

local function _set_keepalive( self , db)

    db:set_keepalive(self.idle_time, self.pool_size)

end


function _M.select( self , sql )

    local db , err = _connect( self )

    if not db then
        return nil , err
    end

    local res, err = db:query( sql )

    if not res then
        ngx.log(ngx.ERR , 'msyql query error :' .. err )
        return nil ,  err
    end	

    _set_keepalive(self , db )

    return res , 'success'

end


function _M.delete( self,sql )

    local db , err = _connect(self)

    if not db then
        return nil , err
    end

    local res, err　 =　 db:query( sql )

    if not res then
        ngx.log(ngx.ERR , 'msyql delete error :' .. err  )
        return nil ,  err
    end	

    _set_keepalive(self,db)

    return true , 'success'

end


function _M.update( self,sql )

    local db , err = _connect(self)

    if not db then
        return nil , err
    end

    local  res , err　 = db:query( sql )

    if not res then
        ngx.log(ngx.ERR , 'msyql update error :' .. err  )
        return nil ,  err
    end	

    _set_keepalive(self,db)

    return true , 'success'

end


function _M.insert( self,sql )

    local db , err = _connect(self)

    if not db then
        return nil , err
    end

    local res  , err = db:query( sql )

    if res == nil then
        ngx.log(ngx.ERR , 'msyql insert error :' .. err   )
        return nil ,  err
    end	

    _set_keepalive(self,db)

    return true , 'success'

end

return _M