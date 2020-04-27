//Kerbin transfer Script
Parameter TransferHeight, T_Angle, T_Goal.
//local OrbiterLog is "0:/partlist.txt".
Notify("Beginning Transfer Script").
log ("Current Ship logged: " + SHIP:NAME + ": Transfer Inflight -" + TransferHeight) to OrbiterLog.
log ("Checktostage: Transfer Inflight -" + TransferHeight) to OrbiterLog.
Run orbit.ks.
Run Maneuver.ks.
ChecktoStage().
LOCK Transfer_Angle to LNG_TO_DEGREES(SHIP:LONGITUDE).
log ("Transfer.ks - initial Ship LNG " + Transfer_Angle) to OrbiterLog.
log (Orbitable("Orbiter-1")) to OrbiterLog.
//Set TransferHeight = 11,200,000.
//wait for window 111 degrees for encounter. 150 degrees and 70 for Trail and Lead
Notify("Waiting for Target Angle - degree angle from Ship to Target").
//Until ISH(Target_Angle(T_Goal),T_Angle,0.5) {
//when executing Transfer in relation to another
//orbiting body (Mun), OrbitComm1
Until Transfer_Angle < T_Angle {
  Print "SHIP:LNG " + Transfer_Angle.
  log ("Until Ship LNG < T_ANGLE " + Transfer_Angle +
  " = " + T_Angle) to OrbiterLog.
  wait 10.
  //set Transfer_Angle to LNG_TO_DEGREES(SHIP:LONGITUDE).
}
//log ("ISHyness Achieved T_ANGLE / Ship LNG " +  T_ANGLE + " / " + Transfer_Angle) to OrbiterLog.
//Mun Transfer
Notify("Beginning Transfer Burn").
//set forward to Prograde.
//Lock Steering to forward. Wait 10.
Lock throttle to 0.
set MNV_DV to MNV_HOHMANN_DV(TransferHeight).
Set T1_MNV to MNV_Time(MNV_DV[0]).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Print "Burntime #1 / #2 : " + T1_MNV  + " / " + T2_MNV.
log ("Current Ship logged: " + SHIP:NAME + ": Transfer -" + TransferHeight) to OrbiterLog.
Log ("Burn Times 1 & 2 " + T1_MNV + " & " + T2_MNV) to OrbiterLog.
IF Time:Seconds - (ETA:Apoapsis + T1_MNV/2) > T1_MNV {
Set T1_Start to Time:Seconds + ETA:Apoapsis - T1_MNV/2.
} Else { Set T1_Start to Time:Seconds + 2.}
Set n1 to Node(T1_Start,0,0,MNV_DV[0]).
Notify("Beginning 1st Transfer Burn").
Print "dV - Node #1: " + MNV_DV[0].
log ("dV - Node #1: " + MNV_DV[0]) to OrbiterLog.
log ("Pre Node#1 dV - Node #2: " + MNV_DV[1]) to OrbiterLog.
Add n1.
LOCK STEERING TO n1:BURNVECTOR.
log ("#1 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("Periapsis: " + Periapsis) to OrbiterLog.
//Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
MNV_EXEC_NODE(TRUE).
Remove n1.
log ("After Burn #1 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("After Burn #1 Periapsis: " + Periapsis) to OrbiterLog.
// Get new #2 MNV values
set MNV_DV to MNV_HOHMANN_DV(TransferHeight).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Set T2_Start to Time:Seconds + ETA:Apoapsis - T2_MNV/2.
Set n2 to Node(T2_Start,0,0,MNV_DV[1]).
Notify("Beginning 2nd Transfer Burn").
Print "dV - Node #2: " + MNV_DV[1].
Log ("After Burn #1 Burn Time #2 " + T1_MNV + " & " + T2_MNV) to OrbiterLog.
log ("dV - Node #2: " + MNV_DV[1]) to OrbiterLog.
Add n2.
LOCK STEERING TO n2:BURNVECTOR.
MNV_EXEC_NODE(TRUE).
Remove n2.
log ("#2 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("Periapsis: " + Periapsis) to OrbiterLog.
Notify("Transfer Burn completed").
SAS on.

//wait until Ship:Apoapsis > TransferHeight.


Function ISH {
  Parameter a.
  Parameter b.
  Parameter Ishyness.

  Return a - ishyness < b and a + ishyness > b.
}

//set forward to Prograde.
//Lock Steering to forward. Wait 10.
//Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
//wait until Ship:Apoapsis > TransferHeight.
//SET prevThrust TO MAXTHRUST.
