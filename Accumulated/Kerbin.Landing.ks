//Kerbin Landing
Notify("Beginning Landing Script").
Run Maneuver.ks.
Run Lib_pid.ks.
Run Telemetry.ks.

Set Margin to 100.
Function Upward {
  If ship:verticalspeed < 0 {
    Return SRFRetrograde.
  } ELSE {
    Return Heading(90,90).
  }
}
Notify("Waiting to enter Mun's SOI").
Wait until Ship:Body = Mun.
Lock steering to Upward(). Wait 10.

Notify("Waiting to be 50km above Mun's surface").
Wait until Alt:Radar < 50000.
Lights on. Toggle Brakes.

Lock Throttle to 1.
Wait until MNV_Burnout(True).
Lock throttle to 0.
Gear off. wait 1. Gear on.

Wait until TLM_TTI(margin) <= MNV_Time(Abs(Ship:VerticalSpeed)).
Notify("Beginning Suicide Burn").
Lock throttle to 1.
Wait until Ship:VerticalSpeed > -20.
Notify("Entering controllable range. PID Controller Enabled.").
Set hoverPID to PID_Init(0.05, 0.005, 0.01,0, 1).
Set pidThrottle to 0.
Lock Throttle to pidThrottle.

set targetDescent to -20.

When Alt:Radar < 100 then {
  set targetDescent to -5.
  Lock steering to heading(90,90).
}
When Alt:Radar < 20 then {
  set targetDescent to -2.
}
 Until Ship:Status = "Landed" {
   set pidThrottle to PID_seek(hoverPID, targetDescent, Ship:VerticalSpeed).
   Wait 0.001.
 }
 set pidThrottle to 0.
 Unlock Steering.
 Notify("Landed").
 Notify("Landing Script Completed").
