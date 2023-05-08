local _, ns = ...

if ns:IsSameLocale("koKR") then
	local L = ns.L or ns:NewLocale()

	L["COPY_RAIDERIO_PROFILE_URL"] = "Armory URL 복사"
	L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r: 새 서버가 발견되었습니다. |cffFF9999 {|r |cffFFFFFF%s|r  |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r의 정보를 적은 후 개발자에게 보고해주세요. 감사합니다!"

	ns.L = L
end
