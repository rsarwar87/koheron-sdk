#include "logic_analyzer.hpp"


int main(){

    logic_analyser_window ip("192.168.1.114", 36000);
    ip.get_forty_two();

    ip.set_triggers(0xfffffff);
    ip.get_triggers();
    auto data = ip.get_data();

    for (size_t i = 0; i < 60; i++)
    {
      for(auto j: data[i].to_string(char(0), char(1))) {
        std::cout << "\t" << (int)j;
      }
      std::cout << std::endl;
    }


    std::cout << "\nhelloworld" << std::endl;
}
