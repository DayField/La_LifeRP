--[[
##################
#    Oskarr      #
#    MysticRP    #
#   client.lua   #
#      2017      #
##################
--]]
----- Vault Menu
local optionss = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Coffre",
    menu_subtitle = "Menu",
    color_r = 26, 
    color_g = 149,
    color_b = 7,
}
--------- Service Menu
local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Dépanneur",
    menu_subtitle = "Menu",
    color_r = 26, 
    color_g = 149,
    color_b = 7,
}


local jobId = -1 -- Don't edit !!!
local isInServiceDep = false -- Don't edit !!!
local currentlyTowedVehicle = nil -- Don't edit !!!
local caution = false -- Don't edit !!!
local cautionprice = 3000 -- Caution Price for service car
local towmodel = GetHashKey('flatbed') -- Service Car
local towPlate = "DEPANNEUR" -- Service Car Plate
local depanID = 14 -- Tow trucker id job
local useModelMenu = true -- set to true if you use https://forum.fivem.net/t/release-async-model-menu-v2-6-17-6/19999
local useVdkCall = true -- If you use VDK Call https://forum.fivem.net/t/release-1-0-call-services-system/20384
local emplacement = {
{name="Entreprise Depanneur", id=67, colour=52, x=-196.89817817810059, y=-1316.2583007813, 31.08935546875},
}


---- THREADS ----

-- Service
Citizen.CreateThread(
	function()
		local x = -196.89817817810059
		local y = -1316.2583007813
		local z = 31.08935546875

		while true do
			Citizen.Wait(1)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 26, 149, 7,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
					if isInServiceDep then
						DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~stopper~s~ votre ~b~service') 
					else
						DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre~s~ votre ~b~service')
					end
					if (IsControlJustReleased(1, 51)) then 
						TriggerServerEvent('depanneur:sv_getJobId')
					end
				end
			end
		end
end)


-- Service Car
Citizen.CreateThread(
	function()
		local x = -184.7798614502
		local y = -1291.1783447266
		local z = 31.295978546143
		while true do
			Citizen.Wait(1)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInServiceDep then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 26, 149, 7,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 5.0) then
					local ply = GetPlayerPed(-1)
				if IsPedInAnyVehicle(ply, false) then
				    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger~s~ votre ~b~dépanneuse')
					if (IsControlJustReleased(1, 51)) then 
						local vehicle = GetVehiclePedIsIn(ply, true) 
	                    local isVehicleTow = IsVehicleModel(vehicle, towmodel)
						local isTaxiPlate = GetVehicleNumberPlateText(vehicle)
                     if isVehicleTow then
					    if isTaxiPlate == towPlate then
						DeleteDepanneuse()
						caution = false
						TriggerServerEvent("depanneur:cautionOff", cautionprice)
						Notify("Vous avez récupérer vos ~g~"..cautionprice.."$~s~ de caution pour la ~b~dépanneuse")
						else
						 Notify("~r~Ce n'est pas une dépanneuse de l'entreprise !")
						end
					 else
					 Notify("~r~Ce n'est pas une dépanneuse !")
					 end
					end
				else						
					DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir~s~ une ~b~dépanneuse')
					if (IsControlJustReleased(1, 51)) then 
						Depanneuse()
						caution = true
						TriggerServerEvent("depanneur:cautionOn", cautionprice)
						Notify("Vous avez laisser ~g~"..cautionprice.."$~s~ de caution pour la ~b~dépanneuse")
					end
				end
				end
			end
		end
end)

-----  coffre 
Citizen.CreateThread(
	function()
		local x = -207.90879821777
		local y = -1337.4641113281
		local z = 34.894401550293
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInServiceDep then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 1.5001, 26, 149, 7,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
					DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~g~ouvrir~s~ le ~b~coffre')					
					if (IsControlJustReleased(1, 51)) then 
						CoffreMenu()
						Menu2.hidden = not Menu2.hidden   
					end
					 Menu2.renderGUI(optionss) 
				end
			end
		end
end)

