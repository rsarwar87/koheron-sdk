#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import time
from koheron import command, connect

class Monitor(object):
    def __init__(self, client):
        self.client = client

    @command()
    def get_temperature(self):
        return self.client.recv_float()
    @command()
    def get_freq(self):
        return self.client.recv_uint32()
    @command("Common")
    def get_forty_two(self):
        return self.client.recv_uint32()

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.129')
    client = connect(host, 'clock-test')
    driver = Monitor(client)

    print(driver.get_forty_two())
    print(driver.get_temperature())
    print(driver.get_freq())

