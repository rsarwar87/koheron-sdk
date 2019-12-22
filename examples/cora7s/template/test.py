#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import time
from koheron import command, connect

class TemplateDriver(object):
    def __init__(self, client):
        self.client = client


    @command()
    def get_forty_two(self):
        return self.client.recv_uint32()

if __name__=="__main__":
    host = os.getenv('HOST','192.168.1.87')
    client = connect(host, 'template')
    driver = TemplateDriver(client)

    print(driver.get_forty_two())

