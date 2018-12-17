
# coding: utf-8

# In[1]:


from pip._internal import main as pipmain

try:
 import pymongo
except ImportError:
 pipmain(['install','pymongo'])

try:
 import bs4
except ImportError:
 pipmain(['install','beautifulsoup4'])

try:
 import os
except ImportError:
 pipmain(['install','os'])

try:
 import pathlib
except ImportError:
 pipmain(['install','pathlib'])

try:
 import requests
except ImportError:
 pipmain(['install','requests'])

#try:
# import ete3 #Mutually exclusive with pandas#
#except ImportError:
# pipmain(['install','ete3'])

#try: #Mutually exclusive with ete3#
# import pandas
#except ImportError:
# pipmain(['install','pandas'])

