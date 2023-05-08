local _, ns = ...

if ns:IsSameLocale("zhCN") then
	local L = ns.L or ns:NewLocale()

L["COPY_RAIDERIO_PROFILE_URL"] = "复制 Armory 人物简介链接"
L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r已经转到新服务器。情急下这条信息|cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r並且发送给开发者，非常感谢！"

	ns.L = L
end
