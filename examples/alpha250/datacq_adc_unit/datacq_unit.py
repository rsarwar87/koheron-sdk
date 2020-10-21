#!/usr/bin/env python
# -*- coding: utf-8 -*-

from koheron import command

class DatAcqUnit(object):

    def __init__(self, client):
    	self.client = client

    @command()
    def get_forty_two(self):
        return self.client.recv_uint32()

    @command()
    def get_current_state(self):
    	return self.client.recv_uint32()
    @command()
    def is_active(self):
    	return self.client.recv_bool()
    @command()
    def detected_simulation_command(self):
    	return self.client.recv_bool()
    @command()
    def detected_continuity_error(self):
    	return self.client.recv_bool()
    @command()
    def is_mbus_ready(self):
    	return self.client.recv_bool()
    @command()
    def is_clock_okay(self):
    	return self.client.recv_bool()
    @command()
    def detected_clock_error(self):
    	return self.client.recv_bool()
    @command()
    def is_triggered(self):
    	return self.client.recv_bool()
    @command()
    def is_in_delay_phase(self):
    	return self.client.recv_bool()



    @command()
    def set_adc_channel_select(self, val):
        pass
    @command()
    def get_adc_channel_select(self):
    	return self.client.recv_uint32()
    @command()
    def set_arm(self):
        pass
    @command()
    def set_prepare(self):
        pass
    @command()
    def set_simulated_trigger(self):
        pass
    @command()
    def set_ip_reset(self):
        pass
    @command()
    def set_clkerr_ignore(self, val):
        pass
    @command()
    def get_clkerr_ignore(self):
    	return self.client.recv_bool()
    @command()
    def set_simulation_flag(self, val):
        pass
    @command()
    def get_simulation_flag(self):
    	return self.client.recv_bool()
    
    @command()
    def get_trigger_duration(self):
    	return self.client.recv_uint32()
    @command()
    def get_trigger_delay(self):
    	return self.client.recv_uint32()
    @command()
    def set_trigger_duration(self, value):
        pass
    @command()
    def set_trigger_delay(self, value):
        pass

    
    @command()
    def get_adc_freq(self):
        return self.client.recv_uint32()
    @command()
    def get_up_time(self):
    	return self.client.recv_uint32()
    @command()
    def get_tick_escaped(self):
    	return self.client.recv_uint32()
    @command()
    def get_bus_error_duration(self):
    	return self.client.recv_uint32()
    @command()
    def get_bus_error_count(self):
    	return self.client.recv_uint32()
    @command()
    def get_raw_status(self):
    	return self.client.recv_uint32()
    @command()
    def get_ext_io(self):
    	return self.client.recv_uint32()
    @command()
    def get_adc_values(self):
        return self.client.recv_array(2, dtype='uint32')


    @command()
    def getDevName(self):
    	return self.client.recv_string()
    @command()
    def get_temperature(self):
    	return self.client.recv_float()



    @command()
    def get_state_machine(self):
    	return self.client.recv_uint32()
    @command()
    def set_state_machine(self, value):
    	return self.client.recv_uint32()
    @command()
    def get_device_status(self):
    	return self.client.recv_uint64()
    @command()
    def get_number_of_samples_detected(self):
    	return self.client.recv_uint32()
    @command()
    def do_arm(self):
        pass




    @command("DmaUnit")
    def start_dma(self):
    	return self.client.recv_bool()
    @command("DmaUnit")
    def get_dma_status(self):
    	return self.client.recv_uint32()
    @command("DmaUnit")
    def stop_dma(self):
    	return self.client.recv_bool()
    @command("DmaUnit")
    def reset_s2mm(self):
    	return self.client.recv_bool()
    @command("DmaUnit")
    def get_data(self, offset):
        return self.client.recv_array(64 * 1024 * 64, dtype='uint32')


    @command()
    def get_PlVccInt(self):
    	return self.client.recv_float()
    @command()
    def get_PlVccAux(self):
    	return self.client.recv_float()
    @command()
    def get_PlVccBram(self):
    	return self.client.recv_float()
    @command()
    def get_PsVccInt(self):
    	return self.client.recv_float()
    @command()
    def get_PsVccAux(self):
    	return self.client.recv_float()
    @command()
    def get_PsVccMem(self):
    	return self.client.recv_float()

