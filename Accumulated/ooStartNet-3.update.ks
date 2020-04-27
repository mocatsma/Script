// L2O-1.ks

print "X:update.ks".

// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
DOWNLOAD("AscentSat1Net.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("KerbinSat1Net.Launch.KS").
DOWNLOAD("KerbinSat1Net.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").

Notify("Kerbin Launch Commencing soon"). Wait 5.

Run KerbinSat1Net.Launch.ks.
Run KerbinSat1Net.Transfer.ks.
//Run Mun.orbit.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 10.
