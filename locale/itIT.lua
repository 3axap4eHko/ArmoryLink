local _, ns = ...

if ns:IsSameLocale("itIT") then
	local L = ns.L or ns:NewLocale()

	L["COPY_RAIDERIO_PROFILE_URL"] = "Copia URL Armory"
	L["UNKNOWN_SERVER_FOUND"] = "| cffFFFFFF% s | r ha rilevato un nuovo server. Si prega di scrivere queste informazioni | cffFF9999 {| r | cffFFFFFF% s | r | cffFF9999, | r | cffFFFFFF% s | r | cffFF9999} | r e segnalarlo agli sviluppatori. Grazie!"

	ns.L = L
end
