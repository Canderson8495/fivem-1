Transformer = false;
Air = false;
Hopper = false;
Breaker = false;
Liquid = false;

ESX = nil
Citizen.CreateThread(function()
    while true do
        Wait(5)
        if ESX ~= nil then

        else
            ESX = nil
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
        end
    end
end)

local acidLevel = 5.0
local acidLoad = 0
local temperature = 70
local ingredLoad = 0
local product = {}
local isOn = false
local mistakes = 0
local callback = nil
local highqual = 0
local lowqual = 0

local locations = {}

local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
local spawned = false
Citizen.CreateThread(function()
    Citizen.Wait(10000)

    while true do
        Citizen.Wait(1000)
        if GetDistanceBetweenCoords(Config.PickupBlip.x, Config.PickupBlip.y, Config.PickupBlip.z,
            GetEntityCoords(GetPlayerPed(-1))) <= 200 then
            if spawned == false then
                for i = 0, 10 do
                    TriggerEvent('EWine:start')
                end
            end
            spawned = true
        else
            if spawned then
                locations = {}
            end
            spawned = false

        end
    end
end)

local displayed = false
local menuOpen = false
-- Deprecated
--[[
local blipPickup = AddBlipForCoord(Config.PickupBlip.x,Config.PickupBlip.y,Config.PickupBlip.z)

			SetBlipSprite (blipPickup, 514)
			SetBlipDisplay(blipPickup, 4)
			SetBlipScale  (blipPickup, 1.1)
			SetBlipColour (blipPickup, 24)
			SetBlipAsShortRange(blipPickup, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Cocoa Leaves Plantation")
			EndTextCommandSetBlipName(blipPickup)
			
local blipProcess = AddBlipForCoord(Config.Processing.x, Config.Processing.y, Config.Processing.z)

			SetBlipSprite (blipProcess, 514)
			SetBlipDisplay(blipProcess, 4)
			SetBlipScale  (blipProcess, 1.1)
			SetBlipColour (blipProcess, 24)
			SetBlipAsShortRange(blipProcess, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString("Cocaine production")
			EndTextCommandSetBlipName(blipProcess)
--]]

local process = true
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        playerCoords = GetEntityCoords(GetPlayerPed(-1))
        -- pick up spot

        for k in pairs(locations) do
            if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z,
                GetEntityCoords(GetPlayerPed(-1))) < 150 then
                DrawMarker(3, locations[k].x, locations[k].y, locations[k].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0,
                    1.0, 0, 200, 0, 200, 0, 1, 0, 0)

                if GetDistanceBetweenCoords(locations[k].x, locations[k].y, locations[k].z,
                    GetEntityCoords(GetPlayerPed(-1)), false) < 2 then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        TriggerServerEvent('EWine:get')
                        TriggerEvent('EWine:new', k)
                    end
                end

            end
        end
        -- Put ingrediant spot
        if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
            GetEntityCoords(GetPlayerPed(-1))) < 150 then
            DrawMarker(1, Config.Processing.x, Config.Processing.y, Config.Processing.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                Draw3DText(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    "~w~Wine Production~y~\nPress [~b~E~y~] to load ingredients.\n~w~" .. ingredLoad .. " concoctions",
                    4, 0.15, 0.1)
                -- Change this for all of them
                if IsControlJustReleased(0, Keys['E']) then
                    Citizen.CreateThread(function()

                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "grape")
                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end
        -- Show Switch to Start/Stop
        if GetDistanceBetweenCoords(Config.Switch.x, Config.Switch.y, Config.Switch.z, GetEntityCoords(GetPlayerPed(-1))) <
            150 then
            DrawMarker(1, Config.Switch.x, Config.Switch.y, Config.Switch.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3,
                1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.Switch.x, Config.Switch.y, Config.Switch.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                -- Notify You hear the machines begin to buzz
                -- Add logic to show different stuff based on isOn
                if isOn then
                    Draw3DText(Config.Switch.x, Config.Switch.y, Config.Switch.z,
                        "~w~On/Off Switch~y~\nPress [~b~E~y~] to Turn the Machine off.", 4, 0.15, 0.1)
                else
                    Draw3DText(Config.Switch.x, Config.Switch.y, Config.Switch.z,
                        "~w~On/Off Switch~y~\nPress [~b~E~y~] to Turn the Machine on.", 4, 0.15, 0.1)
                end
                if IsControlJustReleased(0, Keys['E']) then
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        -- Notify you hear the machines start to whirr and buzz
                        if isOn then
                            ESX.TriggerServerCallback('EWine:fix', function(output)
                                grindResult = output
                            end, "power")
                            TriggerEvent("pNotify:SendNotification", {
                                text = "The machine quiets down slowly.",
                                type = "success",
                                queue = "wow",
                                timeout = "5000",
                                layout = "centerLeft"
                            })

                        else
                            if ingredLoad > 4 and acidLoad > 4 then
                                ESX.TriggerServerCallback('EWine:fix', function(output)
                                    grindResult = output
                                end, "power")
                                TriggerEvent("pNotify:SendNotification", {
                                    text = "The machine slowly begins to hum to life.",
                                    type = "success",
                                    queue = "wow",
                                    timeout = "5000",
                                    layout = "centerLeft"
                                })
                                TriggerEvent("EWine:OnNotification", isOn)
                                Citizen.Wait(500)
                            else
                                TriggerEvent("pNotify:SendNotification", {
                                    text = "The machine is empty!",
                                    type = "error",
                                    queue = "wow",
                                    timeout = "3000",
                                    layout = "centerLeft"
                                })
                            end
                        end

                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end
        -- Temperature
        if GetDistanceBetweenCoords(Config.Temperature.x, Config.Temperature.y, Config.Temperature.z,
            GetEntityCoords(GetPlayerPed(-1))) < 150 then
            DrawMarker(1, Config.Temperature.x, Config.Temperature.y, Config.Temperature.z, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.Temperature.x, Config.Temperature.y, Config.Temperature.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                Draw3DText(Config.Temperature.x, Config.Temperature.y, Config.Temperature.z,
                    "~w~Temperature~y~\nPress [~b~E~y~] to lower the temperature.\n~w~" .. temperature .. " F", 4, 0.15,
                    0.1)
                if IsControlJustReleased(0, Keys['E']) then
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "temperature")

                        Citizen.Wait(500)
                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end
        -- tBox
        checkBoxFix(Config.tBox , "transformer", Transformer)
        -- bBox
        checkBoxFix(Config.bBox , "breaker", Breaker)
        -- aBox
        checkBoxFix(Config.aBox , "air", Air)
        -- lBox
        checkBoxFix(Config.lBox , "liquid", Liquid)
        -- hBox
        checkBoxFix(Config.hBox , "hopper", Hopper)
        -- Acid
        if GetDistanceBetweenCoords(Config.Acid.x, Config.Acid.y, Config.Acid.z, GetEntityCoords(GetPlayerPed(-1))) <
            150 then
            DrawMarker(1, Config.Acid.x, Config.Acid.y, Config.Acid.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0, 0,
                200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.Acid.x, Config.Acid.y, Config.Acid.z, GetEntityCoords(GetPlayerPed(-1)),
                true) < 1.5 then
                Draw3DText(Config.Acid.x, Config.Acid.y, Config.Acid.z,
                    "~w~Acid~y~\nPress [~b~E~y~] to make your wine more acidic\n~w~" .. acidLevel .. " ph", 4, 0.15, 0.1)
                if IsControlJustReleased(0, Keys['E']) then
                    print("Called")
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "acid")

                        Citizen.Wait(500)
                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end

        -- EndProduct
        if GetDistanceBetweenCoords(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
            GetEntityCoords(GetPlayerPed(-1))) < 150 then
            DrawMarker(1, Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                Draw3DText(Config.EndProduct.x, Config.EndProduct.y, Config.EndProduct.z,
                    "~w~End Product~y~\nPress [~b~E~y~] to pick up your product.\n~w~" .. highqual .. " Fine Wine" ..
                        "\n~w~" .. lowqual .. " Basic Wine", 4, 0.15, 0.1)
                if IsControlJustReleased(0, Keys['E']) then
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "take")

                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end
        -- Acid Mixture
        if GetDistanceBetweenCoords(Config.AcidMixture.x, Config.AcidMixture.y, Config.AcidMixture.z,
            GetEntityCoords(GetPlayerPed(-1))) < 150 then
            DrawMarker(1, Config.AcidMixture.x, Config.AcidMixture.y, Config.AcidMixture.z, 0.0, 0.0, 0.0, 0.0, 0.0,
                0.0, 1.3, 1.3, 1.0, 0, 200, 0, 110, 0, 1, 0, 0)
            if GetDistanceBetweenCoords(Config.AcidMixture.x, Config.AcidMixture.y, Config.AcidMixture.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 1.5 then
                Draw3DText(Config.AcidMixture.x, Config.AcidMixture.y, Config.AcidMixture.z,
                    "~w~Yeast Mixture~y~\nPress [~b~E~y~] to mix your yeast.\n~w~" .. acidLoad .. " gallons", 4, 0.15,
                    0.1)
                if IsControlJustReleased(0, Keys['E']) then
                    -- Change this for all of them
                    Citizen.CreateThread(function()
                        print("We are n yeast adder")
                        local result = false
                        ESX.TriggerServerCallback('EWine:fix', function(output)
                            grindResult = output
                        end, "yeast")
                    end)
                end
            end

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end

        --[[		
	for k,v in ipairs(Config.FastTravels) do
		local distance = GetDistanceBetweenCoords(playerCoords, v.From, true)
		if distance < Config.DrawDistance then
			DrawMarker(v.Marker.type, v.From, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Marker.x, v.Marker.y, v.Marker.z, v.Marker.r, v.Marker.g, v.Marker.b, v.Marker.a, false, false, 2, v.Marker.rotate, nil,nil,false)
		end
		if distance < v.Marker.x then
			FastTravel(v.To.coords, v.To.heading)
		end
	end
	--]]

    end
end)



function checkBoxFix(Box, name, currValue)
    if GetDistanceBetweenCoords(Box.x, Box.y, Box.z, GetEntityCoords(GetPlayerPed(-1))) <
            150 then
            if currValue then
                DrawMarker(1, Box.x, Box.y, Box.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0,
                    0, 200, 0, 110, 0, 1, 0, 0)
            else
                DrawMarker(1, Box.x, Box.y, Box.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.0,
                    200, 0, 0, 110, 0, 1, 0, 0)
            end
            tryPlayerFix(Box, name)

            if GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                GetEntityCoords(GetPlayerPed(-1)), true) < 20 and
                GetDistanceBetweenCoords(Config.Processing.x, Config.Processing.y, Config.Processing.z,
                    GetEntityCoords(GetPlayerPed(-1)), true) > 3 then
                process = false
            end
        end
