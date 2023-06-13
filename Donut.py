# sources:
#   https://scipython.com/book/chapter-7-matplotlib/examples/a-torus/
#   https://www.lucamoroni.it/toric-sections/

import numpy as np
import matplotlib.pyplot as plt

def elmos_donut(R: int, r: int, scale: int):
    #   R as big radius (theta)
    #   r as tiny radius    (phi)
    #   theta as hight of circle (circle in y)  
    #   phi as x coord of big circle ( cirlce in x)   

    # To compute all positions you need to iterate over theta and phi for 2*pi

    #   x = (R + r * math.cos(theta))* cos(phi)
    #   y = (R + r * math.cos(theta))* cos(phi)
    #   z = r * sin(theta)

    # create 1d array of values from 0 to 2*pi, with 2*pi / scale as resolution
    # for both, theta and phi
    theta = np.linspace(0, 2.*np.pi, scale)
    phi = np.linspace(0, 2.*np.pi, scale)
    theta, phi = np.meshgrid(theta, phi)
    x = (R + r*np.cos(theta)) * np.cos(phi)
    y = (R + r*np.cos(theta)) * np.sin(phi)
    z = r * np.sin(theta)

    return (x,y,z)

def elmos_half_donut(R: int, r: int, scale: int, down = True):
    # for 0 --> pi the upper half is modeled
    # for pi --> 2*pi the lower half is modeled
    # scale = scale / 2 because there would be double the datapoints 
    # for this model compared to the normal (complete) model otherwise

    scale = int(scale / 2)
    if(down):
        theta = np.linspace(np.pi, 2.*np.pi, scale)
    else:
        theta = np.linspace(0, np.pi, scale)
    
    phi = np.linspace(0, 2.*np.pi, scale)

    theta, phi = np.meshgrid(theta, phi)
    X = (R + r*np.cos(theta)) * np.cos(phi)
    Y = (R + r*np.cos(theta)) * np.sin(phi)
    Z = r * np.sin(theta) 
    return (X,Y,Z)

def deez_balls(coords: (), r: int, scale: int):
    # i dont know if i messed up the vars
    # x = r * cos(theta) * sin(phi)
    # y = r * sin(theta) * sin(phi)
    # z = r * cos(phi)
    x ,y = coords

    theta = np.linspace(0, 2.*np.pi, scale)
    phi = np.linspace(0, np.pi, scale)
    theta, phi = np.meshgrid(theta, phi)

    X = r * np.cos(theta) * np.sin(phi) + x
    Y = r * np.sin(theta) * np.sin(phi) + y
    Z = r * np.cos(phi)
    

    return (X,Y,Z)

def deez_nuts(coords: (), r: int, scale: int, down=False):
    # i dont know if i messed up the vars
    # x = r * cos(theta) * sin(phi)
    # y = r * sin(theta) * sin(phi)
    # z = r * cos(phi)
    # 
    # scale = scale / 2 because there would be double the datapoints 
    # for this model compared to the normal (complete) model otherwise

    x ,y = coords
    scale = int(scale / 2)

    theta = np.linspace(0, 2.*np.pi, scale)
    if(down):
        phi = np.linspace(0.5*np.pi,np.pi , scale)
    else:
        phi = np.linspace(0,0.5*np.pi , scale)

    theta, phi = np.meshgrid(theta, phi)

    X = r * np.cos(theta) * np.sin(phi)
    Y = r * np.sin(theta) * np.sin(phi)
    Z = r * np.cos(phi)
    

    return (X,Y,Z)
##########################################
scale = 30
R, r = 5,2
##########################################

# X1,Y1,Z1 = elmos_half_donut(R,r,scale, down=False)
# X2,Y2,Z2 = elmos_half_donut(R,r,scale, down=True)

# fig = plt.figure()
# ax1 = fig.add_subplot(121, projection='3d')
# ax1.set_zlim(-1*R,R)

# ax1.scatter(X1, Y1, Z1, color ="blue")
# ax1.scatter(X2, Y2, Z2, color = "red")

# ax1.view_init(36, 26)
# plt.show()

#########################################

X1,Y1,Z1 = deez_balls((R,R), R, scale)
X2,Y2,Z2 = deez_nuts((R*2,R*2), R, scale)

fig = plt.figure()
ax1 = fig.add_subplot(121, projection='3d')
ax1.set_zlim(-1*R,R)

ax1.scatter(X1, Y1, Z1, color ="green")
ax1.scatter(X2, Y2, Z2, color ="yellow")

ax1.view_init(36, 26)
plt.show()