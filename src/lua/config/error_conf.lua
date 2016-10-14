
--[[
    400开头返回业务错误代码
    500开头返回服务器内部错误
]]--
local _M = { 

    _VERSION = '0.1.0',
    ['auth_error'] = { error_code = 40001 ,reason = '授权失败，请检查授权信息' },
    ['db_auth_error'] = {error_code = 50001 , reason ='数据库授权失败'},
    
}
return _M