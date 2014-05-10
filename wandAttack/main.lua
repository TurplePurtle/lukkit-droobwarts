lukkit.addPlugin("wandAttack", "1.0", function(plugin)
--------

local Action = luajava.bindClass("org.bukkit.event.block.Action")
local Projectile = luajava.bindClass("org.bukkit.entity.Arrow")

local asdf = {}

events.add("playerInteract", function(ev)
  local player = ev:getPlayer()
  local action = ev:getAction()
  
  if action == Action.LEFT_CLICK_AIR or action == Action.LEFT_CLICK_BLOCK then
    local t = os.clock()
    
    if not asdf[player] or t - asdf[player] >= 1 then
      player:launchProjectile(Projectile, player:getLocation():getDirection():multiply(5))
      asdf[player] = t
    end
  end
end)

-- events.add("playerToggleSneak", function(ev)
  -- local player = ev:getPlayer()
  
  -- if ev:isSneaking() then
    -- local xp = player:getExp()
    -- if xp < 1 then
      -- bukkit scheduler might help
      -- xp
    -- end
  -- else
  -- end
-- end)

--------
end)
