//Kerbin Launch with solid rocket boosters
Parameter CircHeight.
Notify("Begin the Launch, control to Ship").

Run Maneuver.ks.
Run Ascent.ks.

Set AscentHeading to 90.
Set ascentProfile to List(
  //Altitude, Angle, thrust
  0,          90,     1,
  250,        89,     .5,
  1200,       88,     .5,
  2000,       87,     .5,
  2500,       80,     .5,
  5000,       75,     .5,
  7500,       70,     .85,
  10000,      65,     .95,
  15000,      60,     .95,
  20000,      55,     1,
  25000,      50,     1,
  30000,      35,     1,
  35000,      25,     1,
  40000,      10,     1,
  42000,       5,     1,
  48000,       0,     1
).
Notify("Launch Ascent begins").
//local OrbiterLog is "0:/partlist.txt".
//Stage 1 Launch
Lock Throttle to .1. wait 1. Stage.
Execute_Ascent_Profile(AscentHeading,AscentProfile,CircHeight).
log ("Exe_Asc_Pro completed") to OrbiterLog.
log( "Stage Fuel + Ox: " + Stage:Liquidfuel + " & "
+ Stage:Oxidizer ) to OrbiterLog.
//SAS on.
lock steering to heading(AscentHeading,0).
//Lock throttle to 1 - (Ship:Apoapsis/CircHeight * 0.99).
set MNV_DV to MNV_HOHMANN_DV(CircHeight).
Set T1_MNV to MNV_Time(MNV_DV[0]).
Set T2_MNV to MNV_Time(MNV_DV[1]).
Set DV_MNV to MNV_DV[0] + MNV_DV[1].
Print "Burntime #1 / #2 : " + T1_MNV  + " / " + T2_MNV.
log ("Current Ship logged: " + SHIP:NAME + ": CircTransfer -" +
CircHeight) to OrbiterLog.
Log ("Time: " + Time:Seconds) to OrbiterLog.
Log ("ETA & MNV_Time: " + ETA:Apoapsis + " & " + T1_MNV + " / " + T2_MNV) to OrbiterLog.
If ETA:Apoapsis - T1_MNV/2 < 30 {
  Set T1_Start to Time:Seconds + 2.
  log ("<30") to OrbiterLog.
} else If ETA:Apoapsis - (T1_MNV/2 + T2_MNV) < 300 {
  Set T1_Start to Time:Seconds + ETA:Apoapsis - (T1_MNV/2 + T2_MNV/2).
  log ("<300") to OrbiterLog.
} else { Set T1_Start to Time:Seconds + .5.}
Set n1 to Node(T1_Start,0,0,DV_MNV).
//log ("Start: " + T1_Start) to OrbiterLog.
Notify("Beginning 1st Transfer Burn").
Add n1.
MNV_EXEC_NODE(FALSE).
Remove n1.
Print "dV - Circ Node #1: " + MNV_DV[0] + " + " + MNV_DV[1].
//log ("dV - Circ Node #1: " + MNV_DV[0] + " + " + MNV_DV[1]) to OrbiterLog.

Set BurnoutThrust to Maxthrust.
Lock THROTTLE to 0.
PANELS ON.
LIGHTS ON.
local ETATimer is 50.
Local ETABurn is 16.
Local ETAGoal is 6.
Until Periapsis > CircHeight {
  If ETA:Apoapsis < ETATimer {
    lock THROTTLE to 1.
    BOCheck(BurnoutThrust).
    Set BurnoutThrust to Maxthrust.
    log ("Apoapsis ETA / Periapsis / ALT: ") to OrbiterLog.
    log (Eta:Apoapsis + " / " + Periapsis +
    " / " + Ship:ALTITUDE) to OrbiterLog.
    Print "ETATimer & ETABurn: " + ETATimer +
    " & " + ETABurn.
    wait ETABurn.
    If ETATimer > 20 and ETABurn > 10{
    Set ETATimer to ETATimer - 12.
    Set ETABurn to ETABurn - 4.
  } Else IF ETATimer > 10 and ETABurn > 6{
    Set ETATimer to ETATimer - 8.
    Set ETABurn to ETABurn - 1.
  }Else If ETATimer = 6 {
    Set ETATimer to 4.
  }

  Until ETA:Apoapsis > ETAGoal {
    Wait 1.}
}

//  log ("ETATimer & ETABurn: " + ETATimer + " & "
  //+ ETABurn) to OrbiterLog.
  Lock THROTTLE to 0.
  If PeriApsis > 20000 {
    Set ETATimer to 4.
    Set ETABurn to 1.
    Set ETAGoal to 2.
    Log ("Periapsis > 20000") to OrbiterLog.
  }
  Wait 1.
}

//Wait for Orbit, stage as needed
//Until Periapsis > 65000 {
  //BOCheck(BurnoutThrust).
  //Set BurnoutThrust to Maxthrust.
  //lock throttle to .5.
  //IF ETA:Apoapsis > 50{
    //Lock Throttle to .75.
    //WAIT until ETA:Apoapsis <= 40.
    //Lock Throttle to 1.
  //}
//}
BOCheck(BurnoutThrust).
Lock Throttle to 0. Wait .1.
Local vol is 1.
Local dbgStep is 0.
SWITCH TO vol.
LIST FILES IN allFiles.
FOR file IN allFiles {
  //log ("...Launch PERIAPSIS > CircHeight - "  +
  //allfiles[dbgStep] + " Step: " + dbgStep ) to OrbiterLog.
  set dbgStep to dbgStep + 1.
}
Notify("Launch Script Complete").
