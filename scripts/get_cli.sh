#!/bin/bash

export GOVC_INSECURE=1
export GOVC_URL=172.16.1.2
export GOVC_USERNAME=administrator@homelab.io
export GOVC_PASSWORD=Welcome12#
export GOVC_DATACENTER="PCF"
export GOVC_DATASTORE="PCF_STORAGE_1"
export GOVC_NETWORK="PCF_NW"
export GOVC_RESOURCE_POOL="MGMT_RP"

govc about
