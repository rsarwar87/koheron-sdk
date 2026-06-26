#!/usr/bin/env python
# -*- coding: utf-8 -*-

from koheron import connect
import os
import time
from led_blinker import LedBlinker
import sys
sys.path.insert(0, "./cores/ethernet_mac_v1_0/")
sys.path.insert(0, "./cores/udp_client_v1_0/")
import json

from mac import *
from udp import *

def pretty_print_status(status_dict, title=""):
    """Pretty print a status dictionary."""
    if title:
        print(f"\n=== {title} ===")
    print(json.dumps(status_dict, indent=2))

if __name__=="__main__":
    host = os.getenv('HOST','10.240.229.100')
    client = connect(host, name='teb0911_sfp')
    driver = LedBlinker(client)
    
    print(driver.get_forty_two())
    time.sleep(2)
    print(driver.get_mgt_clocks())
    

    mac = MacCore(client)
    udp = UdpClient(client)

    mac.set_an_enable(True)
    mac.set_sgmii_enable(False)
    mac.set_phy_rst_aux(True)
    mac.set_phy_rst_aux(False)
    time.sleep(2)


    while True:
        time.sleep(0.75)
        print("\n--- Update ---")
        pretty_print_status(mac.get_mac_status(), "MAC Status")
        pretty_print_status(mac.get_phy_status()['10g'], "PHY Status 10G")

