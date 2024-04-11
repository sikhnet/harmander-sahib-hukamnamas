#!/bin/bash
# save today's Hukamnama from the SGPC website
# requires: curl, awk, grep

echo "DEBUG: Starting $(date '+%Y-%m-%d %H:%I:%S')"

todaysDate="$(date '+%Y-%m-%d')"
readonly todaysDate

targetDir="hukamnamas/raw/$(date +"%Y")"
readonly targetDir

tempFile=$(mktemp)
readonly tempFile

# hukamnamas will be stored by year
mkdir -p "${targetDir}"

# Use a head request to ensure network is ok
# NB SGPC's server doesn't really undertstand HEAD requests and will
# give 20x repsonses even if page is down
# this is just a check for network outages
echo "DEBUG: Validating network connectivity"
if (! curl --head https://hs.sgpc.net); then
    >&2 echo "Error: Could not reach SGPC website"
    exit 3
fi

echo "DEBUG: Sleep for 5 seconds so as not to upset Cloudflare"
sleep 5s

# need to use curl impersonation scripts which adds a load of browser+cookie data
# to convince cloudlfare to let us in, otherwise it applies bot protection
# pick a random browser from /curl-impersonation-scripts to further placate cloudflare
declare -a browserImpersonation=(\
'curl_chrome110' \
'curl_edge101' \
'curl_ff109' \
'curl_safari15_5')
browser=$(printf "%s\n" "${browserImpersonation[@]}" | shuf -n1)

echo "DEBUG: Getting Hukamnama for ${todaysDate} using ${browser}"
"curl-impersonation-scripts/${browser}" https://hs.sgpc.net \
  --output "${tempFile}"

echo "DEBUG: Validate file exists: ${tempFile}"
if [[ ! -f "${tempFile}" ]]; then
    >&2 echo "Error: Could not get hukamnama for ${tempFile}"
    exit 4
fi

echo "DEBUG: Validating file contents by checking hukamnama date from html file"
# get the raw "<FONT>" block and use Grep and AWK-foo to get the date string for comparison
# shellcheck disable=SC2002
hukamnamaDateRaw=$(cat "${tempFile}" | \
     grep -P '\[\w+\s\d,\s\d{4},\s\w+\s\d{2}:\d{2}\s\w{2}\.\sIST\]' | \
     awk 'BEGIN { FS="[" }; { print $2}' | \
     awk 'BEGIN { FS=" "}; {gsub(/,/, ""); }{ print $2,$1,$3 }')
# now should look like '2 August 2023'
actualHukamnamaDate=$(date -d "${hukamnamaDateRaw}" '+%Y-%m-%d')
echo "DEBUG: actualHukamnamaDate: ${actualHukamnamaDate}"

# shellcheck disable=SC2053
if [[ ${actualHukamnamaDate} != ${todaysDate} ]]; then
    # >&2 echo "Error: Hukamnama date should be '${comparisonDate}' got '${hukamnamaDateRaw}'"
    >&2 echo "WARN: Hukamnama date should be '${todaysDate}' got '${actualHukamnamaDate}'"
    # exit 5
fi

targetFile="${targetDir}/${actualHukamnamaDate}.html"
readonly targetFile
cp "${tempFile}" "${targetFile}"

echo "Saved ${todaysDate} Hukamnama to ${targetFile}"
