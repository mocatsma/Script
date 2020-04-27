// ooSatScan-1.ks

print "X:update.ks".

// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
DOWNLOAD("AscentSatScan.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("KerbinSatScan.Launch.KS").
DOWNLOAD("KerbinSatScan.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").

Notify("Kerbin Launch Commencing soon"). Wait 5.

Run KerbinSatScan.Launch.ks.
Run KerbinSatScan.Transfer.ks.
//Run Mun.orbit.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 10.
