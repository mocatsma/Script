function main {
  doLaunch().
  DoAscent().
  until Apoapsis > 100000{
    DoAutostage().
  }
  DoShutdown().


function doLaunch {
  lock throttle to 1.
  dosafestage().
}
doLaunch().

function DoAscent{
  lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
  set targetDirection to 90.
  lock steering to heading(targetDirection, targetPitch).
}
DoAscent().

Function DoAutostage{
  if not(defined OldThrust){
    declare global OldThrust to ship:availablethrust.
    declare global stagenumber to 1.
    declare global maxstagenumber to 4.
  }
  if ship:availablethrust< (OldThrust - 10) {
    dosafestage().
    wait 1.
    declare global OldThrust to ship:availablethrust.
    print "Stage: " + stagenumber + " / " + maxstagenumber.
    print "Apoapsis: " + Apoapsis.
    print "Thrust: " + OldThrust
  }
}

function DoShutdown {
  lock throttle to 0.
  lock steering to prograde.
  wait until false.
}
doShutdown().

function dosafestage {
  wait until stage:ready.
  stage.
  declare global stagenumber to stagenumber + 1.
}

main().
