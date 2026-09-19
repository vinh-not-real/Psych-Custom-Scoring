--[[ Script by Vinh_Not_Real
  idea from osu!stable and **NOT LIKE OSU!MANIA**
]]--
--[[
i freaky hate Hscript
]]--

-- var
local SickAll = true
local score = 0
local Hited = 1
local ItSustain = false
local CURRENT_VERSION = "1.0.0"
local VERSION_URL = "https://raw.githubusercontent.com/vinh-not-real/Psych-Custom-Scoring/refs/heads/main/version-osuv1.txt"
-- function

function onCreate()
    checkVersion()
end

function checkVersion()
    addHaxeLibrary('Http', 'sys')
    runHaxeCode([[
        var http = new Http("]] .. VERSION_URL .. [[");
        http.onData = function(data:String) {
            var onlineVersion = StringTools.trim(data.split("\n")[0]);
            var current = "]] .. CURRENT_VERSION .. [[";
            if (onlineVersion != current) {
                setVar("hasNewVersion", true);
                setVar("onlineVersion", onlineVersion);
            } else {
                setVar("hasNewVersion", false);
            }
        };
        http.onError = function(error) {
            setVar("hasNewVersion", false);
        };
        http.request();
    ]])
end

function onUpdate(elapsed)
    if getVar("hasNewVersion") == true then
        local onlineVer = getVar("onlineVersion") or "?"
        debugPrint("Script outdated! Current: " .. CURRENT_VERSION .. " | Latest: " .. onlineVer)
        debugPrint("Download: ")
        setVar("hasNewVersion", false)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
  if isSustainNote then
    ItSustain = true
    score = score + (50 * (1 + combo/25))
    setScore(score)
    ItSustain = false
    return
  end

  local Time = getPropertyFromGroup('notes', id, 'strumTime')
  local CurrentTime = getSongPosition()
  local HitTime = math.abs(CurrentTime - Time)
  if HitTime < 45 then
    score = score + (350 * (1 + combo/25))
    Hited = Hited + 1
  elseif HitTime < 90 then
    score = score + (300 * (1 + combo/25))
    Hited = Hited + 1
    SickAll = false
  elseif HitTime < 135 then
    score = score + (100 * (1 + combo/25))
    Hited = Hited + 0.75
    SickAll = false
  elseif HitTime < 166 then
    score = score + (50 * (1 + combo/25))
    Hited = Hited + 0.5
    SickAll = false
  end
end


function onRecalculateRating()
  setScore(score)
  local RatingPercent = (Hited / totalPlayed)
  local RatingPercent1 = ((Hited - 1) / totalPlayed)
    setRatingPercent(RatingPercent)
    if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent == 1 then
  if not ItSustain then
      if SickAll then
        setRatingName('SS+')
      else
        setRatingName('SS')
      end
    elseif RatingPercent >= 0.95 then
      setRatingName('S')
    elseif RatingPercent >= 0.9 then
      setRatingName('A')
    elseif RatingPercent >= 0.8 then
      setRatingName('B')
    elseif RatingPercent >= 0.75 then
      setRatingName('C')
    else
      setRatingName('D')
    end
  else
    setRatingPercent(RatingPercent1)
    if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent1 == 1 then
      if SickAll then
        setRatingName('SS+')
      else
        setRatingName('SS')
      end
      setRatingName('SS')
    elseif RatingPercent1 >= 0.95 then
      setRatingName('S')
    elseif RatingPercent1 >= 0.9 then
      setRatingName('A')
    elseif RatingPercent1 >= 0.8 then
      setRatingName('B')
    elseif RatingPercent1 >= 0.75 then
      setRatingName('C')
    else
      setRatingName('D')
    end
  end
  return Function_Stop
end
end

function onUpdate(elapsed)
    if getVar("hasNewVersion") == true then
        local onlineVer = getVar("onlineVersion") or "?"
        debugPrint("Script outdated! Current: " .. CURRENT_VERSION .. " | Latest: " .. onlineVer)
        debugPrint("Download: ")
        setVar("hasNewVersion", false)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
  if isSustainNote then
    ItSustain = true
    score = score + (50 * (1 + combo/25))
    setScore(score)
    ItSustain = false
    return
  end

  local Time = getPropertyFromGroup('notes', id, 'strumTime')
  local CurrentTime = getSongPosition()
  local HitTime = math.abs(CurrentTime - Time)
  if HitTime < 45 then
    score = score + (350 * (1 + combo/25))
    Hited = Hited + 1
  elseif HitTime < 90 then
    score = score + (300 * (1 + combo/25))
    Hited = Hited + 1
    SickAll = false
  elseif HitTime < 135 then
    score = score + (100 * (1 + combo/25))
    Hited = Hited + 0.75
    SickAll = false
  elseif HitTime < 166 then
    score = score + (50 * (1 + combo/25))
    Hited = Hited + 0.5
    SickAll = false
  end
end


function onRecalculateRating()
  setScore(score)
  local RatingPercent = (Hited / totalPlayed)
  local RatingPercent1 = ((Hited - 1) / totalPlayed)
    setRatingPercent(RatingPercent)
    if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent == 1 then
  if not ItSustain then
      if SickAll then
        setRatingName('SS+')
      else
        setRatingName('SS')
      end
    elseif RatingPercent >= 0.95 then
      setRatingName('S')
    elseif RatingPercent >= 0.9 then
      setRatingName('A')
    elseif RatingPercent >= 0.8 then
      setRatingName('B')
    elseif RatingPercent >= 0.75 then
      setRatingName('C')
    else
      setRatingName('D')
    end
  else
    setRatingPercent(RatingPercent1)
    if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent1 == 1 then
      if SickAll then
        setRatingName('SS+')
      else
        setRatingName('SS')
      end
      setRatingName('SS')
    elseif RatingPercent1 >= 0.95 then
      setRatingName('S')
    elseif RatingPercent1 >= 0.9 then
      setRatingName('A')
    elseif RatingPercent1 >= 0.8 then
      setRatingName('B')
    elseif RatingPercent1 >= 0.75 then
      setRatingName('C')
    else
      setRatingName('D')
    end
  end
  return Function_Stop
end
