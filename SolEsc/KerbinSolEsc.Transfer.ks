//Kerbin transfer Scripts
Notify("Beginning Transfer Script").
Run orbit.ks.
Run Maneuver.ks.
Set Inclin to 0.
Set TransferHeight to 85000.
Set Start_Peri to Periapsis.
Set Start_Apo to Apoapsis.
Notify("Checking Starting Orbit Peri and Apo").
wait 3.
If Start_peri > transferheight{
  Set T_DV_list to MNV_HOHMANN_DV(transferheight).
  Set M_T2 to time:seconds + MNV_TIME(T_DV_list[1]).
  Print "T_DV_list and M_T2: " + T_DV_list +" / " + M_T2.
  Set Starttime to ETA:Apoapsis - 10 - M_T2/2.
  Set PeriNode to Node(M_T2,0,0,T_DV_list[1]).
  Lock steering to retrograde.
  when ETA:Apoapsis - Starttime = 0 Then {
    Add PeriNode.
    When ETA:Apoapsis - M_T2/2 = 0 then {
    MNV_EXEC_NODE(TRUE).}
    Remove PeriNode.
  }
}
If Start_peri < transferheight{
  Set T_DV_list to MNV_HOHMANN_DV(transferheight).
  Set M_T2 to time:seconds + MNV_TIME(T_DV_list[1]).
  Print "T_DV_list and M_T2: " + T_DV_list +" / " + M_T2.
  Set Starttime to ETA:Apoapsis - 10 - M_T2/2.
  Set PeriNode to Node(M_T2,0,0,T_DV_list[1]).
  Lock STEERING to prograde.
  When ETA:Apoapsis - startTime = 0 Then {
    Add PeriNode.
    When ETA:Apoapsis - M_T2/2 = 0 Then {
    MNV_EXEC_NODE(TRUE).}
    Remove PeriNode.
  }
}
If Start_Apo > transferheight{
  Set T_DV_list to MNV_HOHMANN_DV(transferheight).
  Set M_T1 to time:seconds + MNV_TIME(T_DV_list[0]).
  Print "T_DV_list and M_T1: " + T_DV_list +" / " + M_T1.
  Set Starttime to ETA:Periapsis - 10 - M_T1/2.
  Set ApoNode to Node(M_T1,0,0,T_DV_list[0]).
  Lock STEERING to retrograde.
  When ETA:Periapsis - Starttime = 0 Then {
    Add ApoNode.
    when ETA:Periapsis - M_T1/2 = 0 Then {
    MNV_EXEC_NODE(TRUE).}
    Remove ApoNode.
  }
}
If Start_Apo < transferheight{
  Set T_DV_list to MNV_HOHMANN_DV(transferheight).
  Set M_T1 to time:seconds + MNV_TIME(T_DV_list[0]).
  Print "T_DV_list and M_T1: " + T_DV_list +" / " + M_T1.
  Set Starttime to ETA:Periapsis - 10 - M_T1/2.
  Lock STEERING to prograde.
  Set ApoNode to Node(M_T1,0,0,T_DV_list[0]).
  When ETA:Periapsis - Starttime = 0 Then {
    Add ApoNode.
    When ETA:Periapsis - M_T1/2 = 0 Then {
    MNV_EXEC_NODE(TRUE).}
    Remove ApoNode.
  }
}
sas on.
lock steering to prograde.
Notify("Transfer Burn(s) Completed").
//set forward to Prograde.
//Lock Steering to forward. Wait 10.
//Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
//wait until Ship:Apoapsis > TransferHeight.
