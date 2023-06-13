import math

import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator
import numpy as np
# donut variables
#   R as big radius
#   r as tiny radius
#   u as hight of circle (circle in y)
#   v as x coord of big circle ( cirlce in x)

# To compute all positions you need to iterate over u and v for (idk) 5 (?)
# 

#   x = (R + r * math.cos(u))* cos(v)
#   y = (R + r * math.cos(u))* cos(v)
#   z = r * sin(u)

def elmos_donut(R: int, r: int, scale: int, debug = False):
    x = list()
    y = list()
    z = list()

    for u in range(scale):
        if (u % 100 == 0 and debug):
            print(f'Running: {  ((u +1)/scale) * 100:.2f} % ')
        for v in range(scale):
            x.append((R + r * math.cos(u))* math.cos(v))
            y.append((R + r * math.cos(u))* math.cos(v))
            z.append(r * math.sin(u))
    if(debug):
        print("Done!")
    return (x,y,z)

X,Y,Z = elmos_donut(2,1,2500, debug=True)

fig = plt.figure()
ax = plt.axes(projection='3d')

# Data for a three-dimensional line
zline = np.array(Z)
xline = np.array(X)
yline = np.array(Y)
# ax.plot3D(xline, yline, zline, 'gray')

# Data for three-dimensional scattered points
# zdata = 15 * np.random.random(100)
# xdata = np.sin(zdata) + 0.1 * np.random.randn(100)
# ydata = np.cos(zdata) + 0.1 * np.random.randn(100)
ax.scatter3D(xline, yline, zline, c=zline, cmap='Greens')

plt.show()