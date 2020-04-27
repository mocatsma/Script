// Mission.ks episode 45
// Kevin Gisi
//Boot - Vanguard.ks
if not exists("1:/knu.ks")
copypath("0:/knu.ks", "1:/").
runpath("1:/knu.ks").
import("vanguard_mission.ks")().

// Knu.ks longstring
{
  local s is stack().
  local d is lex().
  global import is{parameter n.s:push(n).
    if not exists("1:/"+n)
    copypath("0:/"+n,"1:/").
    runpath("1:/"+n).
    return d[n].}.
    global export is{parameter v.
      set d[s:pop()] to v.}.
    }
© 20


{
local f is "1:/runmode.ks".
export({parameter d.
local r is 0.
if exists(f)set r to import("runmode.ks").
local s is list().
local e is lex().
local n is{parameter m is r+1.
if not exists(f)create(f).
local h is open(f).
h:clear().
h:write("export("+m+").").
set r to m.
}.
d(s,e,n).
return
{until r>=s:length{s[r]().
for v in e:values
v().
wait 0.
}
}.
}).
}
