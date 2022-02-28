Transformer = false;
Air = false;
Breaker = false;
Hopper = false;
Liquid = false;
Temperature = 70;
Acid = 5.0;
IsOn = false;
Yeast = 0;  
Grape = 0;
mistakes = 0;
lowqual = 0
highqual = 0



ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterServerEvent("EWine:get")
AddEventHandler("EWine:get", function()
    	local _source = source	
		local xPlayer = ESX.GetPlayerFromId(_source)
		local amount = math.random(1,2)
		print("Giving grapes")
				if xPlayer.canCarryItem("grape", amount) then
					xPlayer.addInventoryItem("grape", amount)
					else
					TriggerClientEvent('esx:showNotification', source, '~r~You cant hold any more grapes')
				end
end)



ESX.RegisterServerCallback("EWine:getProduct", function(source, cb, product)
    	local _source = source	
	print(source)
	print(cb)
	print(product)
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if product == nil then		
		TriggerClientEvent("pNotify:SendNotification", _source, {
    			text = "You don't have any end product ready.",
    			type = "error",
    			queue = "lmao",
    			timeout = 3000,
    			layout = "centerLeft"	
		})
	cb(false)
	
	else
	xPlayer.addInventoryItem(product, 1)
	cb(true)
	end
end)
ESX.RegisterServerCallback("EWine:fix", function(source, cb, fixItem)
	print("Called fix")
	print(fixItem)
	if fixItem == "transformer" then 
		Transformer = true;
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
	elseif fixItem == "take" then 
		if highqual > 0 then
		  local _source = source
		  local xPlayer = ESX.GetPlayerFromId(_source)
		  if xPlayer.getInventoryItem('highqualwine').count < 20 then
				xPlayer.addInventoryItem('highqualwine', 1) 
				highqual = highqual -1
		
				TriggerClientEvent("EWine:updateData", -1 ,"highqual", highqual)
		  else 
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You can't hold anymore of this wine.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
		--inventory full
		  end
		elseif lowqual > 0 then
		  local _source = source
		  local xPlayer = ESX.GetPlayerFromId(_source)
		  if xPlayer.getInventoryItem('lowqualwine').count < 20 then
				xPlayer.addInventoryItem('lowqualwine', 1) 
				lowqual = lowqual -1
		
				TriggerClientEvent("EWine:updateData", -1 ,"lowqual", lowqual)
		  else 
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You can't hold anymore of this wine.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
		  end
		else
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "There is no wine for you to take.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
        end
	elseif fixItem == "breaker" then
		Breaker = true;
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
	elseif fixItem == "air" then
		Air = true;
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
	elseif fixItem == "hopper" then
		Hopper = true;
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
	elseif fixItem == "liquid" then
		Liquid = true;
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
	elseif fixItem == "power" then
		IsOn = not IsOn
		if IsOn == true then 
			Grape = Grape - 5
			Yeast = Yeast - 5
		end
		TriggerClientEvent("EWine:updateData", -1 , fixItem, true)
		TriggerClientEvent("EWine:updateData", -1 , "grape", Grape)
		TriggerClientEvent("EWine:updateData", -1 , "yeast", Yeast)
	elseif fixItem == "yeast" then
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem('yeast').count >= 1 then
				xPlayer.removeInventoryItem('yeast', 1) 
				Yeast = Yeast + 1
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You pour your yeast into the vats.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
				else
				
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    		text = "You don't have anymore yeast.",
		    		type = "error",
		    		queue = "lmao",
		    		timeout = 3000,
		    		layout = "centerLeft"	
				})
				end
		TriggerClientEvent("EWine:updateData", -1 , fixItem, Yeast)
	elseif fixItem == "grape" then
		local _source = source
		local xPlayer  = ESX.GetPlayerFromId(_source)
			if xPlayer.getInventoryItem('grapes').count >= 1 then
				xPlayer.removeInventoryItem('grapes', 1) 
				Grape = Grape + 1
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You pour your grapes into the hopper",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
					print("test")
				else
				
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    		text = "You don't have anymore grapes.",
		    		type = "error",
		    		queue = "lmao",
		    		timeout = 3000,
		    		layout = "centerLeft"	
				})
				end
		TriggerClientEvent("EWine:updateData", -1 , fixItem, Grape)
		cb(true)
	elseif fixItem == "temperature" then
		if Temperature > 10 then 
		Temperature = Temperature - 10;
		end
		TriggerClientEvent("EWine:updateData", -1 , fixItem, Temperature)
	elseif fixItem == "acid" then
		if Acid > 0.5 then
		Acid = Acid - 0.5;
		end
		TriggerClientEvent("EWine:updateData", -1 , fixItem, Acid)
	end

	--[[
    	local _source = source	
	print(source)
	print(cb)
	print(product)
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if product == nil then		
		TriggerClientEvent("pNotify:SendNotification", _source, {
    			text = "You don't have any end product ready.",
    			type = "error",
    			queue = "lmao",
    			timeout = 3000,
    			layout = "centerLeft"	
		})
	cb(false)
	
	else
	xPlayer.addInventoryItem(product, 1)
	cb(true)
	end
	--]]
	cb(true)
