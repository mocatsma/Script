//Kerbin transfer Scripts
Notify("Beginning Transfer Script").
Run orbit.ks.
Run Maneuver.ks.
Set TransferHeight to 4906300.
Notify("Beginning Transfer Burn").
set forward to Prograde.
Lock Steering to forward. Wait 10.
Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
wait until Ship:Apoapsis > TransferHeight.
