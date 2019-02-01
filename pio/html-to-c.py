# Invoke the html-to-c.sh script to generate C arrays from webpage content. 
import sys, subprocess

Import('env')

#
# Dump build environment (for debug)
#print env.Dump()
#
retcode = subprocess.call("./esp-scripts/sh/html-to-c.sh")

if retcode != 0:
    sys.exit(retcode)
