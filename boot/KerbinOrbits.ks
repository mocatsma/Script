// Herald Boot Script - new folder in script
// added for new Sandbox experiments
// Kevin Gisi
// http://youtube.com/gisikw

{
  core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
  for dependency in list(
    "mission_runner.v0.1.0.ks",
    "hillclimb.v0.1.0.ks",
    "maneuver.v0.1.0.ks",
    "KerbinOrbit1.ks"
  )
    {
    if not exists("1:/" + dependency) copypath("0:/" + dependency, "1:/").
    runpath("1:/" + dependency).
  }
  global logfile is "0:/KerbinOrbitLog.txt".
  log("Boot file KerbinOrbit 5-4-20") to logfile.
  run_mission(KerbinOrbit1["sequence"], KerbinOrbit1["events"]).
}
