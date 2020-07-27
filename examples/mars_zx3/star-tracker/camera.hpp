/// Led Blinker driver
///
/// (c) Koheron

#ifndef __CAMERA_INTERFACE_HPP__
#define __CAMERA_INTERFACE_HPP__

#include <context.hpp>

using namespace std::chrono_literals;
class CameraInterface {
 public:
  CameraInterface(Context& ctx_)
      : ctx(ctx_),
        ctl(ctx.mm.get<mem::control>())
  {
  }

  bool set_cameratrigger_reg(uint8_t val){
    ctl.write<reg::camera_trigger>(val);
    ctx.log<INFO>("CameraInterface: %s=0x%08x\n", __func__, val);
    return true;
  }
  uint8_t get_cameratrigger_reg(){
    uint32_t ret = ctl.read<reg::camera_trigger>();
    ctx.log<INFO>("CameraInterface: %s=0x%08x\n", __func__, ret);
    return ret; 
  }
  bool open_shutter(){
    ctl.write<reg::camera_trigger>(0x1);
    std::this_thread::sleep_for(100ms);
    ctl.write<reg::camera_trigger>(0x3);
    ctx.log<INFO>("CameraInterface: %s=0x%08x\n", __func__, ctl.read<reg::camera_trigger>());
    return true;
  }
  bool close_shutter(){
    ctl.write<reg::camera_trigger>(0x1);
    std::this_thread::sleep_for(100ms);
    ctl.write<reg::camera_trigger>(0x0);
    ctx.log<INFO>("CameraInterface: %s=0x%08x\n", __func__, ctl.read<reg::camera_trigger>());
    return true;
  }


 private:
  Context& ctx;
  Memory<mem::control>& ctl;
};

#endif  // __DRIVERS_LED_BLINKER_HPP__
