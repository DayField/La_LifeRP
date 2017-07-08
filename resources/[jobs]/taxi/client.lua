--[[
##################
#    Oskarr      #
#    MysticRP    #
#   client.lua   #
#      2017      #
##################
--]]

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Menu Taxi",
    menu_subtitle = "Menu",
    color_r = 208, 
    color_g = 222,
    color_b = 20,
}

local optionss = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Coffre Entreprise",
    menu_subtitle = "Menu",
    color_r = 225, 
    color_g = 225,
    color_b = 12,
}

local jobId = -1 -- don't edit
local isInServiceTaxi = false -- don't edit
local caution = false -- don't edit
local cautionprice = 1500 -- caution price for service vehicle
local taxiplatee = "TAXI" -- Plate for service vehicle
local taximodel = GetHashKey('taxi') -- Model for service car
local taxijob = 5 -- JobID for taxi
local useModelMenu = true -- set to true if you use https://forum.fivem.net/t/release-async-model-menu-v2-6-17-6/19999
local useVdkCall = true -- If you use VDK Call https://forum.fivem.net/t/release-1-0-call-services-system/20384
local openMenuKey = 47 -- (G) Key for OPEN TAXI MENU 
local emplacement = {
{name="Entreprise Taxi", id=56, colour=81, x=895.90020751953, y=-178.72854614258, z=74.700271606445},
}

---- THREADS ----

-- Service
Citizen.CreateThread(
	function()
		local x = 895.90020751953
		local y = -178.72854614258
		local z = 74.700271606445

		while true do
			Citizen.Wait(1)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) then
				DrawMarker(0, x, y, z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
					if isInServiceTaxi then
						DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~stopper~s~ votre service') 
					else
						DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre~s~ votre service')
					end
					if (IsControlJustReleased(1, 51)) then 
						TriggerServerEvent('taxi:sv_getJobId')
					end
				end
			end
		end
end)

-- Service Car
Citizen.CreateThread(
	function()
		local x = 913.99212646484
		local y = -167.31979370117
		local z = 74.33235168457
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInServiceTaxi then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
					local ply = GetPlayerPed(-1)
				if IsPedInAnyVehicle(ply, true) then
				    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger~s~ votre ~b~taxi')
					if (IsControlJustReleased(1, 51)) then 
						local vehicle = GetVehiclePedIsIn(ply, true)
	                    local isVehicleTaxi = IsVehicleModel(vehicle, taximodel)
						local isTaxiPlate = GetVehicleNumberPlateText(vehicle)
                     if isVehicleTaxi then
					 if isTaxiPlate == taxiplatee then
						DeleteTaxi()
						caution = false
						TriggerServerEvent("taxi:cautionOff", cautionprice)
						Notify("Vous avez récupérer vos ~g~"..cautionprice.."$~s~ de caution pour le ~b~taxi")
					 else
					 Notify("~r~Ce n'est pas un taxi de l'entreprise !")
					 end
					 else
					 Notify("~r~Ce n'est pas un taxi !")
					 end
					end
				else						
					DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir~s~ un ~b~taxi')
					if (IsControlJustReleased(1, 51)) then 
						Taxi()
						caution = true
						TriggerServerEvent("taxi:cautionOn", cautionprice)
						Notify("Vous avez laisser ~g~"..cautionprice.."$~s~ de caution pour le ~b~taxi")
					end
				end
				end
			end
		end
end)


--- coffre 
Citizen.CreateThread(
	function()
		local x = 882.27172851563
		local y = -171.77275085
		local z = 77.110221862793
		while true do
			Citizen.Wait(0)
			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 100.0) and isInServiceTaxi then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 1.5001, 198, 153, 2, 105, 0, 0, 0,0)
				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 4.0) then
					DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~b~coffre')
					if (IsControlJustReleased(1, 51)) then 
						CoffreMenu()
						Menu2.hidden = not Menu2.hidden   
					end
					 Menu2.renderGUI(optionss) 
				end
			end
		end
end)


function CoffreMenu()
   optionss.menu_subtitle = "MENU"
    ClearMenu2()
	Menu2.addButton("Gestion du Compte", "gesArgent", nil)
	Menu2.addButton("Gestion du Compte Offshore", "gesDArgent", nil)
	Menu2.addButton("Blanchisserie", "Blanchir", -1)
	Menu2.addButton("Fermer", "CloseMenu", nil)	
