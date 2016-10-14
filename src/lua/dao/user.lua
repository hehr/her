local mysql =  require("lua.db.mysql")
local mysql_conf =  require("lua.config.mysql_conf")


local _M = { _VERSION = '0.1.0'  }


function _M.new(self)

	local db = mysql:init( {
				timeout = 1000 ,
				port = mysql_conf.port ,
				host = mysql_conf.host , 
				idle_time = 10000 ,
				pool_size = 200 ,
				user = mysql_conf.user ,
				pwd = mysql_conf.pwd ,
				db_name =mysql_conf.db_name ,
				max_packet_size = 1024*1024 ,
					})

	if db ~= nil then
		_M.db  = db
	end

	return setmetatable( {} , { __index = _M } )

end

function _M.query_user_by_device( self , device )

	local sql = "SELECT id,device_id,open_id,nick_name,sex,language,city,province,country,headimgurl,subscribe_time,unionid,remark,groupid,tagid_list FROM tb_user WHERE device_id = \'".. device .."\' limit 1;"

	if _M.db ~= nil then
		return	_M.db:select(sql)
	end

	return nil , 'can not get db'

end


function _M.insert_user( self , user)

	local sql  = "INSERT INTO tb_user (open_id,nick_name,sex,language,city,province,country,headimgurl,subscribe_time,unionid,remark,groupid,tagid_list) VALUES (\'"
		.. user.open_id .."\',\'".. user.nick_name .."\',\'".. user.sex .."\',\'".. user.lang .."\',\'".. user.city .."\',\'".. user.prov .."\',\'".. user.country
	  	 .."\',\'".. user.head_imgurl .."\',\'".. user.time .."\',\'".. user.union_id .."\',\'".. user.remark .."\',\'".. user.group_id.."\',\'".. user.tagid_list .."\');"
    

	if _M.db ~= nil then
		return  _M.db:insert(sql)
	end	

	return nil , 'can not get db'

end

function _M.update_user( self , user )
	
	local sql  = "UPDATE tb_user SET nick_name = \'".. user.nick_name.."\',sex = \'".. user.sex.."\', language = \'"
		..user.lang.."\', city = \'"..user.city.."\' , province = \'".. user.prov .."\', country = \'"..user.country.."\' , headimgurl = \'"
		..user.head_imgurl.."\' , subscribe_time = \'".. user.time .."\' , unionid = \'".. user.union_id .."\' , remark = \'".. user.remark
		.."\' , groupid = \'".. user.group_id.."\' , tagid_list = \'".. user.tagid_list .."\'  WHERE id = ".. user.id..";"	   


	if _M.db ~= nil then
		return  _M.db:update(sql)
	end	
	
	return nil , 'can not get db'

end

function _M.delete_user(self , id)
	
	local sql = "delete from tb_user where id = " .. id ..";"

	if _M.db ~= nil then 
		return _M.db:delete(sql)
	end

	return nil , 'can not get db'

end

return _M