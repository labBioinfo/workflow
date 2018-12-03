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
