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
Tunnel.bindInterface("burgershot",cRP)
vCLIENT = Tunnel.getInterface("burgershot")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local amount = {}
local paymentMin = 75
local paymentMax = 115
local consumeItem = "foodbox"
-----------------------------------------------------------------------------------------------------------------------------------------
-- BURGERSHOT:FOODBURGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("burgershot:foodBurger")
AddEventHandler("burgershot:foodBurger",function(foodBurger)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
	    if vRP.computeInvWeight(user_id) + 1 > vRP.getBackpack(user_id) then
	        TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		else
		    if vRP.getInventoryItemAmount(user_id,"foodburger") >= 1 then
	            TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			else
	            vRP.giveInventoryItem(user_id,"foodburger",1,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BURGERSHOT:FOODJUICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("burgershot:foodJuice")
AddEventHandler("burgershot:foodJuice",function(foodJuice)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
	    if vRP.computeInvWeight(user_id) + 1 > vRP.getBackpack(user_id) then
	        TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		else
		    if vRP.getInventoryItemAmount(user_id,"foodjuice") >= 1 then
	            TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			else
	            vRP.giveInventoryItem(user_id,"foodjuice",1,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BURGERSHOT:FOODBOX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("burgershot:foodBox")
AddEventHandler("burgershot:foodBox",function(foodBox)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
	    if vRP.computeInvWeight(user_id) + 1 > vRP.getBackpack(user_id) then
	        TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
		else
		    if vRP.getInventoryItemAmount(user_id,"foodbox") >= 3 then
                TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
			else
				if vRP.getInventoryItemAmount(user_id,"foodburger") >= 1 and vRP.getInventoryItemAmount(user_id,"foodjuice") >= 1 then
				    vRP.tryGetInventoryItem(user_id,"foodburger",1,false)
				    vRP.tryGetInventoryItem(user_id,"foodjuice",1,false)
				    vRP.giveInventoryItem(user_id,"foodbox",1,true)
				else
				    TriggerClientEvent("Notify",source,"amarelo","Voc?? n??o o necess??rio para fazer um combo.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,tostring(consumeItem),1,true) then
			vRP.upgradeStress(user_id,1)

			local value = math.random(paymentMin,paymentMax)
			vRP.giveInventoryItem(user_id,"dollars",parseInt(value),true)

			TriggerClientEvent("sounds:source",source,"cash",0.5)
			return true
		end
		
		return false
	end
end