end

function CloseMenu()
Menu2.hidden = true
end

function gesArgent()
  optionss.menu2_subtitle = "ARGENT"
    ClearMenu2()
	Menu2.addButton("Voir Solde", "VoirSolde", nil)
	Menu2.addButton("Ajouter un montant", "AjouterSolde", nil)
	Menu2.addButton("Retirer un montant", "RetirerSolde", nil)
	Menu2.addButton("Retour", "CoffreMenu", nil)
end

function gesDArgent()
  optionss.menu2_subtitle = "ARGENT SALE"
    ClearMenu2()
	Menu2.addButton("Voir Solde", "VoirDirtySolde", nil)
	Menu2.addButton("Ajouter un montant", "AjouterDirtySolde", nil)
	Menu2.addButton("Retirer un montant", "RetirerDirtySolde", nil)
	Menu2.addButton("Retour", "CoffreMenu", nil)
end
-----------------------

function VoirSolde()
	TriggerServerEvent('coffretaxi:getsolde')
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
       	TriggerServerEvent('coffretaxi:ajoutsolde',result)
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
       	TriggerServerEvent('coffretaxi:retirersolde',result)
       	--end
    end	
end

function VoirDirtySolde()
	TriggerServerEvent('coffretaxi:getdirtysolde')
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
       	TriggerServerEvent('coffretaxi:ajoutdirtysolde',result)
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
       	TriggerServerEvent('coffretaxi:retirerdirtysolde',result)
       	--end
    end	
end


---- FONCTIONS ----

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

---------------------------

function Taxi()
	Citizen.Wait(0)
	local ped = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = taximodel

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	--local plate = math.random(300, 900)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
	local spawned_car = CreateVehicle(vehicle, coords, 913.99212646484, -167.31979370117, 74.33235168457, true, false)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleNumberPlateText(spawned_car, taxiplatee)
	SetVehicleColours(spawned_car, 12, 131)
	SetVehicleExtraColours(spawned_car, 12, 12)
	SetPedIntoVehicle(ped, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end

function DeleteTaxi()
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


-------
---------


function TaxiMenu() -- TAXI MENU
	options.menu_subtitle = "MENU"
    ClearMenu()
	Menu.addButton("Facturation", "factureMenu", nil) 
	Menu.addButton("GPS", "GPSMenu", nil) 
end

function GPSMenu() -- FACTURE MENU
	options.menu_subtitle = "GPS"
    ClearMenu()
	Menu.addButton("Comissariat", "goC", nil)
	Menu.addButton("Pôle Emploi", "goPO", nil)
    Menu.addButton("Préfecture", "goPF", nil)
    Menu.addButton("Concessionaire", "goCC", nil)		
	Menu.addButton("Fleeca Banque", "goFB", nil)	
	Menu.addButton("Retour", "TaxiMenu", nil)
end

function factureMenu() -- FACTURE MENU
	options.menu_subtitle = "FACTURES"
    ClearMenu()
	Menu.addButton("Déplacement (200$)", "Facture", 200)
    Menu.addButton("1 km (300$)", "Facture", 300)
	Menu.addButton("2 km (600$)", "Facture", 600)
	Menu.addButton("3 km (900$)", "Facture", 900)
    Menu.addButton("5 km (1500$)", "Facture", 1500)		
	Menu.addButton("10 km (3000$)", "Facture", 3000)
	Menu.addButton("Autre Montant", "Facture", -1)	
	Menu.addButton("Retour", "TaxiMenu", nil)
end


--------------- GPS COORDS
function goC(x, y, z)
x = 425.130
y = -979.558
z = 30.711
BLIPP = AddBlipForCoord(x, y, z)
SetBlipSprite(BLIPP, 2)
SetNewWaypoint(x, y)
end
function goPO(x, y, z)
x = -234.164
y = -979.708
z = 29.2826
BLIPP = AddBlipForCoord(x, y, z)
SetBlipSprite(BLIPP, 2)
SetNewWaypoint(x, y)
end
function goCC(x, y, z)
x = -47.4288
y = -1112.52
z = 26.436
BLIPP = AddBlipForCoord(x, y, z)
SetBlipSprite(BLIPP, 2)
SetNewWaypoint(x, y)
end
function goPF(x, y, z)
x = 162.186
y = -441.774
z = 40.9113
BLIPP = AddBlipForCoord(x, y, z)
SetBlipSprite(BLIPP, 2)
SetNewWaypoint(x, y)
end
function goFB(x, y, z)
x = 152.32469177246
y = -1030.0135498047
z = 29.185220718384
BLIPP = AddBlipForCoord(x, y, z)
SetBlipSprite(BLIPP, 2)
SetNewWaypoint(x, y)
end
--------------------------

RegisterNetEvent('taxi:cl_setJobId')
AddEventHandler('taxi:cl_setJobId',
	function(p_jobId)
		jobId = p_jobId
		GetService()
	end
)


function GetService()
if jobId ~= taxijob then
 Notify("~y~Tu n'est pas chauffeur de taxi !") 
		return
end
	if isInServiceTaxi then
		Notify("Vous avez ~r~fini~s~ votre service") 
		if (useModelMenu == true) then
		TriggerServerEvent("mm:spawn2") 
		end
		TriggerServerEvent('taxi:sv_setService', 0) 
		if (useVdkCall == true) then
		TriggerServerEvent("player:serviceOff", "taxi") 
		end
	else 
		Notify("~g~Vous êtes en service !") 
		TriggerServerEvent('taxi:sv_setService', 1) 
		if (useVdkCall == true) then
		TriggerServerEvent("player:serviceOn", "taxi") 
		end
	end
	
	isInServiceTaxi = not isInServiceTaxi
-- Here for any clothes with SetPedComponentVariation ... 
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
				if(res ~= nil and res ~= 0 and res <= 5000) then
					amount = res		
                else
                 Notify("~r~Tu a dépasser le montant maximum autorisé !")				
				end
			end
		end

		if(amount ~= -1) then
			TriggerServerEvent("taxi:factureGranted", GetPlayerServerId(t), amount)
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
			TriggerServerEvent("taxi:BlanchirCash", amount)
		end
end

---- MENU OPEN -----
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, openMenuKey) then 
		if isInServiceTaxi then
            TaxiMenu()
			Notify("~s~Menu taxi ~g~activé~s~")  
            Menu.hidden = not Menu.hidden
		else
		Notify("~y~Tu n'est pas en service taxi !") 
		end
        end
        Menu.renderGUI(options)
    end
