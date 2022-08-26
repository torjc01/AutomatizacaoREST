#!/bin/bash
#
# Nom script  : 03-branches-creation.sh
# Objectf     : Création des branches utilisées dans ce repo 
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
#
# Création des branches 

set -e
set -vx
source ./couleurs.sh 

DEPOT=$1 
PROFILE=$2

# D'abord, il faut chercher la valeur de la branche main. 

SHA=$(curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/git/refs/heads/prod | jq '.object.sha' | sed 's/\"//g')

echo "SHA de la branche main: "$SHA

# Ensuite, on crée les trois environnements à partir de la branche main
# POST /repos/:user/:repo/git/refs

echo ${MAGENTA}"Creation des nouvelles refs"${RESET}
echo ${GREEN}"    Creation de la branche DEV"${RESET}
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/git/refs \
  -d "{
    \"ref\": \"refs/heads/dev\",
    \"sha\" : \"$SHA\" 
  }"

if [ $PROFILE -eq 2 ]
then
  echo ${GREEN}"    Creation de la branche PRE-PROD"${RESET}
  curl \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: token $AUTH" \
    https://api.github.com/repos/torjc01/${DEPOT}/git/refs \
    -d "{
      \"ref\": \"refs/heads/pre-prod\",
      \"sha\" : \"$SHA\" 
    }"
fi

echo ${GREEN}"    Creation de la branche PROD"${RESET}
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/git/refs \
  -d "{
    \"ref\": \"refs/heads/prod\",
    \"sha\" : \"$SHA\" 
  }"

# Update PROD comme dépôt default  

curl -X PATCH  \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token ${AUTH}"  \
-i https://api.github.com/repos/torjc01/${DEPOT} \
-d '{
        "security_and_analysis": {
            "advanced_security": "enabled", 
            "secret_scanning": "enabled", 
            "secret_scanning_push_protection": "enabled"
        }, 
        "default_branch":"prod"
    }'
