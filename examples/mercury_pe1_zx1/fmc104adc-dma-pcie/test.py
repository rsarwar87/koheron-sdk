#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np
import sys

class TopLevel(object):
    def __init__(self, client):
        self.n = 8*1024*1024
        self.client = client
        self.adc0 = np.zeros((self.n))
        self.adc1 = np.zeros((self.n))

    @command()
    def get_dna(self):
        return self.client.recv_uint64()

    @command()
    def get_fortytwo(self):
        return self.client.recv_uint32()

    @command()
    def set_vco(self, enable):
        pass

    @command()
    def set_adc_clear_error(self, channel_mask):
        pass

    @command()
    def set_adc_delay_dec(self, channel_mask):
        pass

    @command()
    def set_adc_delay_inc(self, channel_mask):
        pass

    @command()
    def set_gpio(self, val):
        pass

    @command()
    def set_pciegpio(self, val):
        pass

    @command()
    def set_threashold(self, idx, value):
        pass

    @command()
    def get_adc_valid(self):
        return self.client.recv_uint32()

    @command()
    def get_adc_error(self):
        return self.client.recv_uint32()

    @command()
    def get_gpiopcie(self):
        return self.client.recv_uint32()

    @command(classname='SSFifoDriver')
    def stop_fifo_acquisition(self):
        pass
    @command(classname='SSFifoDriver')
    def start_fifo_acquisition(self, val):
        pass

    @command(classname='SSFifoDriver')
    def get_vector_rx(self):
        return self.client.recv_array(2048, dtype='uint32', check_type = False)

    @command(classname='SSFifoDriver')
    #@command()
    def fifo_reset_rx(self):
        pass

    @command(classname='SSFifoDriver')
    #@command()
    def fifo_vacancy_rx(self):
        return self.client.recv_uint32()
        #return self.client.recv_uint32()

    @command(classname='SSFifoDriver')
    #@command()
    def fifo_read_rx(self):
        return self.client.recv_uint32()

    @command()
    def set_dac_data(self, data):
        pass

    @command()
    def get_adc_raw_data(self):
        return np.int16(self.client.recv_array(4, dtype='uint32'))

    @command()
    def get_adc_clocks(self):
        return self.client.recv_array(4, dtype='uint32')

    @command(classname = "DmaSG")
    def get_s2mm0_data(self):
        return self.client.recv_array(self.n/2, dtype='uint32')

    @command(classname = "DmaSG")
    def start_dma0_s2mm(self):
        pass

    @command(classname = "DmaSG")
    def start_dma0_acquisition(self, circuler):
        pass

    @command(classname = "DmaSG")
    def stop_dma0_acquisition(self):
        pass

    @command(classname = "DmaSG")
    def stop_dma0_s2mm(self):
        pass

    def get_adc0(self):
        data = self.get_s2mm0_data()
        self.adc0 = (np.int16(data & 0xFFFF)) #- 32768) % 65536 - 32768
        self.adc1 = (np.int16((data >> 16) & 0xFFFF))#- 32768) % 65536 - 32768

    @command(classname = "DmaSG")
    def print_dma_log(self):
        pass

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.90')
    client = connect(host, name='fmc104adc-dma-pcie')
    driver = TopLevel(client)


    print ("Printing DNA: {}".format(driver.get_dna()))
    print ("Printing forty_two: {}".format(driver.get_fortytwo()))
    print ("Printing AdcClocks (MHz): {}".format(driver.get_adc_clocks()/1000000.))
    print ("Printing PCIeGPIO: {}".format(driver.get_gpiopcie()))
    print ("Printing ADC error: {}".format(driver.get_adc_error()))
    print ("Printing ADC Valid: {}".format(driver.get_adc_valid()))
    print ("Printing ADC raw: {}".format((driver.get_adc_raw_data())))
    
    print ("Printing FifoVacancy: {}".format((driver.fifo_vacancy_rx())))


    driver.start_fifo_acquisition(True);
    time.sleep(2.4)
    ret = driver.get_vector_rx()
    driver.stop_fifo_acquisition(); 
    ret0 = (np.int16(ret %0x3FFF)) # % 65536) - 32768) % 65536 - 32768
    ret1  = (np.int16((ret >> 16) & 0x3FFF))# - 32768) % 65536 - 32768

    adc0 = np.zeros(driver.n/2)
    adc1 = np.zeros(driver.n/2)

    driver.fifo_reset_rx()

    for x in range(1000):
        print ("FIFO STATUS: {}: {} {}; {}". format(x, ret0[x], ret1[x], driver.fifo_vacancy_rx()))


    print("Get ADC0 data ({} points)".format(driver.n))
    time.sleep(5)
    driver.stop_dma0_s2mm()
    driver.start_dma0_s2mm()
    driver.get_adc0()
    driver.print_dma_log()

    fs = driver.get_adc_clocks()[0]
    t = np.arange(driver.n/2) 
    n_pts = 1000000
    print("Plot first {} points".format(n_pts))
    plt.plot(1e6 * t[0:n_pts], driver.adc0[0:n_pts], marker=".")
    plt.plot(1e6 * t[0:n_pts], driver.adc1[0:n_pts])
    plt.legend(['ADC0', 'ADC1'])
    plt.ylim((-1000, 2**14+1000))
    plt.xlabel('Time (us)')
    plt.ylabel('ADC Raw data')
    plt.show()
