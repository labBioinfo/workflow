Download and Store requirements:

mongodb version 4.0.3 or more

python 3.5 or more

please make sure that build-essential package is installed. (sudo apt install build-essential)

Python Libraries used:
- pymongo
- BeautifulSoup
- Pandas
- os
- pathlib
- requests


Use the following program run sequence for sample database download and store: (please make sure to have the utilities.py with the import and download datasets.

1. create_project_folders.sh make it executable and run it (chmod +x)

2. create_mongo_collections.sh make it executable and run it (chmod +x)

3. Import_data_AG.py

4. xml_AG_tocollection.py

5. Import_data_T2D.py

6. xml_T2D_tocollection.py

7. Import_data_IBD.py

8. xml_IBD_tocollection.py


Use the following program run sequence for kraken database download and store:

1. create_kraken_greengenes.sh make it executable and run it (chmod +x)
