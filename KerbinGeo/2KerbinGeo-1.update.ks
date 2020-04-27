// 2KerbinGeo.ks

print "2X:update.ks".

// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("KerbinGeo.Transfer.KS").
Run KerbinSatScan.Transfer.ks.
Notify("Transfer Script Completed").
wait 10.
