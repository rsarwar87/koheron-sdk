#include <koheron-client.hpp>

#include "logicanalyser.hpp"
#include "log.hpp"
namespace sky_driver {
static std::unique_ptr<KoheronClient> client;
static syslog_stream klog;
}
using namespace sky_driver;

logic_analyser_interface::logic_analyser_interface(const char* host, int port) {
  klog << "Initializing driver - connecting to koheron server@" << host << ":" << port << std::endl;
  client = std::make_unique<KoheronClient>(host, port);
  client->connect();
  klog << "Initialization completed" << std::endl;
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
std::array<uint32_t, 64 * 1024 * 64>  logic_analyser_interface::get_adc_data() {
  klog << "calling from " << __func__ << std::endl;
  client->call<op::DmaExample::get_adc_data>();
  klog << "retrieving from " << __func__ << std::endl;
  auto buffer = client->recv<op::DmaExample::get_adc_data, std::array<uint32_t, 64 * 1024 * 64> >();
  klog << "returning from " << __func__ << std::endl;
  return buffer;
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

