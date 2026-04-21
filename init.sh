#!/bin/bash

#VPC network creation
if gcloud compute networks describe privatenet-docker >/dev/null 2>&1; then
    echo "VPC already exists, skipping"
else
    gcloud compute networks create privatenet-docker --subnet-mode=custom
fi


#subnet creation
if gcloud compute networks subnets describe privatenet-docker-subnet \
    --region=us-central1 >/dev/null 2>&1; then
    echo "Subnet exists, skipping"
else
    gcloud compute networks subnets create privatenet-docker-subnet \
        --network=privatenet-docker \
        --region=us-central1 \
        --range=10.0.0.0/24 
fi


#firewall rules
if gcloud compute firewall-rules describe allow-ssh >/dev/null 2>&1; then
    echo "Firewall rule exists, skipping"
else
    gcloud compute firewall-rules create allow-ssh \
        --network=privatenet-docker \
        --allow=tcp:22 \
        --source-ranges=0.0.0.0/0 
fi

if gcloud compute firewall-rules describe allow-http >/dev/null 2>&1; then
    echo "Firewall rule exists, skipping"
else
    gcloud compute firewall-rules create allow-http \
        --network=privatenet-docker \
        --allow=tcp:80 \
        --source-ranges=0.0.0.0/0 
fi

#enableing artifact registry
gcloud services enable artifactregistry.googleapis.com


#artifact registry creation
if gcloud artifacts repositories describe petclinic-docker-test \
    --location=us-central1 >/dev/null 2>&1; then
    echo "Repo exists, skipping"
else
    gcloud artifacts repositories create petclinic-docker-test \
        --repository-format=docker \
        --location=us-central1 \
        --description="docker image repo" \
        --labels=creator=skhachatryan
fi


#VM creation
if gcloud compute instances describe docker-vm \
    --zone=us-central1-a >/dev/null 2>&1; then
    echo "VM exists, skipping"
else
    gcloud compute instances create docker-vm \
        --zone=us-central1-a \
        --machine-type=e2-micro \
        --image-family=debian-12 \
        --image-project=debian-cloud \
        --network=privatenet-docker \
        --subnet=privatenet-docker-subnet \
        --labels=creator=skhachatryan
fi