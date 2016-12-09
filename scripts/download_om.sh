#!/bin/bash

. download_product.sh

create_work_dir

login
get_slug_name ops-manager
get_releases_json
get_product_and_version_details
accept_eula

RESPONSE=`pivnet-cli product-files -p $SLUG_NAME -r $PRODUCT_VERSION --format=json`
PRODUCT_ID=`echo $RESPONSE | jq '.[] | select(.name | contains("vSphere"))' | jq '.id' | tr -d '"'`

download_product
