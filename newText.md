# The Turn-Milling project
### Abstract
Turn-Milling is an essencial part of high performance metal-products with high production cost. By modelling the produced contour before production, costly errors can be prevented. This modelling process is the target of this work, featuring two approaches, one being a practical approach and one being analytical. Both have the goal to deliver a piecewise function describing the contours of the tool in the workpiece.

### Background
In medical, automotive and aeronautical applications great accuracy and material strength is needed to achieve best results and longevity of tools. For this purpose often steel is used, but with great strength comes difficult processing.

Turn-Milling is a process offering both accuracy and the capabilities to cut steel and harder metals, thus fitting all mentioned criteria.
In this process, the workpiece, often a hard-metal-block is fixed to a turn-table and spins at around 20,000 RPM. Then a tool is lowered into the metal, cutting off layers. Over time this creates a rotational contour of the tool in the workpiece.
If the tool was to penetrate or move through the metal at high speeds, it might damage the tool itself, as well as destroy the workpiece. As both the tool and the workpiece are expensive, it's important to be able to determine the contour ahead of time, to tweak the settings of the machine.

# How would one model the contour?

## Description of the problem
The contour can be controlled by moving the tool. It was proficient for us to model the movement of the tool along the $z$ and $x$ axis. Here, the $z$-axis represents the depth of the contour and the $x$-axis the position along the length of the workpiece. It wasn't necessary to model the movement of the tool along the $x$-axis while the milling is in process.
Due to the workpiece spinning at high speeds around the $x$-axis, one could simplify the model by assuming the speed as infinite, rendering the workpiece a geometrical cylinder.
The cutting depth is limited by the rotational-axis along $x$ and the radius $r$ or hight of the cylinder.

## First approach
As the workpiece is spinning at infinite speed, all changes made at a position $x$ will be applied around the cylinder. It is fully symmetrical. Thus, the 3D-form of the tool should not make a difference, as only it's deepest cuts have to be taken into account.
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
workpiece
\left(\begin{array}{ccc} 
0 & 0 & 0\\
1 & 0 & 1\\
1 & 1 & 1
\end{array}\right)

$$ 
\center \large is the same as:\\
$$
workpiece
\left(\begin{array}{ccc} 
3 & 3 & 3\\
\end{array}\right)\\
\left(\begin{array}{ccc} 
1 & 2 & 1\\
\end{array}\right)
$$ 
\center substraction: workpiece - tool \\
$$
workpiece
\left(\begin{array}{ccc} 
2&1&2\\
\end{array}\right)

The resulting hight-matrix can be used to plot the processed workpiece.

![show stair stepping graph]()

The heavy stair-stepping is a result of our low resolution tool. By interpolating points between the target points, we were able to smooth out the graph and gave it a more realistic shape. 

![get pic of smooth graph]()

#### Rotation

The next step is to rotate the slice of the workpiece around it's rotational axis. This was achieved by utilizing rotation-matrixes. 
 
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
The results for the cross-section (2D-plot) of the working-piece do work, altough with very low resolution. To up the resolution without relying on interpolation, we would have to add more points to the matrix of the tool.
Here we are hardware limited, as the matrices for both, workpiece and tool are loaded directly into the RAM of a computer. With possible millions of points to model round corners, a huge amount of RAM could be needed. This is not realistic and would mean high computational cost for a possibly simple render.

## Second approach
After we communicated with a representative from Modulework, we got to know that the cutting part of tool will always be a torus and could be need in a very high resolution. As this would resemble the worst case for our current algorithm, we opted for a more analytical approach. 
As this analytical approach doesn't impact the symmetry of our workpiece, the same cross-section as seen with the matrices is used.

By defining functions for both the workpiece and the tool, we would be able to compute the height of each object at any position. This would grant us to compute each height individually, not stressing the RAM. Also, the computations remain independet thus being able to still run in parallel, just like the matrices. The resolution could be defined by the amounts of points supplied to the function. As these functions also take values with decimal point, the resolution has a theoretical limit of the maximum float-size of the given PC

### basic algorithm
If the height of the tool is smaller than the height of the workpiece at the same point $x$, we can replace the height of the workpiece at that point with the height of the tool. 
The desribed logic can be written as:
```
wp = workpiece(x)
tl = tool(x)
where wp < tool:
    wp = tool
``` 

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


### II. Torus Formula
we researched the formula for the 3D-Torus and began to plot it. 

$x=(R+r\cdot cos(\phi))\cdot cos(\theta)$

$y=(R+r\cdot cos(\phi))\cdot sin(\theta)$

$z=r\cdot sin(\phi)$

in which the torus is described by two radii: the main radius {large radius R} and the cross-sectional radius {small radius r}. We wanted a formal in Cartesian coordinate system sothat it is not dependent on the angles--((sqrt(x^2 + y^2) - R)^2 + z^2) = r^2 this formula explains the relationship between the coordinates {x,y,z} of a point on the torus (the tool), the radius of the outer ring {R} and the smaller radius {r}.This equation ensures that a point (x, y, z) lies on the surface of the torus exactly when the equation is satisfied. We assumed that getting to know if one point on our workpiece is touched by the torus will help us to calculate the change of shapes of our workpiece and how it eventually looks like.

We tried to imagine that the workpiece is in the same coordinate system as the torus-tool and if we bring the coordinate of one point on the workpiece {x,y,z} in the formula, and the formula is rentabel, this means that this point is a touched by the torus. But the flaw of our thought is that there is a hole on the torus and if we calculate one point in that area as 'not touched' by the torus, still it will be influenced by the torus due to the rotation and we still do not know how deep it will be milled.

But meanwhile we got some new clues through the Spherical coordinate system formel, one idea is that if since the workpiece is rotating with infinitive speed, the centerpart of the torus will be milled in a form of hemisphere or an ellipse. The transition between the curves should be smooth enough that we can consider the bottom of the torus which touches the workpiece and the hemisphere as a whole function that affects and eventually forms the milled workpiece. This means that the whole process can be moderated and the resolution shall be choosable.

If we can get the funktion that will work on all forms of tools, the calculations will be optimized and at the same time save storage space and performance.


The problem remained to be the illustration as a 3D-model.
