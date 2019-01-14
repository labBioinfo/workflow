#!/bin/bash
#!/usr/bin/env python

echo "Starting up the Taxonomy report. Get comfy. CTRL+C if you want to stop midway through."
chmod +x Taxonomy/kraken_output.sh
source activate workflow-pandas
./kraken_output.sh
echo "Taxonomy concluded and/or interrupted. Let's move on."
python Taxonomy/colunas.py
source deactivate workflow-pandas

source activate workflow-ete3
python ete3tree.py
python ete3bubble.py
source deactivate workflow-ete3

echo "Job's done."



