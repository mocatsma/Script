// L2O-1.ks

print "X:update.ks".

// Libraries
DOWNLOAD("Lib_Pid.KS").
DOWNLOAD("Maneuver.KS").
DOWNLOAD("Orbit.KS").
DOWNLOAD("Telemetry.KS").
DOWNLOAD("Ascent.KS").
DOWNLOAD("Autopilot.KS").

// Mission Scripts
DOWNLOAD("Kerbin.Launch.KS").
DOWNLOAD("Kerbin.Transfer.KS").
//DOWNLOAD("Kerbin.Landing.KS").

Notify("Kerbin Launch Commencing soon"). Wait 5.

Run Kerbin.Launch.ks.
Run Kerbin.Transfer.ks.
Run Mun.orbit.ks.
//Run Kerbin.Landing.ks.
print "ending update.ks".

wait 10.
