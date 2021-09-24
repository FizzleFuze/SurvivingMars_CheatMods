-- See LICENSE for terms

-- we need to return our new infopanel (if it isn"t another panel)
local ChoOrig_ElectricityGridElement_GetInfopanelTemplate = ElectricityGridElement.GetInfopanelTemplate
function ElectricityGridElement.GetInfopanelTemplate(...)
	local ret = ChoOrig_ElectricityGridElement_GetInfopanelTemplate(...)
	if not ret or ret == "ipLeak" then
		return "ipCable"
	end
	return ret
end
-- needed to show grid info template
function ElectricityGridElement.ShowUISectionElectricityGrid()
	return true
end

local ChoOrig_LifeSupportGridElement_GetInfopanelTemplate = LifeSupportGridElement.GetInfopanelTemplate
function LifeSupportGridElement:GetInfopanelTemplate(...)
	local ret = ChoOrig_LifeSupportGridElement_GetInfopanelTemplate(self, ...)
	if self.is_switch or self.auto_connect or self.pillar
		or self:IsKindOf("ConstructionSite")
	then
		return ret
	end
	-- needed to show grid info
	self.pillar = true

	return "ipPillaredPipe"
end

-- so we know something is selected
local function OnSelected(self)
	-- not construction site and not a switch (they already have a parsystem added)
	if not self.building_class_proto and not self.is_switch then
		AddSelectionParticlesToObj(self)
	end
end
ElectricityGridElement.OnSelected = OnSelected
LifeSupportGridElement.OnSelected = OnSelected

function OnMsg.ClassesPostprocess()
	-- clear old if existing
	if XTemplates.ipCable then
		XTemplates.ipCable:delete()
	end

	XTemplates.ipCable = PlaceObj("XTemplate", {
		group = "Infopanel Sections",
		id = "ipCable",
		PlaceObj("XTemplateTemplate", {
			"__context_of_kind", "ElectricityGridElement",
			"__condition", function (_, context)
				return context.is_hub or not context.is_switch
			end,
			"__template", "Infopanel",
			"Description", T(313911890683, "<description>"),
		}, {
			PlaceObj("XTemplateTemplate", {
				"comment", "salvage",
				"__template", "InfopanelButton",
				"RolloverText", T(640016954592, "Remove this switch or valve."),
				"RolloverTitle", T(3973, "Salvage"),
				"RolloverHintGamepad", T(7657, "<ButtonY> Activate"),
				"ContextUpdateOnOpen", false,
				"OnPressParam", "Demolish",
				"Icon", "UI/Icons/IPButtons/salvage_1.tga",
			}, {
				PlaceObj("XTemplateFunc", {
					"name", "OnXButtonDown(self, button)",
					"func", function (self, button)
						if button == "ButtonY" then
							return self:OnButtonDown(false)
						elseif button == "ButtonX" then
							return self:OnButtonDown(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
				PlaceObj("XTemplateFunc", {
					"name", "OnXButtonUp(self, button)",
					"func", function (self, button)
						if button == "ButtonY" then
							return self:OnButtonUp(false)
						elseif button == "ButtonX" then
							return self:OnButtonUp(true)
						end
						return (button == "ButtonA") and "break"
					end,
				}),
			}),
			PlaceObj('XTemplateTemplate', {
				'__template', "sectionPowerGrid",
			}),
		}),
	})

end
