
# coding: utf-8

# In[1]:

from pip._internal import main as pipmain

try: #Mutually exclusive with ete3#
 import pandas
except ImportError:
 pipmain(['install','pandas'])
