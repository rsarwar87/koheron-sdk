
/***************************** Include Files ********************************/
#ifndef XPS_BOARD_ZCU111
#define XPS_BOARD_ZCU111

#pragma once
#include <context.hpp>
#include <filesystem> // for std::filesystem
#include <fstream>    // for std::ifstream and std::ofstream
#include <iostream>   // for std::cout, std::cerr
#include <string.h>

// --- Constants ---------------------------------------------------------------
constexpr size_t MAX_FREQ = 9;

// --- Data Structures ---------------------------------------------------------

struct XClockingLmx {
  std::string chip;
  uint32_t xfrequency;
  size_t sz;
  std::array<unsigned int, 136> addr;
  std::array<unsigned int, 136> reg;
};
class LMKDevice {
public:
  std::string spi_device;
  std::string compatible;
  uint32_t num_bytes;
  SpiDev &spi;

  LMKDevice(const std::string &dev_name, const std::string &compat,
            uint32_t nbytes, SpiDev &spi_ref)
      : spi_device(dev_name), compatible(compat), num_bytes(nbytes),
        spi(spi_ref) {}

  void write_LMK_regs(XClockingLmx *reg_vals) {

    for (size_t i = 0; i < reg_vals->sz; i++) {
      uint32_t val = reg_vals->reg[i];
      // Convert to big-endian bytes
      std::array<uint8_t, 4> data = {static_cast<uint8_t>((val >> 24) & 0xFF),
                                     static_cast<uint8_t>((val >> 16) & 0xFF),
                                     static_cast<uint8_t>((val >> 8) & 0xFF),
                                     static_cast<uint8_t>(val & 0xFF)};

      if (num_bytes == 3) {
        spi.write<uint8_t>(&data[1],
                           3); // Write last 3 bytes
      } else {
        spi.write<uint8_t>(data.data(),
                           4); // Write all 4 bytes
      }
    }
  }
};



class LMXDevice {
public:
    std::string spi_device;
    std::string compatible;
    SpiDev &spi;

    LMXDevice(const std::string &dev_name, const std::string &compat,
              SpiDev &spi_ref)
        : spi_device(dev_name), compatible(compat), spi(spi_ref) {}

    void write_LMK_regs(XClockingLmx *reg_vals) {
        auto write_24bit = [this](uint32_t value) {
            char buf[3];
            buf[0] = (value >> 16) & 0xFF;
            buf[1] = (value >> 8) & 0xFF;
            buf[2] = value & 0xFF;
            spi.write<uint8_t>(reinterpret_cast<uint8_t *>(buf), 3); // Correct buffer
        };

        // Program RESET = 1 to reset registers
        write_24bit(0x020000);

        // Program RESET = 0 to remove reset
        write_24bit(0x000000);

        // Write all registers
        for (size_t i = 0; i < reg_vals->sz; i++) {
            write_24bit(reg_vals->reg[i]);
        }

        // Program R0 one additional time
        write_24bit(reg_vals->reg[112]);
    }
};
#endif /* #ifdef XPS_BOARD_ZCU111*/
