// K2Mun Orbiit Boot Script - new folder in script
// added for new Sandbox experiments
// Kevin Gisi
// http://youtube.com/gisikw

{
  core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
  for dependency in list(
    "mission_runner.v0.1.0.ks",
    "hillclimb.v0.1.0.ks",
    "transfer.v0.2.3.ks",
    "maneuver.v0.1.0.ks",
    "K2MunMission1.ks"
  )
    {
    if not exists("1:/" + dependency) copypath("0:/" + dependency, "1:/").
    runpath("1:/" + dependency).
  }
  global logfile is "0:/K2MunLog.txt".
  log("Boot file K2MunOrbits 5-6-20") to logfile.

  run_mission(K2MunMission1["sequence"], K2MunMission1["events"]).
}
