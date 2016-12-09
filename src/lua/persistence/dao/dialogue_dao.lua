--[[
    
   dialogue　collection:

{
   uuId:	
   dialogueId:对话唯一标识，
   startTime:对话开始时间，
   duration:对话持续时间，从开始到退出的时间,统计用户停留时间
   talk:[{
		 action:功能意图，
		　condition:执行意图触发条件，　　
		 duration:响应用户单轮对话所需时间，客户端记录用户说完话到TTS开始播报的时间区间，　
		　interrupt:[{
			      type:打断类型，主唤醒词打断，取消/退出，分词打断，固定次打断
			      context:打断词汇，						
			      },{打断2},{打断3}],
			},{第二轮对话},{第三轮对话}],
	
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
    
    _M.collection = 'dialogue' --　set collection 

    return setmetatable( {} , { __index = _M } )

end


function _M.insert_dialogue( self , doc )

    if not _M.db or not doc then
        return nil , 'dialogue dao can not get db or nil doc'
    end

    return _M.db:insert(_M.collection,doc )

end

return _M