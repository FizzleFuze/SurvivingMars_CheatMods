-- See LICENSE for terms

local mod_Amount

-- fired when settings are changed/init
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Amount = CurrentModOptions:GetProperty("Amount") * const.ResourceScale
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_RCTransport_TransportRouteLoad = RCTransport.TransportRouteLoad
function RCTransport:TransportRouteLoad(...)
  if not self.transport_route then
    return
  end

	-- [LUA ERROR] Mars/Lua/Units/RCTransport.lua:1018: attempt to index a boolean value (field 'unreachable_objects')
	if not self.unreachable_objects then
		self.unreachable_objects = {}
	end

	-- save supply obj
	local supply = self.transport_route.from
	-- fire off orig
	ChoOrig_RCTransport_TransportRouteLoad(self, ...)

	-- If this is false then TransportRouteLoad removed it
	if self.transport_route.from then
		return
	end

	-- add the missing half of the route back so it doesn't remove the route
	self.transport_route.from = supply

	-- If amount > storage then that's bad
	if mod_Amount > self.max_shared_storage then
		mod_Amount = self.max_shared_storage
	end

	-- If not enough res then set to idle anim
	if self:GetStoredAmount() < mod_Amount then
		-- wonder how long this networking func will stick around? (considering there's no MP, unless it's a ged thing)
		self:Gossip("Idle")
		-- set anim to idle state
		self:SetState("idle")
	end

	-- loop till we have enough
	while true do
		-- wait for it...
		Sleep(5000)

		-- If amount > storage then that's bad
		if mod_Amount > self.max_shared_storage then
			mod_Amount = self.max_shared_storage
		end

		-- gotta clear these so they don't cause issues
		table.clear(self.route_visited_dests)
		table.clear(self.route_visited_sources)

		local next_source = self:FindNextRouteSource()
		-- check for nearby deposits
		if next_source then
			self.route_visited_sources[next_source] = true
			self:ProcessRouteObj(next_source)
			break
		elseif self:GetStoredAmount() >= mod_Amount then
			-- if we have enough than go to unload func (load n unload are in a loop in transport object)
			break
		end
	end	 -- while
end

local ChoOrig_RCTransport_TransportRouteUnload = RCTransport.TransportRouteUnload
function RCTransport:TransportRouteUnload(...)
  if not self.transport_route then
    return
  end

	-- If amount > storage then that's bad
	if mod_Amount > self.max_shared_storage then
		mod_Amount = self.max_shared_storage
	end

	-- If not enough res then set to idle anim and return to load func
	if self:GetStoredAmount() < mod_Amount then
		-- fix for inf loop
		Sleep(1000)
		return
	end

	return ChoOrig_RCTransport_TransportRouteUnload(self, ...)
end
