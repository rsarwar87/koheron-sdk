/// Trigger Unit driver
///

#ifndef __DRIVERS_TRIGGER_UNIT_HPP__
#define __DRIVERS_TRIGGER_UNIT_HPP__
#include <iostream>
#include <sstream>
#include <context.hpp>
#include <container.hpp>
#include <dma_driver.hpp>
#include <fstream>
#include <bitset>
namespace xadc_regs {
    constexpr uint32_t TEMP         = 0x200;    // fpga temperature
    constexpr uint32_t PLVCCINT     = 0x204;    // fpga PL Vccint
    constexpr uint32_t PLVCCAUX     = 0x208;    // fpga PL Vccaux
    constexpr uint32_t PLVCCBRAM    = 0x218;    // fpga PL Vccbram
    constexpr uint32_t PSVCCINT     = 0x234;    // fpga PS Vccint
    constexpr uint32_t PSVCCAUX     = 0x238;    // fpga PS Vccaux
    constexpr uint32_t PSVCCMEM     = 0x23c;    // fpga PS Vccmem
}

enum {
    STATE_INIT = 0,                // init state
    STATE_RESET,               // start reset sequence
    STATE_READY,               // system is ready, wait for arm
    STATE_ARM,                 // start arming sequence
    STATE_ARMED,               // system is armed, wait for trigger
    STATE_SAMPLING,            // system is sampling
    STATE_PROC_DATA,            // process data: save raw data vector (for debugging)
    STATE_PROC_INF,            // process data: save acqusition info
    STATE_FINISHED,            // acquisition cycle has finished
    STATE_ERROR                // error state 
};

namespace sts_off {
    constexpr uint32_t fpga_state = 0x0;     // Active high when clock error detected. falls back to 10 MHz internal clock
    constexpr uint32_t is_active = 0x4;     // Active high when clock error detected. falls back to 10 MHz internal clock
    constexpr uint32_t in_simulation = 0x5;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t continuity_error = 0x6;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t is_clock_ok = 0x7;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t clock_error = 0x8;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t bus_active = 0x9;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t is_triggered = 0xA;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t in_delay = 0xB;     // status to check if dma/fifo is ready to recieve data
    constexpr uint32_t bus_ready = 0xC;     // status to check if dma/fifo is ready to recieve data
}
namespace ctl_off {
    constexpr uint32_t channel_select = 0x0;             // Arm device - device will wait for ext_trigger to start operating
    constexpr uint32_t is_simulation = 0x2;     // Active high to indicate the usage of external clock
    constexpr uint32_t do_prepare = 0x3; // reset external clock error
    constexpr uint32_t do_arm = 0x4;     // start simulation run
    constexpr uint32_t ignore_clk_error = 0x5;       // indicate device to use simulated triggeres
    constexpr uint32_t simulated_trigger = 0x6;       // indicate device to use simulated triggeres
    constexpr uint32_t ip_reset = 0x7;       // indicate device to use simulated triggeres
}

class DatAcqUnit {
 public:
  DatAcqUnit(Context& ctx_)
    : ctx(ctx_)
    , ctl(ctx_.mm.get<mem::control>())
    , sts(ctx_.mm.get<mem::status>()) 
    , xadc(ctx.mm.get<mem::xadc>())
    , dma(ctx.get<DmaUnit>())
    , ram_s2mm(ctx.mm.get<mem::ram_s2mm>())
  {
    ctx.log<INFO>("Starting DatAcq Class...");
    // start the main control thread
    //ctrlThreadStart();
  }

