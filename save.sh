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

echo "DEBUG: Sleep for 3seconds so as not to upset Cloudflare"
sleep 3s

# need to use curl impersonation scripts which adds a load of browser+cookie data
# to convince cloudlfare to let us in
# TODO pick a random browser from /curl-impersonation-scripts
echo "DEBUG: Getting Hukamnama for ${todaysDate}"
curl-impersonation-scripts/curl_chrome110 https://old.sgpc.net/hukumnama/indexhtml.asp \
  --output "${targetFile}"

echo "DEBUG: Validate file exists"
if [[ ! -f "${targetFile}" ]]; then
    >&2 echo "Error: Could not get hukamnama for ${targetFile}"
    exit 4
fi

echo "DEBUG: Validating file contents by checking hukamnama date from html file"
# get the raw "<FONT>" block and use Grep and AWK-foo to get the date string for comparison
# shellcheck disable=SC2002
hukamnamaDateRaw=$(cat "${targetFile}" | \
     grep -P '\[\w+\s\d,\s\d{4},\s\w+\s\d{2}:\d{2}\s\w{2}\.\sIST\]' | \
     awk 'BEGIN { FS="[" }; { print $2}' | \
     awk 'BEGIN { FS=" "}; { print $3,$1,$2 }')
# now should look like '2023, August 2,'

comparisonDate=$(date '+%Y, %B %-d,')
# shellcheck disable=SC2053
if [[ ${hukamnamaDateRaw} != ${comparisonDate} ]]; then
    # >&2 echo "Error: Hukamnama date should be '${comparisonDate}' got '${hukamnamaDateRaw}'"
    >&2 echo "WARN: Hukamnama date should be '${comparisonDate}' got '${hukamnamaDateRaw}'"
    # exit 5
fi
echo "Sucessfully saved ${todaysDate} Hukamnama to ${targetFile}"
