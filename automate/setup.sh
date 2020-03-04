#!/bin/bash

PASS="\342\234\224"
FAIL="\xE2\x9D\x8C"
PRECHECK=1
CHECK=1
INSTALL_PATH="/tmp"

printf "Locating required utilities..\n"

if ! [ -x "$(command -v docker)" ]; then
  printf "$FAIL docker not installed\n"
  echo " please install before continuing\n"
  PRECHECK=0
else
  printf "$PASS docker installed\n"
fi

if ! [ -x "$(command -v kubectl)" ]; then
  printf "$FAIL kubernetes not installed"
  PRECHECK=0
else
  printf "$PASS kubernetes installed\n"
fi

if ! [ -x "$(command -v docker)" ]; then
  printf "$FAIL docker not installed\n"
  printf "please install before continuing\n"
  PRECHECK=0
else
  printf "$PASS docker installed\n"
fi

if ! [ -x "$(command -v helm)" ]; then
  printf "$FAIL helm not installed\n"
  printf "please install before continuing\n"
  PRECHECK=0
else
  printf "$PASS helm installed\n"
fi

if [ $PRECHECK -eq 1 ]; then 
  DOCKER_STATUS=$(docker info >/dev/null 2>&1)
  if [[ $? -ne 0 ]]; then
      printf "$FAIL docker is not running, please start it\n"
      CHECK=0
  fi
  KUBE_STATUS=$(kubectl cluster-info >/dev/null 2>&1)
  if ! [[ $? -eq 0 ]] ; then
      printf "$FAIL kubectl cannot speak to cluster, check status\n"
      CHECK=0
  fi
fi

if [ $CHECK -eq 1 ]; then 
  printf "installing charts with helm..\n"
  HELM_INSTALL1=$(helm install traackr-hello-world  ./helm/traackr-hello-world/)
  HELM_INSTALL2=$(helm install ingress-traackr-hello-world stable/traefik --set dashboard.enabled=true,dashboard.domain=dashboard.localhost)
  printf "waiting for pods to be ready..\n"
  while true ; do 
    STATUS_CHECK=$(kubectl get pods | grep traackr-hello-world | grep 1/1 | wc -l)
    if [ $STATUS_CHECK -eq 2 ]; then 
      printf "waiting for pods to be ready..\n"
      open http://helloworld.localhost
      exit 0
    fi 
  done 
fi