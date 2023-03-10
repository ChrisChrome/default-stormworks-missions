local RESOURCE_DIESEL = 1
local RESOURCE_JET = 2
local RESOURCE_OIL = 5
local RESOURCE_COAL = "Coal"

local MAX_CHANGE = 0.0000001
local MAX_TIME = 60 * 60
local UI_UPDATE_MAX = 7200

local tick_time = 9999

g_savedata = {
    [RESOURCE_DIESEL] = { gantries = {} },
    [RESOURCE_JET] = { gantries = {} },
    [RESOURCE_OIL] = { gantries = {} },
    [RESOURCE_COAL] = { gantries = {} },
}

g_resources = {
    [RESOURCE_DIESEL] = {
        name = "Diesel",
        base = 0.25,
        getvehicle = function(self, vehicle_id, vehicle)
            local delta = 0
            local data, vehicle_loaded = server.getVehicleTank(vehicle_id, "Tank")

            if data and vehicle_loaded then
                vehicle.capacity = data.capacity

                if vehicle.is_buy then
                    delta = vehicle.capacity - data.value
                else
                    delta = 0 - data.value
                end
            end

            return delta, vehicle_loaded
        end,
        executeTrade = function(self, vehicle_id, vehicle, transaction)

            local money_current = server.getCurrency()

            if money_current < math.floor(transaction + 0.5) then return end

            if server.getGameSettings().infinite_money == false then
                server.setCurrency(money_current - math.floor(transaction + 0.5), server.getResearchPoints())
            end

            if vehicle.is_buy then
                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_DIESEL)
            else
                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_DIESEL)
            end
        end,
        tick = function(self)
            for vehicle_id, vehicle in pairs(g_savedata[RESOURCE_DIESEL].gantries) do
                if vehicle.spawn_protection > 0 then
                    vehicle.spawn_protection = vehicle.spawn_protection - 1

                    if vehicle.spawn_protection == 60 then
                        local data, _ =  server.getVehicleTank(vehicle_id, "Tank")

                        if data then
                            vehicle.capacity = data.capacity

                            if vehicle.is_buy then
                                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_DIESEL)
                            else
                                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_DIESEL)
                            end
                        end
                    end
                else
                    vehicle.timer = vehicle.timer + 1
                    if vehicle.timer >= 30 then
                        vehicle.timer = vehicle.timer - 30

                        if vehicle.base_factor == nil then
                            vehicle.base_factor = 1
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)

                        current_price = current_price * getPriceFactors(RESOURCE_DIESEL, self, vehicle_id, vehicle)

                        local transaction = delta * current_price

                        -- if loaded execute trade
                        if vehicle_loaded and math.abs(transaction) >= 1.0 then
                            self:executeTrade(vehicle_id, vehicle, transaction)
                            vehicle.time_without_trade = 0
                            vehicle.supply_demand_target = 1.0
                        elseif vehicle.time_without_trade >= MAX_TIME then
                            vehicle.supply_demand_target = 0.2
                        else
                            vehicle.time_without_trade = math.max(vehicle.time_without_trade + 1, MAX_TIME)
                        end

                        if vehicle.is_buy then
                            -- slowly lower price if supply is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        else
                            -- slowly raise payment if demand is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((1 / vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        end
                    end

                    if vehicle.timer_ui == nil or vehicle.timer_ui >= UI_UPDATE_MAX then
                        if vehicle.timer_ui == nil then
                            vehicle.timer_ui = math.random(0, UI_UPDATE_MAX)
                        else
                            vehicle.timer_ui = vehicle.timer_ui - UI_UPDATE_MAX
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)
                        current_price = current_price * getPriceFactors(RESOURCE_DIESEL, self, vehicle_id, vehicle)

                        updateUI(self.name, vehicle_id, vehicle, current_price, vehicle_loaded)
                    end
                    vehicle.timer_ui = vehicle.timer_ui + 1
                end
            end
        end,
     },
    [RESOURCE_JET] = {
        name = "Jet Fuel",
        base = 1.0,
        getvehicle = function(self, vehicle_id, vehicle)
            local delta = 0
            local data, vehicle_loaded = server.getVehicleTank(vehicle_id, "Tank")

            if data and vehicle_loaded then
                vehicle.capacity = data.capacity

                if vehicle.is_buy then
                    delta = vehicle.capacity - data.value
                else
                    delta = 0 - data.value
                end
            end

            return delta, vehicle_loaded
        end,
        executeTrade = function(self, vehicle_id, vehicle, transaction)

            local money_current = server.getCurrency()

            if money_current < math.floor(transaction + 0.5) then return end

            if server.getGameSettings().infinite_money == false then
                server.setCurrency(money_current - math.floor(transaction + 0.5), server.getResearchPoints())
            end

            if vehicle.is_buy then
                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_JET)
            else
                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_JET)
            end
        end,
        tick = function(self)
            for vehicle_id, vehicle in pairs(g_savedata[RESOURCE_JET].gantries) do
                if vehicle.spawn_protection > 0 then
                    vehicle.spawn_protection = vehicle.spawn_protection - 1

                    if vehicle.spawn_protection == 60 then
                        local data, _ =  server.getVehicleTank(vehicle_id, "Tank")

                        if data then
                            vehicle.capacity = data.capacity

                            if vehicle.is_buy then
                                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_JET)
                            else
                                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_JET)
                            end
                        end
                    end
                else
                    vehicle.timer = vehicle.timer + 1
                    if vehicle.timer >= 30 then
                        vehicle.timer = vehicle.timer - 30

                        if vehicle.base_factor == nil then
                            vehicle.base_factor = 1
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)

                        current_price = current_price * getPriceFactors(RESOURCE_JET, self, vehicle_id, vehicle)

                        local transaction = delta * current_price

                        -- if loaded execute trade
                        if vehicle_loaded and math.abs(transaction) >= 1.0 then
                            self:executeTrade(vehicle_id, vehicle, transaction)
                            vehicle.time_without_trade = 0
                            vehicle.supply_demand_target = 1.0
                        elseif vehicle.time_without_trade >= MAX_TIME then
                            vehicle.supply_demand_target = 0.2
                        else
                            vehicle.time_without_trade = math.max(vehicle.time_without_trade + 1, MAX_TIME)
                        end

                        if vehicle.is_buy then
                            -- slowly lower price if supply is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        else
                            -- slowly raise payment if demand is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((1 / vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        end
                    end

                    if vehicle.timer_ui == nil or vehicle.timer_ui >= UI_UPDATE_MAX then
                        if vehicle.timer_ui == nil then
                            vehicle.timer_ui = math.random(0, UI_UPDATE_MAX)
                        else
                            vehicle.timer_ui = vehicle.timer_ui - UI_UPDATE_MAX
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)
                        current_price = current_price * getPriceFactors(RESOURCE_JET, self, vehicle_id, vehicle)

                        updateUI(self.name, vehicle_id, vehicle, current_price, vehicle_loaded)
                    end
                    vehicle.timer_ui = vehicle.timer_ui + 1
                end
            end
        end,
     },
    [RESOURCE_OIL] = {
        name = "Oil",
        base = 2.0,
        getvehicle = function(self, vehicle_id, vehicle)
            local delta = 0
            local data, vehicle_loaded = server.getVehicleTank(vehicle_id, "Tank")

            if data and vehicle_loaded then
                vehicle.capacity = data.capacity

                if vehicle.is_buy then
                    delta = vehicle.capacity - data.value
                else
                    delta = 0 - data.value
                end
            end

            return delta, vehicle_loaded
        end,
        executeTrade = function(self, vehicle_id, vehicle, transaction)

            local money_current = server.getCurrency()

            if money_current < math.floor(transaction + 0.5) then return end

            if server.getGameSettings().infinite_money == false then
                server.setCurrency(money_current - math.floor(transaction + 0.5), server.getResearchPoints())
            end

            if vehicle.is_buy then
                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_OIL)
            else
                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_OIL)
            end
        end,
        tick = function(self)
            for vehicle_id, vehicle in pairs(g_savedata[RESOURCE_OIL].gantries) do
                if vehicle.spawn_protection > 0 then
                    vehicle.spawn_protection = vehicle.spawn_protection - 1

                    if vehicle.spawn_protection == 60 then
                        local data, _ =  server.getVehicleTank(vehicle_id, "Tank")

                        if data then
                            vehicle.capacity = data.capacity

                            if vehicle.is_buy then
                                server.setVehicleTank(vehicle_id, "Tank", vehicle.capacity, RESOURCE_OIL)
                            else
                                server.setVehicleTank(vehicle_id, "Tank", 0, RESOURCE_OIL)
                            end
                        end
                    end
                else
                    vehicle.timer = vehicle.timer + 1
                    if vehicle.timer >= 30 then
                        vehicle.timer = vehicle.timer - 30

                        if vehicle.base_factor == nil then
                            vehicle.base_factor = 1
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)

                        current_price = current_price * getPriceFactors(RESOURCE_OIL, self, vehicle_id, vehicle)

                        local transaction = delta * current_price

                        -- if loaded execute trade
                        if vehicle_loaded and math.abs(transaction) >= 1.0 then
                            self:executeTrade(vehicle_id, vehicle, transaction)
                            vehicle.time_without_trade = 0
                            vehicle.supply_demand_target = 1.0
                        elseif vehicle.time_without_trade >= MAX_TIME then
                            vehicle.supply_demand_target = 0.2
                        else
                            vehicle.time_without_trade = math.max(vehicle.time_without_trade + 1, MAX_TIME)
                        end

                        if vehicle.is_buy then
                            -- slowly lower price if supply is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        else
                            -- slowly raise payment if demand is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((1 / vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        end
                    end

                    if vehicle.timer_ui == nil or vehicle.timer_ui >= UI_UPDATE_MAX then
                        if vehicle.timer_ui == nil then
                            vehicle.timer_ui = math.random(0, UI_UPDATE_MAX)
                        else
                            vehicle.timer_ui = vehicle.timer_ui - UI_UPDATE_MAX
                        end

                        local current_price = self.base * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)
                        current_price = current_price * getPriceFactors(RESOURCE_OIL, self, vehicle_id, vehicle)

                        updateUI(self.name, vehicle_id, vehicle, current_price, vehicle_loaded)
                    end
                    vehicle.timer_ui = vehicle.timer_ui + 1
                end
            end
        end,
     },
    [RESOURCE_COAL] = {
        name = {
            [0] = "Coal",
            [6] = "Iron",
            [7] = "Steel",
            [8] = "Aluminium",
            [9] = "Impure Gold",
            [10] = "Gold",
        },
        base = {
            [0] = 2.0,
            [6] = 70.0,
            [7] = 150.0,
            [8] = 85.0,
            [9] = 150.0,
            [10] = 2000.0,
        },
        getvehicle = function(self, vehicle_id, vehicle)
            local delta = 0
            local data, vehicle_loaded = server.getVehicleHopper(vehicle_id, "Tank")

            if data and vehicle_loaded then
                vehicle.capacity = data.capacity

                if vehicle.is_buy then
                    delta = vehicle.capacity - data.values[vehicle.coal_type]
                else
                    delta = 0 - data.values[vehicle.coal_type]
                end
            end

            return delta, vehicle_loaded
        end,
        executeTrade = function(self, vehicle_id, vehicle, transaction)

            local money_current = server.getCurrency()

            if money_current < math.floor(transaction + 0.5) then return end

            if server.getGameSettings().infinite_money == false then
                server.setCurrency(money_current - math.floor(transaction + 0.5), server.getResearchPoints())
            end

            if vehicle.is_buy then
                server.setVehicleHopper(vehicle_id, "Tank", vehicle.capacity, vehicle.coal_type)
            else
                server.setVehicleHopper(vehicle_id, "Tank", 0, vehicle.coal_type)
            end
        end,
        tick = function(self)
            for vehicle_id, vehicle in pairs(g_savedata[RESOURCE_COAL].gantries) do
                if vehicle.spawn_protection > 0 then
                    vehicle.spawn_protection = vehicle.spawn_protection - 1

                    if vehicle.spawn_protection == 60 then
                        local data, _ = server.getVehicleHopper(vehicle_id, "Tank")

                        if data then
                            vehicle.capacity = data.capacity

                            if vehicle.is_buy then
                                server.setVehicleHopper(vehicle_id, "Tank", vehicle.capacity, vehicle.coal_type)
                            else
                                server.setVehicleHopper(vehicle_id, "Tank", 0, vehicle.coal_type)
                            end
                        end
                    end
                else
                    vehicle.timer = vehicle.timer + 1
                    if vehicle.timer >= 30 then
                        vehicle.timer = vehicle.timer - 30

                        if vehicle.base_factor == nil then
                            vehicle.base_factor = 1
                        end

                        local current_price = self.base[vehicle.coal_type] * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)

                        current_price = current_price * getPriceFactors(RESOURCE_COAL, self, vehicle_id, vehicle)

                        local transaction = delta * current_price

                        -- if loaded execute trade
                        if vehicle_loaded and math.abs(transaction) >= 1.0 then
                            self:executeTrade(vehicle_id, vehicle, transaction)
                            vehicle.time_without_trade = 0
                            vehicle.supply_demand_target = 1.0
                        elseif vehicle.time_without_trade >= MAX_TIME then
                            vehicle.supply_demand_target = 0.2
                        else
                            vehicle.time_without_trade = math.max(vehicle.time_without_trade + 1, MAX_TIME)
                        end

                        if vehicle.is_buy then
                            -- slowly lower price if supply is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        else
                            -- slowly raise payment if demand is high
                            vehicle.supply_demand =  vehicle.supply_demand + math.min(math.max((1 / vehicle.supply_demand_target) - vehicle.supply_demand, -MAX_CHANGE), MAX_CHANGE)
                        end
                    end

                    if vehicle.timer_ui == nil or vehicle.timer_ui >= UI_UPDATE_MAX then
                        if vehicle.timer_ui == nil then
                            vehicle.timer_ui = math.random(0, UI_UPDATE_MAX)
                        else
                            vehicle.timer_ui = vehicle.timer_ui - UI_UPDATE_MAX
                        end

                        local current_price = self.base[vehicle.coal_type] * vehicle.base_factor * vehicle.supply_demand
                        local delta, vehicle_loaded = self:getvehicle(vehicle_id, vehicle)
                        current_price = current_price * getPriceFactors(RESOURCE_COAL, self, vehicle_id, vehicle)

                        updateUI(self.name[vehicle.coal_type], vehicle_id, vehicle, current_price, vehicle_loaded)
                    end
                    vehicle.timer_ui = vehicle.timer_ui + 1
                end
            end
        end,
    }
}

