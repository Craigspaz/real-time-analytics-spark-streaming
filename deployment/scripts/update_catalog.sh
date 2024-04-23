#!/bin/sh
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
if [ -z "$1"]
then
  echo "Please provide key name as parameter."
  exit 1
else
  echo "The default SSKey is: $1"
fi

echo "Loading stacks..."
deployment/scripts/load_stacks.sh

STACK_NAME="emr-service-catalog-product"
STACK_REGION="us-west-2"

aws cloudformation update-stack \
--stack-name $STACK_NAME \
--template-body file://deployment/templates/emr-studio-service-catalog-setup.yaml \
--parameters ParameterKey=DefaultSSHKey,ParameterValue=$1 \
--capabilities CAPABILITY_NAMED_IAM \
--region $STACK_REGION

INPUT_STRING="\"UPDATE_IN_PROGRESS\""
while [ "$INPUT_STRING" != "\"UPDATE_COMPLETE\"" ]
do
  INPUT_STRING=$(aws cloudformation describe-stacks --stack-name $STACK_NAME  --query "Stacks[0].StackStatus")
  echo "Stack Status: $INPUT_STRING"
  sleep 5
done

echo "Update complete"