// Herald Boot Script - new folder in script
// added for new Sandbox experiments
// Kevin Gisi
// http://youtube.com/gisikw

{
  core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
  for dependency in list(
    "mission_runner.v0.1.0.ks",
    "hillclimb.v0.1.0.ks",
    "transfer.v0.2.2.ks",
    "maneuver.v0.1.0.ks",
    "NetSat2Mission1.ks"
  )
    global logfile is "0:/FlightLog.txt".
    log("Boot file NetSat2") to logfile.
    {
    if not exists("1:/" + dependency) copypath("0:/" + dependency, "1:/").
    runpath("1:/" + dependency).
  }

  run_mission(NetSat2Mission1["sequence"], NetSat2Mission1["events"]).
}
