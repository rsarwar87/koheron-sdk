#!/usr/bin/python3
import numpy as np
import matplotlib.pyplot as plt

class detector:

    def __init__(self, name,sr):
        self.filename = name
        self.samples = np.uint32(np.zeros(sr)) # array with last 180 samples
        self.f=open(name, "r")

        
    def ReadValues(self):
        i = 0
        for x in range(0, len(self.samples)):
            data1 = self.f.readline()
            data2 = self.f.readline()
            self.samples[x] = (((np.uint16(data2) >> 2) & 0x3FFF) << 16) + ((np.uint16(data1) >> 2) & 0x3FFF)
 
 
if __name__ ==  '__main__':
    p1 = detector("/home/rsarwar/workspace/psa/Cf-int32",8*1024*1024)
    p1.ReadValues()
    print (len(p1.samples))
