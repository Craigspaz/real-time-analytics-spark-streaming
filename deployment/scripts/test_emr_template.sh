#!/bin/sh
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
echo "Loading stack to S3..."
aws s3 cp deployment/templates/emr-cluster-template-for-service-catalog.yaml s3://emrstudio.sample.templates/templates/

STACK_NAME="test-emr-template"
STACK_REGION="us-west-2"

echo "Deploying cloudformation stack"
aws cloudformation create-stack \
--stack-name ${STACK_NAME}-small \
--template-body file://deployment/templates/emr-cluster-template-for-service-catalog.yaml \
--parameters ParameterKey=MemoryProfile,ParameterValue=small \
ParameterKey=Optimization,ParameterValue=cost \
ParameterKey=UserConcurrency,ParameterValue=2 \
--capabilities CAPABILITY_AUTO_EXPAND \
--region $STACK_REGION

echo "Deploying cloudformation stack"
aws cloudformation create-stack \
--stack-name ${STACK_NAME}-medium \
--template-body file://deployment/templates/emr-cluster-template-for-service-catalog.yaml \
--parameters ParameterKey=MemoryProfile,ParameterValue=medium \
ParameterKey=Optimization,ParameterValue=cost \
ParameterKey=UserConcurrency,ParameterValue=2 \
--capabilities CAPABILITY_AUTO_EXPAND \
--region $STACK_REGION

echo "Deploying cloudformation stack"
aws cloudformation create-stack \
--stack-name ${STACK_NAME}-large \
--template-body file://deployment/templates/emr-cluster-template-for-service-catalog.yaml \
--parameters ParameterKey=MemoryProfile,ParameterValue=large \
ParameterKey=Optimization,ParameterValue=cost \
ParameterKey=UserConcurrency,ParameterValue=2 \
--capabilities CAPABILITY_AUTO_EXPAND \
--region $STACK_REGION


INPUT_STRING="\"CREATE_IN_PROGRESS\""
while [ "$INPUT_STRING" = "\"CREATE_IN_PROGRESS\"" ]
do
  INPUT_STRING=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME}-small  --query "Stacks[0].StackStatus")
  echo "Small Stack Status: $INPUT_STRING"
  sleep 5
done

INPUT_STRING="\"CREATE_IN_PROGRESS\""
while [ "$INPUT_STRING" = "\"CREATE_IN_PROGRESS\"" ]
do
  INPUT_STRING=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME}-medium  --query "Stacks[0].StackStatus")
  echo "Medium Stack Status: $INPUT_STRING"
  sleep 5
done

INPUT_STRING="\"CREATE_IN_PROGRESS\""
while [ "$INPUT_STRING" = "\"CREATE_IN_PROGRESS\"" ]
do
  INPUT_STRING=$(aws cloudformation describe-stacks --stack-name ${STACK_NAME}-large  --query "Stacks[0].StackStatus")
  echo "Large Stack Status: $INPUT_STRING"
  sleep 5
done

echo "Deployment complete. Validate and delete stacks to avoid additional costs"