//K2Mun Mission Script
// Kevin Gisi
// http://youtube.com/gisikw

{
  local TGT_Alt is 100000.
  local TGT_Mun_Alt is 45000.
  local TGT_Mun_Inc is 5.
  local crct_Tm is 0.
  local safety_Tm is 0.

  global K2MunMission1 is lex(
    "sequence", list(
      "preflight", preflight@,
      "launch", launch@,
      "ascent", ascent@,
      "circularize", circularize@,
      "PFM_trn", PFM_trn@,
      "PFM_crct", PFM_crct@,
      "warp_to_soi", warp_to_soi@,
      "adj_Mun_peri", adj_Mun_peri@,
      "PFM_capt", PFM_capt@,
      "idle", idle@
    ),
    "events", lex()
  ).

  function preflight {
    parameter mission.
    set ship:control:pilotmainthrottle to 0.
    lock throttle to 1.
    lock steering to heading(90, 90).
    wait 5.
    mission["next"]().
  }

  function launch {
    parameter mission.
    stage. wait 2.
    lock pct_alt to alt:radar / TGT_Alt.
    set TGT_twr to 8.26.
    lock TGT_pitch to -115.23935 * pct_alt^0.409 + 88.963.
    lock throttle to max(min(TGT_twr / available_twr(), 1), 0). // Honestly, just lock throttle to 1
    lock steering to heading(90, TGT_pitch).
    mission["next"]().
  }

  function ascent {
    parameter mission.
    if apoapsis > TGT_Alt {
      lock throttle to 0.
      lock steering to prograde.
      wait until alt:radar > body:atm:height.
      mission["next"]().
    }
  }

  function circularize {
    parameter mission.

    // Find good circularization dV
    local dV is list(0).
    set dV to hillclimb["seek"](dV, circ_Ftns@, 100).
    set dV to hillclimb["seek"](dV, circ_Ftns@, 10).
    set dV to hillclimb["seek"](dV, circ_Ftns@, 1).

    // Execute maneuver
    add node(time:seconds + eta:apoapsis, 0, 0, dV[0]). wait 0.1.
    maneuver["exec"]().
    panels on. lights on.
    lock throttle to 0.
    mission["next"]().
  }

  function PFM_trn {
    parameter mission.
    local mnv is transfer["seek"](Mun, TGT_Mun_Alt,TGT_Mun_Inc).
    add mnv. wait 0.01.
    maneuver["exec"](true).
    mission["next"]().
  }

  function PFM_crct {
    parameter mission.
    //attempt to incline first
    set crct_Tm to time:seconds + (eta:transition / 4).
    local dV is list(0, 0, 0).
    set dV to hillclimb["seek"](dV, crctInc_Ftns@, 100).
    set dV to hillclimb["seek"](dV, crctInc_Ftns@, 10).
    set dV to hillclimb["seek"](dV, crctInc_Ftns@, 1).

    add node(crct_Tm, dv[0], dv[1], dV[2]). wait 0.1.
    maneuver["exec"](true).

    set crct_Tm to time:seconds + (eta:transition / 2).
    local dV is list(0, 0, 0).
    set dV to hillclimb["seek"](dV, crct_Ftns@, 100).
    set dV to hillclimb["seek"](dV, crct_Ftns@, 10).
    set dV to hillclimb["seek"](dV, crct_Ftns@, 1).

    add node(crct_Tm, dv[0], dv[1], dV[2]). wait 0.1.
    maneuver["exec"](true).
    mission["next"]().
  }

  function warp_to_soi {
    parameter mission.
    local transition_Tm is time:seconds + eta:transition.
    kuniverse:timewarp:warpto(transition_Tm).
    wait until time:seconds >= transition_Tm.
    mission["next"]().
  }

  function adj_Mun_peri {
    parameter mission.
    if body = Mun {
      wait 30.
      set safety_Tm to time:seconds + 120.
      local dV is list(0).
      set dV to hillclimb["seek"](dV, safe_Ftns@, 100).
      set dV to hillclimb["seek"](dV, safe_Ftns@, 10).
      set dV to hillclimb["seek"](dV, safe_Ftns@, 1).

      add node(safety_Tm, 0, 0, dV[0]). wait 0.1.
      maneuver["exec"](true).
      mission["next"]().
    }
  }

  function PFM_capt {
    parameter mission.
    local dV is list(0).
    set dV to hillclimb["seek"](dV, capt_Ftns@, 100).
    set dV to hillclimb["seek"](dV, capt_Ftns@, 10).
    set dV to hillclimb["seek"](dV, capt_Ftns@, 1).

    add node(time:seconds + eta:periapsis, 0, 0, dV[0]). wait 0.1.
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

  function crctInc_Ftns {
    parameter da.
    local maneuver is node(crct_Tm, da[0], da[1], da[2]).
    local Ftns is 0.
    add maneuver. wait 0.01.
    if maneuver:orbit:hasnextpatch and
       maneuver:orbit:nextpatch:body = Mun {
      set Ftns to -abs(maneuver:orbit:nextpatch:Inclination - TGT_Mun_Inc).
    } else {
      set Ftns to -2^64.
    }
    remove_any_nodes().
    return Ftns.
  }

  function crct_Ftns {
    parameter da.
    local maneuver is node(crct_Tm, da[0], da[1], da[2]).
    local Ftns is 0.
    add maneuver. wait 0.01.
    if maneuver:orbit:hasnextpatch and
       maneuver:orbit:nextpatch:body = Mun {
      set Ftns to -abs(maneuver:orbit:nextpatch:periapsis - TGT_Mun_Alt).
    } else {
      set Ftns to -2^64.
    }
    remove_any_nodes().
    return Ftns.
  }

  function circ_Ftns {
    parameter da.
    local maneuver is node(time:seconds + eta:apoapsis, 0, 0, da[0]).
    local Ftns is 0.
    add maneuver. wait 0.01.
    set Ftns to -maneuver:orbit:eccentricity.
    remove_any_nodes().
    return Ftns.
  }

  // TODO: circ_Ftns and capt_Ftns should be merged. They only
  // differ in start time.
  function capt_Ftns {
    parameter da.
    local maneuver is node(time:seconds + eta:periapsis, 0, 0, da[0]).
    local Ftns is 0.
    add maneuver. wait 0.01.
    set Ftns to -maneuver:orbit:eccentricity.
    remove_any_nodes().
    return Ftns.
  }

  function safe_Ftns {
    parameter da.
    local maneuver is node(safety_Tm, 0, 0, da[0]).
    local Ftns is 0.
    add maneuver. wait 0.01.
    set Ftns to -abs(maneuver:orbit:periapsis - TGT_Mun_Alt).
    remove_any_nodes().
    return Ftns.
  }

  function remove_any_nodes {
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
}
