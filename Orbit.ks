// Scripts from
// Kevin Gisi http://youtube.com/gisikw
//jonnyboyC/ksp


//@lazyglobal off.

FUNCTION LNG_TO_DEGREES {
  PARAMETER lng.
print "LNG_DEGREES".
  RETURN MOD(lng + 360, 360).
}

FUNCTION ORBITABLE {
  PARAMETER name.
  print "Orbitable".
  LIST TARGETS in vessels.
  log ("Fx Orbitable Target Vessles List" + vessels)
  to OrbiterLog.
  FOR vs IN vessels {
    IF vs:NAME = name {
      RETURN VESSEL(name).
    }
  }

  RETURN BODY(name).
}

FUNCTION TARGET_ANGLE {
 PARAMETER target.

 RETURN MOD(
   LNG_TO_DEGREES(ORBITABLE(target):LONGITUDE)
   - LNG_TO_DEGREES(SHIP:LONGITUDE) + 360,
   360
 ).
}

FUNCTION RDV_STEER {
  PARAMETER vector.

  LOCK STEERING TO vector.
  WAIT UNTIL VANG(SHIP:FACING:FOREVECTOR, vector) < 2.
}

FUNCTION RDV_APPROACH {
  PARAMETER craft, speed.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(craft:POSITION). LOCK STEERING TO craft:POSITION.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, ABS(speed - relativeVelocity:MAG) / maxAccel).

  WAIT UNTIL relativeVelocity:MAG > speed - 0.1.
  LOCK THROTTLE TO 0.
  LOCK STEERING TO relativeVelocity.
}

FUNCTION RDV_CANCEL {
  PARAMETER craft.

  LOCK relativeVelocity TO craft:VELOCITY:ORBIT - SHIP:VELOCITY:ORBIT.
  RDV_STEER(relativeVelocity). LOCK STEERING TO relativeVelocity.

  LOCK maxAccel TO SHIP:MAXTHRUST / SHIP:MASS.
  LOCK THROTTLE TO MIN(1, relativeVelocity:MAG / maxAccel).

  WAIT UNTIL relativeVelocity:MAG < 0.1.
  LOCK THROTTLE TO 0.
}

FUNCTION RDV_AWAIT_NEAREST {
  PARAMETER craft, minDistance.

  UNTIL 0 {
    SET lastDistance TO craft:DISTANCE.
    WAIT 0.5.
    IF craft:distance > lastDistance OR craft:distance < minDistance { BREAK. }
  }
}


FUNCTION NextOrbit {
  parameter Inclin, Eccent, SemiMajor,LongAsc,ArgPeri,MeanAnom,Epoch,Name.
  Return Creatorbit(Inclin, Eccent, SemiMajor,LongAsc,ArgPeri,MeanAnom,Epoch,Name).
}
