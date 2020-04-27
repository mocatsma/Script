// Herald Boot Script - new folder in script
// added for new Sandbox experiments
// Kevin Gisi
// http://youtube.com/gisikw

{
  for dependency in list(
    "mission_runner.v0.1.0.ks",
    "hillclimb.v0.1.0.ks",
    "transfer.v0.2.1.ks",
    "maneuver.v0.1.0.ks",
    "herald_mission.ks"
  ) {
    if not exists("1:/" + dependency) copypath("0:/KSP_1_9" + dependency, "1:/").
    runpath("1:/" + dependency).
  }

  run_mission(herald_mission["sequence"], herald_mission["events"]).
}
