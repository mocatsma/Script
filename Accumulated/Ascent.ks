// Execute Ascent Profile v1.0.0
// Kevin Gisi
// http://youtube.com/gisikw

FUNCTION EXECUTE_ASCENT_STEP {
  PARAMETER direction.
  PARAMETER minAlt.
  PARAMETER newAngle.
  PARAMETER newThrust.

  SET prevThrust TO MAXTHRUST.
  //WHEN ALTITUDE > 59000 then DeployFairing(). wait 0.01.
  UNTIL FALSE {
    IF Apoapsis > 68000 {
      print "Apoapsis > 68000".
      LOCK STEERING TO HEADING(direction, newAngle).
      LOCK THROTTLE TO 0.
      Wait 1.
      BREAK.
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
      BREAK.
      print "Exe_Asc_Step - line 28 After Break".
    }
//print "Exe_Asc_Step - line 30 After Break Apoapsis: " + Apoapsis.
    WAIT 0.1.
  }
}

FUNCTION EXECUTE_ASCENT_PROFILE {
  PARAMETER direction.
  PARAMETER profile.

  SET step TO 0.
  UNTIL step >= profile:length - 1 {
    EXECUTE_ASCENT_STEP(
      direction,
      profile[step],
      profile[step+1],
      profile[step+2]
    ).
    print "Exe_Asc_Prof Profile: " + direction +" : " +
    Profile[step] +" : "+
    Profile[step + 1] +" : " +
    Profile[step + 2].
    SET step TO step + 3.
    print "Exe_Asc_Prof Step: " + Step + " Apoapsis: " + Apoapsis.
  }
}

//FUNCTION DeployFairing{
  //Set p to Ship:Partsdubbed("PayloadFairing")[0].
  //Set m to p:Getmodule("Deploy").
  //m:DoEvent("Activate").
//}
