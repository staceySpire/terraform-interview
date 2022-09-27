# Terraform Infrastructure

This directory contains Terraform configuration for setting up the AWS infrastructure needed to run
Terraform. Trippy, right?

To break it down a bit, Terraform needs to retain some state recording knowledge about the shape of
your cloud infrastructure. We'd like to store this in a centralized place, where we can make sure
that it's consistent and available to developers who need it. Generally, we choose to use a
combination of S3 and DynamoDB for this purpose. The files in this directory allocate those
resources so that other Terraform configurations can use them to store their data.

## Question

* Why is there a terraform state file here? Shouldn't it be remote?