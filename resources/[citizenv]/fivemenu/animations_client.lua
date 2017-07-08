AddEventHandler("menuanim:AnimOG", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "vmenu:MainMenuOG", {}, "Retour")
	VMenu.AddFunc(98, "-Sportives", "vmenu:Sportives", {}, "Valider")
	VMenu.AddFunc(98, "-Festives", "vmenu:Festives", {}, "Valider")
	VMenu.AddFunc(98, "-Saluer", "vmenu:Saluer", {}, "Valider")
	VMenu.AddFunc(98, "-Humeur", "vmenu:Humeur", {}, "Valider")
	VMenu.AddFunc(98, "-Autres", "vmenu:Autres", {}, "Valider")
end)

AddEventHandler("vmenu:Sportives", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "menuanim:AnimOG", {}, "Retour")
	VMenu.AddFunc(98, "Yoga", "anim:play", {5}, "Valider")
	VMenu.AddFunc(98, "Faire des pompes", "anim:play", {6}, "Valider")
	VMenu.AddFunc(98, "Jogging", "anim:play", {15}, "Valider")
end)

AddEventHandler("vmenu:Festives", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "menuanim:AnimOG", {}, "Retour")
	VMenu.AddFunc(98, "Jouer de la musique", "anim:play", {3}, "Valider")
	VMenu.AddFunc(98, "Boire une biere", "anim:play", {16}, "Valider")
	VMenu.AddFunc(98, "Pres du feu", "anim:play", {17}, "Valider")
end)

AddEventHandler("vmenu:Saluer", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "menuanim:AnimOG", {}, "Retour")
	VMenu.AddFunc(98, "Serrer la main", "anim:play", {12}, "Valider")
	VMenu.AddFunc(98, "Tappes moi en 5", "anim:play", {13}, "Valider")
	VMenu.AddFunc(98, "Salut militaire", "anim:play", {14}, "Valider")
	VMenu.AddFunc(98, "Dire bonjour", "anim:play", {18}, "Valider")
	VMenu.AddFunc(98, "Viens, je suis là!", "anim:play", {9}, "Valider")
end)

AddEventHandler("vmenu:Humeur", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "menuanim:AnimOG", {}, "Retour")
	VMenu.AddFunc(98, "Applaudir", "anim:play", {1}, "Valider")
	VMenu.AddFunc(98, "Super", "anim:play", {10}, "Valider")
	VMenu.AddFunc(98, "Branleur", "anim:play", {19}, "Valider")
	VMenu.AddFunc(98, "Dammed", "anim:play", {20}, "Valider")
	VMenu.AddFunc(98, "Calme toi", "anim:play", {21}, "Valider")
	VMenu.AddFunc(98, "No way", "anim:play", {22}, "Valider")
	VMenu.AddFunc(98, "Fuck", "anim:play", {23}, "Valider")
	VMenu.AddFunc(98, "Enlacer", "anim:play", {24}, "Valider")
end)

AddEventHandler("vmenu:Autres", function(target)
	VMenu.animations = true
	VMenu.ResetMenu(98, "", "default")
	Wait(100)
	VMenu.AddFunc(98, "Retour", "menuanim:AnimOG", {}, "Retour")
	VMenu.AddFunc(98, "Filmer", "anim:play", {2}, "Valider")
	VMenu.AddFunc(98, "Regarder la carte", "anim:play", {4}, "Valider")
	VMenu.AddFunc(98, "Humble discours", "anim:play", {7}, "Valider")
	VMenu.AddFunc(98, "Le Nabil en forêt", "anim:play", {8}, "Valider")
	VMenu.AddFunc(98, "Fumer une clope", "anim:play", {11}, "Valider")
	VMenu.AddFunc(98, "S'assoir", "anim:play", {25}, "Valider")
	VMenu.AddFunc(98, "Se gratter les bijoux de famille", "anim:play", {26}, "Valider")
end)

AddEventHandler("anim:play", function(target, anim)
	Wait(100)
	TriggerEvent("vmenu:closeMenu")
	Wait(1000)
	if anim == 1 then
		PlayScenario("WORLD_HUMAN_CHEERING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 2 then
		PlayScenario("WORLD_HUMAN_MOBILE_FILM_SHOCKING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 3 then
		PlayScenario("WORLD_HUMAN_MUSICIAN","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 4 then
		PlayScenario("WORLD_HUMAN_TOURIST_MAP","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 5 then
		PlayScenario("WORLD_HUMAN_YOGA","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 6 then
		PlayScenario("WORLD_HUMAN_PUSH_UPS","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 7 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "prem_4stars_a_benton")
	elseif anim == 8 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "prem_actress_star_a")
	elseif anim == 9 then
		TriggerEvent("vmenu:anim", "missmic4premiere", "wave_c")
	elseif anim == 10 then
		TriggerEvent("vmenu:anim", "mp_action", "thanks_male_06")
	elseif anim == 11 then
		PlayScenario("WORLD_HUMAN_SMOKING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 12 then
		TriggerEvent("vmenu:anim", "mp_common", "givetake1_a")
	elseif anim == 13 then
		TriggerEvent("vmenu:anim", "mp_ped_interaction", "highfive_guy_a")
	elseif anim == 14 then
		TriggerEvent("vmenu:anim", "mp_player_int_uppersalute", "mp_player_int_salute")
	elseif anim == 15 then
		PlayScenario("WORLD_HUMAN_JOG_STANDING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 16 then
		PlayScenario("WORLD_HUMAN_DRINKING","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 17 then
		PlayScenario("WORLD_HUMAN_STAND_FIRE","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 18 then
		TriggerEvent("vmenu:anim", "gestures@m@standing@casual", "gesture_hello")
	elseif anim == 19 then
		TriggerEvent("vmenu:anim", "mp_player_int_upperwank", "mp_player_int_wank_01")
	elseif anim == 20 then
		TriggerEvent("vmenu:anim", "gestures@m@standing@casual", "gesture_damn")
	elseif anim == 21 then
		TriggerEvent("vmenu:anim", "gestures@m@standing@casual", "gesture_easy_now")
	elseif anim == 22 then
		TriggerEvent("vmenu:anim", "gestures@m@standing@casual", "gesture_no_way")
	elseif anim == 23 then
		TriggerEvent("vmenu:anim", "mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
	elseif anim == 24 then
		TriggerEvent("vmenu:anim", "mp_ped_interaction", "kisses_guy_a")
	elseif anim == 25 then
		PlayScenario("WORLD_HUMAN_PICNIC","GENERIC_CURSE_MED" ,"SPEECH_PARAMS_FORCE")
	elseif anim == 26 then
		TriggerEvent("vmenu:anim", "mp_player_int_uppergrab_crotch", "mp_player_int_grab_crotch")
	end
end)

function PlayScenario(param1, param2, param3)
	Citizen.CreateThread(function()
		TaskStartScenarioInPlace(GetPlayerPed(-1), param1, 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), param2, param3)
		Citizen.Wait(20000)
		ClearPedTasksImmediately(GetPlayerPed(-1))
	end)
end