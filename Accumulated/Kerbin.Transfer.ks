//Kerbin transfer Scripts
Notify("Beginning Transfer Script").
Run orbit.ks.
Run Maneuver.ks.
Set TransferHeight to Mun:Apoapsis.

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
