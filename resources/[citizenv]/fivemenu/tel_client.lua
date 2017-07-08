PHONEBOOK = {}

-- ON RÉCUPÈRE LE PHONEBOOK DU JOUEUR.
RegisterNetEvent("tel:getPhonebook")
AddEventHandler("tel:getPhonebook", function(p_phonebook)
	PHONEBOOK = {}
	PHONEBOOK = p_phonebook
end)

AddEventHandler("menutel:PhoneOG", function(target, mytel)
	if not IsInVehicle() then
		TriggerEvent("vmenu:animChain", "cellphone@", "text_in", "cellphone@", "f_cellphone_text_read_base", "cellphone@", "cellphone_text_out")
		teldest = ""
		VMenu.telephone = true
		VMenu.ResetMenu(98, "", "default")
		Wait(100)
		VMenu.AddSep(98, tostring(mytel))
		VMenu.AddFunc(98, "Retour", "vmenu:MainMenuOG", {}, "Retour")
		VMenu.AddFunc(98, "Ajouter un contact", "tel:add", {}, "Valider")
		VMenu.AddFunc(98, "Appeler la Police", "tel:call", {"911"}, "Appeler")
		VMenu.AddFunc(98, "Appeler un Depanneur", "tell:callDep", {"200"}, "Appeler")
		VMenu.AddFunc(98, "Appeler un Taxi", "tel:callTaxi", {"14"}, "Appeler")
		for ind, value in pairs(PHONEBOOK) do
			VMenu.AddFunc(98, value.nom .. " " .. value.prenom .. " " .. tostring(ind), "tel:call", {ind}, "Appeler: " .. tostring(ind))
		end
	else
		TriggerEvent("itinerance:notif", "~r~Utilisation impossible en conduisant")
	end
end)

local confirmed = 0
local addconfirmed = 0
local teldest = ""
local iddest = ""
local msgSMS = ""
local fromSMS = ""
local showMsg = false
local queueSMS = false

local telAdd = ""

AddEventHandler("tel:add", function(target)
	TriggerEvent("vmenu:MainMenuOG")
  TriggerEvent("vmenu:closeMenu")
	DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
	addconfirmed = 1
end)

AddEventHandler("tel:call", function(target, tel, sendTo)
	TriggerEvent("vmenu:closeMenu")
	if tel == "911" then
		local plyPos = GetEntityCoords(GetPlayerPed(-1), true)
		TriggerServerEvent("call:makeCall", "police", {x=plyPos.x,y=plyPos.y,z=plyPos.z})
	else
		DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
		teldest = tel
		iddest = sendTo
		confirmed = 1
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if confirmed == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				confirmed = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				local txt = GetOnscreenKeyboardResult()
				if string.len(txt) > 0 then
					msg = txt
					confirmed = 2
				else
					TriggerEvent("itinerance:notif", "~r~ Votre message est vide")
					confirmed = 0
				end
			elseif UpdateOnscreenKeyboard() == 2 then
				confirmed = 0
			end
		end
		if confirmed == 2 then
			TriggerServerEvent('tel:sendingMsg', msg, teldest)
			confirmed = 0
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(0)
		if addconfirmed == 1 then
			if UpdateOnscreenKeyboard() == 3 then
				addconfirmed = 0
			elseif UpdateOnscreenKeyboard() == 1 then
				local txt = GetOnscreenKeyboardResult()
				if (string.len(txt) > 0) and (string.match(txt, '%d%d%d(-)%d%d%d%d')) then -- BEAU REGEX PATTERN EN LUA PARCE QUE C'EST PAUVRE
					telAdd = txt
					addconfirmed = 2
				else
					TriggerEvent("itinerance:notif", "~r~ Entrer un numéro valide")
					addconfirmed = 0
				end
			elseif UpdateOnscreenKeyboard() == 2 then
				addconfirmed = 0
			end
		end
		if addconfirmed == 2 then
			TriggerServerEvent('tel:addingTel', telAdd)
			addconfirmed = 0
		end
	end
end)

RegisterNetEvent("tel:receivingMsg")
AddEventHandler("tel:receivingMsg", function(msg, fnom, fprenom) -- target = Dernier joueur à avoir parlé, pas besoin ici. Mais obligatoire !
	if showMsg == true then
		queueSMS = true
		fromSMSq = fprenom .. " " ..  fnom
		msgSMSq = msg
	else
		showMsg = true
		msgSMS = msg
		fromSMS = fprenom .. " " ..  fnom
	end
end)

-- LE TIT CARRÉ BEAU DE TEXTE BEAU
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (showMsg == true) then
			DrawRect(0.912000000000001, 0.292, 0.185, 0.205, 0, 0, 0, 150)
			DrawAdvancedText(0.966000000000001, 0.220, 0.005, 0.0028, 0.7, "~h~SMS", 255, 255, 255, 255, 1, 1)
			DrawAdvancedText(0.924000000000001, 0.278, 0.005, 0.0028, 0.4, "de ~h~~b~"..fromSMS, 255, 255, 255, 255, 6, 1)
			DrawAdvancedText(0.924000000000001, 0.322, 0.005, 0.0028, 0.4, msgSMS, 255, 255, 255, 255, 6, 1)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if queueSMS == true then
			Citizen.Wait(20000)
			showMsg = true
			fromSMS = fromSMSq
			msgSMS = msgSMSq
			queueSMS = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if showMsg == true then
			Citizen.Wait(20000)
			showMsg = false
		end
	end
end)

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-- LA FONCTION DU BEAU TIT CARRÉ
function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
		DrawText(x - 0.1+w, y - 0.02+h)
end
