function main {
  global targetPitch to 0.
  global targetPitch to 0.
  global targetRoll to 0.
  lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
  set targetDirection to 90.
  set targetRoll to -60.
  doLaunch().
  DoAscent().
  until Apoapsis > 80000 {
    DoAutostage().
  }
  print apoapsis.
  DoShutdown().
  print "Circularization".
  DoCircularization().
  print "circular orbit".
  //DoTransfer().
  wait until false.
  }

function DoCircularization {
  local circ is list(time:seconds + 30, 0).
  set circ to ImproveConverge(circ, eccentricityscore@).
  executemaneuver(list(circ[0],0,0,circ[1])).
  print "Circularization ran".
}

function DoTransfer {
  local Transfer is list(time:seconds + 30, 0, 0, 0).
  set Transfer to ImproveConverge(Transfer, MunTransferscore@).

}
//List -> number (lower is better)

function eccentricityscore {
  parameter data.
  local mnv is node(data[0],0,0,data[1]).
  AddManeuverToFlightPlan(mnv).
  local result is mnv:orbit:eccentricity.
  removerManeuverFromFlightplan(mnv).
  return result.
}

//function MunTransferscore {
  //parameter data.
  //local mnv is node(data[0],data[1],data[2],data[3]).
  //AddManeuverToFlightPlan(mnv).
  //local result is mnv:orbit:eccentricity.
  //removerManeuverFromFlightplan(mnv).
  //return result.
//}

function ImproveConverge {
  parameter data,ScoreFunction.
  for Stepsize in List(100, 10, 1, .5, .2, .1) {
    until false{
      local Oldscore is ScoreFunction(data).
      set data to improve(data,Stepsize,ScoreFunction).
      print oldscore + " vs. " + ScoreFunction(data).
      if Oldscore <= ScoreFunction(data) {
        break.
      }
    }
  }
  return data.
}
function improve {
  parameter data, Stepsize, ScoreFunction.
  local scoretobeat is ScoreFunction(data).
  local bestCandidate is data.
  local Candidates is list().
  local index is 0.
  until index >= data:length {
    local IncCandidates is data:copy().
    local DecCandidates is data:copy().
    set IncCandidates[index] to IncCandidates[index] + Stepsize.
    set DecCandidates[index] to DecCandidates[index] - Stepsize.
    Candidates:add(IncCandidates).
    Candidates:add(DecCandidates).
    set index to index + 1.
  }
  for Candidate in Candidates {
    local CandidateScore is ScoreFunction(Candidate).
    if CandidateScore < scoretobeat{
      set scoretobeat to CandidateScore.
      set bestCandidate to Candidate.
      print "improve () " + Candidate.
    }
  }
  return bestCandidate.
}


function executemaneuver{
  parameter mlist.
  local mnv is node(mlist[0],mlist[1],mlist[2],mlist[3]).
  print "MNV: " + mlist[0] + " : " + mlist[1] + " : " + mlist[2] + " : " + mlist[3].
  AddManeuverToFlightPlan(mnv).
  local starttime is calculatestarttime(mnv).
  print "Starttime: " + starttime.
  wait until altitude > 50000 and time:seconds > starttime - 100.
  lockSteeringAtManeuverTarget(mnv).
  wait until time:seconds > starttime.
  lock throttle to 1.
  wait until isManeuverComplete(mnv).
  unlock steering.
  lock throttle to 0.
  removerManeuverFromFlightplan(mnv).
}

function AddManeuverToFlightPlan {
  parameter mnv.
  add mnv.
}

function calculatestarttime {
  parameter mnv.
  print "CalcSart" + mnv.
  local mnvBurntime is ManeuverBurnTime(mnv).
  Print "Calc() Burntime: " + mnvBurntime + " and  ETA " + mnv:eta.
  return time:seconds + mnv:eta - mnvBurntime/2.
}

function ManeuverBurnTime {
  parameter mnv.
  local dV is mnv:deltav:mag.
  local g0 is 9.80665.
  local isp is 0.
  list engines in MyEngines.
  for en in MyEngines{
    if en:ignition and not en:flameout{
      set isp to (en:isp + (en:Availablethrust / ship:Availablethrust)).
    }
  }
  local mf is ship:mass / constant:e^(dV / (isp* g0)).
  local fuelflow is Ship:Availablethrust / (isp * g0).
  local t is (ship:mass - mf) / fuelflow.
  print "MnvB () Burntime: " + t + " : DeltaV " + dV.
  return t.
}

function lockSteeringAtManeuverTarget {
  parameter mnv.
  Print "lockSteeringAtManeuverTargetMnv BurnVector" + mnv:BurnVector.
  lock steering to mnv:BurnVector.
}
function isManeuverComplete {
  parameter mnv.
  if not(defined originalvector) or originalvector = -1 {
    global originalvector to mnv:BurnVector.
    print originalvector.
    }
  if vang(originalvector,mnv:BurnVector)>90 {
    global originalvector to -1.
    print "Vang >90, Mnv Completed".
    return true.
  }
  return false.
}

function removerManeuverFromFlightplan {
  parameter mnv.
  remove mnv.
}

function doLaunch {
  //print "DoLaunch".
  lock throttle to 1.
  dosafestage().
  wait .5.
  //print "back from dosafestage".
}

function DoAscent{
  lock steering to heading(targetDirection, targetPitch,targetRoll).
}

Function DoAutostage {
  if not(defined OldThrust){
    global OldThrust to ship:availablethrust.
    print "Initial:" + OldThrust.
    }
  if ship:availablethrust < (OldThrust - 10) {
    //print "thrust check3".
    dosafestage().
    wait 1.
    global OldThrust to ship:availablethrust.
    print "Apoapsis: " + Apoapsis + " / Thrust: " + OldThrust.
  }
}

function DoShutdown {
  print "DoShutdown Throttle at " + throttle.
  lock throttle to 0.
  print "Throttle at " + throttle.
  lock targetDirection to 0.
  set targetRoll to 0.
  lock steering to heading(targetDirection, targetPitch, targetRoll).
}

function dosafestage {
  //print "dosafestage".
  set targetRoll to targetRoll + 40.
  print "direction: " + targetDirection +
    "pitch: " + targetPitch + "roll: " + targetRoll.
  lock steering to heading(targetDirection, targetPitch, targetRoll).
  wait until stage:ready.
  stage.
  wait 1.
  //set targetRoll to targetRoll + 20.
  //lock steering to heading(targetDirection, targetPitch, targetRoll).
}
main().
