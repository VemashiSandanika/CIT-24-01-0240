# Lab Sheet 7 - SDN with Mininet and Ryu
# CCS3308 - Virtualization and Containers
# Name: L.W. Vemashi Sandanika | Index Number: CIT-24-01-0240

## Overview
This lab covers building virtual networks with Mininet, controlling them with the Ryu SDN controller, 
and reading/writing OpenFlow rules directly using 'ovs-ofctl'. It follows Lab Sheet 7 (SDN and Virtual Networks), 
working through Parts 1–6: installation, creating networks, the Mininet CLI, bringing in Ryu, flow rules, and 
the six-exercise practice progression.

## Environment
- Ubuntu (VirtualBox VM)
- Mininet and Open vSwitch - installed natively via 'apt-get' (Option B from the lab sheet)
- Ryu SDN controller - installed inside a Python 3.8 virtual environment

### Why Python 3.8?
The VM's default Python version (3.14) is far too new for Ryu, which is an unmaintained package. Installing 
Ryu surfaced a chain of dependency incompatibilities on newer Python versions (setuptools' removed 
'easy_install.get_script_args', eventlet's 'ALREADY_HANDLED' and 'TimeoutError' issues, and dnspython's 
use of the removed 'collections.MutableMapping'). These were resolved by creating a dedicated virtual 
environment pinned to Python 3.8, matching what Ryu was actually built against.

### Recreating the environment

sudo apt-get update
sudo apt-get install mininet openvswitch-switch openvswitch-testcontroller

sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8 python3.8-venv

python3.8 -m venv ryuenv38
source ryuenv38/bin/activate
pip install "setuptools<58"
pip install ryu
pip install eventlet==0.30.2

## Files
- topologies/chain_topo(Part2.2).py - example chain topology from Part 2.2 of the lab sheet
- topologies/my_chain_topo(Part6_Question3).py - original three-switch chain topology built for Exercise 3, using a distinct IP scheme (192.168.1.x/24)
- exercise_answers.md - written answers for Exercises 2, 5, and 6, and a summary of what was done for all six exercises
- screenshots/ - evidence for each part of the lab and each exercise

## How to Run
1. Start Ryu in one terminal:
   source ryuenv38/bin/activate
   ryu-manager --verbose ryu.app.simple_switch_13

2. In a second terminal, start Mininet with the custom topology, pointed at Ryu:
   sudo mn --custom topologies/my_chain_topo.py --topo mychaintopo \
     --controller=remote,ip=127.0.0.1,port=6633 \
     --switch ovsk,protocols=OpenFlow13

3. At the 'mininet>' prompt, verify connectivity:
   pingall
   
4. In a third terminal, inspect or modify flow rules:
   sudo ovs-ofctl -O OpenFlow13 dump-flows s1

## Summary of Work Completed
- **Part 1:** Installed Mininet, Open vSwitch, and Ryu natively; resolved several Python-version dependency conflicts.
- **Part 2:** Built quick topologies with Mininet shortcuts, then wrote a custom Python topology ('chain_topo.py') and
  confirmed it fails without a controller attached.
- **Part 4:** Connected Ryu as the controller and compared controller log activity between a first and second 'pingall'.
- **Part 5:** Read and wrote OpenFlow rules by hand with 'ovs-ofctl', including a block rule and an ICMP-only allow-list example.
- **Part 6:** Completed all six practice exercises — baseline connectivity, controller comparison, an original custom topology,
  hand-blocking a specific host pair, simulating and recovering from a link failure, and reading Ryu's 'simple_switch_13.py'
  source code to explain first-packet vs. subsequent-packet behaviour.