-----  custom
Citizen.CreateThread(
	function()
		local x = -223.05764770508
		local y = -1329.6936035156
		local z = 30.89038848877
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInServiceDep then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 1.5001, 26, 149, 7,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
				DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~g~ouvrir~s~ le ~b~menu véhicule')
					if (IsControlJustReleased(1, 51)) then 
					if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
						VehicleMenu()
						Menu2.hidden = not Menu2.hidden 
                    else
					 Notify('~r~Tu n\'est pas dans un véhicule !')
		        end						
					end
					 Menu2.renderGUI(optionss) 
				end
			end
		end
end)
----------------------- Menu vehicule
function VehicleMenu()
   optionss.menu_title = "Vehicule"
   optionss.menu_subtitle = "OPTIONS"
    ClearMenu2()
	Menu2.addButton("Réparer", "Repair", nil)
	Menu2.addButton("Nettoyer", "Clean", nil)
	Menu2.addButton("Vendre", "Sell", -1)
	Menu2.addButton("Fermer", "CloseMenu", nil)
end

----------------------- Menu coffre
function CoffreMenu()
   optionss.menu_title = "Coffre"
   optionss.menu_subtitle = "ENTREPRISE"
    ClearMenu2()
	Menu2.addButton("Gestion de Compte", "gesArgent", nil)
	Menu2.addButton("Gestion de Comtpe Offshore", "gesDArgent", nil)
	Menu2.addButton("Blanchisserie", "Blanchir", -1)
	Menu2.addButton("Fermer", "CloseMenu", nil)
end

function gesArgent()
 optionss.menu_title = "Coffre"
  optionss.menu2_subtitle = "ARGENT"
    ClearMenu2()
	Menu2.addButton("Voir Solde", "VoirSolde", nil)
	Menu2.addButton("Ajouter un montant", "AjouterSolde", nil)
	Menu2.addButton("Retirer un montant", "RetirerSolde", nil)
	Menu2.addButton("Retour", "CoffreMenu", nil)
end

function gesDArgent()
 optionss.menu_title = "Coffre"
  optionss.menu2_subtitle = "ARGENT SALE"
    ClearMenu2()
	Menu2.addButton("Voir Solde", "VoirDirtySolde", nil)
	Menu2.addButton("Ajouter un montant", "AjouterDirtySolde", nil)
	Menu2.addButton("Retirer un montant", "RetirerDirtySolde", nil)
	Menu2.addButton("Retour", "CoffreMenu", nil)
end

function DepMenu() -- Tow Menu
	options.menu_subtitle = "MENU"
    ClearMenu()
	Menu.addButton("Facturation", "FactureMenu", nil)
	Menu.addButton("Attacher/Détacher", "tow", nil) -- Tow
	Menu.addButton("Réparer", "Repair", nil) -- Repair
	Menu.addButton("Crocheter", "Crocheter", nil) -- Crocheter
end

function FactureMenu() -- FACTURE MENU
	options.menu_subtitle = "FACTURES"
    ClearMenu()
	Menu.addButton("Déplacement (200$)", "Facture", 200)
	Menu.addButton("Nettoyage (100$)", "Facture", 100)
    Menu.addButton("Réparation (1000$)", "Facture", 1000)
	Menu.addButton("Crochetage (2500$)", "Facture", 2500)
	Menu.addButton("Dépannage (300$/km)", "Facture", -1)
	Menu.addButton("Stockage (25$/min)", "Facture", -1)
	Menu.addButton("Autre Montant", "Facture", -1)	
	Menu.addButton("Retour", "DepMenu", nil)
end

function CloseMenu()
Menu2.hidden = true
end


-----------------------

--------- Vault Functions

function VoirSolde()
	TriggerServerEvent('coffredepanneur:getsolde')
end

function AjouterSolde()
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);        
    end
    if (GetOnscreenKeyboardResult()) then
    	--if (assert(type(x) == "number"))then
        local result = GetOnscreenKeyboardResult()
       	TriggerServerEvent('coffredepanneur:ajoutsolde',result)
       	--end
    end	
end

function RetirerSolde()
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);       
    end
    if (GetOnscreenKeyboardResult()) then
    	--if (assert(type(x) == "number"))then
        local result = GetOnscreenKeyboardResult()
       	TriggerServerEvent('coffredepanneur:retirersolde',result)
       	--end
    end	
end

function VoirDirtySolde()
	TriggerServerEvent('coffredepanneur:getdirtysolde')
