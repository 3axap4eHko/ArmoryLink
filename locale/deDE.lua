local _, ns = ...

if ns:IsSameLocale("deDE") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "Kopiere Armory Link"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r hat einen neuen Server gefunden. Bitte schreibe folgende information auf: |cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r . Danach schicke diese den Entwicklern. Danke!"

	ns.L = L
end
