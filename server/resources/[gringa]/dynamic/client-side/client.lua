-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("dynamic",cRP)
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false
local policeService = false
local paramedicService = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMAL
-----------------------------------------------------------------------------------------------------------------------------------------
local animalHahs = nil
local animalFollow = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("police:updateService")
AddEventHandler("police:updateService",function(status)
	policeService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:UPDATESERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("paramedic:updateService")
AddEventHandler("paramedic:updateService",function(status)
	paramedicService = status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(title,description,trigger,par,id,server)
	SetNuiFocus(true,true)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu",function(title,description,menuid)
	SetNuiFocus(true,true)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = menuid })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked",function(data)
	if data["server"] == "true" then
		TriggerServerEvent(data["trigger"],data["param"])
	else
		TriggerEvent(data["trigger"],data["param"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function()
	SetNuiFocus(false,false)
	menuOpen = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem",function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false,false)
		menuOpen = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions",function(source,args)
	if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then
		local ped = PlayerPedId()
		if GetEntityHealth(ped) > 101 then
			menuOpen = true

			exports["dynamic"]:AddButton("Remover","Remover a roupa atual.","player:outfitFunctions","remover","outfit",true)
			
			exports["dynamic"]:AddButton("Chap??u","Colocar/Retirar o chap??u.","skinshop:dynamicHat","","fastoutfit",true)
			exports["dynamic"]:AddButton("M??scara","Colocar/Retirar a m??scara.","skinshop:dynamicMask","","fastoutfit",true)
			exports["dynamic"]:AddButton("??culos","Colocar/Retirar o ??culos.","skinshop:dynamicGlasses","","fastoutfit",true)
			exports["dynamic"]:AddButton("Jaqueta","Colocar/Retirar a jaqueta.","skinshop:dynamicTorso2","","fastoutfit",true)
			exports["dynamic"]:AddButton("Luvas","Colocar/Retirar as luvas.","skinshop:dynamicArms","","fastoutfit",true)
			
			if animalHahs ~= nil then
				exports["dynamic"]:AddButton("Seguir","Seguir o propriet??rio.","dynamic:animalFunctions","seguir","animal",false)
				exports["dynamic"]:AddButton("Colocar no Ve??culo","Colocar o animal no ve??culo.","dynamic:animalFunctions","colocar","animal",false)
				exports["dynamic"]:AddButton("Remover do Ve??culo","Remover o animal no ve??culo.","dynamic:animalFunctions","remover","animal",false)
			end
			
			exports["dynamic"]:AddButton("Desmanche","Listagem dos ve??culos.","dismantle:invokeDismantle","","others",true)
			exports["dynamic"]:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:myInjuries","","others",false)
			exports["dynamic"]:AddButton("Desbugar","Recarregar o personagem.","barbershop:debugSystem","","others",false)
			
			exports["dynamic"]:AddButton("Propriedades","Ativa/Desativa as propriedades no mapa.","homes:togglePropertys","","propertys",false)
			
			if not IsPedInAnyVehicle(ped) then
				exports["dynamic"]:AddButton("Rebocar","Colocar ve??culo na prancha do reboque.","towdriver:invokeTow","","others",false)
			else
				exports["dynamic"]:AddButton("Banco Dianteiro Esquerdo","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
				exports["dynamic"]:AddButton("Banco Dianteiro Direito","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Esquerdo","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
				exports["dynamic"]:AddButton("Banco Traseiro Direito","Sentar no banco do passageiro.","player:seatPlayer","3","vehicle",false)
				exports["dynamic"]:AddButton("Levantar Vidros","Levantar todos os vidros.","player:winsFunctions","1","vehicle",true)
				exports["dynamic"]:AddButton("Abaixar Vidros","Abaixar todos os vidros.","player:winsFunctions","0","vehicle",true)

				exports["dynamic"]:SubMenu("Ve??culo","Fun????es do ve??culo.","vehicle")
			end

			exports["dynamic"]:SubMenu("Roupas","Colocar/Retirar roupas.","outfit")
			exports["dynamic"]:SubMenu("Vestu??rio","Mudan??a de roupas r??pidas.","fastoutfit")
			exports["dynamic"]:SubMenu("Propriedades","Todas as fun????es das propriedades.","propertys")
			
			if animalHahs ~= nil then
				exports["dynamic"]:SubMenu("Dom??sticos","Todas as fun????es dos animais dom??sticos.","animal")
			end
			
			exports["dynamic"]:SubMenu("Outros","Todas as fun????es do personagem.","others")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions",function(source,args)
	if policeService or paramedicService then
		if not exports["player"]:blockCommands() and not exports["player"]:handCuff() and not menuOpen then

			local ped = PlayerPedId()
			if GetEntityHealth(ped) > 101 then
				menuOpen = true

				exports["dynamic"]:AddButton("Servi??o","Verificar companheiros em servi??o.","player:servicoFunctions","","utilitys",true)
				
				if policeService then
					exports["dynamic"]:AddButton("Computador","Abrir o dispositivo m??vel.","police:openSystem","","utilitys",false)
					exports["dynamic"]:AddButton("Cone","Colocar cone na frente.","police:insertCone","","utilitys",false)
					exports["dynamic"]:AddButton("Barreira","Colocar barreira na frente.","police:insertBarrier","","utilitys",false)
					exports["dynamic"]:AddButton("Invadir","Invadir a resid??ncia.","homes:invadeSystem","","utilitys",true)

					exports["dynamic"]:AddButton("Sheriff","Fardamento de oficial.","player:presetFunctions","1","prePolice",true)
					-- exports["dynamic"]:AddButton("State Police","Fardamento de oficial.","player:presetFunctions","2","prePolice",true)
					-- exports["dynamic"]:AddButton("State Park","Fardamento de oficial.","player:presetFunctions","3","prePolice",true)
					-- exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","player:presetFunctions","4","prePolice",true)
					-- exports["dynamic"]:AddButton("Los Santos Police","Fardamento de oficial.","player:presetFunctions","5","prePolice",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
					exports["dynamic"]:SubMenu("Utilidades","Todas as fun????es dos policiais.","utilitys")
				elseif paramedicService then
					exports["dynamic"]:AddButton("Medical Center","Fardamento de doutor.","player:presetFunctions","6","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico.","player:presetFunctions","7","preMedic",true)
					exports["dynamic"]:AddButton("Medical Center","Fardamento de param??dico interno.","player:presetFunctions","8","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de atendimentos.","player:presetFunctions","9","preMedic",true)
					exports["dynamic"]:AddButton("Fire Departament","Fardamento de mergulhador.","player:presetFunctions","10","preMedic",true)

					exports["dynamic"]:SubMenu("Fardamentos","Todos os fardamentos m??dicos.","preMedic")
					exports["dynamic"]:SubMenu("Utilidades","Todas as fun????es dos param??dicos.","utilitys")
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("emergencyFunctions","Abrir menu de emerg??ncia.","keyboard","F10")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalSpawn")
AddEventHandler("dynamic:animalSpawn",function(model)
	if animalHahs == nil then
		local ped = PlayerPedId()
		local mHash = GetHashKey(model)

		RequestModel(mHash)
		while not HasModelLoaded(mHash) do
			Wait(1)
		end

		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,0.0)
		animalHahs = CreatePed(28,mHash,coords["x"],coords["y"],coords["z"] - 1,GetEntityHeading(ped),true,false)
		local netPeds = PedToNet(animalHahs)

		SetNetworkIdCanMigrate(netPeds,true)

		SetPedCanRagdoll(animalHahs,false)
		SetEntityInvincible(animalHahs,true)
		SetPedFleeAttributes(animalHahs,0,0)
		SetEntityAsMissionEntity(animalHahs,true,false)
		SetBlockingOfNonTemporaryEvents(animalHahs,true)
		SetPedRelationshipGroupHash(animalHahs,GetHashKey("k9"))
		GiveWeaponToPed(animalHahs,GetHashKey("WEAPON_ANIMAL"),200,true,true)

		SetModelAsNoLongerNeeded(mHash)

		TriggerEvent("dynamic:animalFunctions","seguir")

		vSERVER.animalRegister(PedToNet(animalHahs))
	else
		vSERVER.animalCleaner()
		animalFollow = false
		animalHahs = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ANIMALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:animalFunctions")
AddEventHandler("dynamic:animalFunctions",function(functions)
	if animalHahs ~= nil then
		local ped = PlayerPedId()

		if functions == "seguir" then
			if not animalFollow then
				TaskFollowToOffsetOfEntity(animalHahs,ped,1.0,1.0,0.0,5.0,-1,2.5,1)
				SetPedKeepTask(animalHahs,true)
				animalFollow = true
			else
				SetPedKeepTask(animalHahs,false)
				ClearPedTasks(animalHahs)
				animalFollow = false
			end
		elseif functions == "colocar" then
			if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
				local vehicle = GetVehiclePedIsUsing(ped)
				if IsVehicleSeatFree(vehicle,0) then
					TaskEnterVehicle(animalHahs,vehicle,-1,0,2.0,16,0)
				end
			end
		elseif functions == "remover" then
			if IsPedInAnyVehicle(ped) and not IsPedOnAnyBike(ped) then
				TaskLeaveVehicle(animalHahs,GetVehiclePedIsUsing(ped),256)
				TriggerEvent("dynamic:animalFunctions","seguir")
			end
		elseif functions == "deletar" then
			vSERVER.animalCleaner()
			animalFollow = false
			animalHahs = nil
		end
	end
end)