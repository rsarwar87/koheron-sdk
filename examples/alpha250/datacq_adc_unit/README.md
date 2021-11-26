# ADC Triggering system

Acquires ADC samples and shuffles them to the SoC DRAM using  DMA. Max capability is 512 MB when using a 1GB SoC or 32 MB on standard 512 MB version. It uses the ADC channels n ALPHA250 board, locked to 250 MHz and ext_io_2_n is used as the triggering pin (triggers on the rising edge).

## Config Params
1. set_trigger_delay - is the delay between the start of the recording and the trigger, can be zero. unit is microsecond.
2. set_trigger_window - is the duration of the acquisition window from the end of the trigger_delay to the end of pulse, unit is microsecond. This can have a valid input range of 1 us to 1000000 usec (each usec has 250 samples of two bytes, therefore 1000000 usec has 1000000*250*2/1024/1024 = 476 MB of data). it will accept 1073741 as max. A value of 0, should in theory allow the entire buffer to be exhausted. 
3. set_adc_channel_select - select which channel to acquire from. valid range is 0 to 3.

## Self Test
The device produces a sawtooth distribution in self test. to run it, set the desired trigger delay and window enable the simulation flags:
1. set_simulation_flag - True when self-test needs to be enabled
2. set_simulated_trigger - sends the soft trigger that triggers the system (not the hardware trigger)

## Normal Operations
1. set_ip_reset -  resets the internal FPGA statemachine
2. reset_s2mm - resets the DRAM buffer to 0xFFFF
3. do_prepare - resets internal counter
4. do_arm - starts looking for trigger
5. get_data - gets 16 MB data buffer, with i as an index pointing to the 512 MB DRAM block. The ADC values are preprocessed as uint16_t, the return type of this function is uint32_t. therefore each item in the list needs to be casted to two uint16_t via bit shifting. To convert it back to unsigned, one needs to substract 0x1FFF.

The reset_s2mm fills the buffer to 0xFFFF. this value is not achievable during normal operations as the ADCs are 14-bit values only. So any value in the RAM that is 0xFFFF means that the value has not been initialized or written to by the DMA.
Other control flags, 0xF000 and 0xFF00 indicates internal internal error. 0xFFF0 may sometimes indicates the first frame (is delay is set to a non-zero value).

## status flags
1. get_current_state - gets the internal statemachine. (s_idle = 1, s_prepare, s_arm, s_seeking, s_delay, s_triggered, s_finished = 7). Data is only valid when the statemachine is on s_finished.
2. get_trigger_duration/get_trigger_delay - retrieve config params
3. get_adc_freq(self): check the freq of the ADC in Khz. should be approx 250000
4. get_up_time(self): device up time
5. get_tick_escaped(self): number of samples of data that has escaped since trigger
6. get_tick_target(self): number of samples of data that has been stored (also includes number of samples ignored during post-trigger delay phase)
7. get_bus_error_duration(self): Number of cycles the link between FPGA and DRAM stalled for. as long as this value is less than 32768, it is of no concern.
8. get_bus_error_count(self): Number of times the link between FPGA and DRAM stalled.
9. get_bus_error_count: Actice high when get_bus_error_duration > 32768
10. get_raw_status(self): internal status flag on FPGA, see source code for explanation

    	
