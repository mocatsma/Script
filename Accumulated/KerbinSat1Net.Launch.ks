//Kerbin Launch

Notify("Begin the Launch, control to Ship").

Run Maneuver.ks.
Run AscentSat1Net.ks.

Set ascentProfile to List(
  //Altitude, Angle, thrust
  0,          90,     1,
  500,        88,     1,
  1500,       85,     1,
  2500,       81,     1,
  3500,       76,     1,
  5500,       70,     1,
  8500,       62,     1,
  12500,      51,     1,
  17500,      40,     1,
  28000,      30,     1,
  36000,      25,     1,
  45000,      20,     1,
  50500,      15,     1,
  55000,      10,     1,
  60000,       0,     0
).
Notify("Launch Ascent begins").
//Stage 1 Launch
Lock Throttle to 1. wait 1. Stage.
Execute_Ascent_Profile(90,ascentProfile).

Until apoapsis > 100000 and Ship:ALTITUDE > 65000 {
  //PARAMETER query.
  //Set qpart TO SHIP:PARTSDUBBED(query)[0].
  //FOR m IN qpart:MODULES {
    //  SET thismod TO qpart:GETMODULE(m).
      //LOG ("These are all the things that I can currently USE GETFIELD AND SETFIELD ON IN " + thismod:NAME + ":") TO partfaefile.
      //LOG thismod:ALLFIELDS TO partfaefile.
      //LOG ("These are all the things that I can currently USE DOEVENT ON IN " +  thismod:NAME + ":") TO partfaefile.
      //LOG thismod:ALLEVENTS TO partfaefile.
      //LOG ("These are all the things that I can currently USE DOACTION ON IN " +  thismod:NAME + ":") TO partfaefile.
      //LOG thismod:ALLACTIONS TO partfaefile.
      //Set m to m + 1.}




  // Deploy Fairing, Enable panels  & antenna
  //Set f to Ship:Partsdubbed("Fairing")[0].
  //Print "KS1N.Launch - Line 34 Fairing: " + f.
  //Print "Variables: f  " + f.
  //For SPm in f:MODULES{
    //SPm:Getmodule("Tag=Fairing"):DoEvent("Deploy").
    PANELS ON.
  //}
//  Module:Doevent("Deploy").
  //Toggle Panels.
  //local count to 0.
  //until count = 3{
    //Set p to Ship:Partsdubbed("MediumDishAntenna").
    //Print "KS1N.Launch - Line 39 MediumDishAntenna List: " + p.
    //For m in p :MODULES{
      //Print "KS1N.Launch - Line 42 MediumDishAntenna List[count]: " .//+ m.
      //m:Getmodule("MediumDishAntenna"):DoEvent("Activate").
      //if count = 0 {
        //m:SetField("target","Kerbin").
        //Print "First MedDish Antenna SetField".
      //} else
        //if count = 1 {
          //m:SetField("target","Active Vessel").
          //Print "Second MedDish Antenna SetField".
      //} else
        //if count = 2 {
          //m:Setfield("target","Mun").
          //Print "Third MedDish Antenna SetField".
      //}
          //local count to count + 1.
          //set m to m + 1.
      //wait 10.
      //}
//original code
  //Set p to Ship:Partsdubbed("MediumDishAntenna")[0].
  //Set m to p:Getmodule("ModuleRTAntenna").
  //m:DoEvent("Activate").
  //m:SetField("target","Mission CONTROL").
      print "Panels and Antenna Routine in ..Launch.ks".
    }
Wait until ETA:Apoapsis < 30.
Lock Throttle to 1.

//Wait for Orbit, stage as needed
Until Periapsis > 100000 {MNV_Burnout(True). Wait 0.01.
  print "Until Periapsis > 100000".
  IF ETA:Apoapsis > 30{
    Lock Throttle to 0. WAIT 5.
    Lock Throttle to 1.
  }
}
Lock Throttle to 0. Wait 1.

Notify("Launch Script Complete").
