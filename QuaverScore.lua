--[[ Script by Vinh_Not_Real and some help from psych ward discord server
   ____                              _____
  / __ \__  ______ __   _____  _____/ ___/_________  ________
 / / / / / / / __ `/ | / / _ \/ ___/\__ \/ ___/ __ \/ ___/ _ \
/ /_/ / /_/ / /_/ /| |/ /  __/ /   ___/ / /__/ /_/ / /  /  __/
\___\_\__,_/\__,_/ |___/\___/_/   /____/\___/\____/_/   \___/.lua
Make this took so long
]]--

---- var ----
local atTheEnd = {}
local Mavious = 0
local Perfect = 0
local Great = 0
local Good = 0
local Okay = 0
local Miss = 0
local Total = 0
local CURRENT_VERSION = "0.0.2 BETA"
local VERSION_URL = "https://raw.githubusercontent.com/vinh-not-real/Psych-Custom-Scoring/refs/heads/main/version-Quaver.txt"
---- function ----

function onCreate()
    setProperty("showCombo", false)
	setProperty("showComboNum", false)
	setProperty("showRating", false)
    checkVersion()
    makeLuaText('SickCaculator', 'Sick: 00', 0, 0, screenHeight/0.5)
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
        debugPrint("Pls download the new version from Discord Psych:Ward/#lua-downloads or from official github repo")
        setVar("hasNewVersion", false)
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    local Time = getPropertyFromGroup('notes', id, 'strumTime')
    local CurrentTime = getSongPosition()
    local HitTime = math.abs(CurrentTime - Time)
    if isSustainNote then
        if stringEndsWith(getProperty('notes.members['..id..'].animation.name'), 'holdend') then
            atTheEnd[noteData] = Time
        end
        return
    end
    if HitTime <= 18 then
      Mavious = Mavious + 1
      Total = Total + 1
    elseif HitTime <= 43 then
      Perfect = Perfect + 1
      Total = Total + 1
    elseif HitTime <= 76 then
      Great = Great + 1
      Total = Total + 1
    elseif HitTime <= 106 then
      Good = Good + 1
      Total = Total + 1
    elseif HitTime <= 127 then
      Okay = Okay + 1
      Total = Total + 1
    elseif HitTime <= 164 then
      Miss = Miss + 1
      Total = Total + 1
      addMisses(1)
    end
end

function noteMiss()
    Miss = Miss + 1
    Total = Total + 1
end

function onRecalculateRating()
  setScore(1000000 * ((100 * Mavious + 98.25 * Perfect + 65 * Great + 25 * Good + (-100) * Okay + (-50) * Miss)/(100 * Total)))
  return Function_Stop
end

function onUpdateScore()
    local RatingPercent = ((100 * Mavious + 98.25 * Perfect + 65 * Great + 25 * Good + (-100) * Okay + (-50) * Miss)/(100 * Total))
    setRatingPercent(RatingPercent)
    if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent > 0.98 then
      setRatingName('X')
    elseif RatingPercent >= 0.95 then
      setRatingName('S')
    elseif RatingPercent >= 0.9 then
      setRatingName('A')
    elseif RatingPercent >= 0.8 then
      setRatingName('B')
    elseif RatingPercent >= 0.7 then
      setRatingName('C')
    elseif RatingPercent >= 0.6 then
      setRatingName('D')
    else
      setRatingName('F')
    end
    updateScoreText()
end

function onKeyRelease(key)
    local CurrentTime = getSongPosition()
    if atTheEnd[key] ~= nil then
        local ReleaseAt = (CurrentTime - atTheEnd[key])
        atTheEnd[key] = nil
        if ReleaseAt <= 18 then
          Mavious = Mavious + 1
          Total = Total + 1
        elseif ReleaseAt <= 43 then
          Perfect = Perfect + 1
          Total = Total + 1
        elseif ReleaseAt <= 76 then
          Great = Great + 1
          Total = Total + 1
        elseif ReleaseAt <= 106 then
          Good = Good + 1
          Total = Total + 1
        elseif ReleaseAt <= 127 then
          Okay = Okay + 1
          Total = Total + 1
        else
          Miss = Miss + 1
          Total = Total + 1
          addMisses(1)
        end
    end
end
