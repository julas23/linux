#!/usr/bin/env python3

import sys

# Print header
print("\033[1mUser\tGroup\tPermission\tOctal\tSize\tDate Modified\tName\033[0m")

# Process and print each line
for line in sys.stdin:
    fields = line.split()
    if len(fields) >= 9:
        user, group, permission, octal, size, date_modified = fields[2], fields[3], fields[0], fields[1], fields[4], " ".join(fields[5:8])
        name = " ".join(fields[8:])
        print(f"{user}\t{group}\t{permission}\t{octal}\t{size}\t{date_modified}\t{name}")
