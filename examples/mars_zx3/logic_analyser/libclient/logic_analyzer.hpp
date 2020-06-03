#ifndef __MAIN__CPP
#define __MAIN__CPP

#include <logicanalyser.hpp>
#include <memory>
#include <iostream>
#include <array>
#include <thread>
#include <sys/resource.h>

using namespace std::chrono_literals;
class logic_analyser_window {
 public:
  logic_analyser_window (const char* host, int port = 36000)
  {
    try {
        ptr = std::make_unique<logic_analyser_interface>(host, port);
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        EXIT_FAILURE;
    }
    data = new uint32_t[64*64*1024];

  }

  uint32_t* get_data()
  {
    try{
        ptr->start_dma();
        ptr->get_adc_data(data);
        ptr->stop_dma();
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        EXIT_FAILURE;
    }
    return data;
  }
  void set_triggers(uint32_t value)
  {
    try{
        if (!ptr->set_triggers(value))
            throw std::runtime_error("ERROR: trigger set failed\n");
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        EXIT_FAILURE;
    }
  }
  void get_triggers()
  {
    try{
        auto ret = ptr->get_triggers();
        std:: cout << "triggers: " << ret << std::endl;
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        EXIT_FAILURE;
    }
  }
  void get_forty_two()
  {
    try{
        auto ret = ptr->get_forty_two();
        std:: cout << "forty_two: " << ret << std::endl;
        if (ret != 42) throw std::runtime_error("ERROR: return not 42\n");
    }
    catch (const std::exception& e)
    {
        std::cout << e.what() << std::endl;
        EXIT_FAILURE;
    }
  }

  ~logic_analyser_window (){
    ptr.reset();
  };


 private:
  std::unique_ptr<logic_analyser_interface> ptr;
  uint32_t *data;
};


#endif
