#!/bin/bash
#!/usr/bin/env python


#Workflow menu
PS3='Welcome to the BioInfo lab project workflow! Please select an option: '
options=("Install dependencies and download database files" "Install conda" "Check and install Python dependencies" "Taxonomy report" "Diversity analysis" "Logging report" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install dependencies and download database files")
	    chmod +x workflow-database-install.sh
	    ./workflow-database-install.sh
            ;;
    	"Install conda")
	     wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
	     chmod +x Miniconda3-latest-Linux-x86_64.sh
	     ./Miniconda3-latest-Linux-x86_64.sh
	    ;;
    	"Check and install Python dependencies")
	    chmod +x workflow-create-conda-environments.sh
	    chmod +x workflow-install-python-dependencies.py
	    chmod +x workflow-conda-env-ete3.sh
	    chmod +x workflow-conda-env-pandas.sh
	    ./workflow-create-conda-environments.sh
	    python workflow-install-python-dependencies.py
	    ./workflow-conda-env-ete3.sh
	    ./workflow-conda-env-pandas.sh	
            ;;
        "Taxonomy report")
            chmod +x workflow-taxonomy.sh #Kraken_output, colunas, ete3bubble, ete3tree, in that order
	    ./workflow-taxonomy.sh
            ;;
   	 "Diversity analysis")
	    Rscript ./DiversityAnalysis/script_for_stat_analysis.r
	    ;;
    	"Logging report")
	    Rscript ./Logging/report.R
	    ;;
    	"Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
