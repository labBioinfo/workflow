echo "Let's hope this works boys"
    chmod +x Database/utilities.py
    chmod +x Database/create_project_folders.sh
    chmod +x Database/create_mongo_db_collections.sh
    chmod +x Database/create_kraken_greengenes.sh
    chmod +x Database/Import_data_AG.py
    chmod +x Database/Import_data_IBD.py
    chmod +x Database/Import_data_T2D.py
    chmod +x Database/Import_AG_metadata_db.py
    chmod +x Database/Import_IBD_metadata_db.py
    chmod +x Database/Import_T2D_metadata_db.py
    chmod +x Database/xml_AG_tocollection_db.py

    echo "Creating project folders..."
    ./Database/create_project_folders.sh
    echo "Creating MongoDB collections..."
    ./Database/create_mongo_db_collections.sh

while true
do
  read -r -p "Would you like to download the AG database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Importing AG data..."
    	python Database/Import_data_AG.py
    	echo "Adding AG metadata to collection..."
    	python Database/Import_AG_metadata_db.py
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping AG database..."
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done
while true
do
  read -r -p "Would you like to download the IBD database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Importing AG data..."
    	python Database/Import_data_IBD.py
    	echo "Adding AG metadata to collection..."
    	python Database/Import_IBD_metadata_db.py
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping IBD database..."
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

while true
do
  read -r -p "Would you like to download the T2D database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Importing T2D data..."
    	python Database/Import_data_T2D.py
    	echo "Adding AG metadata to collection..."
    	python Database/Import_T2D_metadata_db.py
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping T2D database..."
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

while true
do
  read -r -p "Would you like to install the Kraken and the Greengenes database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Installing Kraken and the Greengenes database..."
    	./Database/create_kraken_greengenes.sh
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping Kraken database..."
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done
    echo "Script finished running in $SECONDS seconds."
break
