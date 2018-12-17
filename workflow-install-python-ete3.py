
# coding: utf-8

# In[1]:


from pip._internal import main as pipmain

try:
 import ete3 #Mutually exclusive with pandas#
except ImportError:
 pipmain(['install','ete3'])
