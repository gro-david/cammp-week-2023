# The turn-tool project
### Abstract
Turnmilling is an essencial part of high performance metal-products with high production cost. By modelling the produced contour before production, costly errors can be prevented. This modelling process is the target of this work, featuring two approaches, one being a practical approach and one being analytical. Both have the goal to deliver a picewise function describing the contour of the tool in the workpiece.

### Background
In medical, automotive and aeronautical applications great accurcacy and material strength is needed to achieve best results and longevity. For this purpose often steal is used, but with great strength comes difficult processing.

Turn-Milling is a process offering both accuracy and the capabilities to cut steal and harder metals, thus fitting all mentioned criteria.
In this process, the workpiece, often a hard-metal-block is fixated to a turn-table and spun at around 20 000 RPM. Then a tool is lowered into the metal, cutting off layers. Over time this creates a rotational contour of the tool in the workpiece.
If the tool was to penetrate or move through the metal at high speeds, it might damage the tool itself, as well as destroy the workpiece. As both are expensive it's important to be able to determine the contour ahead of time, to tweak the settings of the machine.

# How could one model the contour?

## Description of the problem
The contour can be controlled by moving the tool. It was profecient for us to model the movement of the tool along the $z$ and $x$ axis. Here, the $z$-axis represents the depth of the contour and the $x$-axis the position along the length of the workpiece. It wasn't necessary to model the movement of the tool along the $x$-axis while the milling is in process.
Due to the workpiece spinning at high speeds around the $x$-axis, one could simplify the model by assuming the speed as infinite, rendering the workpiece a geometrical zylinder.
The cuttingdepth is limited by the rotation-axis $x$ and the radius $r$ or hight of the zylinder.

## I. First approach
As the workpiece is spinning at infinite speed, all changes made at a position $x$ will be applied around the zylinder. It is fully symmetrical. Thus, the 3D-form of the tool should not make a difference, as only it's deepest cuts have to be taken into account.
This would allow to simplify the model further. Representing the workpiece and tool only as a cross-section in a binary matrix with $r$-rows and $x$-collumns, where the $1$ represent the workpiece and the $0$ represent empty space, we should be able to substract the tool from the workpiece. The new matrix would represent a cross-section of the new workpiece with a cutout resembling the tool. By rotating the Matrix around the $x$-axis, the 3D-form would be computable. This is equal to the assumption that all parts of the tool cut at the same depth.

### Implementation
#### Slices
By adding all values of the matrix along the collumns, the resulting 1D-Array still contains all hight and length data, while reducing the needed computational steps. 

$$
workpice \\
\left(\begin{array}{ccc} 
1 & 1 & 1\\
1 & 1 & 1\\
1 & 1 & 1
\end{array}\right)
tool \\
\left(\begin{array}{ccc} 
01 & 1 & 1\\
0 & 1 & 0\\
0 &  & 0
\end{array}\right)
$$ 
\center substraction: workpiece - tool \\
$$
workpice
\left(\begin{array}{ccc} 
0 & 0 & 0\\
1 & 0 & 1\\
1 & 1 & 1
\end{array}\right)

$$ 
\center \large is the same as:\\
$$
workpice
\left(\begin{array}{ccc} 
3 & 3 & 3\\
\end{array}\right)\\
\left(\begin{array}{ccc} 
1 & 2 & 1\\
\end{array}\right)
$$ 
\center substraction: workpiece - tool \\
$$
workpice
\left(\begin{array}{ccc} 
2&1&2\\
\end{array}\right)
$$

The resulting hight-matrix can be used to plot the processed workpiece.

![show stair stepping graph]()

The remainging problem is that our final tool would be a torus and our code still cannot visualize round corners perfectly. To get rid of the step shape we implemented a custom smoothing algorithm.

