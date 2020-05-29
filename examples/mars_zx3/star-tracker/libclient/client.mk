TMP_CLIENT_PATH := $(PWD)

CLIENT := $(TMP_CLIENT_PATH)/main

OPERATIONS_HPP = $(TMP_CLIENT_PATH)/koheron/stu/operations.hpp

CLIENT_CCXX := g++-5 -flto  -m32  
#CLIENT_CCXX = x86_64-w64-mingw32-g++

# Install clang:
# apt-get install clang libc++-dev
# CLIENT_CCXX := clang

# Common flags
CLIENT_CCXXFLAGS := -march=native -O3
CLIENT_CCXXFLAGS += -MMD -MP -Wall -Werror
CLIENT_CCXXFLAGS += -std=c++14 -pthread
CLIENT_CCXXFLAGS += -I$(TMP_CLIENT_PATH) -I$(TMP_CLIENT_PATH)/koheron/drivers -I$(TMP_CLIENT_PATH)/koheron/context -I$(TMP_CLIENT_PATH)/koheron/core -I$(TMP_CLIENT_PATH)/koheron/client -I${TMP_CLIENT_PATH}/koheron/stu

# GCC flags
CLIENT_CCXXFLAGS += -lm -static-libgcc -static-libstdc++
CLIENT_CCXXFLAGS += -Wpedantic -Wfloat-equal -Wunused-macros -Wcast-qual -Wuseless-cast
CLIENT_CCXXFLAGS += -Wlogical-op -Wdouble-promotion -Wformat -Wmissing-include-dirs -Wundef
CLIENT_CCXXFLAGS += -Wcast-align -Wpacked -Wredundant-decls -Wvarargs -Wvector-operation-performance -Wswitch-default
CLIENT_CCXXFLAGS += -Wuninitialized -Wshadow -Wzero-as-null-pointer-constant -Wmissing-declarations

# Clang flags
# CLIENT_CCXXFLAGS += -stdlib=libc++
# CLIENT_LD_FLAGS=-fuse-ld=gold -lstdc++

# Mingw32 flags
#CLIENT_CCXXFLAGS += -lws2_32

CLIENT_DRV := $(TMP_CLIENT_PATH)/driver.so
CLIENT_OBJ := $(TMP_CLIENT_PATH)/main.o
CLIENT_OBJ += $(TMP_CLIENT_PATH)/driver.o
CLIENT_DEP=$(subst .o,.d,$(OBJ))
-include $(CLIENT_DEP)

$(TMP_CLIENT_PATH)/%.so: $(TMP_CLIENT_PATH)/%.o $(OPERATIONS_HPP) | $(TMP_CLIENT_PATH)
	$(CLIENT_CCXX) -shared -fPIC $(CLIENT_CCXXFLAGS) -o $@ $<
	ln -sf driver.so libdriver.so
$(TMP_CLIENT_PATH)/%.o: $(TMP_CLIENT_PATH)/%.cpp $(OPERATIONS_HPP) | $(TMP_CLIENT_PATH)  
	$(CLIENT_CCXX) -c  $(CLIENT_CCXXFLAGS) -o $@ $<

PHONY: client
client: $(CLIENT_OBJ) ${CLIENT_DRV} 
	$(CLIENT_CCXX) -static -o $(CLIENT)_static $(CLIENT_OBJ) $(CLIENT_CCXXFLAGS) $(CLIENT_LD_FLAGS)  
	$(CLIENT_CCXX) -o $(CLIENT)  $(CLIENT_OBJ) $(CLIENT_CCXXFLAGS)  $(CLIENT_LD_FLAGS)

PHONY: clean
clean: rm driver.d driver.so main.d main.o driver.o main libdriver.so main_static
