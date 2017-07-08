--[[
##################
#    Oskarr      #
#    MysticRP    #
#   server.lua   #
#      2017      #
##################
--]]
require "resources/essentialmode/lib/MySQL"

MySQL:open("IP", "gta5_gamemode_essential", "user", "pass")

local towjob = '13' -- Change by your job id for taxi
local boss = 'steam:110000101001010' -- Boss 1 
local boss2 = 'steam:110000101001010' -- Boss 2 
local tauxblanchiment = 0.85 -- 0.85 = 100 000 money -> 85 000 dirty money

RegisterServerEvent('depanneur:tow')
AddEventHandler('depanneur:tow',function()
TriggerClientEvent("depann:tow", source) -- Tow client event
end)

RegisterServerEvent('depanneur:factureGranted')
AddEventHandler('depanneur:factureGranted', function(target, amount)
	TriggerClientEvent('depanneur:payFacture', target, amount, source)
	TriggerClientEvent("depanneur:notify", source, "CHAR_LS_CUSTOMS", 1, "Facture Dépanneur", false, "Facture de ~g~"..amount.."$~s~ envoyée à "..GetPlayerName(target))
end)

RegisterServerEvent('depanneur:factureETA')
AddEventHandler('depanneur:factureETA', function(officer, code)
	if(code==1) then
		TriggerClientEvent("depanneur:notify", officer, "CHAR_LS_CUSTOMS", 1, "Facture Dépanneur", false, GetPlayerName(source).."~b~ à déjà une demande de facture en cours !")
	elseif(code==2) then
		TriggerClientEvent("depanneur:notify", officer, "CHAR_LS_CUSTOMS", 1, "Facture Dépanneur", false, GetPlayerName(source).."~y~ n'a pas répondu à la demande de facture !")
	elseif(code==3) then
		TriggerClientEvent("depanneur:notify", officer, "CHAR_LS_CUSTOMS", 1, "Facture Dépanneur", false, GetPlayerName(source).."~r~ à refuser de payer la facture !")
	elseif(code==0) then
		TriggerClientEvent("depanneur:notify", officer, "CHAR_LS_CUSTOMS", 1, "Facture Dépanneur", false, GetPlayerName(source).."~g~ à payer la facture !")
	end
end)

RegisterServerEvent('depanneur:sv_setService')
AddEventHandler('depanneur:sv_setService',
  function(service)
    TriggerEvent('es:getPlayerFromId', source,
      function(user)
        local executed_query = MySQL:executeQuery("UPDATE users SET enService = @service WHERE users.identifier = '@identifier'", {['@identifier'] = user.identifier, ['@service'] = service})
      end
    )
  end
)

