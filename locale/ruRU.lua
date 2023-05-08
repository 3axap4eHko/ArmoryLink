local _, ns = ...

if ns:IsSameLocale("ruRU") then
  local L = ns.L or ns:NewLocale()
  
  L["UNKNOWN_SERVER_FOUND"] = "|cffFFFFFF%s|r обнаружил неизвестный ранее сервер. Пожалуйста, запишите эту информацию |cffFF9999{|r |cffFFFFFF%s|r |cffFF9999,|r |cffFFFFFF%s|r |cffFF9999}|r и сообщите об этом разработчикам. Спасибо!"
  L["COPY_ARMORY_PROFILE_URL"] = "Копировать ссылку Armory"

  ns.L = L
end