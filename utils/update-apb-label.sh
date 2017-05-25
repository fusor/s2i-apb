#!/bin/bash

SPEC_PATH=$1
APB_IMG_NAME=$2

TMP_CONTAINER='tmp-container'

echo -e "\n ---> Encoding the APB Spec File"
BLOB=`./encode-apb-specfile.py -s ${SPEC_PATH} -q`

echo -e " ---> Creating a temp Container from '${APB_IMG_NAME}' image"
docker create --name ${TMP_CONTAINER} ${APB_IMG_NAME}

echo -e " ---> Updating the LABEL in the temp Container, and committing it back to the '${APB_IMG_NAME}' image"
SPEC_LABEL="\"com.redhat.apb.spec\"=\"${BLOB}\""
docker commit --change "LABEL ${SPEC_LABEL}" ${TMP_CONTAINER} ${APB_IMG_NAME}

echo -e " ---> Clean Up - Removing the temp Container"
docker rm ${TMP_CONTAINER}

# debug output to view if the label has been updated
#docker inspect ${APB_IMG_NAME} | jq .[0].Config.Labels
