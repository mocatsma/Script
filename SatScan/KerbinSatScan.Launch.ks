//Kerbin Launch

Notify("Begin the Launch, control to Ship").

Run Maneuver.ks.
Run AscentSatScan.ks.
Set inclin to 0.
Set TransferHeight to 80000.
Set ascentProfile to List(
  //Altitude, Angle, thrust
  0,          90,     1,
  500,        88,     1,
  1500,       85,     1,
  2500,       81,     1,
  3500,       76,     1,
  5500,       70,     1,
  8500,       62,     1,
  12500,      51,     1,
  17500,      40,     1,
  28000,      30,     1,
  36000,      25,     1,
  40000,      20,     1,
  45000,      15,     1,
  47500,      10,     1,
  50000,       0,     1
).
Notify("Launch Ascent begins").
//Stage 1 Launch
Lock Throttle to 1. wait 1. Stage.
Execute_Ascent_Profile(inclin,ascentProfile,TransferHeight).
wait until Ship:ALTITUDE > 55000.
print "Deploy Fairing until I get it with the script".
WAIT 5.
PANELS ON.
print "Panels and Antenna Routine in ..Launch.ks".
  Set T_DV_list to MNV_HOHMANN_DV(transferheight - Ship:Periapsis).
  Set M_T1 to time:seconds + MNV_TIME(T_DV_list[0]).
  Set M_T2 to time:seconds + MNV_TIME(T_DV_List [1]).
  Print "T_DV_list and M_T1: " + T_DV_list +" / " + M_T1.
  Print "M_T2: " + M_T2.
  Set Starttime to time:seconds + ETA:Apoapsis - M_T1.
  //If Starttime < 30 {
    //Set starttime to 30.
//  }
  Set ApoNode to Node(M_T1,0,0,T_DV_list[0]+ T_DV_List[1]).
  Add ApoNode.
  //Lock STEERING to heading(inclin,0).
  Print "ApoNode added".
//  until Time:seconds - M_T1 > 1 { Wait 1.}
  //MNV_EXEC_NODE(TRUE).
  Remove ApoNode.


//Wait until ETA:Apoapsis < 45.
lock STEERING to heading(inclin,0).
//Lock Throttle to 1.

//Wait for Orbit, stage as needed
Until Periapsis > 65000 {MNV_Burnout(True). Wait 0.01.
  print "Until Periapsis > 65000 is : " + periapsis.
  Print "Apoapsis is : " + Apoapsis +" ETA: "+ ETA:Apoapsis.
  Print "Heading: " + Heading.
  WAIT 10.
  IF ETA:Apoapsis > 30 or ETA:Apoapsis < 300{
    Print "Apoapsis >30, <300".
    Lock Throttle to 0.
    WAIT 5.
    break.
  }else if ETA:Apoapsis < 30 or ETA:Apoapsis > 300{
    Print "Apoapsis < 30, >300".
    if ETA:Apoapsis > 300{
      lock Throttle to 1.
      wait 15.
    }
    Lock Throttle to 1.
  }
}
Lock Throttle to 0. Wait 1.

Notify("Launch Script Complete").
