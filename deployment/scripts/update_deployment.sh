#!/bin/sh
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
if [ -z "$1"]
then
  echo "Please provide IAM ARN as parameter."
  exit 1
else
  echo "The IAM ARN that can assume Studio Admin role is: $1"
fi

echo "Loading stacks..."
deployment/scripts/load_stacks.sh

STACK_NAME="analytics-with-emr"
STACK_REGION="us-west-2"

echo "Updating existing stack"
aws cloudformation update-stack \
--stack-name $STACK_NAME \
--template-body file://deployment/templates/emr-studio-setup.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters ParameterKey=IAMUserArn,ParameterValue=$1 \
--region $STACK_REGION

INPUT_STRING="\"UPDATE_IN_PROGRESS\""
while [ "$INPUT_STRING" != "\"UPDATE_COMPLETE\""  ]
do
  INPUT_STRING=$(aws cloudformation describe-stacks --stack-name $STACK_NAME  --query "Stacks[0].StackStatus")
  echo "Stack Status: $INPUT_STRING"
  sleep 5
done

echo "Update complete"

