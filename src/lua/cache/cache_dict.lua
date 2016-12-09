--[[
@auth hehr
注意：1 如果写入满，需要切换到另外一个数据集合中写入，
     2 key值使用上传的reportId
     2 需要加入时间戳，方便后面存储数据区分上传时间。

]]--

local cjson = require("cjson")
local collector = require("lua.persistence.service.collector")


-- 缓存区的大小，标示接受的数据条目数
local limit_size = 5000

-- key = reportId , value = data 
-- 优使用 dog ，dog 超过 1000调数据，再使用 cat
local cache = { dog = {} , cat = {} }

--默认先是用dog存储
local cache_name = 'dog'


--持久化数据
local function keep_store(premature,cache)
    
    local service = collector:new()

    local ok,err = service:start(cache)

    if not ok then
        ngx.log(ngx.ERR , "store data error , err : " .. err )
    end

end


--释放缓存空间并启动数据库持久化进程
local function free_cache( index_name )

    -- ngx.log(ngx.INFO, "before free size:" .. #cache[index_name])

    ngx.timer.at( 0 , keep_store , cache[index_name])    
    
    cache[index_name] = {}

    -- ngx.log(ngx.INFO, "after free size:" .. #cache[index_name])

end

-- 内存缓存策略：
-- 1 启用缓存策略 
-- 2 优先使用 dog cat 中内存空间，并且在dog 和cat 存储中动态切换
-- 3 当一个存储空间满额之后，启动持久化进程，将缓存中的数据存储到mongo中。
local function get_cache()

    -- ngx.log(ngx.INFO , "<><><><><><><><><><><><><><><><><><><>")

    -- ngx.log(ngx.INFO , "ngx.worker.id() : " .. ngx.worker.id() )

    -- if cache_name == 'dog' then
    --     ngx.log(ngx.INFO , "current_cache is dog ")
    -- else
    --     ngx.log(ngx.INFO , "current_cache is cat ")
    -- end

    -- ngx.log(ngx.INFO , "dog size: " .. #cache['dog'])
    -- ngx.log(ngx.INFO , "cat size: " .. #cache['cat'])

    -- ngx.log(ngx.INFO , "<-><-><-><-><-><-><-><-><-><-><-><-><-><-><->")

        
    if #cache[cache_name] == limit_size then

        local old_cache_name = cache_name  

        if cache_name == 'dog' then

            cache_name = 'cat'

        elseif cache_name == 'cat' then

            cache_name = 'dog'

        end

        free_cache(old_cache_name) --释放满额的内存空间

    end

    return cache[cache_name]

end

local _M = { _VERSION = '0.1.0'}


function _M.new(self)
    return setmetatable( {} , { __index = _M } )
end


function _M.add(self,key,data)

    local  current_cache = get_cache()

    if current_cache then

        local temp = {key , data}
        
        table.insert( current_cache , temp ) 
        
        return true , err

    else

        return nil , 'can`t cache data , check cache chunk!'

    end

end

return _M