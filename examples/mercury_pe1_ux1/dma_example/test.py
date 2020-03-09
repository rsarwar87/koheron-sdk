#!/usr/bin/env python
# -*- coding: utf-8 -*-
import pdb
import os
import time
from random import random
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np
import pdb

class AdcDacDma(object):
    def __init__(self, client):
        self.n = 8*1024*1024
        self.client = client
        self.dac = np.zeros((self.n))
        self.adc = np.zeros((self.n))

    @command(classname='LedBlinker')
    def set_leds(self, led_value):
        pass

    @command(classname='LedBlinker')
    def get_leds(self, led_value):
        return self.client.recv_uint32()

    @command(classname='LedBlinker')
    def set_led(self, index, status):
        pass

    @command(classname='LedBlinker')
    def get_forty_two(self):
        return self.client.recv_uint32()

    @command()
    def set_dac_data(self, data):
        pass

    def set_dac(self, warning=False, reset=False):
        if warning:
            if np.max(np.abs(self.dac)) >= 1:
                print('WARNING : dac out of bounds')
        dac_data = np.uint32(np.mod(np.floor(32768 * self.dac) + 32768, 65536) + 32768)
        self.set_dac_data(dac_data[::2] + 65536 * dac_data[1::2])

    @command()
    def log_axi_widths(self):
        pass
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
        data = self.get_adc_data()
        self.adc[::2] = (np.int32(data % 65536) - 32768) % 65536 - 32768
        self.adc[1::2] = (np.int32(data >> 16) - 32768) % 65536 - 32768

if __name__=="__main__":
    host = os.getenv('HOST','10.211.3.31')
    client = connect(host, name='trenz_teb080x_te803_dma_example')
    driver = AdcDacDma(client)
    print ("Printing DNA: {}".format(driver.get_forty_two()))

    fs = 250e6 * random()
    fmin = 1e3 # Hz
    fmax = 1e6 # Hz

    t = np.arange(driver.n) / fs
    chirp = (fmax-fmin)/(t[-1]-t[0])

    print("Set DAC waveform (chirp between {} and {} MHz)".format(1e-6*fmin, 1e-6*fmax))
    driver.dac = 0.9 * np.cos(2*np.pi * (fmin + chirp * t) * t)
    driver.set_dac()

    fs = 250e6
    n_avg = 10
    adc = np.zeros(driver.n)

    print("Get ADC data ({} points)".format(driver.n))
    driver.start_dma()
    time.sleep(1)
    driver.get_adc()
    driver.stop_dma()

    n_pts = 1000000
    print("Plot first {} points".format(n_pts))
    plt.plot(1e6 * t[0:n_pts], driver.adc[0:n_pts])
    plt.ylim((-2**15, 2**15))
    plt.xlabel('Time (us)')
    plt.ylabel('ADC Raw data')
    plt.show()