end


function tryPlayerFix(Box, name )
    if GetDistanceBetweenCoords(Box.x, Box.y, Box.z, GetEntityCoords(GetPlayerPed(-1)), true) <
        1.5 then
        Draw3DText(Box.x, Box.y, Box.z,
            "~w~"..name.."~y~\nPress [~b~E~y~] to fix the "..name, 4, 0.15, 0.1)
        if IsControlJustReleased(0, Keys['E']) then
            -- Change this for all of them
            Citizen.CreateThread(function()
                local grindResult
                ESX.TriggerServerCallback('EWine:fix', function(output)
                    grindResult = output
                end, name)
                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_WELDING', 0, true)
                Citizen.CreateThread(function()
                    exports['progressBars']:startUI(2000, "Repairing")
                    Citizen.Wait(2000)
                    ClearPedTasksImmediately(PlayerPedId())
                end)
            end)
        end
    end
end

-- Teleport function
function FastTravel(coords, heading)
    local playerPed = PlayerPedId()
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Citizen.Wait(500)
    end
    ESX.Game.Teleport(playerPed, coords, function()
        DoScreenFadeIn(800)
        if heading then
            SetEntityHeading(playerPed, heading)
        end
    end)
end

function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    if inDist then
        SetTextColour(0, 190, 0, 220) -- You can change the text color here
    else
        SetTextColour(220, 0, 0, 220) -- You can change the text color here
    end
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z + 2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent('EWine:start')
AddEventHandler('EWine:start', function()
    local set = false
    Citizen.Wait(10)

    local rnX = Config.PickupBlip.x + math.random(-35, 35)
    local rnY = Config.PickupBlip.y + math.random(-35, 35)

    local u, Z = GetGroundZFor_3dCoord(rnX, rnY, 300.0, 0)

    table.insert(locations, {
        x = rnX,
        y = rnY,
        z = Z + 0.3
    });

end)

