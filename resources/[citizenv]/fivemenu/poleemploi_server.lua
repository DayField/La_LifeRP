require "resources/mysql-async/lib/MySQL"

function nameJob(id)
  return MySQL.Sync.fetchScalar("SELECT job_name FROM jobs WHERE job_id = @namejob", {['@namejob'] = id})
end

function updatejob(player, id)
  local job = id
  MySQL.Async.execute("UPDATE users SET `job`=@value WHERE identifier = @identifier", {['@value'] = job, ['@identifier'] = player})
end

function quitLastJob(source, job)
  if job == 1 then

  elseif job == 2 then
    TriggerClientEvent("jobslegal:poolEnding", source)
  elseif job == 3 then
    TriggerClientEvent("jobslegal:binEnding", source)
  elseif job == 4 then
    TriggerClientEvent("jobslegal:mineEnding", source)
  elseif job == 5 then
	TriggerEvent('es_tax:endingService', source, 0)
  elseif job == 6 then
    TriggerClientEvent("transporter:endingDay", source)
  elseif job == 7 then
    TriggerClientEvent("transporter:endingDay", source)
  elseif job == 8 then
    TriggerClientEvent("transporter:endingDay", source)
  elseif job == 9 then
    TriggerClientEvent("transporter:endingDay", source)
  elseif job == 10 then

  elseif job == 11 then
    TriggerClientEvent("jobslegal:orgEnding", source)
  elseif job == 12 then
    TriggerClientEvent("jobslegal:morgEnding", source)
  elseif job == 13 then
    TriggerEvent('es_em:endingService', source, 0)
  elseif job == 14 then
    TriggerEvent('es_dep:endingService', source, 0)
  end
end

RegisterServerEvent('poleemploi:jobs')
AddEventHandler('poleemploi:jobs', function(id)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local source = source
      local player = user.identifier

      ------ Quit Last job
      local job = user:getJob()
      quitLastJob(source, job)
      ------ Get New Job
      local nameJob = nameJob(id)
      updatejob(player, id)
      user:setJob(id)
      TriggerEvent('poleemploi:getjobss', source)
      TriggerClientEvent("citizenv:notify", source, "CHAR_AMANDA", 1, "Mairie", false, "Votre métier est maintenant : ".. nameJob)
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('poleemploi:getjobs')
AddEventHandler('poleemploi:getjobs', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local source = source
      TriggerClientEvent("jobslegal:getJobs", source, user:getJob())
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)

RegisterServerEvent('poleemploi:getjobss')
AddEventHandler('poleemploi:getjobss', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    if (user) then
      local source = source
      TriggerClientEvent("jobslegal:getJobs", source, user:getJob())
    else
      TriggerEvent("es:desyncMsg")
    end
  end)
end)