end

function AjouterDirtySolde()
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);        
    end
    if (GetOnscreenKeyboardResult()) then
    	--if (assert(type(x) == "number"))then
        local result = GetOnscreenKeyboardResult()
       	TriggerServerEvent('coffredepanneur:ajoutdirtysolde',result)
       	--end
    end	
end

function RetirerDirtySolde()
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);       
    end
    if (GetOnscreenKeyboardResult()) then
    	--if (assert(type(x) == "number"))then
        local result = GetOnscreenKeyboardResult()
       	TriggerServerEvent('coffredepanneur:retirerdirtysolde',result)
       	--end
    end	
end

-------- Notify

function Notify(text)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent("depanneur:notify")
AddEventHandler("depanneur:notify", function(icon, type, sender, title, text)
    Citizen.CreateThread(function()
		Wait(1)
		SetNotificationTextEntry("STRING");
		AddTextComponentString(text);
		SetNotificationMessage(icon, icon, true, type, sender, title, text);
		DrawNotification(false, true);
    end)
end)

---------------------------
--------- Spawn towtruck
function Depanneuse()
	Citizen.Wait(0)
	local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = towmodel

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local plate = math.random(100, 900)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, -184.7798614502, -1291.1783447266, 31.295978546143, true, false)

	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, towPlate)
	SetPedIntoVehicle(ped, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end
--------- Delete towtruck
function DeleteDepanneuse()
    local ply = GetPlayerPed(-1)
    local playerVeh = GetVehiclePedIsIn(ply, false)
    Citizen.Wait(1)
    ClearPedTasksImmediately(ply)
    SetEntityVisible(playerVeh, false, 0)
    SetEntityCoords(playerVeh, 999999.0, 999999.0, 999999.0, false, false, false, true)
    FreezeEntityPosition(playerVeh, true)
    SetEntityAsMissionEntity(playerVeh, 1, 1)
    DeleteVehicle(playerVeh)
end

function Repair()
local pl = GetPlayerPed(-1)
local vehicle = GetVehiclePedIsUsing(pl)
  if IsPedSittingInAnyVehicle(pl) then
    SetVehicleUndriveable(vehicle, false)  
    SetVehicleEngineHealth(vehicle, 100.0) 
	SetVehicleFixed(vehicle) 
	Notify("Véhicule ~g~réparé")
	else
	Notify("~y~Tu doit monter dans le véhicule") 
	end
end

function Clean()
     local pl = GetPlayerPed(-1)
     local vehicle = GetVehiclePedIsUsing(pl)
  if IsPedSittingInAnyVehicle(pl) then
    SetVehicleUndriveable(vehicle, false)  
    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
	Notify("Véhicule ~g~nettoyé")
	else
	Notify("~y~Tu doit monter dans le véhicule") 
	end
end

function Sell()
 local pl = GetPlayerPed(-1)
     local vehicle = GetVehiclePedIsUsing(pl)
  if IsPedSittingInAnyVehicle(pl) then
    DeleteDepanneuse()
    TriggerServerEvent("depanneur:sellVeh")
     Menu2.hidden = true
  else
	Notify("~y~Tu doit monter dans le véhicule") 
	end
end

function Crocheter()
	Citizen.CreateThread(function()
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	
	if IsPedSittingInAnyVehicle(ply) then
	     Notify("~y~Tu ne peut pas crocheter un véhicule en étant dedans !") 
	else
	    veh = GetClosestVehicle(plyCoords["x"], plyCoords["y"], plyCoords["z"], 5.001, 0, 70)
	    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
	    Citizen.Wait(20000)
        SetVehicleDoorsLocked(veh, 1)
    	ClearPedTasksImmediately(GetPlayerPed(-1))
    	Notify("Le véhicule est ~g~ouvert~w~.")
	end
	end)
end


function Facture(amount)
	local t, distance = GetClosestPlayer()
	if(distance ~= -1 and distance < 3) then
		if(amount == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0 and res <= 10000) then
					amount = res		
                else
                 Notify("~r~Tu a dépasser le montant maximum autorisé !")				
				end
			end
		end

		if(amount ~= -1) then
			TriggerServerEvent("depanneur:factureGranted", GetPlayerServerId(t), amount)
		end
	else
		Notify("~y~Pas de client à proximité !")
	end
end

function Blanchir(amount)
		if(amount == -1) then
			DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8S", "", "", "", "", "", 20)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0);
				Wait(0);
			end
			if (GetOnscreenKeyboardResult()) then
				local res = tonumber(GetOnscreenKeyboardResult())
				if(res ~= nil and res ~= 0 and res <= 100000) then
					amount = res		
                else
                 Notify("~r~Tu a dépasser le montant maximum autorisé !")				
				end
			end
		end
		if(amount ~= -1) then
			TriggerServerEvent("depanneur:BlanchirCash", amount)
		end
end

RegisterNetEvent('depanneur:cl_setJobId')
AddEventHandler('depanneur:cl_setJobId',
	function(p_jobId)
		jobId = p_jobId
		GetService()
	end
)


RegisterNetEvent('depann:tow')
AddEventHandler('depann:tow',function()

    local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				if not IsPedInAnyVehicle(playerped, true) then
					if vehicle ~= targetVehicle then
						AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						currentlyTowedVehicle = targetVehicle
					Notify("~g~Véhicule attaché !") -- Vehicle attached
					else
						Notify("~r~Vous ne pouvez pas dépanner votre véhicule !") -- You can't attach your vehicle
					end
				end
			else
			Notify("~b~Aucun véhicule à proximité") -- You are not near vehicle
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			currentlyTowedVehicle = nil
			Notify("~r~Véhicule détaché !") -- Vehicle removed
		end
	end

end)

function tow() -- Call server Function Tow
TriggerServerEvent("depanneur:tow")
end

local lockAskingFine = false -- don't edit !!!!
RegisterNetEvent('depanneur:payFacture')
AddEventHandler('depanneur:payFacture', function(amount, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			Notify("Appuyez sur ~g~Y~s~ pour accepter la facture de ~g~$"..amount.."~s~, Appuyez sur ~r~K~s~ pour la refuser !")
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('depanneur:factureETA', sender, 2)
					Notify("~y~Demande de facturation expirée !")
					lockAskingFine = false
					break
				end
	
				if IsControlPressed(1, 246) then				
					TriggerServerEvent('bank:withdrawFactureDep', amount)	
	       	     	TriggerServerEvent("coffredepanneur:facturecoffre", amount)					
					Notify("Vous avez payé la facture de ~g~"..amount.."$~s~.")
					TriggerServerEvent('depanneur:factureETA', sender, 0)
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, 311) then
					TriggerServerEvent('depanneur:factureETA', sender, 3)
					Notify("~r~Vous avez refusé de payer la facture")
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('depanneur:factureETA', sender, 1)
		end
	end)
end)
---------------------------------------------------------
function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end



