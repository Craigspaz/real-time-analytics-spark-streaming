#!/bin/sh
echo "Copying EMR templates to template bucket.."

aws s3 cp deployment/templates/emr-cluster-template-for-service-catalog.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-studio-service-catalog-setup.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-studio-iam-setup.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-studio-network-setup.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-studio-transform-lambda.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-studio-setup.yaml s3://emrstudio.sample.templates/templates/
aws s3 cp deployment/templates/emr-kinesis-data-stream.yaml s3://emrstudio.sample.templates/templates/

#TODO - script to make objects public after update

echo "Done"