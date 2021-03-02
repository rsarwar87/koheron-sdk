#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np

class AdcDma(object):
    def __init__(self, client):
        self.n = 8*1024*1024
        self.client = client
        self.adc1 = np.zeros((self.n/2))
        self.adc0 = np.zeros((self.n/2))

    @command()
    def start_dma_1(self):
        pass

    @command()
    def stop_dma_1(self):
        pass

    @command()
    def get_adc1_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    def get_adc1(self):
        data = self.get_adc1_data()
        self.adc0 = (np.int32(data % 65536) - 32768) % 65536 - 32768
        self.adc1 = (np.int32(data >> 16) - 32768) % 65536 - 32768

    @command()
    def start_dma_0(self):
        pass

    @command()
    def stop_dma_0(self):
        pass
    @command(classname='Ltc2157')
    def get_calibration(self, adc, channel):
        return self.client.recv_array(8, dtype='float32')

    @command()
    def get_adc0_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    def get_adc0(self):
        data = self.get_adc0_data()
        self.adc0 = (np.int32(data & 0x3FFF))
        self.adc1 = (np.int32((data >> 16) & 0x3FFF))

if __name__=="__main__":
    host = os.getenv('HOST','10.211.3.130')
    client = connect(host, name='adc-dma-orig')
    driver = AdcDma(client)


    adc0 = np.zeros(driver.n/2)
    adc1 = np.zeros(driver.n/2)
    adc_channel = 0;

    
    print("Get ADCCal0 data ({} {})".format(driver.get_calibration(0,0), driver.get_calibration(0,1)))
    print("Get ADCCal1 data ({} {})".format(driver.get_calibration(1,0), driver.get_calibration(1,1)))
    print("Get ADC{} data ({} points)".format(adc_channel, driver.n))
    driver.start_dma_0()
    driver.get_adc0()
    driver.stop_dma_0()

    fs = 250e6
    t = np.arange(driver.n/2) / fs
    n_pts = 1000000
    print("Plot first {} points".format(n_pts))
    plt.plot(1e6 * t[0:n_pts], driver.adc0[0:n_pts])
    plt.plot(1e6 * t[0:n_pts], driver.adc1[0:n_pts])
    plt.legend(['ADC0', 'ADC1'])
    plt.ylim((-1000, 2**14))
    plt.xlabel('Time (us)')
    plt.ylabel('ADC Raw data')
    plt.show()
