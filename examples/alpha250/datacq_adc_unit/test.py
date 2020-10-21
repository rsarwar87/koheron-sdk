#!/usr/bin/env python
# -*- coding: utf-8 -*-

from koheron import connect
import os
import time
import numpy as np
from datacq_unit import DatAcqUnit

host = os.getenv('HOST','10.211.3.122')
client = connect(host, name='dataqc-unit-dma')
driver = DatAcqUnit(client)

#driver.set_trigger_delay(200)
#driver.set_trigger_duration(2000)
#driver.set_prepare()
#driver.set_arm()

print 'Get Forty two:', driver.get_forty_two()
print 'get_adc:', driver.get_adc_values()
print 'get_temperature:', driver.get_temperature()
print 'get_current_state:', driver.get_current_state()
print 'is_active:', driver.is_active()
print 'detected_simulation_command:', driver.detected_simulation_command()
print 'detected_continuity_error:', driver.detected_continuity_error()
print 'is_mbus_ready:', driver.is_mbus_ready()
print 'is_clock_okay:', driver.is_clock_okay()
print 'detected_clock_error:', driver.detected_clock_error()
print 'is_triggered:', driver.is_triggered()
print 'is_in_delay_phase:', driver.is_in_delay_phase()
print 'get_adc_channel_select:', driver.get_adc_channel_select()
print 'get_simulation_flag:', driver.get_simulation_flag()
print 'get_trigger_delay:', driver.get_trigger_delay()
print 'get_trigger_duration:', driver.get_trigger_duration()
print 'get_adc_freq:', driver.get_adc_freq()
print 'get_up_time:', driver.get_up_time()
print 'get_tick_escaped:', driver.get_tick_escaped()
print 'get_bus_error_duration:', driver.get_bus_error_duration()
print 'get_bus_error_count:', driver.get_bus_error_count()
print 'get_raw_status:', driver.get_raw_status()
print 'get_ext_io:', driver.get_ext_io()
print 'getDevName:', driver.getDevName()
print 'get_state_machine:', driver.get_state_machine()
print 'get_device_status:', driver.get_device_status()
print 'get_dma_status:', driver.get_dma_status()
print 'get_number_of_samples_detected:', driver.get_number_of_samples_detected()
#Should return the number 42 from hardware constant



#print 'get_simulation_flag:', driver.get_simulation_flag()
#print 'get_use_ext_clk:', driver.get_use_ext_clk()
#print 'get_ext_clk_freq:', driver.get_ext_clk_freq()
#print 'get_run_time:', driver.get_run_time()
#print 'get_clock0:', driver.get_clock0()
#print 'get_clock1:', driver.get_clocdriver.get_trigger_delay()k1()
#print 'is_ext_clk_err:', driver.is_ext_clk_err()
#print 'is_active:', driver.is_active()
#print 'is_mbus_ready:', driver.is_mbus_ready()
#
#print 'get_clock0:', driver.get_clock0()
#print 'get_clock1:', driver.get_clock1()
#print 'get_temp:', driver.get_temperature()
#print 'devname:', driver.getDevName()
#driver.set_simulation_flag(True)
#driver.set_use_ext_clk(True)
#driver.rst_ext_clk_err()
#
#driver.set_trigger_duration(0xffffff)
#driver.set_trigger_delay(0xff)
#driver.set_stream_full(True)
#
#
#time.sleep(6)
#driver.reset_s2mm()
#driver.get_dma_status()
#driver.stop_dma()
#driver.get_dma_status()
#driver.start_dma()
#driver.get_dma_status()
#driver.set_arm()
#driver.set_simulated_trigger()
#
#
#time.sleep(6)
#driver.stop_dma()
#driver.get_dma_status()
#for i in range(3):
#    vals = driver.get_data(i)
#    print 'get_data[{}]: ', i, vals, type(vals)
#    text = ("file_%d.txt" % (i))
#    np.save(text, vals)
#
#
