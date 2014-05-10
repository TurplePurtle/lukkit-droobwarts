lukkit.addPlugin("broomFlight", "1.0", function(plugin)
--------

local gamemode = luajava.bindClass("org.bukkit.GameMode")
local config = plugin.config
local broomMaterial = material[config.get("broom-material")]

local function hasCreativeMode(player)
  return player:getGameMode() == gamemode.CREATIVE
end

local function activateFlight(player)
  if hasCreativeMode(player) then return end

  player:sendMessage(config.get("broom-equip-message"))
  player:setExp(1)
  player:setAllowFlight(true)
end

local function deactivateFlight(player)
  if hasCreativeMode(player) then return end
  if not player:getAllowFlight() then return end
  
  player:sendMessage(config.get("broom-unequip-message"))
  player:setAllowFlight(false)
end


events.add("playerItemHeld", function(ev)
  local player = ev:getPlayer()

  if hasCreativeMode(player) then return end

  local inventory = player:getInventory()
  local currItem = inventory:getItem(ev:getNewSlot())

  if currItem and currItem:getType() == broomMaterial then
    activateFlight(player)
  elseif player:getAllowFlight() then
    deactivateFlight(player)
  end
end)

events.add("playerDropItem", function(ev)
  local player = ev:getPlayer()

  if hasCreativeMode(player) then return end

  local item = ev:getItemDrop():getItemStack()
  
  if item and item:getType() == broomMaterial then
    deactivateFlight(player)
  end
end)

local expPerMeter = 1 / config.get("flight-meters-per-bar")

events.add("playerMove", function(ev)
  local player = ev:getPlayer()
  if hasCreativeMode(player) then return end
  
  if player:isFlying() then
    local dist = ev:getTo():distance(ev:getFrom())
    local exp = player:getExp()
    
    if exp <= 0 then
      player:sendMessage(config.get("no-flight-juice-message"))
      player:setAllowFlight(false)
    else
      player:setExp(exp - expPerMeter * dist)
    end
  end
end)

--------
end)
