-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("eletronics",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local machineGlobal = 1200
local machineStart = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.startMachine()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local copAmount = vRP.numPermission("Police")
		if parseInt(#copAmount) >= 3 then
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			return false
		elseif parseInt(machineGlobal) > 0 then
			TriggerClientEvent("Notify",source,"azul","Aguarde <b>"..parseInt(machineGlobal).."</b> segundos.",5000)
			return false
		else
			if not machineStart then
				machineStart = true
				machineGlobal = 1200
				vRP.upgradeStress(user_id,10)
				vRP.wantedTimer(parseInt(user_id),300)
				return true
			end
		end
	end
	
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.callPolice(x,y,z)
	local copAmount = vRP.numPermission("Police")
	for k,v in pairs(copAmount) do
		async(function()
			TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 31, title = "Crime em Progresso.", criminal = "Denúncia de Roubo a Caixa Eletrônico.", x = x, y = y, z = z, rgba = {170,80,25} })
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPMACHINE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.stopMachine(x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if machineStart then
			machineStart = false
			local grid = vRP.getGridzone(x,y)
			TriggerEvent("itemdrop:Create","dollars",parseInt(math.random(15000,17500)),x,y,z,grid)

			local random = math.random(100)
			if parseInt(random) >= 75 then
				TriggerEvent("itemdrop:Create","aluminum",parseInt(math.random(10,20)),x,y,z,grid)
			elseif parseInt(random) >= 50 and parseInt(random) <= 74 then
				TriggerEvent("itemdrop:Create","rubber",parseInt(math.random(25,50)),x,y,z,grid)
			elseif parseInt(random) >= 25 and parseInt(random) <= 49 then
				TriggerEvent("itemdrop:Create","plastic",parseInt(math.random(25,50)),x,y,z,grid)
			elseif parseInt(random) <= 24 then
				TriggerEvent("itemdrop:Create","copper",parseInt(math.random(10,20)),x,y,z,grid)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if parseInt(machineGlobal) > 0 then
			machineGlobal = parseInt(machineGlobal) - 1
			if parseInt(machineGlobal) <= 0 then
				machineStart = false
			end
		end
		Wait(1000)
	end
end)