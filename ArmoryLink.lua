if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then return end

local addonName = ...
local ns = select(2, ...)
local L = ns.L
local CONST_REALM_SLUGS = ns.realmSlugs
local CONST_REGION_IDS = ns.regionIDs

local REGIONS = {
  "us",
  "kr",
  "eu",
  "tw",
  "cn"
};

local VALID_TYPES = {
  ARENAENEMY = true,
  BN_FRIEND = true,
  CHAT_ROSTER = true,
  COMMUNITIES_GUILD_MEMBER = true,
  COMMUNITIES_WOW_MEMBER = true,
  FOCUS = true,
  FRIEND = true,
  GUILD = true,
  GUILD_OFFLINE = true,
  PARTY = true,
  PLAYER = true,
  RAID = true,
  RAID_PLAYER = true,
  SELF = true,
  TARGET = true,
  WORLD_STATE_SCORE = true
};

local UNIT_TOKENS = {
  mouseover = true,
  player = true,
  target = true,
  focus = true,
  pet = true,
  vehicle = true,
}

do
  for i = 1, 40 do
      UNIT_TOKENS["raid" .. i] = true
      UNIT_TOKENS["raidpet" .. i] = true
      UNIT_TOKENS["nameplate" .. i] = true
  end

  for i = 1, 4 do
      UNIT_TOKENS["party" .. i] = true
      UNIT_TOKENS["partypet" .. i] = true
  end

  for i = 1, 5 do
      UNIT_TOKENS["arena" .. i] = true
      UNIT_TOKENS["arenapet" .. i] = true
  end

  for i = 1, MAX_BOSS_FRAMES do
      UNIT_TOKENS["boss" .. i] = true
  end

  for k, _ in pairs(UNIT_TOKENS) do
      UNIT_TOKENS[k .. "target"] = true
  end
end

local LOCALE = GetLocale();
local locale = string.lower(LOCALE);
local COUNTRY = string.sub(locale, 1, 2);
local LANGUAGE = string.sub(locale, 3, 4);
local DIALOG_ID = "ARMORYLINK_COPY_URL";

_G.StaticPopupDialogs[DIALOG_ID] = {
  id = DIALOG_ID,
  text = "%s",
  button2 = CLOSE,
  hasEditBox = true,
  hasWideEditBox = true,
  editBoxWidth = 350,
  preferredIndex = 3,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,

  OnShow = function(self)
    self:SetWidth(420)
    local editBox = _G[self:GetName() .. "WideEditBox"] or _G[self:GetName() .. "EditBox"]
    editBox:SetText(self.text.text_arg2)
    editBox:SetFocus()
    editBox:HighlightText()
    local button = _G[self:GetName() .. "Button2"]
    button:ClearAllPoints()
    button:SetWidth(200)
    button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
  end,
  EditBoxOnEscapePressed = function(self)
    self:GetParent():Hide()
  end,
  OnHide = nil,
  OnAccept = nil,
  OnCancel = nil
};

local addon = CreateFrame("Frame")

local function GetRegion()
  -- use the player GUID to find the serverID and check the map for the region we are playing on
  local guid = UnitGUID("player")
  local server
  if guid then
      server = tonumber(strmatch(guid, "^Player%-(%d+)") or 0) or 0
      local i = CONST_REGION_IDS[server]
      if i then
          return REGIONS[i], i
      end
  end
  -- alert the user to report this to the devs
  DEFAULT_CHAT_FRAME:AddMessage(format(L.UNKNOWN_SERVER_FOUND, addonName, guid or "N/A", GetNormalizedRealmName() or "N/A"), 1, 1, 0)
  -- fallback logic that might be wrong, but better than nothing...
  local i = GetCurrentRegion()
  return REGIONS[i], i
end

local function GetRealmSlug(realm)
  return CONST_REALM_SLUGS[realm] or realm
end

function addon:ADDON_LOADED(_, name)
  if name == addonName then
    addon:RegisterEvent("PLAYER_ENTERING_WORLD")
  end
end

function addon:PLAYER_LOGIN()
  PLAYER_REGION = GetRegion()
end

-- we enter the world (after a loading screen, int/out of instances)
function addon:PLAYER_ENTERING_WORLD()
end


local function CopyURLForNameAndRealm(name, realm)
  local realmSlug = GetRealmSlug(realm);
  local url = string.format("https://worldofwarcraft.blizzard.com/%s-%s/character/%s/%s/%s", COUNTRY, LANGUAGE, PLAYER_REGION, realmSlug, name);
  StaticPopup_Show(DIALOG_ID, string.format("%s (%s)", name, realm), url);
end

local function IsValidDropDown(bdropdown)
  return bdropdown == LFGListFrameDropDown or (type(bdropdown.which) == "string" and VALID_TYPES[bdropdown.which])
end

local function IsUnitToken(unit)
  return type(unit) == "string" and UNIT_TOKENS[unit]
end

