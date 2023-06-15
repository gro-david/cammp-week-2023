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

## First approach
As the workpiece is spinning at infinite speed, all changes made at a position $x$ will be applied around the zylinder. It is fully symmetrical. Thus, the 3D-form of the tool should not make a difference, as only it's deepest cuts have to be taken into account.
This would allow to simplify the model further. Representing the workpiece and tool only as a cross-section in a binary matrix with $r$-rows and $x$-collumns, where the $1$ represent the workpiece and the $0$ represent empty space, we should be able to substract the tool from the workpiece. The new matrix would represent a cross-section of the new workpiece with a cutout resembling the tool. By rotating the Matrix around the $x$-axis, the 3D-form would be computable.

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