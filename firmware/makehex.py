#!/usr/bin/env python3
#
# This is free and unencumbered software released into the public domain.
#
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.

from sys import argv

binfile = argv[1]
hexfile = argv[2]

with open(binfile, "rb") as f:
    bindata = f.read()

with open(hexfile, "w") as f:
    for byte in bindata:
        f.write("%02x\n" % byte)
