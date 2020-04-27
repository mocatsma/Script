//Kerbin transfer Script
Notify("Beginning Transfer Script").
Run orbit.ks.
Run Maneuver.ks.
Set TransferHeight = 2,863,334.
set MNV_DV to MNV_HOHMANN_DV(TransferHeight).
Set T1_MNV to MNV_Time(MNV_DV[0]).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Set T1_Start to Time:Seconds + ETA:Apoapsis - T1_MNV/2.
Set n1 to Node(T1_Start,0,0,MNV_DV[0]).
Notify("Beginning 1st Transfer Burn").
Add n1.
MNV_EXEC_NODE(TRUE).
Remove n1.
Set T2_Start to Time:Seconds + ETA:Apoapsis - T2_MNV/2.
Set n2 to Node(T2_Start,0,0,MNV_DV[1]).
Notify("Beginning 2nd Transfer Burn").
Add n2.
MNV_EXEC_NODE(TRUE).
Remove n2.
Notify("Transfer Burn completed").
SAS on.


//set forward to Prograde.
//Lock Steering to forward. Wait 10.
//Lock throttle to 1 - (Ship:Apoapsis/TransferHeight * 0.99).
//wait until Ship:Apoapsis > TransferHeight.
//SET prevThrust TO MAXTHRUST.
