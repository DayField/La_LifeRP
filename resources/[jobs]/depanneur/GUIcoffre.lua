
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



Menu2 = {}
Menu2.GUI = {}
Menu2.buttonCount = 0
Menu2.selection = 0
Menu2.hidden = true
Menu2Title = "Menu2"

function Menu2.addButton(name, func,args)

	local yoffset = 0.3
	local xoffset = 0
	local xmin = 0.0
	local xmax = 0.2
	local ymin = 0.05
	local ymax = 0.05
	Menu2.GUI[Menu2.buttonCount+1] = {}
	Menu2.GUI[Menu2.buttonCount+1]["name"] = name
	Menu2.GUI[Menu2.buttonCount+1]["func"] = func
	Menu2.GUI[Menu2.buttonCount+1]["args"] = args
	Menu2.GUI[Menu2.buttonCount+1]["active"] = false
	Menu2.GUI[Menu2.buttonCount+1]["xmin"] = xmin + xoffset
	Menu2.GUI[Menu2.buttonCount+1]["ymin"] = ymin * (Menu2.buttonCount + 0.01) +yoffset
	Menu2.GUI[Menu2.buttonCount+1]["xmax"] = xmax 
	Menu2.GUI[Menu2.buttonCount+1]["ymax"] = ymax 
	Menu2.buttonCount = Menu2.buttonCount+1
end


function Menu2.updateSelection() 
	if IsControlJustPressed(1, Keys["DOWN"]) then 
		if(Menu2.selection < Menu2.buttonCount -1 ) then
			Menu2.selection = Menu2.selection +1
		else
			Menu2.selection = 0
		end		
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, Keys["TOP"]) then
		if(Menu2.selection > 0)then
			Menu2.selection = Menu2.selection -1
		else
			Menu2.selection = Menu2.buttonCount-1
		end	
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	elseif IsControlJustPressed(1, Keys["NENTER"])  then
		Menu2CallFunction(Menu2.GUI[Menu2.selection +1]["func"], Menu2.GUI[Menu2.selection +1]["args"])
		PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
	end
	local iterator = 0
	for id, settings in ipairs(Menu2.GUI) do
		Menu2.GUI[id]["active"] = false
		if(iterator == Menu2.selection ) then
			Menu2.GUI[iterator +1]["active"] = true
		end
		iterator = iterator +1
	end
end

function Menu2.renderGUI(optionss)
	if not Menu2.hidden then
		Menu2.renderButtons(optionss)
		Menu2.updateSelection()
	end
end

function Menu2.renderBox(xMin,xMax,yMin,yMax,color1,color2,color3,color4)
	DrawRect(xMin, yMin,xMax, yMax, color1, color2, color3, color4);
end

function Menu2:setTitle(optionss)
	SetTextFont(1)
	SetTextProportional(0)
	SetTextScale(1.0, 1.0)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(optionss.menu_title)
	DrawText(optionss.x, optionss.y)
end

function Menu2:setSubTitle(optionss)
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(optionss.scale +0.1, optionss.scale +0.1)
	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(optionss.menu_subtitle)
	DrawRect(optionss.x,(optionss.y +0.08),optionss.width,optionss.height,optionss.color_r,optionss.color_g,optionss.color_b,150)
	DrawText(optionss.x - optionss.width/2 + 0.005, (optionss.y+ 0.08) - optionss.height/2 + 0.0028)

	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(optionss.scale, optionss.scale)
	SetTextColour(255, 255, 255, 255)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(optionss.rightText)
	DrawText((optionss.x + optionss.width/2 - 0.0385) , optionss.y + 0.067)
end

function Menu2:drawButtons(optionss)
	local y = optionss.y + 0.12

	for id, settings in pairs(Menu2.GUI) do
		SetTextFont(0)
		SetTextProportional(0)
		SetTextScale(optionss.scale, optionss.scale)
		if(settings["active"]) then
			SetTextColour(0, 0, 0, 255)
		else
			SetTextColour(255, 255, 255, 255)
		end
		SetTextCentre(0)
		SetTextEntry("STRING")
		AddTextComponentString(settings["name"])
		if(settings["active"]) then
			DrawRect(optionss.x,y,optionss.width,optionss.height,255,255,255,255)
		else
			DrawRect(optionss.x,y,optionss.width,optionss.height,0,0,0,150)
		end
		DrawText(optionss.x - optionss.width/2 + 0.005, y - 0.04/2 + 0.0028)
		y = y + 0.04
	end
end

function Menu2.renderButtons(optionss)

	Menu2:setTitle(optionss)
	Menu2:setSubTitle(optionss)
	Menu2:drawButtons(optionss)

end

--------------------------------------------------------------------------------------------------------------------

function ClearMenu2()
	Menu2.GUI = {}
	Menu2.buttonCount = 0
	Menu2.selection = 0
end

function Menu2CallFunction(fnc, arg)
	_G[fnc](arg)
end