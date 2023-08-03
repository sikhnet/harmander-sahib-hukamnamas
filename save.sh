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

curl -i https://old.sgpc.net/hukumnama/indexhtml.asp \
    --output "${targetFile}"

if [[ ! -f "${targetFile}" ]]; then
    >&2 echo "Error: Could not get hukamnama for ${targetFile}"
    exit 3
fi
