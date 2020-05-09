// Maneuver Node Transfer Library v0.2.3
// Kevin Gisi
// http://youtube.com/gisikw

{
  local MANEUVER_LEAD_Tm is 600.
  local SLOPE_THRESHHOLD is 1.
  local INFINITY is 2^64.

  global transfer is lex(
    "version", "0.2.3",
    "seek", seek@
  ).

  function seek {
    parameter TGT_body, TGT_peri, TGT_Inc is 0.
    local attempt is 1.
    local da is starting_da(attempt).

    // Seek encounter, advancing start time if we get stuck
    until 0 {
      set da to hillclimb["seek"](da, transfer_fit(TGT_body), 50).
      if transfers_to(nextnode, TGT_body) { break. }
      set attempt to attempt + 1.
      set da to starting_da(attempt).
    }

    // Refine for inclination
    set da to hillclimb["seek"](da, inclination_fit(TGT_body,TGT_Inc), 100).
    set data to hillclimb["seek"](data, inclination_fit(target_body,TGT_Inc), 10).
    set da to hillclimb["seek"](da, inclination_fit(TGT_body,TGT_Inc), 1).

    // Refine for periapsis
    set da to hillclimb["seek"](da, periapsis_fit(TGT_body, TGT_peri), 100).
    set da to hillclimb["seek"](da, periapsis_fit(TGT_body, TGT_peri), 10).
    set da to hillclimb["seek"](da, periapsis_fit(TGT_body, TGT_peri), 1).

    remove_any_nodes().
    return make_node(da).
  }

  function transfer_fit {
    parameter TGT_body.
    function Ftns_fn {
      parameter da.
      local maneuver is make_node(da).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if transfers_to(maneuver, TGT_body) return 1.
      local Ftns is -closest_approach(
        TGT_body,
        time:seconds + maneuver:eta,
        time:seconds + maneuver:eta + maneuver:orbit:period
      ).
      return Ftns.
    }
    return Ftns_fn@.
  }

  function inclination_fit {
    parameter TGT_body, TGT_Inc.
    function Ftns_fn {
      parameter da.
      local maneuver is make_node(da).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if maneuver:orbit:hasnextpatch {
      log ("Transfer Fx Inclination: " + maneuver:orbit:nextpatch:Inclination) to logfile.
      log ("Inc_fit da: " + da[0] + " - " + da[1] + " - " + da[2] + " - " + da[3]) to logfile.
    }
      if not transfers_to(maneuver, TGT_body) return -INFINITY.
      return -abs(maneuver:orbit:nextpatch:inclination - TGT_Inc).
    }
    return Ftns_fn@.
  }

  // TODO: There's a lot of shared code in these Ftns functions. Probably
  // means some stuff can be merged / abstracted
  function periapsis_fit {
    parameter TGT_body, TGT_peri.
    function Ftns_fn {
      parameter da.
      local maneuver is make_node(da).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if not transfers_to(maneuver, TGT_body) return -INFINITY.
      return -abs(maneuver:orbit:nextpatch:periapsis - TGT_peri).
    }
    return Ftns_fn@.
  }

  function closest_approach {
    parameter TGT_body, start_Tm, end_Tm.
    local start_slope is slope_at(TGT_body, start_Tm).
    local end_slope is slope_at(TGT_body, end_Tm).
    local middle_Tm is (start_Tm + end_Tm) / 2.
    local middle_slope is slope_at(TGT_body, middle_Tm).
    until (end_Tm - start_Tm < 0.1) or middle_slope < 0.1 {
      if (middle_slope * start_slope) > 0
        set start_Tm to middle_Tm.
      else
        set end_Tm to middle_Tm.
      set middle_Tm to (start_Tm + end_Tm) / 2.
      set middle_slope to slope_at(TGT_body, middle_Tm).
    }
    return separation_at(TGT_body, middle_Tm).
  }

  function slope_at {
    parameter TGT_body, at_Tm.
    return (
      separation_at(TGT_body, at_Tm + 1) -
      separation_at(TGT_body, at_Tm - 1)
    ) / 2.
  }

  function separation_at {
    parameter TGT_body, at_Tm.
    return (positionat(ship, at_Tm) - positionat(TGT_body, at_Tm)):mag.
  }

  function transfers_to {
    parameter maneuver, TGT_body.
    return (
      maneuver:orbit:hasnextpatch and
      maneuver:orbit:nextpatch:body = TGT_body
    ).
  }

  function starting_da {
    parameter attempt.
    return list(time:seconds + (MANEUVER_LEAD_Tm * attempt), 0, 0, 0).
  }

  function make_node {
    parameter maneuver.
    return node(maneuver[0], maneuver[1], maneuver[2], maneuver[3]).
  }

  function remove_any_nodes {
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
}
