local _, ns = ...

if ns:IsSameLocale("esES") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "Copiar URL de Armory"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r ha encontrado un nuevo servidor. Por favor, apunta esta información |cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r y envíasela a los desarrolladores. ¡Gracias!"

	ns.L = L
end
