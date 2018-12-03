# workflow
Workflow for our project. The objective is to run the various analysis scripts automatically, and, ideally, quickly (but let's not get ahead of ourselves).

Each folder is for a specific part of the project, which will then be synchronized/automated/what have you later.

The workflow has been updated to include a very basic menu (which will get updated, I swear!), and integrates some of the Database scripts (namely the ones for creating the folders and assembling the Greengenes kraken database. They seem to be working, although I couldn't fully test Greengenes, as it requires an ftp connection (which I was sadly lacking in when made the script).

In any case, I plan to integrate the rest of the Database scripts once I have the ones I need (check the Issues!).

Workflow organization (so far):

workflow.sh - A basic navigation menu that calls the other script files

workflow-database-install.sh - Creates the databases, sets up the kraken database for data input later

workflow-basic-test.sh - Sort of kind of deprecated, it's just the first version of workflow.sh. This'll almost certainly get replaced later, but I kept it for nostalgia(?) purposes.

