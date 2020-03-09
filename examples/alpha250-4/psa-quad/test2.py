#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np

class AdcDacDma(object):
    def __init__(self, client):
        self.n = 8*1024*1024
        self.client = client
        self.dac = np.zeros((self.n))
        self.adc = np.zeros((self.n))

    @command()
    def select_adc_channel(self, channel):
        pass

    @command()
    def set_dac_data(self, data):
        pass

    def set_dac(self, warning=False, reset=False):
        if warning:
            if np.max(np.abs(self.dac)) >= 1:
                print('WARNING : dac out of bounds')
        dac_data = np.uint32(np.mod(np.floor(8192 * self.dac) + 8192, 16384) + 8192)
        dac_data =self.dac  
        #print self.dac
        self.set_dac_data(dac_data[::2] + 16384 * dac_data[1::2]) #self.set_dac_data(dac_data)

    @command()
    def start_dma(self):
        pass

    @command()
    def stop_dma(self):
        pass

    @command()
    def get_adc_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    def get_adc(self):
        data  = self.get_adc_data()
        self.adc[::2] = (np.int32(data % 16384) - 8192) % 16384 - 8192
        self.adc[1::2] = (np.int32(data >> 16) - 8192) % 16384 - 8192

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.7')
    client = connect(host, name='adc-dac-dma')
    driver = AdcDacDma(client)


    fs = 125e6
    fmin = 1 # Hz
    fmax = 10000 # Hz

    t = np.arange(driver.n) / fs
    chirp = (fmax-fmin)/(t[-1]-t[0])

    print("Set DAC waveform (chirp between {} and {} MHz)".format(1e-6*fmin, 1e-6*fmax))
    with open('/wsfat/neutron_data/int3_cf250') as f:
    #    w, h = [int(x) for x in next(f).split()]
    #    array = [[int(x) for x in line.split()] for line in f]
        data = f.read()
    x = [int(i)/8192 for i in data.split()]
    x = np.array(x)
    #x = x.astype(np.uint32) 
    #print x.dtype
    #x=np.swapaxes(x,0,1)
    print x.size

    driver.dac = x #0.9 * np.cos(2*np.pi * (fmin + chirp * t) * t)
    driver.set_dac()

    adc = np.zeros(driver.n)

    print("Get ADC0 and ADC1 data ({} points)".format(driver.n))
    driver.start_dma()
    driver.get_adc()
    driver.stop_dma()
    print driver.adc
    n_pts = -1
    print("Plot first {} points".format(n_pts))
    plt.plot(1e9 * t[0:n_pts], driver.adc[0:n_pts])
    plt.ylim((-2**13-1000, 2**13+1000))
    plt.xlabel('Time (ns)')
    plt.ylabel('ADC Raw data')
    plt.show()