  uint32_t get_forty_two() { 
    uint32_t ret = sts.read<reg::forty_two>() ; 
    return ret;
  }
  uint32_t get_current_state() { 
    uint32_t ret = sts.read<reg::unit_status_in>() & 0xF; 
    return ret;
  }
  bool is_active() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::is_active>(); 
    return ret;
  }
  bool detected_simulation_command() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::in_simulation>(); 
    return ret;
  }
  bool detected_continuity_error() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::continuity_error>(); 
    return ret;
  }
  bool is_mbus_ready() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::bus_ready>(); 
    return ret;
  }
  bool is_clock_okay() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::is_clock_ok>(); 
    return ret;
  }
  bool detected_clock_error() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::clock_error>(); 
    return ret;
  }
  bool is_triggered() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::is_triggered>(); 
    return ret;
  }
  bool is_in_delay_phase() { 
    bool ret = sts.get_bit<reg::unit_status_in, sts_off::in_delay>(); 
    return ret;
  }




  void set_adc_channel_select(uint8_t val) {
    if (val > 4)
    {
      ctx.log<CRITICAL>("%s: Invalid Channel ID: %d.", __func__, val);
      return ;
    }
    uint32_t ret = ctl.read<reg::unit_control>() & 0xFFFFFFFC; 
    ret += val;
    ctl.write<reg::unit_control>(ret);
    set_ip_reset();
    log_message(__func__, ret);
  }
  uint32_t get_adc_channel_select() { 
    uint32_t ret = ctl.read<reg::unit_control>(); 
    log_message(__func__, ret);
    return ret & 0x3;
  }

  void set_arm() {
    ctl.set_bit<reg::unit_control, ctl_off::do_arm>();
    using namespace std::chrono_literals;
    std::this_thread::sleep_for(1ms);
    ctl.clear_bit<reg::unit_control, ctl_off::do_arm>();
    log_message(__func__, 1);
  }
  void set_prepare() {
    ctl.set_bit<reg::unit_control, ctl_off::do_prepare>();
    using namespace std::chrono_literals;
    std::this_thread::sleep_for(1ms);
    ctl.clear_bit<reg::unit_control, ctl_off::do_prepare>();
    log_message(__func__, 1);
  }
  void set_simulated_trigger() {
    ctl.set_bit<reg::unit_control, ctl_off::simulated_trigger>();
    using namespace std::chrono_literals;
    std::this_thread::sleep_for(1ms);
    ctl.clear_bit<reg::unit_control, ctl_off::simulated_trigger>();
    log_message(__func__, 1);
  }
  void set_ip_reset() {
    ctl.set_bit<reg::unit_control, ctl_off::ip_reset>();
    using namespace std::chrono_literals;
    std::this_thread::sleep_for(1ms);
    ctl.clear_bit<reg::unit_control, ctl_off::ip_reset>();
    log_message(__func__, 1);
  }
  void set_clkerr_ignore(bool val) {
    if (val)
      ctl.set_bit<reg::unit_control, ctl_off::ignore_clk_error>();
    else
      ctl.clear_bit<reg::unit_control, ctl_off::ignore_clk_error>();
    
    log_message(__func__, val);
  }
  bool get_clkerr_ignore() { 
    bool ret = ctl.get_bit<reg::unit_control, ctl_off::ignore_clk_error>(); 
    return ret;
  }
  void set_simulation_flag(bool val) {
    if (val)
      ctl.set_bit<reg::unit_control, ctl_off::is_simulation>();
    else
      ctl.clear_bit<reg::unit_control, ctl_off::is_simulation>();
    
    log_message(__func__, val);
  }
  bool get_simulation_flag() { 
    bool ret = ctl.get_bit<reg::unit_control, ctl_off::is_simulation>(); 
    return ret;
  }


  void set_trigger_duration(uint32_t value) { 
    log_message(__func__, value);
    acq_param_duration = value;
    //if (value+acq_param_delay > 7000000) acq_param_duration = 7000000 - acq_param_delay;
    //already handled in the hardware
    ctl.write<reg::datac_window>((acq_param_duration/*+acq_param_delay*/)*250); 
    log_message(__func__, (acq_param_duration/*+acq_param_delay*/)*250);
  }
  void set_trigger_delay(uint32_t value) { 
    log_message(__func__, value);
    acq_param_delay = value;
    ctl.write<reg::datac_delay>(value*250); 
    log_message(__func__, value);
    //
    //already handled in the hardware
    //set_trigger_duration(acq_param_duration);
  }
  uint32_t get_trigger_duration() { 
    uint32_t value = ctl.read<reg::datac_window>()/250 /*- get_trigger_delay()*/; 
    log_message(__func__, value);
    return value;
  }
  uint32_t get_trigger_delay() { 
    uint32_t value = ctl.read<reg::datac_delay>()/250; 
    log_message(__func__, value);
    return value;
  }

  uint32_t get_adc_freq() {
    return sts.read<reg::adc_freq>();
  }
  uint32_t get_up_time() {
    return sts.read<reg::up_time>();
  }
  uint32_t get_tick_escaped() {
    return sts.read<reg::tick_counter>();
  }
  uint32_t get_bus_error_duration() {
    return sts.read<reg::bus_error_integrator>();
  }
  uint32_t get_bus_error_count() {
    return sts.read<reg::bus_error_count>();
  }
  uint32_t get_tick_target() {
    return sts.read<reg::datac_processed>();
  }
  uint32_t get_ext_io() {
    return sts.read<reg::io_in>() & 0xFF;
  }
  std::array<uint32_t, 2>  get_adc_values() {
    std::array<uint32_t, 2> ret = { 
        sts.read<reg::adc0> (), 
        sts.read<reg::adc1> ()
    };
    return ret;
  }
  uint32_t get_raw_status()
  {
    return sts.read<reg::unit_status_in>();
  }
  
  float get_temperature() {
    float ret = (xadc.read<xadc_regs::TEMP>() * 503.975) / 65356 - 273.15;
    return ret;
  }

  std::string getDevName(){
    std::ifstream file(host_filename.c_str());
    std::string devname;

    if(file.good()){
        getline(file, devname);
    }

    file.close();
    ctx.log<INFO>("%s(): %s \n", __func__, devname);
    return devname;
  }



  void set_state_machine(uint8_t val)
  {
    state_next = val;
    ctx.log<INFO>("%s: %d: Statemachine: %s.", __func__, state_next, ctrl_thread_running ? "On" : "Off");
  }
  uint32_t get_state_machine()
  {
    return state_crnt;
  }

  uint32_t get_number_of_samples_detected()
  {
    uint32_t val = nsamples_triggers ;
    return state_crnt == static_cast<uint32_t>(STATE_FINISHED) ? val : 0 ;
  }
  uint64_t get_device_status()
  {
    std::bitset<32> ret;

    uint64_t _ret = ret.to_ulong();
    return _ret;
  }

  bool do_arm() {
    if (get_state_machine() != 2) {
      ctx.log<CRITICAL>("%s: Failed to set arm %d.", __func__, get_state_machine());
      return false;
    }
    ctx.log<INFO>("%s()", __func__);
    set_state_machine(3);
    return true;
  }

  // return FPGA PL Vccint voltage
  float get_PlVccInt(){
      return (xadc.read<xadc_regs::PLVCCINT>() * 3.0) / 65356;
  }

  // return FPGA PL Vccaux voltage
  float get_PlVccAux(){
      return (xadc.read<xadc_regs::PLVCCAUX>() * 3.0) / 65356;
  }

  // return FPGA PL Vbram voltage
  float get_PlVccBram(){
      return (xadc.read<xadc_regs::PLVCCBRAM>() * 3.0) / 65356;
  }

  // return FPGA PS Vccint voltage
  float get_PsVccInt(){
      return (xadc.read<xadc_regs::PSVCCINT>() * 3.0) / 65356;
  }

  // return FPGA PS Vccaux voltage
  float get_PsVccAux(){
      return (xadc.read<xadc_regs::PSVCCAUX>() * 3.0) / 65356;
  }

  // return FPGA PS Vccmem voltage
  float get_PsVccMem(){
      return (xadc.read<xadc_regs::PSVCCMEM>() * 3.0) / 65356;
  }


 private:
  Context& ctx;
  Memory<mem::control>& ctl;
  Memory<mem::status>& sts;
  Memory<mem::xadc>& xadc;
  DmaUnit& dma;
  Memory<mem::ram_s2mm>& ram_s2mm;
  std::array<uint32_t, 16*2> data;

  std::thread ctrl_thread;
  std::thread log_thread;
  std::atomic<bool> log_thread_running{false};
  std::atomic<bool> log_thread_abort{false};
  std::atomic<bool> log_thread_finished{false};
  std::atomic<bool> ctrl_thread_abort{false};
  std::atomic<bool> ctrl_thread_running{false};

  uint32_t state_next = STATE_INIT;
  uint32_t state_crnt = STATE_INIT;
  
  std::atomic<std::time_t> time_triggered{0};
  std::atomic<std::uint32_t> nsamples_triggers{0};

  std::atomic<std::uint32_t> acq_param_duration{2};
  std::atomic<std::uint32_t> acq_param_delay{0};


  const std::string host_filename = "/etc/hostname";
  const std::string inf_filename = "/data_inf.dat";
  const std::string tiggers_filename = "/data_triggers.dat";

  void log_message(std::string func, uint32_t value) {
    std::stringstream stream;
    stream << func << ": 0x";
    stream << std::hex << value;
    std::string str = stream.str();
    ctx.log<INFO>(str.c_str());
  }

  void logThreadStart() {
    if (!log_thread_running) {
      ctx.log<INFO>("Starting Log Acq thread...");
      log_thread = std::thread{&DatAcqUnit::acqInfoToFile, this};
      log_thread.detach();
    }
  }

  void ctrlThreadStart() {
    if (!ctrl_thread_running) {
      ctx.log<INFO>("Starting control thread...");

      state_next = STATE_INIT;
      state_crnt = STATE_INIT;
      ctrl_thread = std::thread{&DatAcqUnit::ctrlThread, this};
      ctrl_thread.detach();
    }
  }

  // main control thread
  void ctrlThread() {
    bool data_proc_ok = true;

    ctrl_thread_running = true;

    ctx.log<INFO>("%s: Control thread has started.", __func__);

    while (!ctrl_thread_abort) {
      using namespace std::chrono_literals;
      std::this_thread::sleep_for(100us);
      state_crnt = state_next;

      switch (state_crnt) {
        // init state
        case STATE_INIT:

          ctx.log<INFO>("%s: current status ... INIT", __func__);
          state_next = STATE_RESET;

          break;

        // start reset sequence
        case STATE_RESET:

          //reset ip, dma and maybe flash new bitstream// if we do that we need to redo the timings
          set_ip_reset();
          dma.reset_s2mm();
          data_proc_ok = true;
          log_thread_abort = true;

          state_next = STATE_READY;
          ctx.log<INFO>("%s: current status ... READY", __func__);

          break;

        // system is ready, wait for arm
        case STATE_READY:
          // do nothing
          break;

        // start arming sequence
        case STATE_ARM:

          set_ip_reset();
          data_proc_ok = true;
          log_thread_abort = true;
          dma.reset_s2mm();

          ctx.log<INFO>("%s: current status ... ARM", __func__);
          set_trigger_duration(acq_param_duration);
          set_trigger_delay(acq_param_delay);

          using namespace std::chrono_literals;
          std::this_thread::sleep_for(1ms);
          set_arm();
          if(get_simulation_flag())
            set_simulated_trigger();

          dma.start_dma();

          state_next = STATE_ARMED;
          logThreadStart();

          break;

        // system is armed, wait for trigger
        case STATE_ARMED:

          if (is_triggered()) {
            time_triggered = std::chrono::system_clock::to_time_t(
                std::chrono::system_clock::now());
            ctx.log<INFO>("%s: current status ... TRIGGERED", __func__);
            state_next = STATE_SAMPLING;
          }

          break;

        // system is sampling
        case STATE_SAMPLING:

          if (!is_triggered()) {
            dma.stop_dma();
            state_next = STATE_PROC_DATA;
            log_thread_abort = true;
            ctx.log<INFO>("%s: Sampling done", __func__);
          }

          break;

        // process data: save raw data vector (for debugging)
        case STATE_PROC_DATA:
          {
          bool ret1 = acqDataToTriggersFile();

          data_proc_ok = ret1 ;
          ctx.log<INFO>("%s: Data processing completed: TrigError-%s ", __func__, ret1 ? "True" : "False");
          }
          state_next = STATE_PROC_INF;

          break;

        // process data: save acquisition info file
        case STATE_PROC_INF:

          if (log_thread_finished){
            if (data_proc_ok) {
              state_next = STATE_FINISHED;
              ctx.log<INFO>("%s: current status FINISHED wihout errors", __func__);
            } else {
              ctx.log<PANIC>("%s: ERROR: STATE_PROC_INF", __func__);
              state_next = STATE_ERROR;
            }
          }
          break;

        // acquisition cycle has finished
        case STATE_FINISHED:
          // do nothing
          break;

        // error state
        case STATE_ERROR:
          // do nothing
          break;

        default:
          state_next = STATE_INIT;
          break;
      }
    }

    // clear flags if thread was aborted
    if (ctrl_thread_abort) {
      ctrl_thread_running = false;
      ctrl_thread_abort = false;
      ctx.log<INFO>("%s: Control thread was aborted.", __func__);
    }

    return;
  }

  bool acqInfoToFile() {
    //std::time_t trig_time;//, current_time;
    std::ofstream data_file;
    uint32_t count = 0;
    log_thread_running = true;
    log_thread_abort = false;
    log_thread_finished = false;
    // try to open output file
    data_file.open(inf_filename.c_str(), std::ios::out | std::ios::trunc);

    if (data_file.good()) {
      ctx.log<INFO>("%s: Vector datafile opened/created.", __func__);
    } else {
      ctx.log<CRITICAL>("%s, Could not open/create acquisiton info file.", __func__);
      log_thread_running = false;
      log_thread_abort = false;
      log_thread_finished = true;
      return false;
    }
    //trig_time = time_triggered;

    
    while(!log_thread_abort)
    {

    }


    // close file
    data_file.close();

    log_thread_running = false;
    log_thread_abort = false;
    log_thread_finished = true;
    ctx.log<INFO>("%s: Logging thread was exited. Recorded %d events", __func__, count);
    return true;
  }

  bool acqDataToTriggersFile() {
    std::ofstream data_file;

    char file_header[] = "MAST-FEL-EVENTS/1\r\n";

    nsamples_triggers = 0;
    // try to open output file, truncate exisiting file
    data_file.open(tiggers_filename.c_str(), std::ios::binary | std::ios::trunc);

    if(data_file.good()){
        ctx.log<INFO>("%s: Vector datafile opened/created.", __func__);
    } else {
        ctx.log<INFO>("%s, Could not open/create acquisiton info file.", __func__);
        return false;
    }

    data_file.write((char*) &file_header, sizeof(file_header) - 1);

    // first valid data starts with 0xXXXX0000
    // any value 
    
    //bool await_first = true;
    for (size_t i = 0; i < mem::ram_s2mm_range/4; i++) {
    }
    // close file
    data_file.close();

    uint32_t tmp = nsamples_triggers;
    ctx.log<INFO>("%s: %d trgger frames parsed.", __func__, tmp);
    ctx.log<INFO>("%s: Data successfully written to %s datafile.", __func__, tiggers_filename);

    return true;
  }




};

#endif  // __DRIVERS_TRIGGER_UNIT_HPP__
