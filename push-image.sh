#!/bin/bash

gcloud auth configure-docker us-central1-docker.pkg.dev

docker --platform=linux/amd64 build -t petclinic-app .

docker tag petclinic-app \
    us-central1-docker.pkg.dev/gd-gcp-internship-devops/petclinic-docker-test/petclinic-app:latest

docker push us-central1-docker.pkg.dev/gd-gcp-internship-devops/petclinic-docker-test/petclinic-app:latest