```
for j in range(modified_raw_form[i][1]):
    if smooth:
        try:
            # smooth between the two points with the given offsets
            x0 = modified_raw_form[i][0]
            x1 = modified_raw_form[i + 1][0]
            step = (x1 - x0) / (modified_raw_form[i][1] + 1)  # Include both endpoints
            local_raw_form.append(x0 + step * j)
        except IndexError:
            print("error")
    else:
        # just add the current point
        local_raw_form.append(raw_form[i][0])
```
And more importantly on day two we moved away from the offset based tool creation system, which seemed like a good idea to get started on day one, but later it turned out to be very impractical. To solve this we rewrote great parts of the tool code. This incorporated a dataformat change from a point-point format to a vector-format. We also removed the previously mentioned smoothing code which got unnecesary with the voctorization. We instead needed to implement a interpolation algorithm. First we wanted to make this custom, but then decided for using the numpy.interp function.

```
def interpolate(self, raw_form):
        modified_raw_form = np.array([])
        x_coords2interp = np.array([i for i in range(self.wp_length)])
        x_coords = np.array([0])
        y_coords = np.array([0])

        for i, _ in enumerate(raw_form):
            x_coords = np.append(x_coords, raw_form[i].x)
            y_coords = np.append(y_coords, raw_form[i].y)
        x_coords = np.append(x_coords, self.wp_length)
        y_coords = np.append(y_coords, 0)

        modified_raw_form = -np.interp(x_coords2interp, x_coords, y_coords)
        return modified_raw_form
```


![get pic of smooth graph]()

#### Rotation

The next step is to rotate the slice of the workpiece around it's rotational axis. This was achieved utilizing rotation-matrixes. 
 
(entweder oder, nur eins der beiden sachen zeigen)

