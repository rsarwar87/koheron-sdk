#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import time
from koheron import command, connect
import matplotlib.pyplot as plt
import numpy as np
import sys

class LedBlinker(object):
    def __init__(self, client):
        self.client = client

    @command()
    def set_leds(self, led_value):
        pass

    @command()
    def get_leds(self, led_value):
        return self.client.recv_uint32()

    @command()
    def set_led(self, index, status):
        pass

    @command()
    def get_forty_two(self):
        return self.client.recv_uint32()

    @command("RFSoC_ADC_DAC")
    def get_adc_raw_data(self):
        return self.client.recv_array(8, dtype="uint32")

    @command("RFSoC_ADC_DAC")
    def get_rfsoc_clocks(self):
        return self.client.recv_array(8, dtype="uint32")

    @command("RFSoC_ADC_DAC")
    def set_clocks(self, lmk, lmx):
        pass

if __name__=="__main__":
    host = os.getenv('HOST','10.240.229.243')
    client = connect(host, name='zcu208_template_adc')
    driver = LedBlinker(client)

    print ("Printing DNA: {}".format(driver.get_forty_two()))
    print ("Printing clocks: {}".format(driver.get_rfsoc_clocks()))
    print ("Printing ADC: {}".format(driver.get_adc_raw_data()))
    #driver.set_clocks(245760, 491520)


