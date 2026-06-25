#!/usr/bin/env python
# -*- coding: utf-8 -*-

from koheron import connect
import os
import time
from led_blinker import LedBlinker

host = os.getenv('HOST','10.240.229.100')
client = connect(host, name='teb0911_template')
driver = LedBlinker(client)

print(driver.get_forty_two())
print(driver.get_mgt_clocks())

