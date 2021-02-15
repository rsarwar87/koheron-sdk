#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import time
from koheron import command, connect

class TemplateDriver(object):
    def __init__(self, client):
        self.client = client

    @command()
    def get_buttons(self):
        return self.client.recv_uint32()

    @command()
    def get_user_io(self):
        return self.client.recv_uint32()

    @command()
    def set_user_io(self, value):
        pass

    @command()
    def set_direction_user_io(self, mask):
        pass

    @command()
    def get_ck_outer_io(self):
        return self.client.recv_uint32()

    @command()
    def set_ck_outer_io(self, value):
        pass

    @command()
    def set_direction_ck_outer_io(self, mask):
        pass

    @command()
    def get_ck_inner_io(self):
        return self.client.recv_uint32()

    @command()
    def set_ck_inner_io(self, value):
        pass

    @command()
    def set_direction_ck_inner_io(self, mask):
        pass

    @command()
    def get_pmod_value(self, id):
        return self.client.recv_uint32()

    @command()
    def set_pmod_value(self, id, value):
        pass

    @command()
    def set_pmod_direction(self, id, mask):
        pass

    @command()
    def xadc_read(self, id):
        return self.client.recv_uint32()

    @command()
    def get_dna(self):
        return self.client.recv_uint64()

    @command()
    def set_rbg(self, id, r, g, b):
        pass

    @command()
    def get_forty_two(self):
        return self.client.recv_uint32()

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.87')
    client = connect(host, 'template')
    driver = TemplateDriver(client)

    print("Print fortytwo: {}".format(driver.get_forty_two()))
    print("Print FPGA ID: {}".format(driver.get_dna()))
    print("Print buttons: {}".format(driver.get_buttons()))

    for i in range(12):
        print("Print Xadc{}: {}".format(i, driver.xadc_read(i)))
        
    driver.set_rbg(0, 255,   0, 255)
    driver.set_rbg(1, 255,   0,   0)
