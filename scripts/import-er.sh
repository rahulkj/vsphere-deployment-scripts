. environment.sh
. download_product.sh

get_slug_name elastic-runtime
get_releases_json
get_product_and_version_details
echo $SLUG_NAME $PRODUCT_VERSION

find_stemcell_dependency

FILE_PATH=`find tmp -name *.pivotal | grep cf*`

STEMCELL_FILE_PATH=`find tmp -name *.tgz | grep $SC_VERSION`

om -t https://$OPS_MGR_HOST -u $OPS_MGR_USR -p $OPS_MGR_PWD -k upload-product -p $FILE_PATH
om -t https://$OPS_MGR_HOST -u $OPS_MGR_USR -p $OPS_MGR_PWD -k upload-stemcell -s $STEMCELL_FILE_PATH


CF_RELEASE=`om -t https://$OPS_MGR_HOST -u $OPS_MGR_USR -p $OPS_MGR_PWD -k available-products | grep cf`

PRODUCT_NAME=`echo $CF_RELEASE | cut -d"|" -f2 | tr -d " "`
PRODUCT_VERSION=`echo $CF_RELEASE | cut -d"|" -f3 | tr -d " "`

om -t https://$OPS_MGR_HOST -u $OPS_MGR_USR -p $OPS_MGR_PWD -k stage-product -p $PRODUCT_NAME -v $PRODUCT_VERSION
