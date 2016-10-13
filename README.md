# her

## 数据库支持
- mysql
- mongol
- redis

## 依赖
- openresty http://openresty.org/cn/ https://github.com/openresty/
- lua-resty-mysql  https://github.com/openresty/lua-resty-mysql
- lua-resty-mongol https://github.com/aaashun/lua-resty-mongol
- lua-resty-redis https://github.com/openresty/lua-resty-redis

## 设计
mvc 模式  

## 代码编写
- 在route 中配置你的访问开关，如　/m?device=1234  ,在route中需要添加配置　['/m'] = { method = 'GET', object = m:new()},　m即service
- 编写你的service，在service中处理业务流程，service中必须实现new() 和　feed()　方法

##测试
见test目录

###TODO　list
- mongol
- redis
