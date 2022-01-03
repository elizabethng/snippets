# -*- coding: utf-8 -*-
"""
Created on Wed Dec 29 10:07:08 2021

@author: ElizabethNg
"""

# Understand the zip function
# Note: in Python 3, this is a "generator function" that isn't
# evaluated until requested (i.e., until `list` is called)
# see https://stackoverflow.com/questions/19777612/python-range-and-zip-object-type

a = ("John", "Charles", "Mike")
b = ("Jenny", "Christy", "Monica", "Vicky")

x = zip(a, b)
print(x)
list(x)

c = (1, 2, 3)
d = (4, 5, 6)
y = zip(c, d)
print(y)
list(y)

