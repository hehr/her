
--[[
    400开头返回业务错误代码
    500开头返回服务器内部错误
]]--
local _M = { 
    _VERSION = '0.1.0',
    ['collect_success'] = {status = 'success',error_code = 0 },
    ['auth_error'] = { status = 'error',error_code = 40001 , reason = '授权失败,请检查授权信息' },
    ['param_error'] = { status = 'error' , error_code = 40002 , reason = '参数获取失败,请检查参数'},
    ['process_error'] = { status = 'error' , error_code = 40003 , reason = '数据处理失败,请联系开发童鞋'},
    ['db_auth_error'] = { status = 'error' , error_code = 50001 , reason ='数据库授权失败'},
}
return _M