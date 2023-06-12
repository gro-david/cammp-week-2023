# position is left top corner
# form is a list of floats (index is x-coordinate, value is cut-depth)
import Vector
import Workpiece

from matplotlib import pyplot as plt
import numpy as np

# position is left top corner
# form is a list of floats (index is x-coordinate, value is cut-depth)
# wp_lenght is the length of the workpiece, needed for correct plotting
class Tool:
    position = None
    raw_form = None
    wp_lenght = None
    form = None


    def __init__(self, position: Vector.Vector2, raw_form: np.array, wp_lenght: int):
        self.position = position
        self.raw_form = raw_form
        self.wp_lenght = wp_lenght
        self.form = self.calculate_form()

    # moves the tool by the given vector and recalculates the form
    def move(self, movement: Vector.Vector2):
        self.position += movement
        self.form = self.calculate_form()

    # after this function plt.show() must be called seperately (in this way so we can plot a workpiece and a tool in the same plot)
    def visualize(self, wp):
        plt.plot((self.position.y - self.calculate_form()) + wp.radius )
    
    # must be called after every change to the positition
    def calculate_form(self):
        #print(f'self.form: {self.form} ' )
        mill = self.raw_form.copy()

        sized_mill = np.zeros(self.wp_lenght) # fill resized array with 0
        #print(f'sized_mill: {sized_mill}')
        # for i, _ in enumerate(form): form[i] = self.position.y - form[i]
        mill_size = mill.size -1
        for i in range(mill_size):
            new_val = mill[i] - self.position.y
            if(new_val <= 0 ):
                mill[i] = 0
            else:
                sized_mill[self.position.x + i] = new_val
        self.form = sized_mill
        #print(f'sized_mill: {sized_mill} ')
        #print(f'self.form: {self.form} ' )
        
        return sized_mill.copy()

    # cut the workpiece if the tool is below the surface
    def cut(self, wp: Workpiece):
        #for i, _ in enumerate(wp.array):
        #    if self.form[i] < wp.array[i]: wp.cut(i, self.form[i])
        #print(f'wp array: {wp.array}')
        substract_arr = np.subtract(wp.array, self.form)
        #print(f'substract var: {substract_arr}')
        #print(f'subtrct formula: {np.subtract(wp.array, self.form)}')
        return substract_arr