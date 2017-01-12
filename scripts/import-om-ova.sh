. environment.sh
. update-json.sh

GOVC_INSECURE=1
GOVC_URL=$VCENTER_HOST
GOVC_USERNAME=$VCENTER_USR
GOVC_PASSWORD=$VCENTER_PWD
GOVC_DATACENTER=$VCENTER_DATA_CENTER
GOVC_DATASTORE=$OM_DATA_STORE
GOVC_NETWORK=$OM_VM_NETWORK
GOVC_RESOURCE_POOL=$OM_RESOURCE_POOL

FILE_PATH=`find tmp -name *.ova`

govc import.spec $FILE_PATH | python -m json.tool > om-import.json

mv om-import.json in.json

update

govc import.ova -options=out.json $FILE_PATH

rm *.json
