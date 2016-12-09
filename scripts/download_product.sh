#!/bin/bash

. environment.sh

WORK_DIR="$PWD/tmp"

function create_work_dir {
  if [[ ! -d $WORK_DIR ]]; then
    mkdir -p $WORK_DIR
  fi
}

function login {
  pivnet-cli login --api-token=$PIVNET_TOKEN
}

function get_slug_name() {
  COMPONENT=$1
	SLUG_NAME=`pivnet-cli products --format=json | jq '.[].slug' | grep $COMPONENT | tr -d '"'`
}

function get_releases_json() {
	COMPONENT_RELEASES=`pivnet-cli releases -p $SLUG_NAME --format=json | jq 'sort_by(.id)'`
}

function get_product_and_version_details() {
	LENGTH=`echo $COMPONENT_RELEASES | jq 'sort_by(.id) | length'`
	PRODUCT_VERSION=`echo $COMPONENT_RELEASES | jq .[$LENGTH-1].version`
}

function accept_eula() {
	pivnet-cli accept-eula -p $SLUG_NAME -r $PRODUCT_VERSION
}

function download_product {
  pivnet-cli download-product-files -p $SLUG_NAME -r $PRODUCT_VERSION -i $PRODUCT_ID -d $WORK_DIR/
}

function find_stemcell_dependency() {
  SC_SLUG_NAME=stemcells

	SC_DETAILS=`pivnet-cli release-dependencies -p $SLUG_NAME -r $PRODUCT_VERSION --format=json | jq '.[] | select(.release.product.name | contains("Stemcells"))'`

  SC_VERSION=`echo $SC_DETAILS | jq '.release.version' | tr -d '"'`
  STEMCELL_RELEASES=`pivnet-cli releases -p $SC_SLUG_NAME --format=json | jq 'sort_by(.id)'`
  SC_PRODUCT_ID=`echo $STEMCELL_RELEASES | jq '.[] | select(.version=="'$SC_VERSION'")' | jq '.id'`
}

function download_stemcell {
  SC_RESPONSE=`pivnet-cli product-files -p $SC_SLUG_NAME -r $SC_VERSION --format=json`

  SC_PRODUCT_ID=`echo $SC_RESPONSE | jq '.[] | select(.name | contains("vSphere"))' | jq '.id' | tr -d '"'`
  SC_FILE_VERSION=`echo $SC_RESPONSE | jq '.product_files[] | select(.name | contains("vSphere"))' | jq '.file_version' | tr -d '"'`

  pivnet-cli download-product-files -p $SC_SLUG_NAME -r $SC_VERSION -i $SC_PRODUCT_ID -d $WORK_DIR/
}