RegisterServerEvent('es_dep:endingService')
AddEventHandler('es_dep:endingService',
function(source, service)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      user:setenService(2)
      local player = user.identifier

      MySQL.Async.fetchAll("SELECT skin,face,face_text,hair,hair_text,pants,pants_text,shoes,shoes_text,torso,torso_text,shirt,shirt_text,three,three_text,seven,seven_text,haircolor,haircolor_text FROM outfits WHERE identifier=@user",{
        ['@user']=player
      }, function (result)
        TriggerClientEvent("vmenu:updateChar",source,{result[1].face,result[1].face_text,result[1].hair,result[1].hair_text,result[1].pants,result[1].pants_text,result[1].shoes,result[1].shoes_text,result[1].torso,result[1].torso_text,result[1].shirt,result[1].shirt_text,result[1].three,result[1].three_text,result[1].seven,result[1].seven_text,result[1].haircolor,result[1].haircolor_text,result[1].skin})
      end)
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('depanneur:sv_getJobId')
AddEventHandler('depanneur:sv_getJobId',
  function()
    TriggerClientEvent('depanneur:cl_setJobId', source, GetJobId(source))
  end
)


function idJob(player)
  local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier'", {['@identifier'] = player})
  local result = MySQL:getResults(executed_query, {'job_id'}, "identifier")
  return tostring(result[1].job_id)
end

function GetDirtySolde()
  local executed_query = MySQL:executeQuery("SELECT dirtysolde FROM coffredep WHERE id ='1'")
  local result = MySQL:getResults(executed_query, {'dirtysolde'})
  return tostring(result[1].dirtysolde)
end

function updateCoffreDirty(player, prixavant,prixtotal,prixajoute)
  MySQL:executeQuery("UPDATE coffredep SET `dirtysolde`='@prixtotal' , identifier = '@identifier' , lasttransfert = '@prixajoute' WHERE dirtysolde = '@prixavant' AND id = '1' ",{['@prixtotal'] = prixtotal, ['@identifier'] = player ,['@prixajoute'] = prixajoute,['@prixavant'] = prixavant })

end


function ajoutFactureToCoffre(amount)
  MySQL:executeQuery("UPDATE coffredep SET `solde`='@amount' WHERE id = '1' ",{['@amount'] = amount })
end



RegisterServerEvent('coffredepanneur:facturecoffre')
AddEventHandler('coffredepanneur:facturecoffre', function(amount)
  local solde = GetSolde()
  local amount = amount
  local total = amount + solde
  ajoutFactureToCoffre(total)
end)

function updateCoffre(player, prixavant,prixtotal,prixajoute)
  MySQL:executeQuery("UPDATE coffredep SET `solde`='@prixtotal' , identifier = '@identifier' , lasttransfert = '@prixajoute' WHERE solde = '@prixavant' AND id = '1' ",{['@prixtotal'] = prixtotal, ['@identifier'] = player ,['@prixajoute'] = prixajoute,['@prixavant'] = prixavant })

end

function GetSolde()
  local executed_query = MySQL:executeQuery("SELECT solde FROM coffredep WHERE id ='1'")
  local result = MySQL:getResults(executed_query, {'solde'})
  return tostring(result[1].solde)
end

RegisterServerEvent('coffredepanneur:getsolde')
AddEventHandler('coffredepanneur:getsolde',function()
TriggerEvent('es:getPlayerFromId', source, function(user)
  local player = user.identifier
   local idjob = idJob(player) 
  if(idjob == towjob and player == boss or player == boss2) then
  local data = GetSolde()
  print(data)
  TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Solde restant : ~b~"..data.."$")
  else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
  end
end)
end)


RegisterServerEvent('coffredepanneur:ajoutsolde')
AddEventHandler('coffredepanneur:ajoutsolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local idjob = idJob(player) 

  if(idjob == towjob and player == boss or player == boss2) then
      local prixavant = GetSolde()
      local prixajoute = ajout
      local prixtotal = prixavant+prixajoute    
      print(player)
      print(prixavant)
      print(prixajoute)
      print(prixtotal)
      if(tonumber(prixajoute) <= tonumber(user:money) and tonumber(prixajoute) >= 0) then    
        user:removeMoney((prixajoute))
        updateCoffre(player,prixavant,prixtotal,prixajoute)
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Dépôt : +~g~"..prixajoute.."$")
      else
         TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "ATTENTION", false, "~r~Vous n'avez pas assez d'argent !")
      end
     else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
    end
end)
end)


RegisterServerEvent('coffredepanneur:retirersolde')
AddEventHandler('coffredepanneur:retirersolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local idjob = idJob(player)

  if(idjob == towjob and player == boss or player == boss2) then
      local prixavant = GetSolde()
      local prixenleve = ajout
      local prixtotal = prixavant-prixenleve    
      print(player)
      print(prixavant)
      print(prixenleve)
      print(prixtotal)
    
      if(tonumber(prixenleve) >= 0 and tonumber(prixtotal) >= -1) then    
	    updateCoffre(player,prixavant,prixtotal,prixenleve)
        user:addMoney(prixenleve)
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Retrait: -~r~"..prixenleve.." $")   
      else
               TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Coffre vide ou montant invalide !")  
      end
     else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
    end
end)
end)

RegisterServerEvent('coffredepanneur:getdirtysolde')
AddEventHandler('coffredepanneur:getdirtysolde',function()
TriggerEvent('es:getPlayerFromId', source, function(user)
  local player = user.identifier
   local idjob = idJob(player) 
   if(idjob == towjob and player == boss or player == boss2) then
  local data = GetDirtySolde()
  print(data)
  TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Solde restant : ~b~"..data.."$")
  else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
  end
end)
end)

RegisterServerEvent('coffredepanneur:ajoutdirtysolde')
AddEventHandler('coffredepanneur:ajoutdirtysolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local idjob = idJob(player) 
	local dcash = tonumber(user:getDirty_Money())
 
    if(idjob == towjob and player == boss or player == boss2) then 
      local prixavant = GetDirtySolde()
      local prixajoute = ajout
      local prixtotal = prixavant+prixajoute    
      print(player)
      print(prixavant)
      print(prixajoute)
      print(prixtotal)
      if(tonumber(prixajoute) <= tonumber(dcash) and tonumber(prixajoute) >= 0) then    
        user:removeDirty_Money(prixajoute)
        updateCoffreDirty(player,prixavant,prixtotal,prixajoute)
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Dépôt : +~g~"..prixajoute.."$")
      else
         TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Vous n'avez pas assez d'argent !")
      end
      else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
    end
end)
end)


