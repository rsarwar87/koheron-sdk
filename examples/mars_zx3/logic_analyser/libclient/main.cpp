#include "logic_analyzer.hpp"
#include "bitset"


int main(){

    logic_analyser_window ip("192.168.1.114", 36000);
    ip.get_forty_two();

    ip.set_triggers(0xfffffff);
    ip.get_triggers();
    auto data = ip.get_data();

    for (size_t i = 0; i < 33; i++)
    {
      uint16_t *parr16 = (uint16_t*)(&(data[i]));
      for (size_t k = 0; k < 2; k++){

      std::bitset<16> bits(parr16[k]);
      // Storing integral values in the string:
      for(auto j: bits.to_string(char(0), char(1))) {
        std::cout << "\t" << (int)j;
      }
      std::cout << std::endl;
      }
    }


    std::cout << "\nhelloworld" << std::endl;
}
