from matplotlib import pyplot as plt
import numpy as np

from Vector import Vector2
from Workpiece import Workpiece
from Tool import Tool

import timeit
import time

# intialize workpiece with length 50 and radius 5
wp = Workpiece(50, 5)

# intialize the tool at the given position and set the shape
tl = Tool(Vector2(15, 6), [1, 4, 6, 4, 1, 0, 0, 0, 1, 4, 6, 4, 1], wp.length)

start_time = timeit.default_timer()
# cut out the parts of the workpiece that are in contact with the tool
tl.cut(wp)
print(f'Takes running time: {timeit.default_timer() - start_time}')

# plot the workpiece and the tool and show the plot
tl.visualize()
wp.visualize()
plt.show()