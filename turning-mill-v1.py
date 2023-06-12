from matplotlib import pyplot as plt
import numpy as np

from Vector import Vector2
from Workpiece import Workpiece
from Tool import Tool

wp = Workpiece(50, 5)
wp.cut_multiple((2, 4), 3)

tl = Tool(Vector2(0, 9), [1, 3, 6, 3, 1])

tl.visualize()
wp.visualize()
plt.show()