. environment.sh

IAAS_CONFIG=`cat templates/iaas-configuration.json`
DIRECTOR_CONFIG=`cat templates/director-configuration.json`
AZS_CONFIG=`cat templates/azs-configuration.json`
NETWORKS_CONFIG=`cat templates/networks-configuration.json`
NW_ASSIGNMENT_CONFIG=`cat templates/nw-assignment-configuration.json`

om -t https://$OPS_MGR_HOST -k -u $OPS_MGR_USR -p $OPS_MGR_PWD configure-bosh \
            -i "$IAAS_CONFIG" \
            -d "$DIRECTOR_CONFIG" \
            -a "$AZS_CONFIG" \
            -n "$NETWORKS_CONFIG" \
            -na "$NW_ASSIGNMENT_CONFIG"

om -t https://$OPS_MGR_HOST -k -u $OPS_MGR_USR -p $OPS_MGR_PWD apply-changes
