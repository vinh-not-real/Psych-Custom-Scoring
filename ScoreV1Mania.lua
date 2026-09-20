
--[[ Script by Vinh_Not_Real and some help from psych ward discord server
  idea from osu!mania v1
]]--

---- var ----
setVar('scoreMuti', 1)
local noteNum = 0
local sustainNum = 0
local Sick = 1
local Good = 0
local Bad = 0
local Shit = 0
local Total = 1
local score = 0
local ScoreMul = 1
local CURRENT_VERSION = "0.1.2"
local VERSION_URL = "https://raw.githubusercontent.com/vinh-not-real/Psych-Custom-Scoring/refs/heads/main/version-mania.txt"
---- function ----

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
        debugPrint("Pls download the new version from Discord Psych:Ward/#lua-downloads or from official github repo")
        setVar("hasNewVersion", false)
    end
end

function onCreatePost()
  for i = 0, getProperty("unspawnNotes.length") - 1 do
    if not getProperty("unspawnNotes[".. i .."].isSustainNote") then
      noteNum = noteNum + 1
    end
    if getProperty("unspawnNotes[".. i .."].isSustainNote") then
      sustainNum = sustainNum + 1
    end
  end
  ScoreMul = getVar('scoreMuti')
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
  if isSustainNote then
    score = score + ((500000/sustainNum) * ScoreMul)
    setScore(score)
    return
  end

  local Time = getPropertyFromGroup('notes', id, 'strumTime')
  local CurrentTime = getSongPosition()
  local HitTime = math.abs(CurrentTime - Time)
  if sustainNum ~= 0 then
    if HitTime < 45 then
      score = score + ((500000/noteNum) * ScoreMul)
      Sick = Sick + 1
      Total = Total + 1
    elseif HitTime < 90 then
      score = score + ((250000/noteNum) * ScoreMul)
      Good = Good + 1
      Total = Total + 1
    elseif HitTime < 135 then
      score = score + ((125000/noteNum) * ScoreMul)
      Bad = Bad + 1
      Total = Total + 1
    elseif HitTime < 166 then
      score = score + ((62500/noteNum) * ScoreMul)
      Shit = Shit + 1
      Total = Total + 1
    end
  else
    if HitTime < 45 then
      score = score + ((1000000/noteNum) * ScoreMul)
      Sick = Sick + 1
      Total = Total + 1
    elseif HitTime < 90 then
      score = score + ((500000/noteNum) * ScoreMul)
      Good = Good + 1
      Total = Total + 1
    elseif HitTime < 135 then
      score = score + ((250000/noteNum) * ScoreMul)
      Bad = Bad + 1
      Total = Total + 1
    elseif HitTime < 166 then
      score = score + ((125000/noteNum) * ScoreMul)
      Shit = Shit + 1
      Total = Total + 1
    end
  end
end

function onRecalculateRating()
  setScore(score)
  return Function_Stop
end

function preUpdateScore()
  local RatingPercent = ((300 * Sick + 200 * Good + 100 * Bad + 50 * Shit)/(300 * Total))
    setRatingPercent(RatingPercent)
  if totalPlayed == 0 then setRatingName('?') return end
    if RatingPercent == 1 then
      setRatingName('SS')
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
end
