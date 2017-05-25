#!/bin/bash

SRC_PATH=$1
APB_IMG_NAME=$2

APB_BUILDER_IMG_NAME='s2i-apb-builder'

echo -e "\n\n Begin 's2i-apb' helper scripts \n\n"

echo -e " ===> Running 's2i build' \n"
s2i build ${1} ${APB_BUILDER_IMG_NAME} ${APB_IMG_NAME}
echo -e " ===> Finished 's2i build' \n\n"

echo -e " ===> Update SPEC LABEL on the '${APB_IMG_NAME}' image"
./update-apb-label.sh ${1}/apb.yml ${APB_IMG_NAME}


echo -e "\n\n Finished 's2i-apb' helper script \n\n"
