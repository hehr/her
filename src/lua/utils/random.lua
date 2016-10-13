
local rand = {'A','B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z','0','1','2','3','4','5','6','7','8','9'}

local _M = {_VERSION = '0.1.1'}



--[[
 指定位长度
]]--
function _M.get_random_id( self,len )
       
  math.randomseed(tonumber(tostring(os.clock()):reverse():sub(1,6)))

  local tab = {}
  for i=1, len do
     table.insert(tab, rand[math.random(1,table.getn(rand))])
  end
  return table.concat(tab)

end

--[[
  获取指定范围的随机数
]]--
function _M.get_random_number(self ,range)

  math.randomseed(tonumber(tostring(os.clock()):reverse():sub(1,6)))
  return math.random(1, range)

end

return _M