
local _M = { _VERSION =  '0.1.0'}

local  regex = "select|insert|delete|from|count\\(|drop table|update|truncate|asc\\(|mid\\(|char\\(|xp_cmdshell|exec master|netlocalgroup administrators|:|net user|or|and"

function _M.inject( subject )

    if  ngx.re.find(subject , regex , "isjo") then
        return  true
    end
    return false

end

return _M