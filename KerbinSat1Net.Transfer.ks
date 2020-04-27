//Kerbin transfer Script
Parameter TransferHeight, T_Angle, T_Goal.
//local OrbiterLog is "0:/partlist.txt".
Notify("Beginning Transfer Script").
log ("Current Ship logged: " + SHIP:NAME + ": Transfer Inflight -" + TransferHeight) to OrbiterLog.
log ("Checktostage: Transfer Inflight -" + TransferHeight) to OrbiterLog.
Run orbit.ks.
Run Maneuver.ks.
ChecktoStage().

//Set TransferHeight = 11,200,000.
//wait for window 111 degrees for encounter. 150 degrees and 70 for Trail and Lead
Notify("Waiting for Target Angle - degree angle from Ship to Target").
Until ISH(Target_Angle(T_Goal),T_Angle,0.5) {
  Print Target_Angle(T_Goal).
  //log (TARGET_ANGLE(T_Goal)) to OrbiterLog.
  wait 10.
}

//Mun Transfer
Notify("Beginning Transfer Burn").
//set forward to Prograde.
//Lock Steering to forward. Wait 10.
Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
set MNV_DV to MNV_HOHMANN_DV(TransferHeight).
Set T1_MNV to MNV_Time(MNV_DV[0]).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Print "Burntime #1 / #2 : " + T1_MNV  + " / " + T2_MNV.
log ("Current Ship logged: " + SHIP:NAME + ": Transfer -" + TransferHeight) to OrbiterLog.
//Set T1_Start to Time:Seconds + ETA:Apoapsis - T1_MNV/2.
Set T1_Start to Time:Seconds + 5.
Set n1 to Node(T1_Start,0,0,MNV_DV[0]).
Notify("Beginning 1st Transfer Burn").
Print "dV - Node #1: " + MNV_DV[0].
log ("dV - Node #1: " + MNV_DV[0]) to OrbiterLog.
Add n1.
MNV_EXEC_NODE(TRUE).
Remove n1.
log ("#1 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("Periapsis: " + Periapsis) to OrbiterLog.
Set T2_Start to Time:Seconds + ETA:Apoapsis - T2_MNV/2.
Set n2 to Node(T2_Start,0,0,MNV_DV[1]).
Notify("Beginning 2nd Transfer Burn").
Print "dV - Node #2: " + MNV_DV[1].
log ("dV - Node #2: " + MNV_DV[1]) to OrbiterLog.

Add n2.
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
