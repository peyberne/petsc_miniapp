#!/bin/python
import os
import fnmatch
import numpy as np

results = []
for root, dirs, files in os.walk('./'):
    for name in files:
        if fnmatch.fnmatch(name, 'log'):
            #print(os.path.join(root,name))
            with open(os.path.join(root,name),'r')  as f:
                data = f.readlines()
                if(len(data)>1):
                    norm = np.float64(data[0].rstrip())
                    time = np.float64(data[1].rstrip())
                    time_ssprec = np.float64(data[2].rstrip())
#                    if norm<1e-1:
                    print(norm, os.path.join(root, name), time, time_ssprec)


