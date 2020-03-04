# Infrastructure Hello World Demo

## Assumptions:
This will be ran on a mac with the following utilities already installed:
  - Docker for Mac (with kubernetes enabled)
  - Helm

## Contents
automate/setup.sh 
- a simple script that will verify docker is installed/running, kubectl is able to access a cluster, and that helm is installed. If those conditions are met, it installs charts necessary to make the demo available at http://helloworld.localhost

helm/traackr-hello-world
- a helm chart to pull a custom docker image that displays hello, world for any request sent to it

nginx
- the Dockerfile used to create the image referenced above, in addition to a static html page and a nginx.conf

## Instructions
After cloning, run setup.sh in the automate folder. Then wait :)