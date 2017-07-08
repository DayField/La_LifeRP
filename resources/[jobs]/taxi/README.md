# Taxi Enterprise

http://mysticrp.16mb.com/dev/
https://forum.fivem.net/t/release-taxi-enterprise-1-0-take-service-menu-07-07/

Taxi Enterprise 1.0 by Oskarr For MysticRP Community

Hi guys,
Today, i'm sharing my taxi system with any features

**Requires:**

- EssentialMode
- VDK_Call (optionnaly)
- Model Menu (optionnaly)
- Jobs-Systems
- Banking

**Download:**

https://github.com/MysticRP/taxi/

**Installation:**

PLEASE READ ALL CODE BEFORE YOU PUT IT AND SAY HE DOESN'T WORK ! 
- Add 'sql.sql' to your database
- Check "client.lua" for settings
- Check "server.lua" for settings
- Put the folder in your ressource !
- Do not forget to add "- taxi" in your "citmp-server.yml"

IN BANKING SERVER.LUA, ADD:

```
RegisterServerEvent('bank:withdrawFacture')
AddEventHandler('bank:withdrawFacture', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Mystic Bank", false, "FACTURE TAXI - Nouveau Solde: ~g~$" .. new_balance)
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
- Call System (With vdk_call)
- Service Car with bail
- Chest system (Money/Dirty Money/Laundering)

**Next Version:**

- MySQL Async
- Call System without Vdk_call
- Blips only in service

**Screenshots:**

http://prntscr.com/fsktth
http://prntscr.com/fsku02
http://prntscr.com/fskuap
http://prntscr.com/fskvlb
http://prntscr.com/fskvqd

I do not make support !

**My others Projects** : 

http://mysticrp.16mb.com/dev/

All texts are french because i'm french baguette

**Crédits** : @Kyominii
