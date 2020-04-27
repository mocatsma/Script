// L2O-1.ks SatNet1-Mun.update.KS

print "X:update.ks".
//Mun Apoapsis = 11,400,000, Encounter 111 Degrees, Lead/Trail = 150/70
Set Target_Circ to 75000.
Set Target_Transfer_Height to 11200000.
Set Target_Encounter_Angle to 70.
Set T_Goal to "Mun".
// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
DOWNLOAD("AscentSat1Net.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("Kerbin.Launch.KS").
DOWNLOAD("Kerbin.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").
LIST FILES IN allFiles.
local dbgStep to 0.
FOR file IN allFiles {
  log ("Prior to ...Launch: " + allFiles[dbgstep]) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}
Notify("Kerbin Launch Commencing soon"). Wait 2.

Run Kerbin.Launch.ks(Target_Circ).
Run Kerbin.Transfer.ks(Target_Transfer_Height,Target_Encounter_Angle,T_Goal).
//Run Mun.orbit.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 5.