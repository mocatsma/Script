core:part:getmodule("KOSProcessor"):doevent("Open Terminal").
// Generalized Boot Script v1.0.1
// Kevin Gisi
// http://youtube.com/gisikw
// The ship will use updateScript to check for new commands from KSC.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
local OrbiterLog is "0:/partlist.txt".
// Display a message
IF ship:altitude > 5000 {
  set inflight to TRUE.
}ELSE {set inflight to FALSE.}

FUNCTION NOTIFY {
  PARAMETER message.
  HUDTEXT("kOS: " + message, 5, 2, 50, YELLOW, false).
}
// Detect whether a file exists on the specified volume
FUNCTION HAS_FILE {
  PARAMETER name.
  PARAMETER vol.
  SWITCH TO vol.
  LIST FILES IN bootFiles.
  set dbgStep to 0.
  FOR file IN bootFiles {
    Log("HasFile Fx - bootFiles List:" + dbgstep +
    ":" + bootFiles[dbgstep] + " vol:" + vol) to OrbiterLog.
    IF file:NAME = name {
      SWITCH TO 1.
      RETURN TRUE.
    }
    set dbgStep to dbgStep + 1.
  }
  SWITCH TO 1.
  RETURN FALSE.
}
// First-pass at introducing artificial delay. ADDONS:RT:DELAY(SHIP) represents
// the line-of-site latency to KSC, as per RemoteTech
FUNCTION DELAY {
  SET dTime TO ADDONS:RT:DELAY(SHIP) * 3. // Total delay time
  SET accTime TO 0.                       // Accumulated time
  UNTIL accTime >= dTime {
    SET start TO TIME:SECONDS.
    WAIT UNTIL (TIME:SECONDS - start) > (dTime - accTime) OR NOT ADDONS:RT:HASCONNECTION(SHIP).
    SET accTime TO accTime + TIME:SECONDS - start.
  }
}
// Get a file from KSC
FUNCTION DOWNLOAD {
  PARAMETER name.
  //local OrbiterLog is "0:/partlist.txt".
  log ("Download in Boot: "+ name) to OrbiterLog.
  DELAY().
  local lfp is "1:/" + name. //local file path
  local afp is "0:/" + name. //archive file path
  print "Download(): " + name.
  IF exists(lfp) {
    print "Exist Locally: in 1 so Deletepath".
    //log ("Exists Locally: "+ name) to OrbiterLog.
    DELETEPATH(lfp).
  }
  IF exists(afp) {
    //log ("Archive Exists: "+ name) to OrbiterLog.
    COPYPATH(afp,lfp).//copy from archive
  }
}
// Put a file on KSC
FUNCTION UPLOAD {
  PARAMETER name.
  DELAY().
  local lfp is "1:/" + name. //local file path
  local afp is "0:/" + name. //archive file path
  IF EXISTS(afp) {
    DELETEPATH(afp).
  }
  IF EXISTS(lfp) {
    COPYPATH(lfp,afp).
  }
}
// Run a library, downloading it from KSC if necessary
FUNCTION REQUIRE {
  PARAMETER name.
  DELAY().
  local lfp is "1:/" + name. //local file path
  local afp is "0:/" + name. //archive file path
  log("FxRequire - Archive: " + afp + " Local: " + lfp) to OrbiterLog.
  IF NOT EXISTS(lfp) { DOWNLOAD(name).
    log ("lfp does not exist - downloaded") to OrbiterLog.
  }
  MOVEPATH(lfp,"tmp.exec.ks").
  RUN tmp.exec.ks.
  MOVEPATH("tmp.exec.ks",lfp).
}
// THE ACTUAL BOOTUP PROCESS
SET updateScript TO SHIP:NAME + ".update.ks".
local lfp is "1:/" + updateScript. //local file path
local afp is "0:/" + updateScript. //archive file path
// If we have a connection, see if there are new instructions. If so, download
// and run them.
IF ADDONS:RT:HASCONNECTION(SHIP) and not inflight {
  IF EXISTS(afp) {
    log ("Not Inflight") to OrbiterLog.
    DOWNLOAD(updateScript).
    Switch to 0.
    MOVEPATH(afp,"oSatNet1-x.update.ks").
    SWITCH TO 1.
    IF EXISTS("1:/update.ks") {
      DELETEPATH("1:/update.ks").
    }
    MOVEPATH(updateScript,"1:/update.ks").
    RUNPATH("1:/update.ks").
    DELETEPATH("1:/update.ks").
  }
} ELSE {
  IF ADDONS:RT:HASCONNECTION(SHIP) and inflight {
    IF EXISTS(afp) {
      log ("Inflight") to OrbiterLog.
      DOWNLOAD(updateScript).
      Switch to 0.
      MOVEPATH(afp,"oSatNetxinflight.update.ks").
      SWITCH TO 1.
      IF EXISTS("1:/update.ks") {
        DELETEPATH("1:/update.ks").
      }
      MOVEPATH(updateScript,"1:/update.ks").
      RUNPATH("1:/update.ks").
      DELETEPATH("1:/update.ks").
    }
  }
}
// If a startup.ks file exists on the disk, run that.
IF EXISTS("1:/startup.ks") {
  RUNPATH("1:/startup.ks").
} ELSE {
  WAIT UNTIL ADDONS:RT:HASCONNECTION(SHIP).
  WAIT 10. // Avoid thrashing the CPU (when no startup.ks, but we have a
           // persistent connection, it will continually reboot).
  REBOOT.
}
