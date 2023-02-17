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
Tunnel.bindInterface("target",cRP)
vCLIENT = Tunnel.getInterface("target")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("admon",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
	    if vRP.hasPermission(user_id,"Owner") or vRP.hasPermission(user_id,"Admin") then
		    vCLIENT.toggleService(source)
		end
	end
end)