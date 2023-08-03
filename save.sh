#!/bin/bash
# save today's Hukamnama from the SGPC website
# requires: curl

todaysDate="$(date '+%Y-%m-%d')"
readonly todaysDate

targetDir="hukamnamas/$(date +"%Y")"
readonly targetDir

targetFile="${targetDir}/${todaysDate}.html"
readonly targetFile

echo "Getting Hukamnama for ${todaysDate}"

if [[ -f "${targetFile}" ]]; then
    >&2 echo "Error: Hukamnama ${targetFile} already exists"
    exit 2
fi

# hukamnamas will be stored by year
mkdir -p "${targetDir}"

# Use a head request to ensure network is ok
# NB SGPC's server doesn't really undertstand HEAD requests and will
# give 20x repsonses even if page is down
# this is just a check for network outages
if (! curl --head https://old.sgpc.net/hukumnama/indexhtml.asp); then 
    >&2 echo "Error: Could not reach SGPC website"
    exit 3
fi 

curl -i https://old.sgpc.net/hukumnama/indexhtml.asp \
    --output "${targetFile}"

if [[ ! -f "${targetFile}" ]]; then
    >&2 echo "Error: Could not get hukamnama for ${targetFile}"
    exit 4
fi
