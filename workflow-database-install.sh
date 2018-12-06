echo "Let's hope this works boys"
    chmod +x Database/utilities.py
    chmod +x Database/create_project_folders.sh
    chmod +x Database/create_mongo_db_collections.sh
    chmod +x Database/create_kraken_greengenes.sh
    chmod +x Database/Import_data_AG.py
    chmod +x Database/Import_data_IBD.py
    chmod +x Database/Import_data_T2D.py
    chmod +x Database/Import_AG_metadata.py
    chmod +x Database/Import_IBD_metadata.py
    chmod +x Database/Import_T2D_metadata.py
    chmod +x Database/xml_AG_tocollection.py
    echo "Creating project folders..."
    ./Database/create_project_folders.sh
    echo "Creating MongoDB collections..."
    ./Database/create_mongo_db_collections.sh
    echo "Importing AG metadata..."
    python Database/Import_data_AG.py
    echo "Importing IBD data..."
    python Database/Import_data_IBD.py
    echo "Importing T2D data..."
    python Database/Import_data_T2D.py
    echo "Adding AG metadata to collection..."
    python Database/Import_AG_metadata.py
    echo "Adding IBD metadata to collection..."
    python Database/Import_IBD_metadata.py
    echo "ADding T2D metadata to collection..."
    python Database/Import_T2D_metadata.py
    echo "Installing Kraken and the Greengenes database (here's where it starts taking a while!)"
    ./Database/create_kraken_greengenes.sh
    echo "Script finished running in $SECONDS seconds."
break
