#!/usr/bin/env python
from mininet.topo import Topo

class MyChainTopo(Topo):
    def build(self):
        s1 = self.addSwitch('s1', protocols='OpenFlow13')
        s2 = self.addSwitch('s2', protocols='OpenFlow13')
        s3 = self.addSwitch('s3', protocols='OpenFlow13')

        h1 = self.addHost('h1', ip='192.168.1.1/24')
        h2 = self.addHost('h2', ip='192.168.1.2/24')
        h3 = self.addHost('h3', ip='192.168.1.3/24')

        self.addLink(h1, s1)
        self.addLink(h2, s1)
        self.addLink(h3, s3)
        self.addLink(s1, s2)
        self.addLink(s2, s3)

topos = {'mychaintopo': (lambda: MyChainTopo())}
