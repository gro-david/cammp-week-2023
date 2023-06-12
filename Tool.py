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
    def __init__(self, position: Vector.Vector2, raw_form: list[float], wp_lenght: int):
        self.position = position
        self.raw_form = raw_form
        self.wp_lenght = wp_lenght
        self.form = self.calculate_form()

    # moves the tool by the given vector and recalculates the form
    def move(self, movement: Vector.Vector2):
        self.position += movement
        self.form = self.calculate_form()

    # after this function plt.show() must be called seperately (in this way so we can plot a workpiece and a tool in the same plot)
    def visualize(self):
        plt.plot(self.calculate_form())
    
    # must be called after every change to the positition
    def calculate_form(self):
        local_form = self.raw_form.copy()
        for i in range(0, self.position.x): local_form.insert(0, 0)
        for i, _ in enumerate(local_form): local_form[i] = self.position.y - local_form[i]
        while len(local_form) < self.wp_lenght: local_form.append(self.position.y)
        return local_form.copy()
    
    # cut the workpiece if the tool is below the surface
    def cut(self, wp: Workpiece):
        for i, _ in enumerate(wp.array):
            if self.form[i] < wp.array[i]: wp.cut(i, self.form[i])