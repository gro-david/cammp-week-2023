import sys
sys.path.append('libraries')

import xml.etree.ElementTree as ET
from Vector import Vector2
import numpy as np

# expected format:
# <svg xmlns="http://www.w3.org/2000/svg" 
#   width=[string] 
#   height=[string] 
#   pos=[csv string]>
#   <path [string]=[csv formatted string]/> </svg>

# example: 
# <svg xmlns="http://www.w3.org/2000/svg" 
#   width="24" 
#   height="24" 
#   pos="0, 24">
#   <path "heights"="0,6,1,2,4,3,2,1,9"/> </svg>

class SVGFormater:

    def __init__(self):
        pass

    def read(self, url:str):
        tree = ET.parse(url)
        root = tree.getroot()
        return root

    def get_values(self, url:str, key:str):
        tree = ET.parse(url)
        root = tree.getroot()
        data = root[0].attrib[key]
        return data

    # read file contents of our own standard format (specs see above)
    # output style:
    # np.array(
    #   Vector2(widht, height), 
    #   Vector2(pos.x,pos.y),
    #   Vector2(data.x, data.y),
    #   ...
    #   Vector2(data.x, data.y),
    #   )
    def get_form_val(self, url: str):
        tree = ET.parse(url)
        root = tree.getroot()

        width = root[0].attrib["width"]
        height = root[0].attrib["height"]
        pos = root[0].attrib["pos"]
        data = root[0].attrib["data"]

        own_data = list()
        own_data.append(Vector2(width,height))
        
        x,y = np.array(pos.split(","))
        own_data.append(Vector2(x, y))

        vectors = np.array(data.split(","))
        for id, element in enumerate(vectors):
            own_data.append(Vector2(id, element))
        
        return np.array(own_data)
    
    # specs:
    # <svg xmlns="http://www.w3.org/2000/svg" 
    #   width=[string] 
    #   height=[string] 
    #  pos=[csv string]>
    #   <path [string]=[csv formatted string]/> </svg>

    # expected input: 
    # np.array(
    #   Vector2(widht, height), 
    #   Vector2(pos.x,pos.y),
    #   Vector2(data.x, data.y),
    #   ...
    #   Vector2(data.x, data.y),
    #   )
    def create_form_file(self, url:str, data:np.array):
        width = data[0].x 
        height = data[0].y
        pos = f'{data[1].x}, {data[1].y}'
        data_string = ','.join([ str(num) for num in data])

        data = f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" pos="{pos}"><path data="{data_string}"/> </svg>'
        with open(url, "w") as file:
            file.write(data)

    def create_file(self, url: str, key:str, data: np.array):
        data_string = ','.join([ str(num) for num in data])

        data = f'<svg> <path {key}="{data_string}"/> </svg>'
        with open(url, "w") as file:
            file.write(data)

# SVGFormater = SVGFormater()
# data = SVGFormater.get_form_val(url='smiley.svg')

# SVGFormater.create_file("test.svg", "heights", np.array([5,5,5,55]))
# SVGFormater.create_form_file("form_test.svg", \
#     np.array( \
#         (Vector2(5,5), Vector2(10,10), \
#         Vector2(10,10),Vector2(10,10),Vector2(10,10))))