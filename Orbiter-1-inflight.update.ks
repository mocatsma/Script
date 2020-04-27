// L2O-1.ks SatNet1-Mun.update.KS
//Inflight
print "X:update-1-inflight.ks".
global OrbiterLog to "0:/InflightUpdate.txt"
//Mun Apoapsis = 11,400,000, Encounter 111 Degrees, Lead/Trail = 150/70
Set Target_Circ to 80000.
Set Target_Transfer_Height to 112000.
Set Target_Encounter_Angle to 5.
Set T_Goal to "Orbiter-1-Comm1".
Set lastDistance to T_Goal:DISTANCE.
//KOS topics to consider GeoCoordinates
//DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
//DOWNLOAD("Telemetry.KS").
//DOWNLOAD("AscentSat1Net.KS").
//DOWNLOAD("Autopilot.KS").

//local OrbiterLog is "0:/partlist.txt".
//log ("Checktostage: Transfer Inflight -" + Target_Transfer_Height) to OrbiterLog.
Run orbit.ks.
Run Maneuver.ks.
//ChecktoStage().

Local vol is 1.
Local dbgStep is 0.
SWITCH TO vol.
LIST FILES IN allFiles.
FOR file IN allFiles {
  log ("...Inflight--update.ks - "  +
  allfiles[dbgStep] + " Step: " + dbgStep ) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}
Notify("Gathering Information").
log( "Fx Orbitable(T_Goal) "  + Orbitable(T_Goal))
  to OrbiterLog.
log ("Current Ship logged: " + SHIP:NAME +
  ": InflightUpdate Target_Transfer_Height - " + Target_Transfer_Height)
  to OrbiterLog.
log ("T_Goal / Ship:Name " + T_Goal + " / " + SHIP:NAME)
  to OrbiterLog.
Log (+ " = " + TARGET_ANGLE(T_Goal)) to OrbiterLog.

Notify("Waiting for Target Angle - degree angle from Ship to Target").
Until ISH(Target_Angle(T_Goal),Target_Encounter_Angle,2) {
  Print Target_Angle(T_Goal).
  Log ("Fx ISH 10 seconds wait Fx TARGET_ANGLE(T_Goal) = "
    + TARGET_ANGLE(T_Goal)) to OrbiterLog.
  log ("Fx ISH Values = T_Goal, Target_Encounter_Angle, 2")
    to OrbiterLog.

  wait 10.
}
print "ending Inflight update.ks".

wait 5.

Function ISH {
  Parameter a.
  Parameter b.
  Parameter Ishyness.
  Return a - ishyness < b and a + ishyness > b.
}
