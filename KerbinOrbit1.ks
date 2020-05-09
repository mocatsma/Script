//Herald Mission Script
// Kevin Gisi
// http://youtube.com/gisikw

{
  local TARGET_ALTITUDE is 100000.
  local TARGET_Orbit_ALTITUDE is 2863000.
  local Initiate_Target is "K-Geo1".
  local correction_time is 0.
  local safety_time is 0.
  local OrbitNumerator is 1.
  global KerbinOrbit1 is lex(
    "sequence", list(
      "preflight", preflight@,
      "launch", launch@,
      "ascent", ascent@,
      "circularize", circularize@,
      "perform_transfer", perform_transfer@,
      "circularize", circularize@,
      "idle", idle@
    ),
    "events", lex()
  ).

  function preflight {
    parameter mission.
    set ship:control:pilotmainthrottle to 0.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 1.
    mission["next"]().
  }

  function launch {
    parameter mission.
    stage. wait 1.
    lock pct_alt to alt:radar / TARGET_ALTITUDE.
    set target_twr to 8.26.
    //lock target_pitch to -115.23935 * pct_alt^0.4095114 + 88.963.
    //center of gravity tips over ship before getting up to higher altitudes
    lock target_pitch to -115.23935 * pct_alt^0.55 + 88.963.
    lock throttle to max(min(target_twr / available_twr(), 1), 0). // Honestly, just lock throttle to 1
    lock steering to heading(90, target_pitch).
    mission["next"]().
  }

  function ascent {
    parameter mission.
    SET prevThrust TO MAXTHRUST.
    Until apoapsis > TARGET_ALTITUDE {
      IF MAXTHRUST < (prevThrust - 10) {
        LOCK THROTTLE TO 0.
        WAIT .1. STAGE. WAIT .1.
        lock throttle to max(min(target_twr / available_twr(), 1), 0). // Honestly, just lock throttle to 1
        SET prevThrust TO MAXTHRUST.
      }
      Wait 5.

    if ALTITUDE > 40000 {
      lock steering to heading(90,0).
      Print "Alt > 40000 Target_Angle: " + TARGET_ANGLE(Initiate_Target).
      log ("Alt > 40000 Target_Angle: " + Initiate_Target + " --> "
      + TARGET_ANGLE(Initiate_Target)) to logfile.
    }
  }
  if apoapsis > TARGET_ALTITUDE {
    lock throttle to 0.
    lock steering to heading(90,0).
    wait until alt:radar > body:atm:height.
    mission["next"]().
  }
  }

  function circularize {
    parameter mission.
    log ("KerbinOrbit1 Fx Circularize Mission at Alt: " + ALTITUDE) to logfile.
    Print "Fx Circularize Target_Angle: " + TARGET_ANGLE(Initiate_Target).
    log ("Fx Circularize Target_Angle: " + TARGET_ANGLE(Initiate_Target)) to logfile.
    // Find good circularization dV
    local dV is list(0).
    set dV to hillclimb["seek"](dV, circular_fitness@, 100).
    set dV to hillclimb["seek"](dV, circular_fitness@, 10).
    set dV to hillclimb["seek"](dV, circular_fitness@, 1).
    // Execute maneuver
    add node(time:seconds + eta:apoapsis, 0, 0, dV[0]). wait 0.1.
    If apoapsis < TARGET_ALTITUDE + 10000 {
    maneuver["exec"]().
  } Else {maneuver["exec"](TRUE).}
    panels on. lock throttle to 0.
    //wait 1. stage. wait 1.
    mission["next"]().
  }

  function perform_transfer {
    parameter mission.
    // Position timed with Numerator 1,2,3,4 orbitfraction-- then circularize
    LOCK Initiate_Mission_Pt to TARGET_ANGLE(Initiate_Target).
    log ("perform_transfer Initiate Point: " + Initiate_Mission_Pt) to logfile.
    Print "perform_transfer Initiate Point: " + Initiate_Mission_Pt.
    If Initiate_Mission_Pt > .5 {
      wait until Initiate_Mission_Pt < .5.
    }
    log ("Waited Initiate Point: " + Initiate_Mission_Pt) to logfile.
    Print "Waited Initiate Point: " + Initiate_Mission_Pt.
    global orbitfraction is OrbitNumerator * (Orbit:period/4).
    LOCK Transfer_Angle to LNG_TO_DEGREES(SHIP:LONGITUDE).
    print "Init Ship:LNG = " + Transfer_Angle.
    Print "Fx perform_transfer Target_Angle: " + TARGET_ANGLE(Initiate_Target).
    log ("Fx perform_transfer Target_Angle: " + TARGET_ANGLE(Initiate_Target)) to logfile.
    set orbitfraction to orbitfraction + time:seconds.
    local dv is list(0).
    set dV to hillclimb["seek"](dV, Apoapsis_fitness@, 100).
    set dV to hillclimb["seek"](dV, Apoapsis_fitness@, 10).
    set dV to hillclimb["seek"](dV, Apoapsis_fitness@, 1).
    if abs(Initiate_Mission_Pt) < 15 {
      set kuniverse:timewarp:warp to 3.
      kuniverse:timewarp:warpto(orbitfraction - 120).
    }
    // Execute maneuver
    log ("Mnv starts at: " + orbitfraction) to logfile.
    add node(orbitfraction, 0, 0, dV[0]). wait 0.1.
    //set kuniverse:timewarp:mode to "RAILS".
    //set kuniverse:timewarp:rate to 100.
    if orbitfraction - time:seconds > 180 {
    kuniverse:timewarp:warpto(orbitfraction - 120).}
    maneuver["exec"](TRUE).
    mission["next"]().
  }

  function perform_correction {
    parameter mission.
    log ("KerbinOrbit1 Fx perform_correction") to logfile.
    set correction_time to time:seconds + (eta:transition / 2).
    local dV is list(0, 0, 0).
    set dV to hillclimb["seek"](dV, correction_fitness@, 100).
    set dV to hillclimb["seek"](dV, correction_fitness@, 10).
    set dV to hillclimb["seek"](dV, correction_fitness@, 1).
    add node(correction_time, dv[0], dv[1], dV[2]). wait 0.1.
    maneuver["exec"](true).
    mission["next"]().
  }

  function idle {
    parameter mission.
    // Do nothing
  }

  function available_twr {
    local g is body:mu / (ship:altitude + body:radius)^2.
    return ship:maxthrust / g / ship:mass.
  }

  function correction_fitness {
    parameter data.
    log ("KerbinOrbit1 Fx correction_fitness") to logfile.
    local maneuver is node(correction_time, data[0], data[1], data[2]).
    local fitness is 0.
    add maneuver. wait 0.01.
    if maneuver:orbit:hasnextpatch and
       maneuver:orbit:nextpatch:body = Kerbin {
      set fitness to -abs(maneuver:orbit:nextpatch:periapsis - TARGET_Orbit_ALTITUDE).
    } else {
      set fitness to -2^64.
    }
    remove_any_nodes().
    return fitness.
  }

  function circular_fitness {
    parameter data.
    local maneuver is node(time:seconds + eta:apoapsis, 0, 0, data[0]).
    local fitness is 0.
    add maneuver. wait 0.01.
    set fitness to -maneuver:orbit:eccentricity.
    remove_any_nodes().
    return fitness.
  }

  function Apoapsis_fitness {
    parameter data.
    local maneuver is node(orbitfraction, 0, 0, data[0]).
    local fitness is 0.
    add maneuver. wait 0.01.
    set fitness to -abs(maneuver:orbit:apoapsis - TARGET_Orbit_ALTITUDE).
    remove_any_nodes().
    return fitness.
  }

  function remove_any_nodes {
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
    FUNCTION LNG_TO_DEGREES {
      PARAMETER lng.
      RETURN MOD(lng + 360, 360).
    }
    FUNCTION ORBITABLE {
      PARAMETER name.
      LIST TARGETS in vessels.
      FOR vs IN vessels {
        IF vs:NAME = name {
          RETURN VESSEL(name).
        }
      }
      RETURN BODY(name).
    }

    FUNCTION TARGET_ANGLE {
     PARAMETER target.
     RETURN MOD(
       LNG_TO_DEGREES(ORBITABLE(target):LONGITUDE)
       - LNG_TO_DEGREES(SHIP:LONGITUDE) + 360,
       360
     ).
    }
}
