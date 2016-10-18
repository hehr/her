#her

## 1.简介
her是基于openresty封装的高性能服务架构，可用于有高并发需求的项目。依据mvc思想，对lua代码进行了封装。集成了mysql,mongo,redis的支持，以及一些常用工具类的封装，如http请求，实现了一个简单的的路由分发。
    
## 2.使用
可直接拿来使用

## 3.依赖

- [openresty](http://openresty.org/cn/)  [openresty源码](https://github.com/openresty/)
- [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql)
- [lua-resty-mongol](https://github.com/aaashun/lua-resty-mongol)
- [lua-resty-redis](https://github.com/openresty/lua-resty-redis)


## 4.测试
使用ab测试，目前只在ubuntu和centos跑过。

## 5.TODO　LIST
- redis
- readme
