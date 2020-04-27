//Kerbin Launch

Notify("Begin the Launch, control to Ship").

Run Maneuver.ks.
Run Ascent.ks.

Set ascentProfile to List(
  //Altitude, Angle, thrust
  0,          90,     1,
  500,        80,     1,
  4500,       70,     1,
  15000,      55,     1,
  20000,      50,     1,
  25000,      45,     1,
  30000,      40,     1,
  35000,      30,     1,
  40000,      20,     1,
  50000,      10,     1,
  55000,       0,     1,
  56000,       0,     0
).
Notify("Launch Ascent begins").
//Stage 1 Launch
Lock Throttle to 1. wait 1. Stage.
Execute_Ascent_Profile(90,ascentProfile).

Wait until ETA:Apoapsis < 30.
Lock Throttle to 1.
//Wait for Orbit, stage as needed
Until Periapsis > 70000 {MNV_Burnout(True). Wait 0.01.
  IF ETA:Apoapsis > 30{
    Lock Throttle to 0. WAIT 10.
    Lock Throttle to 1.
  }
}
Lock Throttle to 0. Wait 1.
// Enable panels  & antenna
Toggle Panels.
//Set p to Ship:Partsdubbed("Communitron 16")[0].
//Set m to p:Getmodule("ModuleRTAntenna").
//m:DoEvent("Activate").
//m:SetField("target","Active-vessel").

Notify("Launch Script Complete").