end)
--------------


local lockAskingFine = false
RegisterNetEvent('taxi:payFacture')
AddEventHandler('taxi:payFacture', function(amount, sender)
	Citizen.CreateThread(function()
		
		if(lockAskingFine ~= true) then
			lockAskingFine = true
			local notifReceivedAt = GetGameTimer()
			Notify("Appuyez sur ~g~Y~s~ pour accepter la facture de ~g~$"..amount.."~s~, Appuyez sur ~r~K~s~ pour la refuser !")
			while(true) do
				Wait(0)
				
				if (GetTimeDifference(GetGameTimer(), notifReceivedAt) > 15000) then
					TriggerServerEvent('taxi:factureETA', sender, 2)
					Notify("~y~Demande de facturation expirée !")
					lockAskingFine = false
					break
				end
	
				if IsControlPressed(1, 246) then				
					TriggerServerEvent('bank:withdrawFacture', amount)	
	       		TriggerServerEvent("coffretaxi:facturecoffre", amount)					
					Notify("Vous avez payé la facture de ~g~"..amount.."$~s~.")
					TriggerServerEvent('taxi:factureETA', sender, 0)
					lockAskingFine = false
					break
				end
				
				if IsControlPressed(1, 311) then
					TriggerServerEvent('taxi:factureETA', sender, 3)
					Notify("~r~Vous avez refusé de payer la facture")
					lockAskingFine = false
					break
				end
			end
		else
			TriggerServerEvent('taxi:factureETA', sender, 1)
		end
	end)
end)

-- Copy/paste from fs_freeroam (by FiveM-Script : https://forum.fivem.net/t/alpha-fs-freeroam-0-1-4-fivem-scripts/14097)
RegisterNetEvent("taxi:notify")
AddEventHandler("taxi:notify", function(icon, type, sender, title, text)
    Citizen.CreateThread(function()
		Wait(1)
		SetNotificationTextEntry("STRING");
		AddTextComponentString(text);
		SetNotificationMessage(icon, icon, true, type, sender, title, text);
		DrawNotification(false, true);
    end)
end)

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
