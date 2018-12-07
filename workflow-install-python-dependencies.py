
# coding: utf-8

# In[1]:


from pip._internal import main as pipmain

try:
 import pymongo
except ImportError:
 pipmain(['install','pymongo'])

try:
 import pandas
except ImportError:
 pipmain(['install','pandas'])

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
 import ete3
except ImportError:
 pipmain(['install','ete3'])

try:
 import requests
except ImportError:
 pipmain(['install','requests'])

