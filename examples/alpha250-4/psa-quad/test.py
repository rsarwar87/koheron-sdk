#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
import sys
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np

class AdcDma(object):
    def __init__(self, client):
        self.n = 8*1024*1024
        self.client = client
        self.dac = np.uint32(np.ones((self.n)))
        self.adc = np.zeros((self.n))

    @command()
    def select_adc_channel(self, channel):
        pass

    @command()
    def set_dac_data(self, data):
        pass

    @command()
    def start_dma_mm2s(self):
        pass

    @command(classname='PSACore')
    def set_psa_ram_at(self, idx, addr, val):
        pass
    @command(classname='PSACore')
    def get_psa_ram_at(self, idx, addr):
        return self.client.recv_uint32()

    @command(classname='PSACore')
    def set_psa_triggers(self, idx, val):
        pass
    @command(classname='PSACore')
    def set_psa_gates(self, idx, val):
        pass
    @command(classname='PSACore')
    def get_psa_triggers(self, idx):
        return self.client.recv_array(4, dtype='uint32')
    @command(classname='PSACore')
    def get_psa_gates(self, idx):
        return self.client.recv_array(5, dtype='uint32')

    @command(classname='PSACore')
    def set_channel_active(self, ch, val):
        pass
    @command(classname='PSACore')
    def get_channel_active(self):
        return self.client.recv_uint32()
    @command(classname='PSACore')
    def set_tx_debug(self, val):
        pass
    @command(classname='PSACore')
    def set_debug_one(self, val):
        pass
    @command(classname='PSACore')
    def set_list_mode(self, val):
        pass
    @command(classname='PSACore')
    def get_tx_debug(self):
        return self.client.recv_bool()
    @command(classname='PSACore')
    def get_debug_one(self):
        return self.client.recv_bool()
    @command(classname='PSACore')
    def get_list_mode(self):
        return self.client.recv_bool()
    @command(classname='PSACore')
    def get_dma_fullness(self):
        return self.client.recv_array(8, dtype='uint32')
    @command()
    def stop_dma_mm2s(self):
        pass

    @command()
    def get_adc_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    def get_adc(self):
        data = self.get_adc_data()
        self.adc[::2] = (np.int32(data & 0x3fff) ) 
        self.adc[1::2] = (np.int32((data >> 16) & 0x3fff) ) 
        #self.adc[::2] = (np.int32(data & 0xFFFF ))
        #self.adc[1::2] = (np.int32(data >> 16) & 0xFFFF )

if __name__=="__main__":
    host = os.getenv('HOST','10.211.3.133')
    client = connect(host, name='psa-quad')
    driver = AdcDma(client)
    print('Active Channels: {}'.format(driver.get_channel_active()))
    print('Debug Active: {}'.format(driver.get_debug_one()))
    trig = np.uint32(np.zeros(4))
    trig[0] = 0
    trig[1] = 1023
    trig[2] = 127
    trig[3] = 3
    for idx in range(0, 5): print('Triggers{}: {}'.format(idx, driver.set_psa_triggers(idx, trig)))
    for idx in range(0, 5): print('Triggers{}: {}'.format(idx, driver.get_psa_triggers(idx)))
    gates = np.uint32(np.zeros(5))
    gates[0] = 15
    gates[1] = 10
    gates[2] = 20
    gates[3] = 150
    gates[4] = 170
    for idx in range(0, 5): print('Gates{}: {}'.format(idx, driver.set_psa_gates(idx, gates)))
    for idx in range(0, 5): print('Gates{}: {}'.format(idx, driver.get_psa_gates(idx)))
    driver.set_debug_one(True)
    driver.set_channel_active(0, False)
    driver.set_channel_active(0, True)
    print('DMA fullness: {}'.format(driver.get_dma_fullness()))
    exit()
    
    for i in range (0, len(driver.dac)): 
        driver.dac[i] = np.uint32(np.uint16((8192*4-1)) + np.uint16(((8192*4-1)) << 16))

    driver.set_dac_data(driver.dac)
    driver.start_dma_mm2s()
    driver.get_adc()
    print (driver.adc)
    driver.stop_dma_mm2s()

    driver.set_psa_ram_at(2, 0x0, 123)
    print('PSA_limit: {}'.format(driver.get_psa_ram_at(2, 0x0)))


    driver.set_list_mode(True)
    driver.set_tx_debug(True)
    print('ListMode: {}'.format( driver.get_list_mode()))
    print('DebugMode: {}'.format(driver.get_tx_debug()))
    print('Active Channels: {}'.format(driver.get_channel_active()))
    for idx in range(0, 5): driver.set_channel_active(idx, False)
    driver.set_channel_active(0, True)
    print('Active Channels: {}'.format(driver.get_channel_active()))

