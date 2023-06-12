# position is left top corner
# form is a list of floats (index is x-coordinate, value is cut-depth)
import Vector
from matplotlib import pyplot as plt

class Tool:
    def __init__(self, position: Vector.Vector2, form: list[float]):
        self.position = position
        self.raw_form = form

    def move(self, movement: Vector.Vector2):
        self.position += movement

    def visualize(self):
        form = self.raw_form
        for i in range(0, self.position.x): form.insert(0, 0)
        for i, _ in enumerate(form): form[i] = self.position.y - form[i]
        plt.plot(form)