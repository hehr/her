--[[
  mongo insert service demo
]]--

local cjson = require("cjson")
local user = require("lua.dao.m_user")
local random = require("lua.utils.random")

local _M = { _VSERSION = '0.1.0' }

function _M.new(self)
	return setmetatable( {} , { __index = _M } )
end


function _M.feed(self , body)

    local edge = random:get_random_number(100)

    local id = random:get_random_id(6)

    local name = 'hehr_' .. id
    
    local doc = { id = id , edge =  edge, name = name , sex = sex }

    if doc.edge <= 50 then
        doc.sex = '女'
    else
        doc.sex = '男'
    end

    local docs = {doc}

    local user  = user:new()

    local res , err = user:insert_user( docs )

    ngx.say(err)

end


return _M