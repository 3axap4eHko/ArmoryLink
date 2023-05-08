local _, ns = ...

if ns:IsSameLocale("ptBR") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "Copiar URL do Armory"
--[[ L["UNKNOWN_SERVER_FOUND"] = ""--]] 

	ns.L = L
end
