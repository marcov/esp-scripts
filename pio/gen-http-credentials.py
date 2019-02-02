# Copy a standard credentials file if it does not exist.
import sys, os, subprocess

Import('env')

CREDENTIALS = {
    "src" : "./esp-scripts/c/credentials.cc",
    "dst" : "./src/credentials.cc"
}

#
# Dump build environment (for debug)
#print env.Dump()
#

if os.path.isfile(CREDENTIALS["dst"]):
    sys.stdout.write("WARN: credentials file {} already exits.".format(CREDENTIALS["dst"]))
else:
    retcode = subprocess.call(["cp", CREDENTIALS["src"], CREDENTIALS["dst"]])
    if retcode != 0:
        sys.exit(retcode) 
