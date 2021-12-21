# Retrieve sources from Zotero
# 1. right-click "Toxicology" collection
# 2. Export collection
# 3. Format: Zotero RDF, check Export Files
# 4. Select export location, e.g., "C:\Users\ElizabethNg\Downloads\Toxicology"
# 5. Open bash
cd "C:\Users\ElizabethNg\Downloads\Toxicology\files"                             # navige to files sub directory
for x in */*; do mv "$x" "C:\Users\ElizabethNg\Downloads\Toxicology\files"; done # move files out of individual folders
for dir in */; do rm -r "$dir$                                                   # delete folders, need -r option to remove directory