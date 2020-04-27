// Execute Ascent Profile v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.
  Parameter TransferHeight.

  SET prevThrust TO MAXTHRUST.
  UNTIL FALSE {
    IF Apoapsis > TransferHeight and ALTITUDE > 65000 {
      print "Apoapsis > TransferHeight and Alt > 65000".
      LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO 0.
      Wait .1.
      BREAK.
    }else if Apoapsis > TransferHeight and ALTITUDE < 65000{
      Print "TransferHeight with Altitude < 65000".
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      Set Starttime to time:seconds + ETA:Apoapsis - 45.
      Wait Until time:seconds >= Starttime.
      Print "Until ETA:Apo = Starttime: " + ETA:Apoapsis +":" + Starttime.
      LOCK THROTTLE to currentThrottle.
      lock steering to heading(direction,0).
      print "Waiting for Periapsis > TransferHeight".
      wait until Periapsis > TransferHeight.
      print "Periapsis > TransferHeight".
      set Throttle to 0.
      unlock steering.
    }
    IF MAXTHRUST < (prevThrust - 10) {
      SET currentThrottle TO THROTTLE.
      LOCK THROTTLE TO 0.
      WAIT .3. STAGE. WAIT .7.
      LOCK THROTTLE TO currentThrottle.
      SET prevThrust TO MAXTHRUST.
    }

    IF ALTITUDE > minAlt {
      print "Exe_Asc_Step - line 24 Altitude > minAlt: " + ALTITUDE.
      LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO newThrust.
      wait .01.
      BREAK.
      }
//print "Exe_Asc_Step - line 30 After Break Apoapsis: " + Apoapsis.
    WAIT .01.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.
  Parameter TransferHeight.

  SET step TO 0.
  UNTIL step >= profile:length - 1 or Ship:Apoapsis  > TransferHeight {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2],
      TransferHeight
    ).
    print "AscentSatScan - " + direction +" : " +
    Profile[step] +" : "+
    Profile[step + 1] +" : " +
    Profile[step + 2].
    SET step TO step + 3.
    print "Step: " + Step + " Apo/Periapsis: " + Apoapsis + "/ " + Periapsis.
  }
  lock steering to heading(direction,0).
  lock Throttle to 0.
}
