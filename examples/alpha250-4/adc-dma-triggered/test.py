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

    @command(classname='SSFifoController')
    #@command()
    def fifo_reset_rx(self):
        pass

    @command(classname='SSFifoController')
    #@command()
    def fifo_vacancy_rx(self):
        return self.client.recv_uint32()
        #return self.client.recv_uint32()

    @command(classname='SSFifoController')
    #@command()
    def fifo_read_rx(self):
        return self.client.recv_uint32()

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
    def start_dma_acquisition(self, val):
        pass
    @command()
    def stop_dma_acquisition(self):
        pass
    @command()
    def check_dmaacq_thread(self):
        pass

    @command(classname='SSFifoController')
    def stop_fifo_acquisition(self):
        pass
    @command(classname='SSFifoController')
    def start_fifo_acquisition(self, val):
        pass

    @command()
    def start_dma_0(self):
        pass

    @command()
    def stop_dma_0(self):
        pass

    @command()
    def print_dma_log(self):
        pass

    @command()
    def get_adc0_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    @command(classname='SSFifoController')
    def get_vector_rx(self):
        return self.client.recv_array(2048, dtype='uint32', check_type = False)

    def get_adc0(self):
        data = self.get_adc0_data()
        self.adc0 = (np.int32(data % 65536) & 0x3FFF) #- 32768) % 65536 - 32768
        self.adc1 = (np.int32((data >> 16)) & 0x3FFF)#- 32768) % 65536 - 32768

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.89')
    client = connect(host, name='adc-dma-triggered')
    driver = AdcDma(client)

    driver.start_fifo_acquisition(True);
    time.sleep(2.4)
    ret = driver.get_vector_rx()
    driver.stop_fifo_acquisition(); 
    ret0 = (np.int32(ret %0x3FFF)) # % 65536) - 32768) % 65536 - 32768
    ret1  = (np.int32((ret >> 16) & 0x3FFF))# - 32768) % 65536 - 32768

    adc0 = np.zeros(driver.n/2)
    adc1 = np.zeros(driver.n/2)
    adc_channel = 0;

    driver.fifo_reset_rx()

    for x in range(1000):
        print ("FIFO STATUS: {}: {} {}; {}". format(x, ret0[x], ret1[x], driver.fifo_vacancy_rx()))

    print("Get ADC{} data ({} points)".format(adc_channel, driver.n))
    time.sleep(5)
    driver.stop_dma_0()
    driver.start_dma_0()
    driver.get_adc0()
    driver.print_dma_log()

    fs = 250e6
    t = np.arange(driver.n/2) / fs
    n_pts = 1000000
    print("Plot first {} points".format(n_pts))
    plt.plot(1e6 * t[0:n_pts], driver.adc0[0:n_pts], marker=".")
    #plt.plot(1e6 * t[0:n_pts], driver.adc1[0:n_pts])
    plt.legend(['ADC0', 'ADC1'])
    plt.ylim((-1000, 2**14+1000))
    plt.xlabel('Time (us)')
    plt.ylabel('ADC Raw data')
    plt.show()
