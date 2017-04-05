#!/bin/bash
#
# Run as: ./sharePoint_upload.sh filename sitename libraryname
#
# Example: ./sharePoint_upload.sh test.jpg my-site/my-sub-site documents
#
# Step by step SP REST auth reference here:
# http://paulryan.com.au/2014/spo-remote-authentication-rest/
#

SITENAME="${2}"

# XML dom parsing from:
# http://stackoverflow.com/questions/893585/how-to-parse-xml-in-bash

read_dom () {
    local IFS=\>
    read -d \< ENTITY CONTENT
}

# Get the security token
curl -X POST -d @auth.xml https://login.microsoftonline.com/extSTS.srf -o rstoken

# Parse secure token response (rstoken)
while read_dom; do
    if [[ $ENTITY = "wsse:BinarySecurityToken Id=\"Compact0\"" ]] ; then
        echo $CONTENT > stoken
    fi
done < rstoken

# Get the rtFa and FedAuth cookies required for each API call
curl -c cookies -X POST -d @stoken https://[ you ].sharepoint.com/_forms/default.aspx?wa=wsignin1.0

# Get the request digest
curl -b cookies -d -X POST https://[ you ].sharepoint.com/sites/${SITENAME}/_api/contextinfo > rdigest

# Parse request digest response (rdigest)
while read_dom; do
    # Set request digest to variable
    if [[ $ENTITY = "d:FormDigestValue" ]] ; then
        DIGEST=$CONTENT
    fi
done < rdigest

# Upload file

curl -b cookies \
     -H "X-RequestDigest: ${DIGEST}" \
     -H "Accept: application/json;odata=verbose" \
     -H "Content-Type: multipart/form-data" \
     -T "${1}" \
     -X POST "https://[ you ].sharepoint.com/sites/${SITENAME}/_api/web/lists/getbytitle('${3}')/rootfolder/files/add(url='${1}',overwrite=true)"