end)





ESX.RegisterServerCallback('EWine:process', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('coke').count >= 2 then
					xPlayer.removeInventoryItem('coke', 2) 
					xPlayer.addInventoryItem('coke_pooch', 1) 
					cb(true)
				else
				TriggerClientEvent('esx:showNotification', source, '~r~Not enough coca leaves')
				cb(false)
				end
			

end)
ESX.RegisterServerCallback('EWine:grind', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('coke').count >= 2 then
					xPlayer.removeInventoryItem('coke', 2) 
					xPlayer.addInventoryItem('coke_con', 1)
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You grind your materials into a concoction.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
					cb(true)
				else
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    		text = "You don't have enough materials.",
		    		type = "error",
		    		queue = "lmao",
		    		timeout = 3000,
		    		layout = "centerLeft"	
				})
				cb(false)
				end
			

end)
ESX.RegisterServerCallback('EWine:addAcid', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('hcl').count >= 1 then
					xPlayer.removeInventoryItem('hcl', 1) 
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You pour your acid into the vats.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
					print("test")
					cb(true)
				else
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    		text = "You don't have anymore acid.",
		    		type = "error",
		    		queue = "lmao",
		    		timeout = 3000,
		    		layout = "centerLeft"	
				})
				cb(false)
				end
			
end)
ESX.RegisterServerCallback('EWine:addIngred', function (source, cb)
	
	local _source = source
	
	local xPlayer  = ESX.GetPlayerFromId(_source)
			
			
				if xPlayer.getInventoryItem('grapes').count >= 1 then
					xPlayer.removeInventoryItem('grapes', 1) 
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    			text = "You dump your grapes into the vat.",
		    			type = "success",
		    			queue = "lmao",
		    			timeout = 3000,
		    			layout = "centerLeft"	
				})
					print("test")
					cb(true)
				else
				TriggerClientEvent("pNotify:SendNotification", _source, {
		    		text = "You don't have anymore grapes to dump.",
		    		type = "error",
		    		queue = "lmao",
		    		timeout = 3000,
		    		layout = "centerLeft"	
				})
				cb(false)
				end
			
end)




