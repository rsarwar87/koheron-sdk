#include <koheron-client.hpp>

#include "fpgacameratrigger.hpp"
#include "log.hpp"
namespace cameratrigger_driver {
static std::unique_ptr<KoheronClient> client;
static syslog_stream klog;
}
using namespace cameratrigger_driver;

indi_cameratrigger_interface::indi_cameratrigger_interface(const char* host, int port) {
  klog << "Initializing driver - connecting to koheron server@" << host << ":" << port << std::endl;
  client = std::make_unique<KoheronClient>(host, port);
  client->connect();
  klog << "Initialization completed" << std::endl;
}
indi_cameratrigger_interface::~indi_cameratrigger_interface(){
  klog << __func__ << std::endl;
  client.reset();
}
bool indi_cameratrigger_interface::set_cameratrigger_reg(uint8_t value) {
  client->call<op::CameraInterface::set_cameratrigger_reg>(value);
  auto buffer = client->recv<op::CameraInterface::set_cameratrigger_reg, bool>();
  return buffer;
}
uint8_t indi_cameratrigger_interface::get_cameratrigger_reg() {
  client->call<op::CameraInterface::get_cameratrigger_reg>();
  auto buffer = client->recv<op::CameraInterface::get_cameratrigger_reg, uint8_t>();
  return buffer;
}
bool indi_cameratrigger_interface::open_shutter() {
  client->call<op::CameraInterface::open_shutter>();
  auto buffer = client->recv<op::CameraInterface::open_shutter, bool>();
  return buffer;
}
bool indi_cameratrigger_interface::close_shutter() {
  client->call<op::CameraInterface::close_shutter>();
  auto buffer = client->recv<op::CameraInterface::close_shutter, bool>();
  return buffer;
}