RegisterServerEvent('coffredepanneur:retirerdirtysolde')
AddEventHandler('coffredepanneur:retirerdirtysolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local idjob = idJob(player)
    local dcash = tonumber(user:getDirty_Money())
      if(idjob == towjob and player == boss or player == boss2) then
      local prixavant = GetDirtySolde()
      local prixenleve = ajout
      local prixtotal = prixavant-prixenleve    
      print(player)
      print(prixavant)
      print(prixenleve)
      print(prixtotal)
    
      if(tonumber(prixenleve) >= 0 and tonumber(prixtotal) >= -1) then    
	     updateCoffreDirty(player,prixavant,prixtotal,prixenleve)
        user:addDirty_Money(prixenleve)
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "Retrait: -~r~"..prixenleve.." $")   
	  else
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Coffre vide ou montant invalide !") 
      end
      else
   TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Coffre Entreprise", false, "~r~Tu n'est pas le patron !")
    end
end)
end)

RegisterServerEvent("depanneur:BlanchirCash")
AddEventHandler("depanneur:BlanchirCash", function(amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	 local player = user.identifier
     local idjob = idJob(player)

        if(idjob == towjob and player == boss or player == boss2) then
		local cash = tonumber(user:getMoney())
		local dcash = tonumber(user:getDirty_Money())
	    local ablanchir = amount
		
		if (dcash <= 0 or ablanchir <= 0) then
			 TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Blanchisserie", false, "~y~Tu n'a pas d'argent à blanchir")
		else
		local washedcash = ablanchir * tauxblanchiment
		local total = cash + washedcash
		local totald = dcash - ablanchir
		user:setMoney(total)
		user:setDirty_Money(totald)
	    TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Blanchisserie", false, "Vous avez blanchi ~r~".. tonumber(ablanchir) .."$~s~ d'argent sale.~s~ Vous avez maintenant ~g~".. tonumber(total) .."$")
	    end
    	else
        TriggerClientEvent("citizenv:notify", source, "CHAR_LS_CUSTOMS", 1, "Blanchisserie", false, "~r~Tu n'est pas le patron !")
        end
	end)
end)

local sellTimer = {}
RegisterServerEvent("depanneur:sellVeh")
AddEventHandler("depanneur:sellVeh", function()
 TriggerEvent('es:getPlayerFromId', source, function(user)
 if(sellTimer[source] == nil)then
	sellTimer[source] = os.time() - 1
  end
  if(sellTimer[source] < os.time())then
					sellTimer[source] = os.time() + 900
	   				local amount = math.random(1000, 3000)
                    TriggerEvent("coffredepanneur:facturecoffre", amount)
					TriggerClientEvent("depanneur:notify", source, "CHAR_LS_CUSTOMS", 1, "Vente Entreprise", false, "~g~+"..amount.."$~s~ dans le coffre de l'entreprise !")
				else
					local time = math.ceil((sellTimer[source] - os.time()) / 60) .. " minutes"
					if((sellTimer[source] - os.time()) < 60)then
						time = (sellTimer[source] - os.time()) .. " secondes"
					end
					TriggerClientEvent("depanneur:notify", source, "CHAR_LS_CUSTOMS", 1, "Vente Entreprise", false, "Tu doit attendre ~r~"..time.."~s~ pour vendre un autre véhicule !")
				end
    end)
end)

RegisterServerEvent("depanneur:cautionOn")
AddEventHandler("depanneur:cautionOn", function(cautionprice)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	user:removeMoney(cautionprice)
	end)	
	end)
	
	RegisterServerEvent("depanneur:cautionOff")
AddEventHandler("depanneur:cautionOff", function(cautionprice)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	user:addMoney(cautionprice)
	end)	
	end)


AddEventHandler('playerDropped', function()
  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("UPDATE users SET enService = 0 WHERE users.identifier = '@identifier'", {['@identifier'] = user.identifier})
    end
  )
end)


function GetJobId(source)
  local jobId = -1

  TriggerEvent('es:getPlayerFromId', source,
    function(user)
      local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier' AND job_id IS NOT NULL", {['@identifier'] = user.identifier})
      local result = MySQL:getResults(executed_query, {'job_id'}, "identifier")

      if (result[1] ~= nil) then
        jobId = result[1].job_id
      end
    end
  )

  return jobId
end
