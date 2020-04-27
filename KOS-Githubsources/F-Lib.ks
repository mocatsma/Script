Function TLM_DeltaV {
  list engines in ShipEngines.
  set drymass to Ship:Mass * ((Ship:liquid fuel + Ship Oxidizer)* 0.005).
  return ship:engines[0]:ISP * 9.81 * LN(Ship:Mass/drymass).
}

Function MNV_Time{
  parameter dV.
  LIST Engines in en.
  local f is en[0]:MaxThrust * 1000. //Engine Thrust (Kg *m/s2)
  local m is SHIP:Mass * 1000.       //Starting Mass (Kg)
  local e is CONSTANT():E.           //Base of Natural Log
  local p is en[0]:ISP.              //Engine ISP (s)
  local g is 9.80665.                //Gravitational accel constant (m/s2)

  Return g * m * p * (1- e^(-dV/(g*p))) / f.
}

Function MNV_Hohman_DV{
  parameter desiredaltidude.

  set u to SHIP:OBT:BODY:MU.
  set r1 to SHIP:OBT:SEMIMAJORAXIS.
  Set r2 to desiredaltidude + SHIP:OBT:BODY:RADIUS.
  //v1
  set v1 to SQRT(u/r1) * (SQRT((2 * r2)/(r1 + r2))-1).
  //v2
  set v2 to SQRT(u/r2) * (1 - SQRT((2 * r1)/(r1 +r2))).
  Return List(v1,v2).
}

Print "Testing Structures:".
Print "Ship's DeltaV: " + TLM_DeltaV.
Print "Time for 100 m/s manuever: " + MNV_Time(100).
Print "Transfer DeltaV to 400KM: " + MNV_Hohman_DV(400000).
