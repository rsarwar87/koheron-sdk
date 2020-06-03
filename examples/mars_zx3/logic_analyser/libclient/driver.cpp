#include <koheron-client.hpp>

#include "logicanalyser.hpp"
#include "log.hpp"
#include <sys/resource.h>

namespace sky_driver {
static std::unique_ptr<KoheronClient> client;
static syslog_stream klog;
  void increase_stack_size()
  {
    const rlim_t kStackSize = 100 * 64 * 64 * 1024;   // min stack size = 16 MB
    struct rlimit rl;
    int result;

    result = getrlimit(RLIMIT_STACK, &rl);
    if (result == 0)
    {
        if (rl.rlim_cur < kStackSize)
        {
            rl.rlim_cur = kStackSize;
            result = setrlimit(RLIMIT_STACK, &rl);
            if (result != 0)
            {
                fprintf(stderr, "setrlimit returned result = %d\n", result);
                klog << "setrlimit returned result = " << result;
            }
        }
    }
  }
}
using namespace sky_driver;

logic_analyser_interface::logic_analyser_interface(const char* host, int port) {
  klog << "Initializing driver - connecting to koheron server@" << host << ":" << port << std::endl;
  client = std::make_unique<KoheronClient>(host, port);
  client->connect();
  klog << "Initialization completed" << std::endl;
  increase_stack_size();
}
logic_analyser_interface::~logic_analyser_interface(){
  klog << "calling from " << __func__ << std::endl;
  client.reset();
}
uint32_t logic_analyser_interface::get_triggers() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::DmaExample::get_triggers>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::DmaExample::get_triggers, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
// Initialize                = 'F',
bool logic_analyser_interface::set_triggers(uint32_t value) {
  klog << "calling from " << __func__ << std::endl;
  try {
  client->call<op::DmaExample::set_triggers>(value);
  }
  catch(const std::exception& e) {return false;}
  klog << "returning from " << __func__ << std::endl;
  return true;
}
bool logic_analyser_interface::start_dma() {
  klog << "calling from " << __func__ << std::endl;
  try {
  client->call<op::DmaExample::start_dma>();
  }
  catch(const std::exception& e) {return false;}
  klog << "returning from " << __func__ << std::endl;
  return true;
}
bool logic_analyser_interface::stop_dma() {
  klog << "calling from " << __func__ << std::endl;
  try {
  client->call<op::DmaExample::stop_dma>();
  }
  catch(const std::exception& e) {return false;}
  klog << "returning from " << __func__ << std::endl;
  return true;
}
bool logic_analyser_interface::get_adc_data(std::bitset<16>* arra) {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::DmaExample::get_adc_data>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::DmaExample::get_adc_data, std::array<uint32_t, 64 * 1024 * 64> >();
  for (size_t i = 0; i < 64*1024*64; i++)
  {
      uint16_t *parr16 = (uint16_t*)(&(buffer[i]));
      arra[i*2] = parr16[0];
      arra[i*2 + 1] = parr16[1];
  }
  klog << "returning from " << __func__ << std::endl;
  return true;
}

uint32_t logic_analyser_interface::get_forty_two() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::Common::get_forty_two>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::Common::get_forty_two, uint32_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}
uint64_t logic_analyser_interface::get_dna() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::Common::get_dna>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::Common::get_dna, uint64_t>();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
}

