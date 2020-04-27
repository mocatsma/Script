// Execute Ascent Profile v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw
//local OrbiterLog is "0:/partlist.txt".
FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.
  Parameter CircularAlt.
  LOCK STEERING TO HEADING(direction, newAngle).
  LOCK THROTTLE TO newThrust.
  SET prevThrust TO MAXTHRUST.
  UNTIL Altitude > minAlt {
    IF Apoapsis > CircularAlt {
      print "Apoapsis > CircularAlt".
      log("Apoapsis > CircularAlt Alt>MinAlt: " + ALTITUDE + " / ETA:Apo / " + ETA:Apoapsis) to OrbiterLog.
      //LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO .1.
      Wait until ETA:Apoapsis < 50 or Altitude > minAlt.
      Lock THROTTLE to newThrust.
      print "Apoapsis < 50 sec - Newthrust".
      log("Apoapsis > CircularAlt Waited Is ETA:Apo<50: " + ETA:Apoapsis) to OrbiterLog.
      BREAK.
    }
    IF MAXTHRUST < (prevThrust - 10) {
      print "Alt / minAlt: " + ALTITUDE + " / " + minAlt.
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT .3. STAGE. WAIT .1.
      LOCK THROTTLE TO currentThrottle.
      SET prevThrust TO MAXTHRUST.
    }

    IF ALTITUDE > minAlt {
      wait .01.
      BREAK.
      }
    WAIT .01.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.
  Parameter CircHeight.

  SET step TO 0.
  log("Profile Length: " + Profile:length) to OrbiterLog.
  UNTIL step >= profile:length - 1 or Ship:Altitude > 62000 {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2],
      CircHeight
    ).
    //log ("AscentSat1Net - " + direction +" : " +
    //Profile[step] +" : "+
    //Profile[step + 1] +" : " +
    //Profile[step + 2] + " : " + step) to OrbiterLog.
    log ("Ascent Step Altitude :" + ALTITUDE) to OrbiterLog.
    print "Ascent - " + direction +" : " +
    Profile[step] +" : "+
    Profile[step + 1] +" : " +
    Profile[step + 2].
    SET step TO step + 3.
    wait .01.
    print "Step: " + Step + " Apo/Periapsis: " + Apoapsis + "/ " + Periapsis.
  }
  Log ("Ascent_Step completed : Step: " + step) to OrbiterLog.
}