function onCreate(is_world_create)
	if is_world_create then
		spawnAll()
	end
end

function spawnAll()
	local addonIndex = server.getAddonIndex()
    local componentIDS = {}

	for locationIndex = 0, server.getAddonData(addonIndex).location_count - 1 do
		local locationData = server.getLocationData(addonIndex, locationIndex)
		if not locationData.is_env_mod then
			for componentIndex = 0, locationData.component_count - 1 do
				local componentData = server.getLocationComponentData(addonIndex, locationIndex, componentIndex)
				componentIDS[locationData.name] = {id = componentData.id, offset = componentData.transform}
			end
		end
	end

    for name, component in pairs(componentIDS) do
        local spawn_zones = server.getZones(name)
        for _, zone in pairs(spawn_zones) do
            local spawn_transform = matrix.multiply(zone.transform, component.offset)
            server.spawnAddonVehicle(spawn_transform, addonIndex, component.id)
        end
    end
end

function onVehicleSpawn(vehicle_id, peer_id, x, y, z, cost)

    local v_data, success = server.getVehicleData(vehicle_id)

    if success then
        local is_valid = false
        local is_buy = false
        local resource_id = 0
        local business = "consumer"
        local base_factor = 1
        local coal_type = 0

        for _, tag_object in pairs(v_data.tags) do

            if tag_object == "type=trade" then
                is_valid = true
            end

            if tag_object == "transaction=buy" then
                is_buy = true
            end

            if tag_object == "business=extractor" then
                business = "extractor"
            end
            if tag_object == "business=manufacturer" then
                business = "manufacturer"
            end
            if tag_object == "business=consumer" then
                business = "consumer"
            end
            if tag_object == "business=retailer" then
                business = "retailer"
            end

            if tag_object == "resource=diesel" then
                resource_id = RESOURCE_DIESEL
            elseif tag_object == "resource=jet" then
                resource_id = RESOURCE_JET
            elseif tag_object == "resource=oil" then
                resource_id = RESOURCE_OIL
            elseif tag_object == "resource=coal" then
                resource_id = RESOURCE_COAL
            end

            if string.find(tag_object, "coal_type=") ~= nil then
                coal_type = tonumber(string.sub(tag_object, 11))
            end

            if string.find(tag_object, "base_factor=") ~= nil then
                base_factor = string.sub(tag_object, 13)
            end
        end

        if is_valid then
            g_savedata[resource_id].gantries[vehicle_id] = {spawn_protection = 120, timer = math.fmod(vehicle_id, 30), timer_ui = nil, map_id = server.getMapID(), is_buy = is_buy, supply_demand = 1.0, supply_demand_target = 1.0, time_without_trade = MAX_TIME, ready = false, distance_factor = 0, capacity = 0, business = business, base_factor = base_factor, coal_type = coal_type, price_refresh_timer = 0}
        end
    end
