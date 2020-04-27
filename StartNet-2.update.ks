Set TransferHeight to 85000.
print "X:update-2.ks".
Notify("Beginning Transfer Script").
Run orbit.ks.
Run Maneuver.ks.
//Set TransferHeight to Mun:Apoapsis.

Function ISH {
  Parameter a.
  Parameter b.
  Parameter Ishyness.

  Return a - ishyness < b and a + ishyness > b.
}
//wait for window
Notify("Waiting for 111 - degree angle from Mun").
Until ISH(Target_Angle("Mun"),111,0.5) {
  Print Target_Angle("Mun").
  wait 10.
}
//Mun Transfer
Notify("Beginning Transfer Burn").
set forward to Prograde.
Lock Steering to forward. Wait 10.
Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
wait until Ship:Apoapsis > TransferHeight.

// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
//DOWNLOAD("AscentSat1Net.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
//DOWNLOAD("Kerbin.Launch.KS").
DOWNLOAD("Kerbin.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").

Notify("Kerbin Transfer Commencing soon"). Wait 5.

//Run Kerbin.Launch.ks.
//Run Kerbin.Transfer.ks.
//Run KerbinGeo.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 10.
