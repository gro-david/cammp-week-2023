from matplotlib import pyplot as plt
import numpy as np

from Vector import Vector2
from Workpiece import Workpiece
from Tool import Tool

import timeit
import time

# intialize workpiece with length 50 and radius 5
wp = Workpiece(1000000, 5)

raw_format = np.array([1, 4, 6, 4, 1, 0, 0, 0, 1, 4, 6, 4, 1])
print(f'array size . {raw_format.size}')
# intialize the tool at the given position and set the shape
verschub = Vector2(15, 5)
print(f'x Verschub {verschub.x} | y verschub {verschub.y}')
tl = Tool(verschub, np.array([1, 4, 6, 4, 1, 0, 0, 0, 1, 4, 6, 4, 1]), wp.length)

start_time = timeit.default_timer()
# cut out the parts of the workpiece that are in contact with the tool
wp.array =  tl.cut(wp)
print(f'Takes running time: {timeit.default_timer() - start_time}')
#print(f'wp array: {wp.array}')
# plot the workpiece and the tool and show the plot
tl.visualize(wp)
wp.visualize()
plt.show()