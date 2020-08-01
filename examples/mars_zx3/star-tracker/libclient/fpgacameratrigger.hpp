/// (c) Koheron

#ifndef __DRIVER_CAMERA_HPP__
#define __DRIVER__CAMERA_HPP__
#include <stdint.h>
#include <stdio.h>
#include <array>


class indi_cameratrigger_interface {
 public:
  indi_cameratrigger_interface(const char* host, int port);
  ~indi_cameratrigger_interface();

  bool set_cameratrigger_reg(uint8_t val);
  uint8_t get_cameratrigger_reg();
  bool open_shutter();
  bool close_shutter();

 private:
};

#endif  // __DRIVER_HPP__
