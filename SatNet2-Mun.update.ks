// L2O-1.ks SatNet1-Mun.update.KS
//Inflight
print "X:update.ks".
//Mun Apoapsis = 11,400,000, Encounter 111 Degrees, Lead/Trail = 150/70
Set Target_Circ to 75000.
Set Target_Transfer_Height to 11200000.
Set Target_Encounter_Angle to 70.
Set T_Goal to "Mun".
//DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
//DOWNLOAD("Telemetry.KS").
//DOWNLOAD("AscentSat1Net.KS").
//DOWNLOAD("Autopilot.KS").

//local OrbiterLog is "0:/partlist.txt".
Notify("Beginning Transfer Script").
log ("Current Ship logged: " + SHIP:NAME + ": Transfer Inflight -" + Target_Transfer_Height) to OrbiterLog.
log ("Checktostage: Transfer Inflight -" + Target_Transfer_Height) to OrbiterLog.
Run orbit.ks.
Run Maneuver.ks.
ChecktoStage().

Local vol is 1.
Local dbgStep is 0.
SWITCH TO vol.
LIST FILES IN allFiles.
FOR file IN allFiles {
  log ("...Inflight--update.ks - "  +
  allfiles[dbgStep] + " Step: " + dbgStep ) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}

Function ISH {
  Parameter a.
  Parameter b.
  Parameter Ishyness.
  Return a - ishyness < b and a + ishyness > b.
}

//Set Target_Transfer_Height = 11,200,000.
//wait for window 111 degrees for encounter. 150 degrees and 70 for Trail and Lead
Notify("Waiting for Target Angle - degree angle from Ship to Target").
Until ISH(Target_Angle(T_Goal),Target_Encounter_Angle,0.5) {
  Print Target_Angle(T_Goal).
  log (TARGET_ANGLE(T_Goal)) to OrbiterLog.
  wait 10.
}

//Mun Transfer
Notify("Beginning Transfer Burn").
//set forward to Prograde.
//Lock Steering to forward. Wait 10.
Lock throttle to 1 - (Ship:Apoapsis/Target_Transfer_Height * 0.99).
set MNV_DV to MNV_HOHMANN_DV(Target_Transfer_Height).
Set T1_MNV to MNV_Time(MNV_DV[0]).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Print "Burntime #1 / #2 : " + T1_MNV  + " / " + T2_MNV.
log ("Current Ship logged: " + SHIP:NAME + ": Transfer -" + Target_Transfer_Height) to OrbiterLog.
//Set T1_Start to Time:Seconds + ETA:Apoapsis - T1_MNV/2.
Set T1_Start to Time:Seconds + 2.
Set n1 to Node(T1_Start,0,0,MNV_DV[0]).
Notify("Beginning 1st Transfer Burn").
Print "dV - Node #1: " + MNV_DV[0].
log ("Start & dV - Node #1: " +T1_Start +" & "+ MNV_DV[0]) to OrbiterLog.
Add n1.
MNV_EXEC_NODE(TRUE).
Remove n1.
log ("#1 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("#1 Periapsis: " + Periapsis) to OrbiterLog.
Set T2_Start to Time:Seconds + ETA:Apoapsis - T2_MNV/2.
Set n2 to Node(T2_Start,0,0,MNV_DV[1]).
Notify("Beginning 2nd Transfer Burn").
Print "dV - Node #2: " + MNV_DV[1].
log ("Start & dV - Node #2: " +T2_Start +" & "+ MNV_DV[1]) to OrbiterLog.
Add n2.
MNV_EXEC_NODE(TRUE).
Remove n2.
log ("#2 Apoapsis / ETA: " + Apoapsis + " / " + Time:Seconds + ETA:Apoapsis) to OrbiterLog.
log ("#2 Periapsis: " + Periapsis) to OrbiterLog.
Notify("Transfer Burn completed").
SAS on.

//wait until Ship:Apoapsis > Target_Transfer_Height.

//set forward to Prograde.
//Lock Steering to forward. Wait 10.
//Lock throttle to 1 - (Ship:Apoapsis/Target_Transfer_Height * 0.99).
//wait until Ship:Apoapsis > Target_Transfer_Height.
//SET prevThrust TO MAXTHRUST.

print "ending Inflight update.ks".

wait 5.
