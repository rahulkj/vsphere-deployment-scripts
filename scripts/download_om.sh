#!/bin/bash

. download_product.sh

login
get_slug_name ops-manager
get_releases_json
get_product_and_version_details
accept_eula

RESPONSE=`pivnet-cli curl /products/$SLUG_NAME/releases/$PRODUCT_ID`
DOWNLOAD_URL=`echo $RESPONSE | jq '.product_files[] | select(.name | contains("vSphere"))' | jq '._links.download.href' | tr -d '"'`
FILE_VERSION=`echo $RESPONSE | jq '.product_files[] | select(.name | contains("vSphere"))' | jq '.file_version' | tr -d '"'`

construct_file_name pcf-vsphere $FILE_VERSION "" ova

echo ">>>>" $DOWNLOAD_URL " and save to " $FILE_NAME

download_product
