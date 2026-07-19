local NUM_PET_ACTION_SLOTS = NUM_PET_ACTION_SLOTS or 10

local STANCE_TEXTURE_TOKENS = {
	["PET_AGGRESSIVE_TEXTURE"] = true,
	["PET_DEFENSIVE_TEXTURE"]  = true,
	["PET_PASSIVE_TEXTURE"]    = true,
}

local function IsStanceButtonSlot(index)
	local results = { GetPetActionInfo(index) }
	for i = 1, #results do
		local v = results[i]
		if type(v) == "string" and STANCE_TEXTURE_TOKENS[v] then
			return true
		end
	end
	return false
end

local function HideStanceButtons()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local button = _G["PetActionButton" .. i]
		if button and IsStanceButtonSlot(i) then
			button:Hide()
		end
	end
end

if PetActionBar_Update then
	hooksecurefunc("PetActionBar_Update", HideStanceButtons)
end
if PetActionBar_ShowGrid then
	hooksecurefunc("PetActionBar_ShowGrid", HideStanceButtons)
end
if PetActionBar_HideGrid then
	hooksecurefunc("PetActionBar_HideGrid", HideStanceButtons)
end

local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
watcher:RegisterEvent("UNIT_PET")
watcher:RegisterEvent("PET_BAR_UPDATE")
watcher:RegisterEvent("PET_BAR_UPDATE_USABLE")
watcher:SetScript("OnEvent", function()
	if C_Timer and C_Timer.After then
		C_Timer.After(0, HideStanceButtons)
	else
		HideStanceButtons()
	end
end)
