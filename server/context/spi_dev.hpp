// SPI interface
// (c) Koheron
//
// From http://redpitaya.com/examples-new/spi/
// See also https://www.kernel.org/doc/Documentation/spi/spidev

#ifndef __DRIVERS_LIB_SPI_DEV_HPP__
#define __DRIVERS_LIB_SPI_DEV_HPP__

#include <cstdio>
#include <cstdint>
#include <cassert>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>

#include <unordered_map>
#include <string>
#include <memory>
#include <vector>
#include <array>
#include <mutex>

#include <context_base.hpp>

// https://www.kernel.org/doc/Documentation/spi/spidev
class SpiDev
{
  public:
    SpiDev(ContextBase& ctx_, std::string devname_);

    ~SpiDev() {
        if (fd >= 0)
            close(fd);
    }

    bool is_ok() {return fd >= 0;}

    int init(uint8_t mode_, uint32_t speed_, uint8_t word_length_);
    int set_mode(uint8_t mode_);
    int set_full_mode(uint32_t mode32_);
    int set_speed(uint32_t speed_);

    /// Set the number of bits in each SPI transfer word.
    int set_word_length(uint8_t word_length_);

    template<typename T>
    int write(const T *buffer, uint32_t len)
    {
        if (fd >= 0)
            return ::write(fd, buffer, len * sizeof(T));

        return -1;
    }

    int recv(uint8_t* buffer, int64_t n_bytes) {
      if (!is_ok()) return -1;

      int bytes_rcv = 0;
      int64_t bytes_read = 0;

      while (bytes_read < int(n_bytes)) {
        bytes_rcv = read(fd, buffer + bytes_read, n_bytes - bytes_read);

        if (bytes_rcv == 0) {
          return 0;
        }

        if (bytes_rcv < 0) {
          return -1;
        }

        bytes_read += bytes_rcv;
      }

      assert(bytes_read == int(n_bytes));
      return bytes_read;
    }

    int transfer(uint8_t *tx_buff, uint8_t *rx_buff, size_t len)
    {
        if (! is_ok())
            return -1;
    
        struct spi_ioc_transfer tr{};
        tr.tx_buf = reinterpret_cast<unsigned long>(tx_buff);
        tr.rx_buf = reinterpret_cast<unsigned long>(rx_buff);
        tr.len = len;
        return ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
    }
    template <size_t len>
    int transfer(uint8_t* tx_buff, uint8_t* rx_buff) {
      if (!is_ok()) return -1;

      static std::mutex spi_mutex;
      struct spi_ioc_transfer tr {};
      tr.tx_buf = reinterpret_cast<unsigned long>(tx_buff);
      tr.rx_buf = reinterpret_cast<unsigned long>(rx_buff);
      tr.cs_change = 0;
      tr.len = len;

      spi_mutex.lock();
      int ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);
      spi_mutex.unlock();
      return ret;
    }

    template<typename T>
    int recv(std::vector<T>& vec) {
        return recv(reinterpret_cast<uint8_t*>(vec.data()),
                    vec.size() * sizeof(T));
    }

    template<typename T, size_t N>
    int recv(std::array<T, N>& arr) {
        return recv(reinterpret_cast<uint8_t*>(arr.data()),
                    N * sizeof(T));
    }

    // hold off is a set of dont, care bits put at the end of the data stream
    // in order to allow enough clocks to pass for proper clock domain crossover
    // Not critical during write calls
    // cmd flag gives the option of adding custom flag to indicate that it is a write
    // command, or any other custom command.
    template <size_t addr, uint32_t offset, size_t holdoff = 0,
              typename Twrite = uint32_t, typename Taddr = uint8_t, uint8_t cmd = 0x80>
    int write_at_addr(Twrite* pData) {
      std::array<uint8_t, sizeof(Twrite) + holdoff + sizeof(Taddr)> tx_buff = {};
      tx_buff.at(0) =
          static_cast<uint8_t>(((addr >> (sizeof(Taddr) - 1) * 8) & 0xFF) | cmd);
      for (size_t i = 1; i < sizeof(Taddr); i++) {
        tx_buff.at(i) = ((addr + offset) >> (sizeof(Taddr) - i - 1) * 8) & 0xFF;
      }
      for (size_t i = 0; i < sizeof(Twrite); i++) {
        tx_buff.at(sizeof(Taddr) + i) = ((*pData) >> i * 8) & 0xFF;
      }
      std::array<uint8_t, sizeof(Twrite) + holdoff + sizeof(Taddr)> rx_buff = {{0}};
      return transfer<sizeof(Twrite) + holdoff + sizeof(Taddr)>(tx_buff.data(),
                                                         rx_buff.data());
    }
    template <typename Twrite = uint32_t, uint8_t cmd = 0x80>
    int write_(Twrite* pData) {
      uint8_t* tx_buff = reinterpret_cast<uint8_t*>(pData);
      tx_buff[0] |= cmd;
      std::array<uint8_t, 32> rx_buff = {{0}};
      return transfer<sizeof(Twrite)>(tx_buff, rx_buff.data());
    }
    template <typename Tread = uint32_t>
    int read_(Tread* pData) {
      if (pData == NULL) return -1;
      std::array<uint8_t, sizeof(Tread)> tx_buff = {};
      std::array<uint8_t, 32> rx_buff = {{0}};
      int ret = transfer<sizeof(Tread)>(tx_buff.data(), rx_buff.data());
      Tread* var = reinterpret_cast<Tread*>(rx_buff.data());
      *pData = *var;
      return ret;
    }

    // hold off is a set of dont, care bits put between the address and the datadrame
    // in order to allow enough clocks to pass for proper clock domain crossover
    // May be critical during read calls
    template <size_t addr, uint32_t offset, size_t holdoff = 0,
              typename Tread = uint32_t, typename Taddr = uint8_t>
    int read_at(Tread* pData) {
      if (pData == nullptr) return -1;
      std::array<uint8_t, sizeof(Tread) + holdoff + sizeof(Taddr)> tx_buff = {};
      for (size_t i = 0; i < sizeof(Taddr); i++) {
        tx_buff.at(i) = ((addr + offset) >> (sizeof(Taddr) - i - 1) * 8) & 0xFF;
      }
      std::array<uint8_t, sizeof(Tread) + holdoff + sizeof(Taddr)> rx_buff = {{0}};
      int ret = transfer<sizeof(Tread) + holdoff + sizeof(Taddr)>(tx_buff.data(),
                                                            rx_buff.data());
      memcpy(pData, rx_buff.data() + holdoff + sizeof(Taddr), sizeof(Tread));
      return ret;
    }

   private:
    ContextBase& ctx;
    std::string devname;

    uint8_t mode = SPI_MODE_0;
    uint32_t mode32 = SPI_MODE_0;
    uint32_t speed = 1000000; // SPI bus speed
    uint8_t word_length = 8;

    int fd = -1;
};

class SpiManager
{
  public:
    SpiManager(ContextBase& ctx_);

    int init();

    bool has_device(const std::string& devname);


    SpiDev& get(const std::string& devname,
                uint8_t mode = SPI_MODE_0,
                uint32_t speed = 1000000,
                uint8_t word_length = 8);

  private:
    ContextBase& ctx;
    std::unordered_map<std::string, std::unique_ptr<SpiDev>> spi_drivers;
    SpiDev empty_spidev;
};

#endif // __DRIVERS_LIB_SPI_DEV_HPP__