function GetService()
if jobId ~= depanID then
Notify("~y~Tu n'est pas dépanneur !") 
		return
end
	if isInServiceDep then
		Notify("Vous avez ~r~fini~s~ votre service") 
		if (useModelMenu == true) then
		TriggerServerEvent("vmenu:lastChar")
		end
		TriggerServerEvent('depanneur:sv_setService', 0) 
		if (useVdkCall == true) then
		TriggerServerEvent("player:serviceOff", "depanneur") 
		end
	else
		Notify("~g~Vous êtes en service !") 
		TriggerServerEvent('depanneur:sv_setService', 1) 
		if (useVdkCall == true) then
		TriggerServerEvent("player:serviceOn", "depanneur") 
		end
	end

	isInServiceDep = not isInServiceDep
	--- Uniforme + petrolcan
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_PetrolCan"), true, true)
	SetPedComponentVariation(GetPlayerPed(-1), 11, 65, 3, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 4, 38, 3, 0)
    SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 6, 0)
end




---- MENU OPEN -----
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 56) then 
		if isInServiceDep then
            DepMenu()
			Notify("~s~Menu dépanneur ~g~activé~s~")  
            Menu.hidden = not Menu.hidden
		else
		Notify("~y~Tu n'est pas en service dépanneur !") 
		end
        end
        Menu.renderGUI(options)
    end
end)
--------------


-- Show blip
Citizen.CreateThread(function()
    for _, item in pairs(emplacement) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
end)


------------------ DONT EDIT
function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)

	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end