local function IsUnit(arg1, arg2)
  if not arg2 and type(arg1) == "string" and arg1:find("-", nil, true) then
      arg2 = true
  end
  local isUnit = not arg2 or IsUnitToken(arg1)
  return isUnit, isUnit and UnitExists(arg1), isUnit and UnitIsPlayer(arg1)
end

local function GetNameRealm(arg1, arg2)
  local unit, name, realm
  local _, unitExists, unitIsPlayer = IsUnit(arg1, arg2)
  if unitExists then
      unit = arg1
      if unitIsPlayer then
          name, realm = UnitNameUnmodified(arg1)
          realm = realm and realm ~= "" and realm or GetNormalizedRealmName()
      end
      return name, realm, unit
  end
  if type(arg1) == "string" then
      if arg1:find("-", nil, true) then
          name, realm = ("-"):split(arg1)
      else
          name = arg1 -- assume this is the name
      end
      if not realm or realm == "" then
          if type(arg2) == "string" and arg2 ~= "" then
              realm = arg2
          else
              realm = GetNormalizedRealmName() -- assume they are on our realm
          end
      end
  end
  return name, realm, unit
end

local function GetNameRealmForBNetFriend(bnetIDAccount)
  local index = BNGetFriendIndex(bnetIDAccount)
  if not index then
      return
  end
  for i = 1, C_BattleNet.GetFriendNumGameAccounts(index), 1 do
      local accountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)
      if accountInfo and accountInfo.clientProgram == BNET_CLIENT_WOW and (not accountInfo.wowProjectID or accountInfo.wowProjectID == WOW_PROJECT_MAINLINE) then
          if accountInfo.realmName then
              accountInfo.characterName = accountInfo.characterName .. "-" .. accountInfo.realmName:gsub("%s+", "")
          end
          return accountInfo.characterName
      end
  end
end

local function GetNameRealmFromPlayerLink(playerLink)
  local linkString = LinkUtil.SplitLink(playerLink)
  local linkType, linkData = ExtractLinkData(linkString)
  if linkType == "player" then
      local name, realm = GetNameRealm(linkData)
      return name, realm
  elseif linkType == "BNplayer" then
      local _, bnetIDAccount = strsplit(":", linkData)
      if bnetIDAccount then
          bnetIDAccount = tonumber(bnetIDAccount)
      end
      if bnetIDAccount then
          local fullName = GetNameRealmForBNetFriend(bnetIDAccount)
          local name, realm = GetNameRealm(fullName)
          return name, realm
      end
  end
end

local function GetNameRealmForDropDown(bdropdown)
  local unit = bdropdown.unit
  local bnetIDAccount = bdropdown.bnetIDAccount
  local menuList = bdropdown.menuList
  local quickJoinMember = bdropdown.quickJoinMember
  local quickJoinButton = bdropdown.quickJoinButton
  local tempName, tempRealm = bdropdown.name, bdropdown.server
  local name, realm
  -- unit

  if not name and UnitExists(unit) then
      if UnitIsPlayer(unit) then
          name, realm = GetNameRealm(unit)
      end
      return name, realm
  end
  -- bnet friend
  if not name and bnetIDAccount then
      local fullName = GetNameRealmForBNetFriend(bnetIDAccount)
      if fullName then
          name, realm = GetNameRealm(fullName)
      end
      return name, realm
  end
  -- lfd
  if not name and menuList then
      for i = 1, #menuList do
          local whisperButton = menuList[i]
          if whisperButton and (whisperButton.text == _G.WHISPER_LEADER or whisperButton.text == _G.WHISPER) then
              name, realm = GetNameRealm(whisperButton.arg1)
              break
          end
      end
  end
  -- quick join
  if not name and (quickJoinMember or quickJoinButton) then
      local memberInfo = quickJoinMember or quickJoinButton.Members[1]
      if memberInfo.playerLink then
          name, realm = GetNameRealmFromPlayerLink(memberInfo.playerLink)
      end
  end
  -- dropdown by name and realm
  if not name and tempName then
      name, realm = GetNameRealm(tempName, tempRealm)
  end
  -- if we don't got both we return nothing
  if not name or not realm then
      return
  end
  return name, realm
end

local function OnToggle(bdropdown, event, options)
  if event == "OnShow" then
      if not IsValidDropDown(bdropdown) then
          return
      end
      selectedName, selectedRealm = GetNameRealmForDropDown(bdropdown)
      if not selectedName then
          return
      end
      if not options[1] then
          options[1] = {
            text = L.COPY_ARMORY_PROFILE_URL,
            func = function()
              CopyURLForNameAndRealm(selectedName, selectedRealm)
            end
        };
        return true
      end
  elseif event == "OnHide" then
      if options[1] then
          options[1] = nil
          return true
      end
  end
end

local LibDropDownExtension = LibStub and LibStub:GetLibrary("LibDropDownExtension-1.0", true)
LibDropDownExtension:RegisterEvent("OnShow OnHide", OnToggle, 1, addon)


addon:SetScript("OnEvent", function(_, event, ...) addon[event](addon, event, ...) end)
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_LOGIN")
