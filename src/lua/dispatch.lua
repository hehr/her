local router = require("lua.config.router")
local cjson = require("cjson")

local method = ngx.req.get_method()
local url = ngx.var.uri 
local proxy
local param

for  u , t in pairs(router) do
	
	if u == url then
		proxy  = t  break
	end

end

if not proxy or method ~= proxy.method then -- forbidden
	ngx.status = ngx.HTTP_FORBIDDEN 
	ngx.exit(ngx.status)
	return
end 



if method == 'GET' then

	param = ngx.req.get_uri_args()

elseif method == 'POST' then

	ngx.req.read_body()
	param = ngx.req.get_body_data()

else

 	ngx.status = ngx.HTTP_FORBIDDEN 
	ngx.exit(ngx.status)
	return

end

if not param then  

	ngx.status = ngx.HTTP_BAD_REQUEST
	ngx.exit(ngx.status)
	return

end

proxy.object:feed(param)


