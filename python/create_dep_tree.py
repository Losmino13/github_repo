# simple script for creating dependency tree from knife command output
# do
# knife deps cookbook_name --tree --recurse > file.deps 2> /dev/null
# change open line in parse_deps2()
# it will print tree like we have on wiki

import re
import argparse
#'ascii-ex': ('\u2502', '\u251c\u2500\u2500 ', '\u2514\u2500\u2500 ')
next_row = '\u2514\u2500\u2500'
pipe = '\u2502'
t = '\u251c\u2500\u2500'


# parse deps1 NOT USED check main
def parse_deps1():
    with open("/Users/milos.milisavljevic/dev/issues/DCES-4297818/es_chef-server.deps", "r") as file:
        for line in file:
            if re.search('[^ ]', line).start() == 0:
                linee = line.strip()
                lines = linee
                print(lines)

            if re.search('[^ ]', line).start() == 2:
                linee = line.strip()
                lines = next_row + linee
                print(lines)
            
            if re.search('[^ ]', line).start() == 4:
                lines = pipe + " " + next_row + linee
                print(lines)
            
            if re.search('[^ ]', line).start() == 6:
                linee = line.strip()
                lines = pipe + " " + pipe + " " + next_row + linee
                print(lines)

            if re.search('[^ ]', line).start() == 8:
                linee = line.strip()
                lines = pipe + " " + pipe + " " + pipe + " " + next_row + linee
                print(lines)

            if re.search('[^ ]', line).start() == 10:
                linee = line.strip()
                lines = pipe + " " + pipe + " " + pipe + " " + pipe + " " + next_row + linee
                print(lines)

def parse_deps2():
    with open("/Users/milos.milisavljevic/dev/issues/DCES-4297818/es_chef_server.deps", "r") as file:
        for line in file:
            if re.search('[^ ]', line).start() == 0:
                linee = line.strip()
                lines = linee
                print(lines)

            if re.search('[^ ]', line).start() == 2:
                linee = line.strip()
                lines = next_row + linee
                print(lines)
            
            if re.search('[^ ]', line).start() == 4:
                linee = line.strip()
                lines = pipe + " " + next_row + linee
                print(lines)
            
            if re.search('[^ ]', line).start() == 6:
                linee = line.strip()
                lines = pipe + " " + " " + " " + next_row + linee
                print(lines)

            if re.search('[^ ]', line).start() == 8:
                linee = line.strip()
                lines = pipe + " " + " " + " " + " " + " " + next_row + linee
                print(lines)

            if re.search('[^ ]', line).start() == 10:
                linee = line.strip()
                lines = pipe + " " + " " + " " + " " + " " + " " + " " + next_row + linee
                print(lines)

if __name__=='__main__':

    #parse_deps1()
    print("\n\n ################################## \n\n")
    parse_deps2()

