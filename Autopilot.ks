//Autopilot
// Brakes and RCS used to set and trigger the maneuver.
// new maneuvers can be added and toggling the RCS will autowarp to the new maneuver

run maneuver.ks.
Notify("Maneuver Autopilot initiated").
Notify("RCS: Execute Maneuver. Brakes: Done").

Set done to false.
ON Brakes {set done to True.}

Set rcsState to RCS.
Until done{
  If RCS <> rcsState{
    Set rcsState to RCS.
    Notify("RCS toggled to execute Maneuver").
    MNV_EXEC_NODE(True).
    Notify("Done").
  }
  Wait 0.1.
}
Notify("Maneuver Autopilot terminated").
