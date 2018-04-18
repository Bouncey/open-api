#!/bin/bash
set -e

BRANCH=${TRAVIS_BRANCH:-$(git rev-parse --abbrev-ref HEAD)} 

if [[ $BRANCH == 'master' ]]; then
  STAGE="prod"
  AWS_ACCESS_KEY_ID=AWS_ACCESS_ID_PROD
  AWS_SECRET_ACCESS_KEY=AWS_SECRET_KEY_PROD
elif [[ $BRANCH == 'staging' ]]; then
  STAGE="stage"
  AWS_ACCESS_KEY_ID=AWS_ACCESS_ID_STAGE
  AWS_SECRET_ACCESS_KEY=AWS_SECRET_KEY_STAGE
elif [[ $BRANCH == 'development' ]]; then
  STAGE="dev"
  AWS_ACCESS_KEY_ID=AWS_ACCESS_ID_DEV
  AWS_SECRET_ACCESS_KEY=AWS_SECRET_KEY_DEV
fi

if [ -z ${STAGE+x} ]; then
  echo "Only deploying for development, staging or production branches"
  exit 0
fi

if [[ $STAGE != 'development' ]]; then
  echo "Only development deployments for now, sorry!"
  exit 0
fi


echo "Deploying from branch $BRANCH to stage $STAGE"
npm prune --production  #remove devDependencies
sls deploy --stage $STAGE --region $AWS_REGION
