do
  -- ClassicAPI dependency gate.
  --
  -- Which TOC the client opened already answers "is ClassicAPI here?". Whenever
  -- the DLL is loaded it redirects the read of `pfQuest\pfQuest.toc` to
  -- `pfQuest_ClassicAPI.toc`. Reaching this file from the plain `pfQuest.toc`
  -- therefore means ClassicAPI is absent -- and that TOC deliberately loads
  -- nothing but this file, so there is nothing to disable, only a notice to
  -- show.
  --
  -- The floor below is the redirect version itself (v1.11.0), so the "too old"
  -- gate is currently a no-op: reaching this file through pfQuest_ClassicAPI.toc
  -- already proves ClassicAPI is at least that new. pfQuest's core does reach
  -- for C_Item and EventUtil, which arrived later -- raise the floor to that
  -- version when you want the popup to name the cause instead of letting the
  -- missing-API errors surface on their own.
  local PFQUEST_CLASSIC_API_MIN     = 11100  -- (X*10000 + Y*100 + Z)
  local PFQUEST_CLASSIC_API_LATEST  = PFQUEST_CLASSIC_API_MIN
  local PFQUEST_CLASSIC_API_WEBSITE = "https://github.com/brues-code/ClassicAPI"
  local PFQUEST_CLASSIC_API_LATEST_URL = PFQUEST_CLASSIC_API_WEBSITE .. "/releases/latest"
  local function FormatVersion(packed)
    local x = math.floor(packed / 10000)
    local y = math.floor(math.mod(packed, 10000) / 100)
    local z = math.mod(packed, 100)
    return string.format("v%d.%d.%d", x, y, z)
  end

  local headline, detail
  if not CLASSIC_API_VERSION then
    headline = "|cff33ffccpf|cffffffffQuest|r has been disabled."
    detail = "The ClassicAPI DLL isn't loaded. Download the latest release from:"
  elseif CLASSIC_API_VERSION < PFQUEST_CLASSIC_API_MIN then
    headline = "|cff33ffccpf|cffffffffQuest|r cannot run on this ClassicAPI."
    detail = "ClassicAPI " .. FormatVersion(PFQUEST_CLASSIC_API_MIN) .. " or newer is required -- any errors alongside this one are the APIs it is missing. Download the latest release from:"
  end

  if detail then
    local function ShowRequiredPopup()
      StaticPopupDialogs["PFQUEST_CLASSICAPI_REQUIRED"] = {
        text = headline .. "\n\n" .. detail,
        button1 = OKAY,
        hasEditBox = 1,
        editBoxWidth = 280,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1,
        preferredIndex = 3,
        OnShow = function()
          local editBox = getglobal(this:GetName().."EditBox")
          if editBox then
            editBox:SetText(PFQUEST_CLASSIC_API_LATEST_URL)
            editBox:HighlightText()
            editBox:SetFocus()
          end
        end,
      }
      StaticPopup_Show("PFQUEST_CLASSICAPI_REQUIRED")
      DEFAULT_CHAT_FRAME:AddMessage(
        headline .. " " .. detail .. " " .. PFQUEST_CLASSIC_API_LATEST_URL,
        1, 0.3, 0.3
      )
    end
    local loginFrame = CreateFrame("Frame")
    loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    loginFrame:SetScript("OnEvent", function()
      loginFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
      ShowRequiredPopup()
    end)
  elseif CLASSIC_API_VERSION < PFQUEST_CLASSIC_API_LATEST then
    EventUtil.ContinueOnPlayerLogin(function()
      C_Timer.After(8, function()
        DEFAULT_CHAT_FRAME:AddMessage(
          "|cff33ffccpf|rQuest: ClassicAPI " .. FormatVersion(PFQUEST_CLASSIC_API_LATEST) .. " is available — " .. PFQUEST_CLASSIC_API_LATEST_URL,
          1, 0.85, 0.3
        )
      end)
    end)
  end
end
