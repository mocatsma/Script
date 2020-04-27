//Kerbin Launch

Notify("Begin the Launch, control to Ship").

Run Maneuver.ks.
Run AscentSat1Net.ks.

Set ascentProfile to List(
  //Altitude, Angle, thrust
  0,          90,     1,
  500,        85,     1,
  1500,       80,     1,
  2500,       75,     1,
  3500,       70,     1,
  4500,       65,     1,
  6500,       60,     1,
  10500,      50,     1,
  15500,      40,     1,
  22000,      30,     1,
  30000,      20,     1,
  35000,      15,     1,
  40000,      10,     1,
  45000,       5,     1,
  50000,       0,     0
).
Notify("Launch Ascent begins").
//Stage 1 Launch
Lock Throttle to 1. wait 1. Stage.
Execute_Ascent_Profile(90,ascentProfile).
SAS on.
lock steering to prograde.

Until apoapsis > 65000 and Ship:ALTITUDE > 60000 {
    PANELS ON.
//original code
  //Set p to Ship:Partsdubbed("MediumDishAntenna")[0].
  //Set m to p:Getmodule("ModuleRTAntenna").
  //m:DoEvent("Activate").
  //m:SetField("target","Mission CONTROL").
      print "Panels and Antenna Routine in ..Launch.ks Apoapsis ETA = " + ETA:Apoapsis .
      wait 1.
    }
Print "Waiting for ETA:Apoapsis < 30 ".
Wait until ETA:Apoapsis < 30.
Lock Throttle to 1.

//Wait for Orbit, stage as needed
Until Periapsis > 65000 {MNV_Burnout(True). Wait 0.01.
  print "Until Periapsis > 65000".
  IF ETA:Apoapsis > 30{
    Lock Throttle to 0.
    WAIT until ETA:Apoapsis = 30.
    Lock Throttle to 1.
  }
}
Lock Throttle to 0. Wait 1.

Notify("Launch Script Complete").
