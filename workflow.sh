#!/bin/bash
#!/usr/bin/env python


#Workflow menu
PS3='Welcome to the BioInfo lab project workflow! Please select an option: '
options=("Install dependencies and download database files" "Check and install Python dependencies" "Run basic workflow test" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install dependencies and download database files")
	    chmod +x workflow-database-install.sh
	    ./workflow-database-install.sh
            ;;
        "Check and install Python dependencies")
	    chmod +x workflow-install-python-dependencies.py
	    python workflow-install-python-dependencies.py	
            ;;
        "Run basic workflow test")
            chmod +x workflow-basic-test.sh
	    ./workflow-basic-test.sh
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
#NEXT: Finish up the database install, test it once or twice, PLAY ARCANUM#


