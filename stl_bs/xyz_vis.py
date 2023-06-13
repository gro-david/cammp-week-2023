import numpy as np
import matplotlib.pyplot as plt

fig = plt.figure()
ax = plt.axes(projection='3d')


with open("output.xyz", "r") as f:
    x = np.array([])
    y = np.array([])
    z = np.array([])
    for line in f.readlines():
        _x, _y, _z = line.split()
        
        _x = round(float(_x), 0)
        _z = round(float(_z), 0)
        print(_z)
        if _z == 1:
            x = np.append(x, float(_x))
            y = np.append(y, float(_y))
            z = np.append(z, float(_z))


    ax.scatter3D(x, y, z)
plt.show()