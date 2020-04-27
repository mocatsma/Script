//Mun Orbit Periapsis = 565.65km Apoapsis = 1254.85 - phasing Orbit ECC = 0.45077
//3 satellite network 4 hours apart.

Notify("Beginning Mun Orbit Script").
Run Maneuver.ks.
Run Autopilot.ks.

Set PhasingOrbit to Createorbit(0,0.45077,565000,0,0,0,0,Mun).

Print "Mun Periapsis: " + PhasingOrbit:Periapsis.
Print "Mun Apoapsis: " + PhasingOrbit:Apoapsis.
