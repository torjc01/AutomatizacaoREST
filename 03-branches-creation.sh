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
# set -vx
source ./couleurs.sh 

DEPOT=$1 
PROFILE=$2
OWNER=$3
ORG=$4

if [ "$ORG" = true ]; then
  echo "Criacao de branches na organização"
  ENDPOINT=https://api.github.com/repos/${OWNER}/${DEPOT}
  PRINCIPAL=main
else
  echo "Criacao de branches no usuário"
  ENDPOINT=https://api.github.com/repos/${OWNER}/${DEPOT}
  PRINCIPAL=prod
fi 
echo "Endpoint: "$ENDPOINT

# D'abord, il faut chercher la valeur de la branche principal. 

SHA=$(curl \
  -X GET \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  $ENDPOINT/git/refs/heads/$PRINCIPAL | jq '.object.sha' | sed 's/\"//g')

echo "SHA de la branche $PRINCIPAL: "$SHA

# Ensuite, on crée les trois environnements à partir de la branche principal.
# POST /repos/:user/:repo/git/refs

echo ${MAGENTA}"Creation des nouvelles refs"${RESET}
echo ${GREEN}"    Creation de la branche DEV"${RESET}
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  $ENDPOINT/git/refs \
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
    $ENDPOINT/git/refs \
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
  $ENDPOINT/git/refs \
  -d "{
    \"ref\": \"refs/heads/prod\",
    \"sha\" : \"$SHA\" 
  }"

# Update DEV comme dépôt default  

curl -X PATCH  \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token ${AUTH}"  \
-i $ENDPOINT \
-d '{
        "security_and_analysis": {
            "advanced_security": { "status": "enabled" }, 
            "secret_scanning": { "status": "enabled" }, 
            "secret_scanning_push_protection": { "status": "enabled" }
        }, 
        "default_branch":"dev"
    }'