end

function onVehicleLoad(vehicle_id)
    for resource_id, resource in pairs(g_savedata) do
        for id, vehicle in pairs(resource.gantries) do
            if id == vehicle_id then
                vehicle.spawn_protection = 120
                vehicle.timer = vehicle.timer + 30
                vehicle.timer_ui = vehicle.timer_ui and (vehicle.timer_ui + UI_UPDATE_MAX) or (math.random(0, UI_UPDATE_MAX) + UI_UPDATE_MAX)
            end
        end
    end
end

function updateUI(name, vehicle_id, vehicle, current_price, vehicle_loaded)

    local vehicle_pos = server.getVehiclePos(vehicle_id)
    local g_x, g_y, g_z = matrix.position(vehicle_pos)

    server.removeMapLabel(-1, vehicle.map_id)
    if vehicle.is_buy then
        server.addMapLabel(-1, vehicle.map_id, 13, name .. " Gantry" .. "\nBuy for: " .. string.format("%.3f", current_price), g_x, g_z)
    else
        server.addMapLabel(-1, vehicle.map_id, 14, name .. " Gantry" .. "\nSell for: " .. string.format("%.3f", current_price), g_x, g_z)
    end

    if vehicle_loaded then
        if vehicle.is_buy then
            server.setVehicleKeypad(vehicle_id, "Price", current_price)
        else
            server.setVehicleKeypad(vehicle_id, "Price", current_price)
        end
    end