RegisterNetEvent('EWine:new')
AddEventHandler('EWine:new', function(id)
    local set = false
    Citizen.Wait(10)

    local rnX = Config.PickupBlip.x + math.random(-35, 35)
    local rnY = Config.PickupBlip.y + math.random(-35, 35)

    local u, Z = GetGroundZFor_3dCoord(rnX, rnY, 300.0, 0)

    locations[id].x = rnX
    locations[id].y = rnY
    locations[id].z = Z + 0.3

end)

RegisterNetEvent('EWine:message')
AddEventHandler('EWine:message', function(message)
    ESX.ShowNotification(message)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('EWine:updateData')
AddEventHandler('EWine:updateData', function(item, value)
    if item == "transformer" then
        Transformer = value
    elseif item == "breaker" then
        Breaker = value
    elseif item == "air" then
        Air = value
    elseif item == "hopper" then
        Hopper = value
    elseif item == "liquid" then
        Liquid = value
    elseif item == "temperature" then
        print(value)
        temperature = value
    elseif item == "lowqual" then
        print(value)
        lowqual = value
    elseif item == "highqual" then
        print(value)
        highqual = value
    elseif item == "acid" then
        print(value)
        acidLevel = value
    elseif item == "grape" then
        ingredLoad = value
    elseif item == "yeast" then
        print("yeast added")
        print(value)
        acidLoad = value
    elseif item == "power" then
        isOn = value
        print(isOn)
    end
end)
Citizen.CreateThread(function()
    TriggerServerEvent('syncUp')
    local blip = AddBlipForCoord(853.76, -1967.00, 100)
    SetBlipSprite(blip, 93)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 1.0)
    SetBlipScale(blip, 1.0)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Brewery')
    EndTextCommandSetBlipName(blip)

    local pickupblip = AddBlipForCoord(Config.PickupBlip.x, Config.PickupBlip.y, Config.PickupBlip.z)
    SetBlipSprite(pickupblip, 238)
    SetBlipColour(pickupblip, 31)
    SetBlipDisplay(pickupblip, 4)
    SetBlipScale(pickupblip, 1.0)
    SetBlipScale(pickupblip, 1.0)
    SetBlipAsShortRange(pickupblip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Grape Vineyard')
    EndTextCommandSetBlipName(pickupblip)
    local sellblip = AddBlipForCoord(Config.sell.x, Config.sell.y, Config.sell.z)
    SetBlipSprite(sellblip, 478)
    SetBlipColour(sellblip, 31)
    SetBlipDisplay(sellblip, 4)
    SetBlipScale(sellblip, 1.0)
    SetBlipScale(sellblip, 1.0)
    SetBlipAsShortRange(sellblip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Wine Buyer')
    EndTextCommandSetBlipName(sellblip)
end)

local isSelling = false;
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(1)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), Config.sell.x, Config.sell.y, Config.sell.z, true) <=
            10 then
            DrawMarker(20, Config.sell.x, Config.sell.y, Config.sell.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102,
                100, 102, 100, false, true, 2, false, false, false, false)

            if GetDistanceBetweenCoords(coords, Config.sell.x, Config.sell.y, Config.sell.z, true) < 1.0 then

                DisplayHelpText("Press ~INPUT_PICKUP~ to sell.")

                if IsControlJustReleased(1, 51) then
                    print("attempting sell")
                    ESX.TriggerServerCallback('EWine:sell', function(output)
                        if output == true then
                            TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                            isSelling = true
                            Citizen.CreateThread(function()
                                exports['progressBars']:startUI(3000, "Selling")
                                Citizen.Wait(3000)
                                ClearPedTasksImmediately(PlayerPedId())
                                isSelling = false
                            end)
                        else
                            ESX.ShowNotification("You don't have any wine to sell.")
                        end
                    end)

                end
            end
        end
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if isSelling then
            DisableControlAction(0, 51, true) -- E 
        end
    end
end)
