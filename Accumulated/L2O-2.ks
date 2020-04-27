lock throttle to 1.
stage.
set stagenumber to 1.
Set maxstagenumber to 4.
lock targetPitch to 98.963 - 1.03287 * alt:radar^0.409511.
set targetDirection to 90.
lock steering to heading(targetDirection, targetPitch).
wait 10.
set oldThrust to ship:avaiLablethrUST.
until apoapsis > 80000 {
  print apoapsis.
  print stagenumber.
  print oldthrust.
  wait .5.
  if ship:availablethrust < (oldThrust - 10) and (stagenumber < maxstagenumber) {
    stage.
    wait 1.
    set stagenumber to stagenumber + 1.
   // if stagenumber = maxstagenumber {
   // exit.
    //}
    //lock throttle to (throttle + .25).
    set oldThrust to ship:availablethrust.
  else.
    set oldthrust to ship:availablethrust.
  }
}
lock throttle to .50.
Print apoapsis.
print stagenumber.

lock throttle to 0.
