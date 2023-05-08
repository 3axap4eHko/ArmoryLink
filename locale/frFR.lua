local _, ns = ...

if ns:IsSameLocale("frFR") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "Copier le profil Armory"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r a rencontré une erreur. S'il vous plait, écrivez ces informations |cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r et reporter le aux développers. Merci !"

	ns.L = L
end
