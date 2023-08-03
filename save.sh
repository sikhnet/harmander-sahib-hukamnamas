#!/bin/bash
# save today's Hukamnama from the SGPC website
# requires: curl, awk, htmlq

todaysDate="$(date '+%Y-%m-%d')"
readonly todaysDate

targetDir="hukamnamas/$(date +"%Y")"
readonly targetDir

targetFile="${targetDir}/${todaysDate}.html"
readonly targetFile

if [[ -f "${targetFile}" ]]; then
    >&2 echo "WARN: Hukamnama ${targetFile} already exists"
fi

# hukamnamas will be stored by year
mkdir -p "${targetDir}"

# Use a head request to ensure network is ok
# NB SGPC's server doesn't really undertstand HEAD requests and will
# give 20x repsonses even if page is down
# this is just a check for network outages
echo "DEBUG: Validating network connectivity"
if (! curl --head https://old.sgpc.net/hukumnama/indexhtml.asp); then 
    >&2 echo "Error: Could not reach SGPC website"
    exit 3
fi 

echo "DEBUG: Getting Hukamnama for ${todaysDate}"
curl https://old.sgpc.net/hukumnama/indexhtml.asp \
    --output "${targetFile}"

echo "DEBUG: Validate file exists"
if [[ ! -f "${targetFile}" ]]; then
    >&2 echo "Error: Could not get hukamnama for ${targetFile}"
    exit 4
fi

echo "DEBUG: Validating file contents by checking hukamnama date from html file"
# get the raw "<FONT>" block and use AWK-foo to get the date string for comparison
# shellcheck disable=SC2002
hukamnamaDateRaw=$(cat "${targetFile}" | \
     ./htmlq "body > table:nth-child(3) > tbody > tr:nth-child(1) > td:nth-child(6) > blockquote > center:nth-child(3) > table > tbody > tr:nth-child(3) > td > div > font > b > font > font > font" | \
     awk 'BEGIN { FS="[" }; { print $2}' | \
     awk 'BEGIN { FS=" "}; { print $3,$1,$2 }')
# use a bash hack to get ride of trailing whitespace around the date string
# shellcheck disable=SC2116,SC2086
hukamnamaDateNoWhitespace=$(echo $hukamnamaDateRaw)
# now should look like '2023, August 2,'

comparisonDate=$(date '+%Y, %B %-d,')
# shellcheck disable=SC2053
if [[ ${hukamnamaDateNoWhitespace} != ${comparisonDate} ]]; then
    >&2 echo "Error: Hukamnama date should be '${comparisonDate}' got '${hukamnamaDateNoWhitespace}'"
    exit 5
fi
echo "Sucessfully saved ${todaysDate} Hukamnama to ${targetFile}"