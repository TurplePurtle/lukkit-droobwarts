lukkit.addPlugin("invisiCloak", "1.0", function(plugin)
--------

local statistic = luajava.bindClass("org.bukkit.Statistic")
local config = plugin.config
local cloakMaterial = material[config.get("cloak-material")]
local invisTagStatistic = statistic.FISH_CAUGHT
local invisTagStatisticValue = 2e9 -- just some big number


local function playerInvisTag(player, tag)
  if tag == nil then
    return player:getStatistic(invisTagStatistic) >= invisTagStatisticValue
  else
    local val = tag and invisTagStatisticValue or 0
    player:setStatistic(invisTagStatistic, val)
  end
end

local function makePlayerInvisible(player)
  playerInvisTag(player, true)
  -- player:setExp(1) -- fix experience gain

  local players = server:getOnlinePlayers()
  for i = 1,#players do
    players[i]:hidePlayer(player)
  end
  player:sendMessage(config.get("cloak-equip-message"))
end

local function makePlayerVisible(player)
  playerInvisTag(player, false)

  local players = server:getOnlinePlayers()
  for i = 1,#players do
    players[i]:showPlayer(player)
  end
  player:sendMessage(config.get("cloak-unequip-message"))
end


events.add("playerItemHeld", function(ev)
  local player = ev:getPlayer()
  local inventory = player:getInventory()
  local currItem = inventory:getItem(ev:getNewSlot())
  local isInvisible = playerInvisTag(player)

  if currItem and currItem:getType() == cloakMaterial and not isInvisible then
    makePlayerInvisible(player)
  elseif isInvisible then
    makePlayerVisible(player)
  end
end)

events.add("playerDropItem", function(ev)
  local player = ev:getPlayer()
  local item = ev:getItemDrop():getItemStack()
  
  if item and item:getType() == cloakMaterial then
    makePlayerVisible(player)
  end
end)

-- don't allow "natural" changes to this statistic
events.add("playerStatisticIncrement", function(ev)
  if ev:getStatistic() == invisTagStatistic then
    setCancelled(true)
  end
end)

events.add("playerJoin", function(ev)
  local joinedPlayer = ev:getPlayer()
  local players = server:getOnlinePlayers()
  for i = 1,#players do
    local p = players[i]
    if playerInvisTag(p) then
      joinedPlayer:hidePlayer(p)
    end
  end
end)

--------
end)
