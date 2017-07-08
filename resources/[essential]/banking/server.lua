require "resources/mysql-async/lib/MySQL"

-- HELPER FUNCTIONS
function bankBalance(player)
  return tonumber(MySQL.Sync.fetchScalar("SELECT bankbalance FROM users WHERE identifier = @name", {['@name'] = player}))
end

function bankdBalance(player)
  return tonumber(MySQL.Sync.fetchScalar("SELECT dirtymoney FROM users WHERE identifier = @name", {['@name'] = player}))
end

function deposit(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance + amount
  MySQL.Async.execute("UPDATE users SET `bankbalance`=@value WHERE identifier = @identifier", {['@value'] = new_balance, ['@identifier'] = player})
end

function withdraw(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance - amount
  MySQL.Async.execute("UPDATE users SET `bankbalance`=@value WHERE identifier = @identifier", {['@value'] = new_balance, ['@identifier'] = player})
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Montant trop élevé^0")
        CancelEvent()
      else
        if(tonumber(rounded) <= tonumber(user:money)) then
          user:removeMoney((rounded))
          local player = user.identifier
          deposit(player, rounded)
          local new_balance = bankBalance(player)
          TriggerClientEvent("citizenv:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Dépôt: ~g~$".. rounded .." ~n~~s~Nouvelle Balance: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:addBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent!^0")
          CancelEvent()
        end
      end
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Montant trop élevé^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        if(tonumber(rounded) <= tonumber(bankbalance)) then
          withdraw(player, rounded)
          user:addMoney((rounded))
          local new_balance = bankBalance(player)
          TriggerClientEvent("citizenv:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Retrait: ~g~$".. rounded .." ~n~~s~Nouvelle Balance: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent dans le compte!^0")
          CancelEvent()
        end
      end
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('bank:remove')
AddEventHandler('bank:remove', function(source, amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local rounded = round(math.abs(tonumber(amount)), 0)
      local player = user.identifier
      local bankbalance = bankBalance(player)
      withdraw(player, rounded)
      local new_balance = bankbalance - rounded
      TriggerClientEvent("banking:updateBalance", source, new_balance)
      TriggerClientEvent("banking:removeBalance", source, rounded)
      CancelEvent()
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Impossible de se transférer à soi-même^0")
    CancelEvent()
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
      if (user) then
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Montant trop élevé^0")
          CancelEvent()
        else
          local player = user.identifier
          local bankbalance = bankBalance(player)
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            withdraw(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("citizenv:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transféré: ~r~-$".. rounded .." ~n~~s~Nouvelle Balance: ~g~$" .. new_balance)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:removeBalance", source, rounded)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
              local recipient = user2.identifier
              deposit(recipient, rounded)
              new_balance2 = bankBalance(recipient)
              TriggerClientEvent("citizenv:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Reçu: ~g~$".. rounded .." ~n~~s~Nouvelle Balance: ~g~$" .. new_balance2)
              TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
              TriggerClientEvent("banking:addBalance", toPlayer, rounded)
              CancelEvent()
            end)
            CancelEvent()
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent dans le compte^0")
            CancelEvent()
          end
        end
      else
        TriggerEvent("es:desyncMsg")
      end
    end)
  end
end)

-- DOUBLE CALLBACK
-- RegisterServerEvent('bank:givecash')
-- AddEventHandler('bank:givecash', function(toPlayer, amount)
-- 	TriggerEvent('es:getPlayerFromId', source, function(user)
-- 		if (tonumber(user.money) >= tonumber(amount)) then
-- 			local player = user.identifier
-- 			user:removeMoney(amount)
-- 			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
-- 				recipient:addMoney(amount)
-- 				TriggerClientEvent("citizenv:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent donné: ~r~-$".. amount .." ~n~~s~Porte-monnaie: ~g~$" .. user.money)
-- 				TriggerClientEvent("citizenv:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent reçu: ~g~$".. amount .." ~n~~s~Porte-monnaie: ~g~$" .. recipient.money)
-- 			end)
-- 		else
-- 			if (tonumber(user.money) < tonumber(amount)) then
--         TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent dans votre porte-monnaie^0")
--         CancelEvent()
-- 			end
-- 		end
-- 	end)
-- end)

RegisterServerEvent("banking:getBalance")
AddEventHandler('banking:getBalance', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local player = user.identifier
      local bankbalance = bankBalance(player)
      TriggerClientEvent("banking:f_getBalance", source, bankbalance)
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      user:setMoney(user.money)
      user:setDMoney(user.dirtymoney)
      local player = user.identifier
      local bankbalance = bankBalance(player)
      local bankdbalance = bankdBalance(player)
      TriggerClientEvent("banking:updateBalance", source, bankbalance)
      TriggerClientEvent("banking:updatedBalance", source, bankdbalance)
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('bank:withdrawFacture')
AddEventHandler('bank:withdrawFacture', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "FACTURE TAXI - Nouveau Solde: ~g~$" .. new_balance)
		TriggerClientEvent("banking:updateBalance", source, new_balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
		CancelEvent()
    end)
end)

RegisterServerEvent('bank:withdrawFactureDep')
AddEventHandler('bank:withdrawFactureDep', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "FACTURE DEPANNEUR - Nouveau Solde: ~g~$" .. new_balance)
		TriggerClientEvent("banking:updateBalance", source, new_balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
		CancelEvent()
    end)
end)