![rotation matrix Rx(a)](https://mathworld.wolfram.com/images/equations/RotationMatrix/Inline10.svg)
![rotation matrix Rx(b)](https://mathworld.wolfram.com/images/equations/RotationMatrix/Inline10.svg)
![rotation matrix Rx(y)](https://mathworld.wolfram.com/images/equations/RotationMatrix/Inline10.svg)

```
    def rotate(self, t):
        tx, ty, tz = np.deg2rad(t.x), np.deg2rad(t.y), np.deg2rad(t.z)
        matrix_x = np.matrix([[1, 0, 0], [0, np.cos(tx), -np.sin(tx)], [0, np.sin(tx), np.cos(tx)]])
        matrix_y = np.matrix([[np.cos(ty), 0, np.sin(ty)], [0, 1, 0], [-np.sin(ty), 0, np.cos(ty)]])
        matrix_z = np.matrix([[np.cos(tz), -np.sin(tz), 0], [np.sin(tz), np.cos(tz), 0], [0, 0, 1]])
        res_x = self.array * matrix_x
        res_y = res_x * matrix_y
        res_z = res_y * matrix_z
                
        self.x, self.y, self.z = round(res_z[0, 0], 5), round(res_z[0, 1], 5), round(res_z[0, 2], 5)
        return self
```

This results in the following plot:
![Fehlender Plot!]()

### Results and Problems
The results for the cross-section (the 2D-plot) of the workingpiece do work, altough with very low resolution. To up the resolution without relying on interpolation, we would have to add more points to the matrix of the tool.
Here we are hardware limited, as the matrices for both, workpiece and tool are loaded directly into the RAM of the PC. With possible millions of points to model round corners, a huge amount of RAM could be needed. This is not realistic and would mean high computational cost for a possibly simple render.

## II. Second approach
After we communicated with a representative from Modulework, we got to know that the cutting part of tool will always be a torus and could be need in a very high resolution. As this would resemble the worst case for our current algorithm, we opted for a more analytical approach. 

As this analytical approach doesn't impact the symmetry of our workpiece, the same cross-section as seen with the matrices is used.

By defining functions for both the workpiece and the tool, we would be able to compute the height of each object at any position. This would grant us to compute each height individually, not stressing the RAM. Also, the computations remain independet thus being able to still run in parallel, just like the matrices. The resolution could be defined by the amounts of points supplied to the function. As these functions also take values with decimal point, the resolution has a theoretical limit of the maximum float-size of the given PC

### Basic Algorithm
If the height of the tool is smaller than the height of the workpiece at the same point $x$, we can replace the height of the workpiece at that point with the height of the tool. 
The desribed logic can be written as:
```
wp = workpiece(x)
tl = tool(x)
where wp < tool:
    wp = tool
``` 

### Torus is 3D!

We researched the formula for the 3D-Torus and began to plot it. 

$x=(R+r\cdot cos(\phi))\cdot cos(\theta)$

$y=(R+r\cdot cos(\phi))\cdot sin(\theta)$

$z=r\cdot sin(\phi)$

in which the torus is described by two radii: the main radius {large radius R} and the cross-sectional radius {small radius r}. This correlation is given in a spherical coordinate system. With no experience in the spherical coordinate system, we changed to the Cartesian coordinate system as soon as possible. This formula explains the relationship between the coordinates {x,y,z} of a point on the torus (the tool), the radius of the outer ring {R} and the smaller radius {r}.This equation ensures that a point (x, y, z) lies on the surface of the torus exactly when the equation is satisfied. 

Per our basic algorithm it was only necessery to compute the coordinates of the lower half of the torus. This resulted in the following code to generate the half torus:

```

def half_donut(R: int, r: int, scale: int, down = True):
    # for 0 --> pi the upper half is modeled
    # for pi --> 2*pi the lower half is modeled
    # scale = scale / 2 because there would be double the datapoints 
    # for this model compared to the normal (complete) model otherwise
    # the down flag is to change wether the upper or lower half is rendered

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
```
The torus is not defined for values smaller than the inner radius $r§. As this would create unrealistic results, a sub-problem was found. How does a cavity inside a mill change the contour? We will reference this problem in the final conclusion, for now we found the following solution:
For our proof of concept we changed the rotating object. Instead of rotating the workpiece around the $x$ axis, we would rotate the mill around the $x$-axis. When the mill is lowered until it's center cuts the $x$-axis, it's spinning around itself, creating a sphere. This is equal to the assumption that all parts of the tool cut at the same depth.
Thus we modeled a ball next, once again cutting it in half to ensure that no more points where generated than actually needed:

```
def half_ball(coords: (), r: int, scale: int, down=False):
    # x = r * cos(theta) * sin(phi)
    # y = r * sin(theta) * sin(phi)
    # z = r * cos(phi)
    # 
    # scale = scale / 2 because there would be double the datapoints 
    # for this model compared to the normal (complete) model otherwise
    # the down flag is to change wether the upper or lower half is rendered

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
```

As we had difficulties defining the functions to take a known $x$- and $z$-value and retrun the $y$-value, we simplyfied the problem. 

#### Back to 2D
As the symmetrie remained the same and we still asume that all parts of the tool cut at the same depth, we used slices which we could then rotate again.

### Implementation
As the tool function is not defined for values broader than the tool width, it has to return 0 for these values of $x$.

```

def circle_fn(pos:(),r: int, x: int):
    x_ver, y_ver = pos
    if(x > (r+x_ver)):
        return 0
    if(x < (x_ver -r)):
        return 0
    r = r*r
    x = math.pow(x - x_ver,2) 
    
    return (math.sqrt(abs(r - x)) + y_ver ) * -1
```

This way we could utilize the basic algorithm for all given $x$. The computed values can then be stored in a file, in our case we stored them in a matrix to make visualization easier. 

This matrix could then also be rotated around the $x$-axis.

# 2D into 3D
The first idea of creating a 3D model is based on our 2D model. With the existing programme we are able to create slices that visualize the cutted workpiece 2-dimentionally in a z-x coordinate system. Then we take the slice and rotate it around the x-axis for a complete full rotation. In this way we can get a 3D portrayal. To achieve that we need to rotate vectors and it is quite tricky at first. But still the programmers accomplish that so that we can visualize workpiece and tool in 3D.

```
def create3d_plot():
    origin = Vector3(0, tl.form[0], 0)
    tl.form_on_origin = np.array([])
    x_coords_on_origin = np.array([])
    y_coords_on_origin = np.array([])
    z_coords_on_origin = np.array([])
    # the coordinates will get rounded and returned (x, y, z)
    output = np.array([[], [], []])
    ax = plt.axes(projection='3d')
    for i, _ in enumerate(tl.form):
        tl.form_on_origin = np.append(tl.form_on_origin, Vector3(i - origin.x, tl.form[i] - origin.y, 0))

    x_coords_on_origin = np.array([])
    y_coords_on_origin = np.array([])
    z_coords_on_origin = np.array([])
    for j in range(15, 375, 30):
        for k, _ in enumerate(tl.form_on_origin):
            tl.form_on_origin[k].rotate(Vector3(0, j, 0))
            x_coords_on_origin = np.append(x_coords_on_origin, np.array(tl.form_on_origin[k].z))
            y_coords_on_origin = np.append(y_coords_on_origin, np.array(tl.form_on_origin[k].x))
            z_coords_on_origin = np.append(z_coords_on_origin, np.array(tl.form_on_origin[k].y))

        ax.plot(x_coords_on_origin, y_coords_on_origin, z_coords_on_origin, color="blue")
        x_coords_on_origin = np.array([])
        y_coords_on_origin = np.array([])
        z_coords_on_origin = np.array([])
```

# Support through main classes
We also have some main classes to support the programm.
The first one is for the workpiece which is only defined by its length and radius. And the workpiece is always a cylinder but with different array variations to visualize the uncut workpiece, the negative workpiece and the cutted workpiece. Then we can visualize the half of the workpiece in all variations.

```
# 2/3D vec,tor classes with basic operations

class Vector2:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector2(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        return Vector2(self.x - other.x, self.y - other.y)

    def __mul__(self, other: float):
        return Vector2(self.x * other, self.y * other)

    def __truediv__(self, other: float):
        return Vector2(self.x / other, self.y / other)

    def to_vector3(self):
        return Vector3(self.x, self.y, 0)

class Vector3:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
        self.array = np.array([self.x, self.y, self.z])

    def __add__(self, other):
        return Vector3(self.x + other.x, self.y + other.y, self.z + other.z)

    def __sub__(self, other):
        return Vector3(self.x - other.x, self.y - other.y, self.z - other.z)

    def __mul__(self, other):
        return Vector3(self.x * other, self.y * other, self.z * other)

    def __truediv__(self, other):
        return Vector3(self.x / other, self.y / other, self.z / other)

    def __repr__(self):
         return f"Vector3({self.x}, {self.y}, {self.z})"

    def rotate(self, t):
        tx, ty, tz = np.deg2rad(t.x), np.deg2rad(t.y), np.deg2rad(t.z)
        matrix_x = np.matrix([[1, 0, 0], [0, np.cos(tx), -np.sin(tx)], [0, np.sin(tx), np.cos(tx)]])
        matrix_y = np.matrix([[np.cos(ty), 0, np.sin(ty)], [0, 1, 0], [-np.sin(ty), 0, np.cos(ty)]])
        matrix_z = np.matrix([[np.cos(tz), -np.sin(tz), 0], [np.sin(tz), np.cos(tz), 0], [0, 0, 1]])
        res_x = self.array * matrix_x
        res_y = res_x * matrix_y
        res_z = res_y * matrix_z

        self.x, self.y, self.z = round(res_z[0, 0], 5), round(res_z[0, 1], 5), round(res_z[0, 2], 5)
        return self

# a workpiece is cylinder defined by its length and radius
class Workpiece:
    def __init__(self, length: int, radius: float):
        self.length = length
        self.radius = radius
        self.array = np.array([])
        for i in range(0, length):
            self.array = np.append(self.array, self.radius)
        self.array_uncut = self.array.copy()
        self.negative_array = [-i for i in self.array]
        self.negative_array_uncut = self.negative_array.copy()

    # sets the correct dimensions of the plot and plots the workpiece
    def visualize_half(self):
        """
        x = np.array([i for i in range(self.length)])
        b_spline_coeff = make_interp_spline(x, self.array)
        x_final = np.linspace(x.min(), x.max(), 500)
        y_final = b_spline_coeff(x_final)
        plt.plot(x_final, y_final)
        """
        g = fig.add_subplot(133)
        g.plot(self.array)
        g.set_xlim(0, self.length)
        g.set_ylim(-self.radius * 2, self.radius * 2)

    def visualize_uncut(self):
        g = fig.add_subplot(131)
        g.set_title("Uncut Workpiece")
        g.plot(self.array_uncut, color='orange')
        g.plot(self.negative_array_uncut, color='orange')
        g.set_xlim(0, self.length)
        g.set_ylim(-self.radius * 2, self.radius * 2)

    def visualize(self):
        self.negative_array = [-i for i in self.array]
        g = fig.add_subplot(133)
        g.set_title("Finished Workpiece")
        g.plot(self.array, color='orange')
        g.plot(self.negative_array, color='orange')
        g.set_xlim(0, self.length)
        g.set_ylim(-self.radius * 2, self.radius * 2)

    # point is the index of the slice, depth the y-coordinate of the cut
    def cut(self, point: int, depth: float):
        self.array[point] = depth

    # cut to the same depth at multiple points
    # points: (from: inclusive, to: exclusive)
    def cut_multiple(self, points: list[int, int], depth: float):
        for point in range(points[0], points[1] - 1):
            self.cut(point, depth)
```


The other one class is for the tool that we can choose the position and the shape of it and then translate in 2 dimentional arrays. The still form is saved in vector 2, and it needs to be written in an array form so it can be substracted in the workpiece. The length is chosen as one parameter to be used in the calculation. Additionally, we have a chosen origin point that is located in the center of the tool and represents all the other point in this tool, it is easy to rotate the tool around the origin point. In this tool class is also an numpy interpolation used. Calculate form extends our still form to the length of the workpiece, the question in which direction it is extended is defined by our position on the x-axis. Visualize sub is a visualization function that presents many plotings in one data as a sub plot that can draws its own graph. During the cutting process, the workpiece musted be indicated with what getting cut is and compares if the tool z- index is lower or the workpiece z-index. And we will cut and form our workpiece at the lowest index. This means if the workpiece has the same value as the tool, nothing will be cut, if our tools index is lower, then we cut it.

```
# position is left top corner
# form is a list of tuples with float (depth) and int (how often) (index is x-coordinate, value is cut-depth)
# wp_lenght is the length of the workpiece, needed for correct plotting
class Tool:
    def __init__(self, position: Vector2, raw_form: np.array([Vector2]), wp_lenght: int):
        self.position = position
        self.wp_length = wp_lenght
        self.form_on_origin = np.array([])
        self.raw_form = self.interpolate(raw_form)
        self.form = self.calculate_form()

    def interpolate(self, raw_form):
        modified_raw_form = np.array([])
        x_coords2interp = np.array([i for i in range(self.wp_length)])
        x_coords = np.array([0])
        y_coords = np.array([0])

        for i, _ in enumerate(raw_form):
            x_coords = np.append(x_coords, raw_form[i].x)
            y_coords = np.append(y_coords, raw_form[i].y)
        x_coords = np.append(x_coords, self.wp_length)
        y_coords = np.append(y_coords, 0)

        modified_raw_form = -np.interp(x_coords2interp, x_coords, y_coords)
        return modified_raw_form

    def move(self, position: Vector2):
        self.position = position
        self.form = self.calculate_form()

    def calculate_form(self):
        local_form = self.raw_form.copy()
        for i in range(0, self.position.x): local_form = np.insert(local_form, 0, 0)
        for i, _ in enumerate(local_form): local_form[i] = self.position.y - local_form[i]
        while len(local_form) < self.wp_length: local_form = np.append(local_form, self.position.y)
        return local_form.copy()

    def visualize(self, wp):
        g = fig.add_subplot(132)
        g.set_title("Tool")
        self.plot = g.plot(self.form, color="blue")
        g.set_xlim(0, self.wp_length)
        g.set_ylim(-wp.radius * 2, wp.radius * 2)

    def cut(self, wp):
        for i, _ in enumerate(wp.array):
            wp.cut(i, min(self.form[i], wp.array[i]))
```

We have our workpiece which has a uneven number of data points as length, it has to be uneven so we can have an exact middle point, so we can rotate our workpiece around it. Then we enter the points where we want the workpiece to be cut and everything will be visualized with the programm.

```
ax = plt.axes(projection='3d')
origin = Vector3(0, 0, 0)
wp.array_on_origin = np.array([])
x_coords_on_origin = np.array([])
y_coords_on_origin = np.array([])
z_coords_on_origin = np.array([])
for i, _ in enumerate(wp.array):
    wp.array_on_origin = np.append(wp.array_on_origin, Vector3(i - origin.x, wp.array[i] - origin.y, 0))
for j in range(0, 360, 36):
    for k, _ in enumerate(wp.array_on_origin):
        wp.array_on_origin[k].rotate(Vector3(j, 0, 0))
        x_coords_on_origin = np.append(x_coords_on_origin, np.array(wp.array_on_origin[k].x))
        y_coords_on_origin = np.append(y_coords_on_origin, np.array(wp.array_on_origin[k].y))
        z_coords_on_origin = np.append(z_coords_on_origin, np.array(wp.array_on_origin[k].z))
    ax.plot(x_coords_on_origin, y_coords_on_origin, z_coords_on_origin, color="blue")
    x_coords_on_origin = np.array([])
    y_coords_on_origin = np.array([])
    z_coords_on_origin = np.array([])

array_on_origin = wp.array_on_origin.copy()
important_points = np.array([])
first_point = 0
first_point_value = array_on_origin[0].y
second_point = 0
second_point_value = 0
i = 1
while first_point_value == array_on_origin[i].y:
    try:
        if array_on_origin[i + 1].y != first_point_value:
            second_point = int(i)
            second_point_value = round(array_on_origin[i].y, 5)
            important_points = np.append(important_points, [first_point, second_point])
            first_point = int(i + 1)
            first_point_value = round(array_on_origin[i + 1].y, 5)
    except IndexError:
        second_point = int(i)
        second_point_value = round(array_on_origin[i].y, 5)
        important_points = np.append(important_points, [first_point, second_point])
        break
    i += 1
print(important_points)

vertices = []
for i, _ in enumerate(important_points):
    for j in range(0, 360, 180):
        vertex = array_on_origin[int(important_points[i])].rotate(Vector3(j, 0, 0))
        vertex = tuple([vertex.x, vertex.y, vertex.z])
        vertices.append(vertex)
plt.show()
![rotated_endproduct]

```

## Problems
As teasered in II. Torus, we found a sub-problem to our approach. We assumed the tool to penetrate the same way at all coordinates, this prooved to be wrong. 
Let's assume that instead of spinning the workpiece, we spun the tool around the $x$-axis. As previously, we lover the torus towards to $x$-axis until it transforms into a sphere. For this edge-case, assumption is correct. But if we where to lift the tool, the resulting workpiece doesn't feature a circle anymore.

In reality, the points along the $y$-axis dont penetrate as deep and thus also cut less from the material. Thus results in an eliptic curvature between the deepest cutting points of the tool

![show cross sectrion from module works]()

To resolve this issue, we would like to define the given solution as only applicable for tools without an invagination. This is because these tools are not limited by the $y$-axis, as the material not cut at an outer position would still be cut at an more inward position.

## Conclusion
The first approach was easy to implement and allowed for fast iteration of our ideas, but yielded bad resolution and performance parameters. The second approach solved both of these issues and revealed underlying problems with our models. 
Still, we managed to come up with a model which can be applied for tools without an invagination at the bottom. The resulting cross-sections for these graphs can be rendered in parallel, with low memory-usage and a chosen resolution. Also an upscaling to a 3D-model is possible!

## Note of thanks
Thanks to ModuleWorks for the interesting problem and push in the right direction!
Thanks to the RWTH Aachen and the KIT for financing and organizing this great opportunity!

Special thanks to:
Maks for proofreading this script, helping the lost in code and streamlining of our final day!
Maren for helping with the mathematical formulas and forcing us reflect our approaches!

Dear reader, thank you for your time reading this script! 