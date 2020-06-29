/// (c) Koheron

#ifndef __DRIVER_HPP__
#define __DRIVER_HPP__
#include <stdint.h>
#include <stdio.h>
#include <array>
#include <bitset>


class logic_analyser_interface {
 public:
  logic_analyser_interface (const char* host, int port = 36000);
  ~logic_analyser_interface ();

  uint32_t get_triggers();
  bool set_triggers(uint32_t value);

  bool start_dma();
  bool stop_dma();
  bool get_adc_data(std::bitset<16> *arra);
  uint64_t get_dna();
  uint32_t get_forty_two();

 private:
};

#endif  // __DRIVER_HPP__
