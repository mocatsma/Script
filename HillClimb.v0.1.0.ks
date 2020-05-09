// Hillclimb v0.1.0 Algorithm Library
// Kevin Gisi
// http://youtube.com/gisikw

{
  local INFINITY is 2^64.
  local DEFAULT_STEP_SIZE is 1.

  global hillclimb is lex(
    "version", "0.1.0",
    "seek", seek@
  ).

  function seek {
    parameter da, Ftns_fn, step_size is DEFAULT_STEP_SIZE.
    local next_da is best_neighbor(da, Ftns_fn, step_size).
    until Ftns_fn(next_da) <= Ftns_fn(da) {
      set da to next_da.
      set next_da to best_neighbor(da, Ftns_fn, step_size).
    }
    log ("Hillclimb:da Fx Seek, final Next_da & da " + next_da + " / " + da) to logfile.
    log ("Hillclimb:FitFxNextda / FitFxda Fx Seek, Until2: " + Ftns_fn(next_da) + " / " + Ftns_fn(da)) to logfile.
    return da.
  }

  function best_neighbor {
    parameter da, Ftns_fn, step_size.
    local best_Ftns is -INFINITY.
    local best is 0.
    for neighbor in neighbors(da, step_size) {
      local Ftns is Ftns_fn(neighbor).
      if Ftns > best_Ftns {
        set best to neighbor.
        set best_Ftns to Ftns.
      }
    }
    return best.
  }

  function neighbors {
    parameter da, step_size, results is list().
    log("Hillclimb Fx Neighbors da: " + da) to logfile.
    for i in range(0, da:length) {
      local increment is da:copy.
      local decrement is da:copy.
      set increment[i] to increment[i] + step_size.
      set decrement[i] to decrement[i] - step_size.
      results:add(increment).
      results:add(decrement).
    }
    //log("Hillclimb:Results of Fx neighbors: " + step_size) to logfile.
    return results.
  }
}
