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
  5500,       60,     1,
  8500,       55,     1,
  12500,      40,     1,
  20000,      35,     .8,
  30000,      25,     .75,
  35000,      20,     .75,
  40000,      10,     1,
  45000,       5,     1,
  50000,       0,     0
).
Notify("Launch Ascent begins").
//Stage 1 Launch
Lock Throttle to 1. wait 1. Stage.
Execute_Ascent_Profile(90,ascentProfile).
wait .5.
SAS on.
lock throttle to .5.
SET prevThrust TO MAXTHRUST.
print "MAXTHRUST: " + MAXTHRUST.
Until apoapsis > 85000 and Ship:ALTITUDE > 75000 {
    PANELS ON.
    IF MAXTHRUST < (prevThrust - 10) {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT .3. STAGE. WAIT .1.
      LOCK THROTTLE TO currentThrottle.
      SET prevThrust TO MAXTHRUST.
    }

//original code
  //Set p to Ship:Partsdubbed("MediumDishAntenna")[0].
  //Set m to p:Getmodule("ModuleRTAntenna").
  //m:DoEvent("Activate").
  //m:SetField("target","Mission CONTROL").
      print "Panels and Antenna Routine in ..Launch.ks Apoapsis ETA = " + ETA:Apoapsis .

      wait 5.
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
