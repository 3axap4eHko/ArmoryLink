local _, ns = ...

if ns:IsSameLocale("zhTW") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "複製Armory設定檔網址"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r已經轉到新伺服器。請記下此資訊|cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r並且回報給開發者，感謝您！"

	ns.L = L
end
