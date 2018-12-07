#MADE BY BOBO#
#THIS SCRIPT AUTOMATES THE DATABASE INSTALL PROCESS - IT CALLS THE REQUISITE SCRIPTS AUTOMATICALLY#
#YOU CAN PICK WHICH DATABASES YOU'D LIKE TO INSTALL#
#HAVE A DAMN FTP CONNECTION WHEN YOU'RE INSTALLING GREENGENES#
#YOU CAN CANCEL THE DOWNLOAD AT ANY TIME BY PRESSING CTRL+D#
#TO-DO: SANITY CHECKS - VALIDATE THE DOWNLOAD AND CHECK FOR POTENTIAL ERRORS#

######ALSO, PLAY ARCANUM######

echo "Let's hope this works boys" #CHMOD FOR ALL THE NECESSARY FILES#
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

    echo "Creating project folders..." #CREATES THE REQUISITE FOLDERS#
    ./Database/create_project_folders.sh
    echo "Creating MongoDB collections..." #CREATES THE MONGODB DATABASE#
    ./Database/create_mongo_db_collections.sh

while true #AG INSTALL PROMPT#
do
  read -r -p "Would you like to install the AG database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
	echo "Will install AG database."	
	install1=true
	break	
	;;
		[nN][oO]|[nN])
	echo "Skipping AG database..."
	install1=false
	break	
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

while true #IBD INSTALL PROMPT#
do
  read -r -p "Would you like to download the IBD database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Will install IBD database."
	install2=true
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping IBD database..."
	install2=false
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

while true #T2D INSTALL PROMPT#
do
  read -r -p "Would you like to download the T2D database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Will install T2D database."
	install3=true
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping T2D database..."
	install3=false
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

while true #KRAKEN/GREENGENES INSTALL#
do
  read -r -p "Would you like to install the Kraken and the Greengenes database? [y/n]" input1

  case $input1 in
		[yY][eE][sS]|[yY])
    	echo "Will install Kraken and Greengenes."
	install4=true
	break
	;;
		[nN][oO]|[nN])
	echo "Skipping Kraken database..."
	install4=false
	break
	;;
		*)
	echo "Invalid input."
	;;
	esac
done

#INSTALLERS#

if $install1 ; then #American Genome
	echo "Downloading the AG database!"
	python Database/Import_data_AG.py
	echo "Creating the AG collection!"
	python Database/Import_AG_metadata_db.py
else
	echo "AG skipped."
fi

if $install2 ; then #IBD
	echo "Downloading the IBD database!"
	python Database/Import_data_IBD.py
	echo "Creating the IBD collection!"
	python Database/Import_IBD_metadata_db.py
else
	echo "IBD skipped."
fi

if $install3 ; then #T2D
	echo "Downloading the T2D database!"
	python Database/Import_data_T2D.py
	echo "Creating the AG collection!"
	python Database/Import_T2D_metadata_db.py
else
	echo "T2D skipped."
fi

if $install4 ; then #Greengenes (and Kraken!)
	echo "Installing Kraken and setting up the Greengenes database!"
	./Database/create_kraken_greengenes.sh
else
	echo "Greengenes/Kraken skipped."
fi

    echo "It's done! Script finished running in $SECONDS seconds."
