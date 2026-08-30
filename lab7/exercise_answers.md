# Lab Sheet 7 - Exercise Answers
# CCS3308 - Virtualization and Containers
# Name: L.W. Vemashi Sandanika | Index Number: CIT-24-01-0240

## Exercise 1 - Warm-up
Built '--topo single,3' with Mininet's default controller and ran 'pingall' repeatedly. All runs returned '0% dropped', confirming a healthy baseline network with no controller attached beyond Mininet's own default.

(screenshots - 6.1.png)

## Exercise 2 - Swap the Brain
Rebuilt the same 'single,3' topology, this time attached to 'ryu-manager ryu.app.simple_switch_13' instead of the default controller. Both 'pingall' runs returned '0% dropped (6/6 received)'.

(screenshots - 6.2.1.png , 6.2.2.png ,6.2.3.png , 6.2.4.png , 6.2.5.png , 6.2.6.png)

**Answer:** The first 'pingall' is slower because Ryu has to learn each host's location through 'packet_in' events and install new flow rules one at a time. The second 'pingall' is faster because those flow rules are already cached in the switch, so packets are forwarded directly without involving the controller.

## Exercise 3 - Build Your Own Chain
Wrote an original three-switch linear topology ('topologies/my_chain_topo(Part6_Question3).py') from scratch, using the '192.168.1.x/24' IP range instead of the lab sheet's '10.0.0.x/24' example. Attached Ryu (simple_switch_13) and verified 'h1 ping -c 3 h3' succeeded with 0% packet loss, confirming traffic correctly crossed all three hops (h1 → s1 → s2 → s3 → h3).

(screenshots - 6.3.1.png , 6.3.2.png)

## Exercise 4 - Hand-block a Pair
On the Exercise 3 topology, retrieved h1 and h3's MAC addresses using 'h1 ifconfig' / 'h3 ifconfig', then added a flow rule on switch 's1' to drop traffic between them.
Verified with 'pingall': only the h1↔h3 pair failed (33% dropped, 4/6 received), while h1↔h2 and h2↔h3 continued working normally. Confirmed the rule was active and dropping packets (n_packets=11) using 'dump-flows s1'.

(screenshots - 6.4.1.png , 6.4.2.png ,  6.4.3.png)

## Exercise 5 - Break a Link on Purpose
On the same running topology (with the Exercise 4 block rule still active), ran 'link s1 s2 down'.

(screenshots - 6.5.png)

**Answer:** With the s1–s2 link down, both h1↔h3 and h2↔h3 stopped working, because that link was the only path connecting switch s1 (where h1 and h2 are) to switch s3 (where h3 is), via s2. The h1↔h2 pair was unaffected, since both hosts connect directly to s1 and never needed the broken link. After running link s1 s2 up, connectivity was restored to its previous state - h2↔h3 worked again, though h1↔h3 remained blocked, since that was a separate rule manually installed in Exercise 4, not something caused by the link failure.

## Exercise 6 - Read Ryu's Source Code
Located 'simple_switch_13.py' inside the Ryu installation using: python3 -c "import ryu.app.simple_switch_13 as m; print(m.file)"
Found the '_packet_in_handler' method (decorated with '@set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)') and the 'add_flow()' call inside it.

(screenshots - 6.6.1.png , 6.6.2.png , 6.6.3.png)

**Answer:** On a packet's first arrival, the switch has no matching flow rule for it, so it forwards the packet to the Ryu controller as a 'packet_in' event, which triggers the '_packet_in_handler' function. This handler reads the packet's source and destination MAC addresses, records which port the source host is on (learning its location), and works out the correct output port for the destination or floods it if the destination is still unknown. It then calls 'add_flow()' to install a new rule directly into the switch's flow table, so future packets matching this same source/destination pattern can be handled locally. On every arrival after that, the switch finds a matching rule already in its flow table and forwards the packet immediately, without contacting the controller again. This is exactly why the second pingall in Exercise 2 completed with far less controller log activity than the first.

