import sys
sys.path.append('libraries')

import xml.etree.ElementTree as ET
from Vector import Vector2
import numpy as np

# expected format:
# <svg> <path [string]=[csv formatted string]/> </svg>
# example: <svg> <path "heights"="0,6,1,2,4,3,2,1,9"/> </svg>

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

    def get_form_val(self, url: str, key:str):
        tree = ET.parse(url)
        root = tree.getroot()
        data = root[0].attrib[key]
        vektors = np.array(data.split(","))
    
        own_data = list()
        for id, element in enumerate(vektors):
            own_data.append(Vector2(id, element))
        return np.array(own_data)

# SVGFormater = SVGFormater()
# data = SVGFormater.get_form_val(url='smiley.svg', key='d')