end

function getPriceFactors(resource_id, resource, vehicle_id, vehicle)

    if vehicle.distance_factor == 0 or vehicle.price_refresh_timer == nil or vehicle.price_refresh_timer <= 0 then
        generateDistanceFactor(resource_id, resource, vehicle_id, vehicle)
        vehicle.price_refresh_timer = 60 * 2 * 5
    else
        vehicle.price_refresh_timer = vehicle.price_refresh_timer -1
    end

    local season_factor = 1.0 + (math.cos((m / 12) * math.pi * 2.0) * -0.5)

    if vehicle.is_buy then
        return season_factor * (1 /  vehicle.distance_factor)
    else
        return season_factor * vehicle.distance_factor
    end
end

function generateDistanceFactor(resource_id, resource, vehicle_id, vehicle)

    local target_type

    if resource_id == RESOURCE_COAL then
        if vehicle.business == "extractor" then -- find nearest manufacturer
            target_type = "consumer"
        elseif vehicle.business == "consumer" then
            target_type = "extractor"
        end
    else
        if vehicle.business == "extractor" then -- find nearest manufacturer
            target_type = "manufacturer"
        elseif vehicle.business == "manufacturer" then -- manufacturers refine at 1:1 ratio
            vehicle.distance_factor = 1.0
            return
        elseif vehicle.business == "consumer" then
            target_type = "manufacturer"

        elseif vehicle.business == "retailer" then -- retailers sell at a 10% markup
            local best_distance = 999999999
            for target_id, target in pairs(g_savedata[resource_id].gantries) do
                if target.business == "manufacturer" then
                    local vehicle_pos = server.getVehiclePos(vehicle_id)
                    local target_pos = server.getVehiclePos(target_id)
                    best_distance = math.min(best_distance, matrix.distance(vehicle_pos, target_pos))
                end
            end
            vehicle.distance_factor = 1 / ((1.0 + (best_distance / 8000.0)) * 1.1)
            return
        end

    end

    local vehicle_pos = server.getVehiclePos(vehicle_id)

    local best_distance = 999999999
    for target_id, target in pairs(g_savedata[resource_id].gantries) do
        if target.business == target_type then     
            local target_pos = server.getVehiclePos(target_id)
            best_distance = math.min(best_distance, matrix.distance(vehicle_pos, target_pos))
        end
    end

    if best_distance == 999999999 then -- default to dist from origin
        best_distance = math.min(best_distance, matrix.distance(vehicle_pos, matrix.identity()))
    end

    vehicle.distance_factor = 1.0 + (best_distance / 8000.0)
