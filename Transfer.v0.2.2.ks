// Maneuver Node Transfer Library v0.2.1
// Kevin Gisi
// http://youtube.com/gisikw
//modified to establish Kerbin orbit vs to another body

{
  local MANEUVER_LEAD_TIME is ETA:Periapsis.
  local SLOPE_THRESHHOLD is 1.
  local INFINITY is 2^64.

  global transfer is lex(
    "version", "0.2.2",
    "seek", seek@
  ).

  function seek {
    parameter target_body, target_apoapsis.
    local attempt is 1.
    local data is starting_data(attempt).
    log ("Transfer 0.2.2.2 Fx seek - starting_data: " + data + "ETA:Peri..: " + ETA:Periapsis) to logfile.
    // Seek encounter, advancing start time if we get stuck
    until 0 {
      //set data to hillclimb["seek"](data, transfer_fit(target_body), 20).
      log ("Transfer 0.2.2.2 Fx seek - until 0") to logfile.
      set data to hillclimb["seek"](data, apoapsis_fit(target_body, target_apoapsis), 100).
      //if transfers_to(nextnode, target_body) { break. }
      if nextnode:orbit:apoapsis > target_apoapsis {break.}
      set attempt to attempt + 1.
      log( "Transfer 0.2.2.2 Fx seek Attempt + 1: " + Attempt) to logfile.
      set data to starting_data(attempt).
      log ("Transfer 0.2.2.2 Fx seek Data: " + Data) to logfile.
    }
    // Refine for Apoapsis
    set data to hillclimb["seek"](data, apoapsis_fit(target_body, target_apoapsis), 10).
    set data to hillclimb["seek"](data, apoapsis_fit(target_body, target_apoapsis), 1).

    // Refine for inclination
    //set data to hillclimb["seek"](data, inclination_fit(target_body), 10).
    //set data to hillclimb["seek"](data, inclination_fit(target_body), 1).

    // Refine for periapsis
    //set data to hillclimb["seek"](data, periapsis_fit(target_body, target_periapsis), 10).
    //set data to hillclimb["seek"](data, periapsis_fit(target_body, target_periapsis), 1).

    remove_any_nodes().
    return make_node(data).
  }

  function transfer_fit {
    parameter target_body.
    log ("Transfer 0.2.2.2 Fx transfer_fit") to logfile.
    function fitness_fn {
      parameter data.
      local maneuver is make_node(data).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if transfers_to(maneuver, target_body) return 1.
      local fitness is -closest_approach(
        target_body,
        time:seconds + maneuver:eta,
        time:seconds + maneuver:eta + maneuver:orbit:period
      ).
      return fitness.
    }
    return fitness_fn@.
  }

  function inclination_fit {
    parameter target_body.
    log ("Transfer 0.2.2.2 Fx inclination_fit") to logfile.
    function fitness_fn {
      parameter data.
      local maneuver is make_node(data).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if not transfers_to(maneuver, target_body) return -INFINITY.
      return -abs(nextnode:orbit:inclination).
    }
    return fitness_fn@.
  }

  // TODO: There's a lot of shared code in these fitness functions. Probably
  // means some stuff can be merged / abstracted
  function periapsis_fit {
    parameter target_body, target_periapsis.
    log ("Transfer 0.2.2.2 Fx periapsis_fit") to logfile.
    function fitness_fn {
      parameter data.
      local maneuver is make_node(data).
      remove_any_nodes().
      add maneuver. wait 0.01.
      if nextnode:orbit:periapsis < target_periapsis return -INFINITY.
      //if not transfers_to(maneuver, target_body) return -INFINITY.
      return -abs(nextnode:orbit:periapsis - target_periapsis).
    }
    return fitness_fn@.
  }

  function starting_data {
    parameter attempt.
    log ("Transfer 0.2.2.2 Fx starting_data - attempt: " + attempt) to logfile.
    return list(time:seconds + (MANEUVER_LEAD_TIME + attempt), 0, 0, 0).
  }

  function make_node {
    parameter m_m_mnv.
    log ("Transfer 0.2.2.2 Fx make_node m_m_mnv: " + m_m_mnv) to logfile.
    return node(m_m_mnv[0], m_m_mnv[1], m_m_mnv[2], m_m_mnv[3]).
  }

  function remove_any_nodes {
    log ("Transfer 0.2.2.2 Fx remove_any_nodes") to logfile.
    until not hasnode {
      remove nextnode. wait 0.01.
    }
  }
}
