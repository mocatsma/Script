// Maneuver Library v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

SET burnoutCheck TO "reset".
//local OrbiterLog is "0:/partlist.txt".
FUNCTION MNV_BURNOUT {
  PARAMETER autoStage.

  IF burnoutCheck = "reset" {
    print "Fx MNV_BURNOUT, burnoutcheck at reset".
    SET burnoutCheck TO MAXTHRUST.
    RETURN FALSE.
  }
  print "Fx MNV_BURNOUT Checking Prior MAXTHRUST against MAXTHRUST".
  IF burnoutCheck - MAXTHRUST > 10 {
    IF autoStage {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT 1. STAGE. WAIT 1.
      LOCK THROTTLE TO currentThrottle.
    }
    SET burnoutCheck TO "reset".
    RETURN TRUE.
  }

  RETURN FALSE.
}

// Time to complete a maneuver
function mnv_time {
  parameter dv.
  set ens to list().
  ens:clear.
  set ens_thrust to 0.
  set ens_isp to 0.
  list engines in myengines.

  for en in myengines {
    if en:ignition = true and en:flameout = false {
      ens:add(en).
    }
  }
set Cnt_Eng to 0.
  for en in ens {
    //print "MNV_TIME Engine List: " + myengines[Cnt_Eng].
    Set Cnt_Eng to Cnt_Eng + 1.
    set ens_thrust to ens_thrust + en:availablethrust.
    set ens_isp to ens_isp + en:isp.
    //print "MNV_TIME Isp: " + ens_isp.
  }

  if ens_thrust = 0 or ens_isp = 0 {
    notify("No engines available!").
    return 0.
  }
  else {
    local f is ens_thrust * 1000.  // engine thrust (kg * m/s²)
    local m is ship:mass * 1000.        // starting mass (kg)
    local e is constant():e.            // base of natural log
    local p is ens_isp/ens:length.               // engine isp (s) support to average different isp values
    local g is ship:orbit:body:mu/ship:obt:body:radius^2.    // gravitational acceleration constant (m/s²)
    //log( "MNV_TIME Thrust / ISP " + ens_thrust + " / " + ens_isp)
    //to OrbiterLog.
    return g * m * p * (1 - e^(-dv/(g*p))) / f.
  }
}

// Delta v requirements for Hohmann Transfer
FUNCTION MNV_HOHMANN_DV {
  PARAMETER desiredAltitude.

  SET u  TO SHIP:OBT:BODY:MU.
  SET r1 TO SHIP:OBT:SEMIMAJORAXIS.
  SET r2 TO desiredAltitude + SHIP:OBT:BODY:RADIUS.

  // v1
  SET v1 TO SQRT(u / r1) * (SQRT((2 * r2) / (r1 + r2)) - 1).

  // v2
  SET v2 TO SQRT(u / r2) * (1 - SQRT((2 * r1) / (r1 + r2))).

  RETURN LIST(v1, v2).
}

// Execute the next node
FUNCTION MNV_EXEC_NODE {
  PARAMETER autoWarp.

  LOCAL n IS NEXTNODE.
  LOCAL v IS n:BURNVECTOR.
  Print "Burnvector : " + v.
  Log ("MNV_Exec_Node -- BurnVector : " + v) to OrbiterLog.
  LOCAL startTime IS TIME:SECONDS + n:ETA - MNV_TIME(v:MAG)/2.
  log ( "Time :" + TIME:SECONDS ) to OrbiterLog.
  log ("MNV_Exec_Node -- startTime :" + startTime
    + " ETA: " + n:ETA + " MNV_TIME " + MNV_TIME(v:MAG)/2 ) to OrbiterLog.
  LOCK STEERING TO n:BURNVECTOR.

  IF autoWarp { WARPTO(startTime - 60). }

  WAIT UNTIL TIME:SECONDS >= startTime.
  LOCK THROTTLE TO MIN(MNV_TIME(n:BURNVECTOR:MAG), 1).
  log(Throttle) to OrbiterLog.
  WAIT UNTIL VDOT(n:BURNVECTOR, v) < 0.
  LOCK THROTTLE TO 0.
  LOCK STEERING to prograde.
  wait .1.
}
// added functions from L2O-1old.
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
//Used in Kerbin.Launch.ks
FUNCTION BOCheck {
  parameter BOThrust.
  //log ("BOThrust") to OrbiterLog.
  IF BOThrust - MAXTHRUST > 10 {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT 1. STAGE. WAIT 1.
      LOCK THROTTLE TO currentThrottle.
      log ("BOCheck Staged") to OrbiterLog.
    }
    //log ("Not Staged") to OrbiterLog.
}

function CheckToStage {
  //log ("CheckToStage") to OrbiterLog.
  list engines in myengines.
  for en in myengines {
    if en:flameout = True {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT .1. STAGE. WAIT .5.
      LOCK THROTTLE TO currentThrottle.
      log ("CheckToStage Staged") to OrbiterLog.
      Return.
    }
    //Log ("Not Staged") to OrbiterLog.
  }
}