RegisterServerEvent("EWine:OnNotification")
AddEventHandler("EWine:OnNotification", function(isOn)
	print("We're in the server event")
	if isOn then
		-- Turning 
		TriggerClientEvent("pNotify:SendNotification", _source, {
		    text = "The noises from the machines seem to slow down and shut off",
		    type = "success",
		    queue = "lmao",
		    timeout = 3000,
		    layout = "bottomCenter"	
		})
	else	
		-- Turning on
		TriggerClientEvent("pNotify:SendNotification", _source, {
		    text = "The machines seem to buzz and whirr into life",
		    type = "success",
		    queue = "lmao",
		    timeout = 3000,
		    layout = "bottomCenter"	
		})
	end
end)
	

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(5000)
		if IsOn then
			if Temperature > 110 or Temperature < 50 or Acid > 6.0 or Acid < 2.0 then	
				mistakes =  mistakes + 1
				Citizen.Wait(5000)
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(5000)
		if IsOn then
			if not Hopper or not Air or not Transformer or not Breaker or not Liquid then	
				mistakes =  mistakes + 1
				Citizen.Wait(5000)
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(15000)
		if IsOn then
			itemBreak = math.random(1,5)
			print(itemBreak)
			if itemBreak == 1 then 
				print("transformer")
				Transformer = false;
				TriggerClientEvent("EWine:updateData", -1 , "transformer", false)
				TriggerEvent('InteractSound_SV:PlayWithinDistanceOfCoords', 50.0 ,'boom', 0.1, Config.tBox)
			elseif itemBreak == 2 then 
				Air = false;
				TriggerClientEvent("EWine:updateData", -1 , "air", false)
				TriggerEvent('InteractSound_SV:PlayWithinDistanceOfCoords', 50.0 ,'metal', 0.1, Config.aBox)
			elseif itemBreak == 3 then 
				Breaker = false;
				TriggerClientEvent("EWine:updateData", -1 , "breaker", false)
				TriggerEvent('InteractSound_SV:PlayWithinDistanceOfCoords', 50.0 ,'shock', 0.1, Config.bBox)
			elseif itemBreak == 4 then 
				Liquid = false;
				TriggerClientEvent("EWine:updateData", -1 , "liquid", false)
				TriggerEvent('InteractSound_SV:PlayWithinDistanceOfCoords', 50.0 ,'water', 0.1, Config.lBox)
			elseif itemBreak == 5 then 
				Hopper = false;
				TriggerClientEvent("EWine:updateData", -1 , "hopper", false)
				TriggerEvent('InteractSound_SV:PlayWithinDistanceOfCoords', 50.0 ,'thud', 0.1, Config.hBox)
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do 
	Citizen.Wait(750)
		if IsOn then
			if Temperature <= 212 then 
			Temperature = Temperature + 1;
			TriggerClientEvent("EWine:updateData", -1 , "temperature", Temperature)
			end
			if Acid < 14.0 then
			Acid = Acid + 0.1;
			TriggerClientEvent("EWine:updateData", -1 , "acid", Acid)
			end
			print("Temperature and Acid Increase by 0.1")
			
		
		end
	
	end
end)
Citizen.CreateThread(function()
	while true do 
		if IsOn then
			print(mistakes)
			if mistakes < 5  then
				highqual = highqual + 1
				TriggerClientEvent("EWine:updateData", -1 , "highqual", highqual)
				print("reward 1 high qual wine")
			else
				lowqual = lowqual + 1
				TriggerClientEvent("EWine:updateData", -1 , "lowqual", lowqual)
				print("reward 1 low qual wine")
			end
			mistakes = 0
		        if Yeast - 5 > -1 and Grape -5 > -1 then 
				Yeast = Yeast - 5  
				Grape = Grape - 5
				TriggerClientEvent("EWine:updateData", -1 , "grape", Grape)
				TriggerClientEvent("EWine:updateData", -1 , "yeast", Yeast)
			else 
				IsOn = false	
				TriggerClientEvent("EWine:updateData", -1 , "power", false)
			end
			
		
		end
	Citizen.Wait(60000)
	
	end
end)




ESX.RegisterServerCallback('EWine:sell', function (source, cb)
	
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	if xPlayer.getInventoryItem('highqualwine').count >= 1 then
		xPlayer.removeInventoryItem('highqualwine', 1) 
		xPlayer.addMoney(2000)
		cb(true)
	elseif xPlayer.getInventoryItem('lowqualwine').count >= 1 then
		xPlayer.removeInventoryItem('lowqualwine',1)
		xPlayer.addMoney(400)
		cb(true)
	else 
		cb(false)
	end
			
end)


RegisterServerEvent("syncUp")
AddEventHandler('syncUp', function()
				TriggerClientEvent("EWine:updateData", -1 , "grape", Grape)
				TriggerClientEvent("EWine:updateData", -1 , "yeast", Yeast)
				TriggerClientEvent("EWine:updateData", -1 , "power", IsOn)
				TriggerClientEvent("EWine:updateData", -1 , "highqual", highqual)
				TriggerClientEvent("EWine:updateData", -1 , "lowqual", lowqual)
				TriggerClientEvent("EWine:updateData", -1 , "transformer", Transformer)
				TriggerClientEvent("EWine:updateData", -1 , "hopper", Hopper)
				TriggerClientEvent("EWine:updateData", -1 , "air", Air)
				TriggerClientEvent("EWine:updateData", -1 , "breaker", Breaker)
				TriggerClientEvent("EWine:updateData", -1 , "liquid", Liquid)
				TriggerClientEvent("EWine:updateData", -1 , "temperature", Temperature)
				TriggerClientEvent("EWine:updateData", -1 , "acid", Acid)


end)
