#!/bin/bash

. download_product.sh

create_work_dir

login
get_slug_name elastic-runtime
get_releases_json
get_product_and_version_details
accept_eula $SLUG_NAME $PRODUCT_VERSION

RESPONSE=`pivnet-cli product-files -p $SLUG_NAME -r $PRODUCT_VERSION --format=json`
PRODUCT_ID=`echo $RESPONSE | jq '.[] | select(.name=="PCF Elastic Runtime")' | jq '.id' | tr -d '"'`

download_product $SLUG_NAME $PRODUCT_VERSION $PRODUCT_ID

find_stemcell_dependency
download_stemcell
