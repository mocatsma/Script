// L2O-1.ks SatNet1-Mun.update.KS

print "X:update-1-notinflight.ks".
//Mun Apoapsis = 11,400,000, Encounter 111 Degrees, Lead/Trail = 150/70
Set Target_Circ to 80000.
Set Target_Transfer_Height to 120000.
Set Target_Encounter_Angle to 5.
Set T_Goal to "Orbiter-1-Comm1".
// I want to set the Target_Encounter_Angle same in all Orbiter Launches
// see  ...Transfer.ks that uses Target_Encounter_Angle as the
//LNG_TO_DEGREES(SHIP:LONGITUDE) + 360,360) to be close to that point
// Libraries
//DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
//DOWNLOAD("Telemetry.KS").
DOWNLOAD("Ascent.KS").
//DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("Kerbin.Launch.KS").
//DOWNLOAD("Kerbin.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").
LIST FILES IN allFiles.
local dbgStep to 0.
FOR file IN allFiles {
  log ("Prior to ...Launch: " + allFiles[dbgstep]) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}
Notify("Kerbin Launch Commencing soon"). Wait 2.

Run Kerbin.Launch.ks(Target_Circ).
DOWNLOAD("Kerbin.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").
set allfiles to 0.
LIST FILES IN allFiles.
local dbgStep to 0.
FOR file IN allFiles {
  log ("Prior to ...Transfer: " + allFiles[dbgstep]) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}

Run Kerbin.Transfer.ks(Target_Transfer_Height,Target_Encounter_Angle,T_Goal).
//Run Mun.orbit.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 5.
