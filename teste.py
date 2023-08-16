#!/usr/bin/env python3

import subprocess
import re

def run_exa_command(path, show_hidden):
    exa_options = ["exa", "-lgh", "-s", "name", "--color=always", "--group-directories-first", "--icons", "--octal-permissions"]
    if show_hidden:
        exa_options.append("-a")
    exa_options.append(path)

    exa_output = subprocess.check_output(exa_options, text=True)

    return exa_output

def process_output(output):
    lines = output.split('\n')
    header = lines[0]
    data_lines = lines[1:]

    formatted_lines = []

    for line in data_lines:
        fields = re.split(r'\s+', line.strip(), maxsplit=6)
        if len(fields) == 7:
            user, group, permission, octal, size, date_modified, name = fields
            formatted_line = f"{user}\t{group}\t{permission}\t{octal}\t{size}\t{date_modified}\t{name}"
            formatted_lines.append(formatted_line)

    return [header] + formatted_lines

def main():
    show_hidden = False
    path = "."

    if len(sys.argv) > 1 and sys.argv[1] == "-a":
        show_hidden = True

    if len(sys.argv) > 2:
        path = sys.argv[2]

    exa_output = run_exa_command(path, show_hidden)
    formatted_output = process_output(exa_output)

    for line in formatted_output:
        print(line)

if __name__ == "__main__":
    import sys
    main()
