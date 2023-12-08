--[[
	EISHU: "Might have to nuke here when selectable nametags exist >:("
	Dynamic nametags! JSJSJSJS
--]]
-- Example: dnametag.exampleOBJ = {obj = obj, name = "", range = 50, players = {usrdata1, usrdata2}, color = 0x0000, huds = {pname1 = ID}}
dnametag = {

}

dnt_api = {}

dnthud = {
	hud_elem_type = "waypoint",
	number = 0x00,
	name = "",
	text = nil,
	world_pos = vector.new(),
	precision = 0,
}

local function is_online(thing)
	if type(thing) == "userdata" then
		if thing:is_player() and thing:get_player_name() and thing:get_player_control() then
			return true
		else
			return false
		end
	else
		return Player(thing) ~= nil
	end
end

local function IsObjStillAlive(obj)
	local check = obj:get_hp()
	local check2 = obj:get_yaw() or obj:is_player()
	if check and check2 then return true end
	return false
end

local function GetPlayerObj(thing)
	if type(thing) == "userdata" then
		return thing
	elseif type(thing) == "string" then
		return core.get_player_by_name(thing)
	end
end

if not Name then
	function Name(thing)
		if type(thing) == "userdata" then
			return thing:get_player_name()
		elseif type(thing) == "string" then
			return thing
		end
	end
end

local function GetUpPosFromObject(obj)
	local obj_pos = obj:get_pos()
	local obj_properties = obj:get_properties()
	if obj_pos and obj_properties then
		local collisionbox = obj_properties.collisionbox
		local Ymax = collisionbox[5]
		if Ymax then
			return {
				x = obj_pos.x,
				y = obj_pos.y + Ymax + 0.05,
				z = obj_pos.z
			}
		end
		return obj_pos
	end
end

local function on_step(dtime)
	for i, nt in pairs(dnametag) do
		if nt.text and nt.players then
			for pname, bool in pairs(nt.players) do
				local player = GetPlayerObj(pname)
				if bool then
					if IsObjStillAlive(nt.obj) then
						if is_online(player) then
							if nt.range then
								if vector.distance(nt.obj:get_pos(), player:get_pos()) <= nt.range then
									if nt.huds[Name(player)] then
										player:hud_change(nt.huds[Name(player)], "world_pos", GetUpPosFromObject(nt.obj))
									else
										local def = dnthud
										def.world_pos = GetUpPosFromObject(nt.obj)
										def.name = nt.text
										def.precision = nt.precision or 0
										def.number = nt.color
										local id = player:hud_add(def)
										if id then
											dnametag[i].huds[Name(player)] = id
										end
									end
								else
									if nt.huds[Name(player)] then
										player:hud_remove(nt.huds[Name(player)])
										dnametag[i].huds[Name(player)] = nil
									end
								end
							else
								if nt.huds[Name(player)] then
									player:hud_change(nt.huds[Name(player)], "world_pos", GetUpPosFromObject(nt.obj))
								else
									local def = dnthud
									def.world_pos = GetUpPosFromObject(nt.obj)
									def.name = nt.text
									def.precision = nt.precision or 0
									def.number = nt.color
									local id = player:hud_add(def)
									if id then
										dnametag[i].huds[Name(player)] = id
									end
								end
							end
						else
							dnametag[i].players[pname] = nil -- Delete player if not online
						end
					else
						dnt_api.remove_dynamic_nametag(i)
					end
				else
					dnametag[i].players[pname] = nil
				end
			end
		end
	end
end

core.register_globalstep(on_step)

core.register_on_leaveplayer(function(thing)
	for i, nt in pairs(dnametag) do
		if nt.players then
			for _, player in pairs(nt.players) do
				if Name(player) == Name(thing) then
					dnametag[i].players[_] = nil
				end
			end
		end
		if nt.huds[Name(thing)] then
			dnametag[i].huds[Name(thing)] = nil
		end
	end
end)

function dnt_api.register_nametag(name, def)
	if name and def.text and def.obj and def.players and def.color then
		if dnametag[name] == nil then
			dnametag[name] = {
				text = def.text,
				obj = def.obj,
				color = def.color,
				players = def.players,
				range = def.range or nil,
				huds = {}
			}
			return true
		else
			return false
		end
	else
		return false
	end
end

function dnt_api.insert_player(name, player)
	if dnametag[name] and player and player:get_player_name() then
		dnametag[name].players[player:get_player_name()] = true
		return true
	end
	return false
end

function dnt_api.update_hard_players(name, players)
	if dnametag[name] then
		dnametag[name].players = players
	end
end

function dnt_api.remove_player(name, thing)
	if dnametag[name] then
		for i, player in pairs(dnametag[name].players) do
			if Name(player) == Name(thing) then
				dnametag[name].players[i] = nil
			end
		end
		for i, pname in pairs(dnametag[name].huds) do
			if pname == Name(thing) then
				dnametag[name].huds[i] = nil
			end
		end
	end
end

function dnt_api.remove_dynamic_nametag(name)
	if dnametag[name] then
		local huds = dnametag[name].huds
		dnametag[name] = nil
		for i, id in pairs(huds) do
			for i, player in pairs(core.get_connected_players()) do
				player:hud_remove(id)
			end
		end
	else
		return false
	end
end





