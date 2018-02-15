{-
Build with 'cabal new-build', run with e.g:
  gdb -q dist-newstyle/build/x86_64-linux/ghc-8.2.1/breakpoint-0.1.0.0/x/breakpoint-example/build/breakpoint-example/breakpoint-example

Then in gdb type 'run' and you'll get to the breakpoints
and have the label printed out as well!

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x4200107030 "0") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb) c
Continuing.

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x4200107070 "1") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb)
Continuing.

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x42001070b0 "2") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb)
Continuing.

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x42001070f0 "3") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb)
Continuing.

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x4200107130 "4") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb)
Continuing.

Program received signal SIGTRAP, Trace/breakpoint trap.
c_breakpoint (label=0x4200107170 "5") at cbits/breakpoint.c:29
29	  labelled(label);
(gdb)
Continuing.
[0,2,4,6,8,10]
-}

import System.Breakpoint

main :: IO ()
main = print $ map (\i -> breakOnEval (show i) (2*i)) [0..5]
