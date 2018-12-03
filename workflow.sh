#!/bin/bash
#!/usr/bin/env python


#Script de teste do workflow
#Mkdir de 3 pastas
#Tentativa de criar um menu

PS3='Welcome to the BioInfo lab project workflow! Please select an option: '
options=("Install dependencies and download database files" "Run taxonomic analysis" "Run basic workflow test" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install dependencies and download database files (Greengenes requires an FTP connection to install!)")
            echo "Let's hope this works boys"
		    chmod +x Database/create_project_folders.sh
		    chmod +x Database/create_mongo_db_collections.sh
		    chmod +x Database/create_kraken_greengenes.sh
		    chmod +x Database/Import_data_AG.py
		    chmod +x Database/Import_data_IBD.py
		    chmod +x Database/Import_data_T2D.py
		    chmod +x Database/xml_AG_tocollection.py
		    echo "Creating project folders..."
		    ./Database/create_project_folders.sh
		    echo "Creating MongoDB collections..."
                    ./Database/create_mongo_db_collections.sh
		    echo "Installing Kraken and the Greengenes database (here's where it starts taking a while!)"
                    ./Database/create_kraken_greengenes.sh
                    echo "Importing AG metadata..."
		    python Database/Import_data_AG.py
		    echo "Adding AG metadata to collection..."
		    python Database/xml_AG_tocollection.py
		    echo "Script finished running in $SECONDS seconds."
		    break
            ;;
        "Run taxonomic analysis")
            echo "Error! Scripts not found!"
            ;;
        "Run basic workflow test")
            export WORKFLOW_DIRECTORY=~/workflowDirectory/
	    if [ ! -d "$WORKFLOW_DIRECTORY" ]
		then
			echo "No workflow folder detected! Creating..."
			sleep 1
			mkdir ~/workflowDirectory
			mkdir ~/workflowDirectory/Stage2Output
		else
			sleep 1
			echo "Workflow folder detected. Good work!"
		fi
		read -p "Please select a text file to test. It can only have numeric characters." FILEPATH
		TESTFILE=$( cat $FILEPATH )
		echo "Test file loaded. Hopefully it doesn't have non-numeric characters..."

		#Validation
		sleep 1
		if [[ $TESTFILE =~ ^[0-9]+$ ]]
		then
		    echo "You can follow basic instructions! Excellent job! Moving to phase 2..."
		    sleep 1
		    cp $FILEPATH ~/workflowDirectory/Stage2Output/Outputfile.txt
		    sleep 1
		    echo "Phase 2 file created! It seems like this script works!"
		    sleep 1
		    echo "If you're reading this, your validation worked. Well done, you wrote one very simple script!" >> ~/workflowDirectory/Stage2Output/Outputfile.txt
		else
		     echo "Input has non-valid characters. It ain't working son."
		     sleep 2
		fi

		echo "Script finished running in $SECONDS seconds."
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done



##Next part: user inputs the testfile by himself - DONE
##The sleep commands really do nothing useful, other than make it look like the program is doing something


