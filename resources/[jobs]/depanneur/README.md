# Tow Enterprise
https://forum.fivem.net/t/release-tow-enterprise-1-0-take-service-menu-chest-07-07/29133
http://mysticrp.16mb.com/dev/

Tow Enterprise 1.0 by Oskarr For MysticRP Community

Hi guys,
Today, i'm sharing my tow system with any features

**Requires:**

- EssentialMode
- VDK_Call (optionnaly)
- Model Menu (optionnaly)
- Jobs-Systems
- Banking

**Download:**

https://github.com/MysticRP/depanneur/

**Installation:**

PLEASE READ ALL CODE BEFORE YOU PUT IT AND SAY HE DOESN'T WORK ! 
- Add 'sql.sql' to your database
- Check "client.lua" for settings
- Check "server.lua" for settings
- Put the folder in your ressource !
- Do not forget to add "- depanneur" in your "citmp-server.yml"


IN BANKING SERVER.LUA, ADD:

```
RegisterServerEvent('bank:withdrawFactureDep')
AddEventHandler('bank:withdrawFactureDep', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Mystic Bank", false, "FACTURE DEPANNEUR - Nouveau Solde: ~g~$" .. new_balance)
		TriggerClientEvent("banking:updateBalance", source, new_balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
		CancelEvent()
    end)
end)
```

**Features:**

- Take Service
- Service Menu
- Billing System
- Sell Vehicles
- Call System (With vdk_call)
- Service Car with bail
- Chest system (Money/Dirty Money/Laundering)

**Next Version:**

- MySQL Async
- Call System without Vdk_call
- Blips only in service
- Differents functions
- Objets

**Screenshots:**

http://prntscr.com/fsmlmp
http://prntscr.com/fsmm80
http://prntscr.com/fsmlon
http://prntscr.com/fsmlqx
http://prntscr.com/fsmlus
http://prntscr.com/fsmlzp
http://prntscr.com/fsmm32

I do not make support !

**My others Projects** : 

http://mysticrp.16mb.com/dev/

All texts are french because i'm french baguette

(Some functions come from other scripts but I do not remember names, 
If you see your code, tell me for credits !)