end

function onTick(tick_delta)

    tick_time = tick_time + 1
    if tick_time >= 3600 then
        tick_time = 0
        d, m, y = server.getDate()
    end

    for _, resource in pairs(g_resources) do
        resource:tick()
    end
end

--
--[[UTIL]]
--

function hasTag(tags, tag)
	for k, v in pairs(tags) do
		if v == tag then
			return true
		end
	end

	return false
end

-- calculates the size of non-contiguous tables and tables that use non-integer keys
function tableLength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- recursively outputs the contents of a table to the chat window for debugging purposes.
-- name is the name that should be displayed for the root of the table being passed in.
-- m is an optional parameter used when the function recurses to specify a margin string that will be prepended before printing for readability
function printTable(table, name, m)
	local margin = m or ""

	if tableLength(table) == 0 then
		server.announce("", margin .. name .. " = {}")
	else
		server.announce("", margin .. name .. " = {")

		for k, v in pairs(table) do
			local vtype = type(v)

			if vtype == "table" then
				printTable(v, k, margin .. "    ")
			elseif vtype == "string" then
				server.announce("", margin .. "    " .. k .. " = \"" .. tostring(v) .. "\",")
			elseif vtype == "number" or vtype == "function" or vtype == "boolean" then
				server.announce("", margin .. "    " .. k .. " = " .. tostring(v) .. ",")
			else
				server.announce("", margin .. "    " .. k .. " = " .. tostring(v) .. " (" .. type(v) .. "),")
			end
		end

		server.announce("", margin .. "},")
	end
end