# sp-bash
SharePoint REST authentication in bash using cURL

This is a basic example of how to authenticate with the SP REST API and execute requests via cURL. This script could easily be expanded to handle simple automated tasks from a Linux command line. Big thanks to Paul Ryan for his explanation of the process here:

http://paulryan.com.au/2014/spo-remote-authentication-rest/

## To Use

1. Edit auth.xml to add your user account info and domain.

2. Edit sharePoint_upload.sh to point to your SP domain.

3. Execute the script with arguments corresponding to your target file to upload, your site (and sub-site if applicable) and the target library.
