#!/bin/bash
#
# Nom script  : 04-fichiers-creation.sh
# Objectf     : Création des fichiers default pour le dépôt 
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
# PARAMS      : DEPOT:  
#               USERNAME: 
#               EMAIL:

set -e
# set -vx
source ./couleurs.sh 

# Récupère le SHA du README default 
# get/repos/{owner}/{repo}/contents/{path}
# https://docs.github.com/en/rest/repos/contents#get-repository-content

DEPOT=$1
USERNAME=$2
EMAIL=$3

GH_USER=$(git config user.name)
GH_EMAIL=$(git config user.email)

echo ${GREEN}"Recuperer le SHA du README default"${RESET}
SHA=$(curl -X GET  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type:application/json" \
-H "Authorization: token $AUTH"  \
https://api.github.com/repos/CQEN-QDCE/${DEPOT}/contents/README.md | jq '.sha'| sed 's/\"//g')


echo "SHA du fichier README: " $SHA

# Insertion du fichier README.md

echo ${GREEN}"Inserer le nouveau README default"${RESET}
curl -X PUT  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type:application/json" \
-H "Authorization: token $AUTH"  \
https://api.github.com/repos/CQEN-QDCE/${DEPOT}/contents/README.md \
-d  "{
        \"message\": \"Création automatisée du fichier README.md \nSigned-off-by: $GH_USER <$GH_EMAIL>\",
        \"sha\": \"$SHA\",
        \"author\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"committer\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"content\": \"$(cat ./docs/README.b64)\"
    }" 


# Insertion de la licence 
echo ${GREEN}"Inserer la LICENCE"${RESET}

curl -X PUT  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type:application/json" \
-H "Authorization: token $AUTH"  \
https://api.github.com/repos/CQEN-QDCE/${DEPOT}/contents/LICENCE.md \
-d  "{
        \"message\": \"Création automatisée du fichier LICENCE.md \nSigned-off-by: $GH_USER <$GH_EMAIL>\",
        \"author\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"committer\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"content\": \"$(cat ./docs/LICENCE.b64)\"
    }" 

# Insertion de la CODEOWNERS 
echo ${GREEN}"Inserer le fichier CODEOWNERS"${RESET}

curl -X PUT  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type:application/json" \
-H "Authorization: token $AUTH"  \
https://api.github.com/repos/CQEN-QDCE/${DEPOT}/contents/.github/CODEOWNERS \
-d  "{
        \"message\": \"Création automatisée du fichier CODEOWNERS. \nSigned-off-by: $GH_USER <$GH_EMAIL>\",
        \"author\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"committer\": {
            \"name\": \"${USERNAME}\",
            \"email\": \"${EMAIL}\"
        },
        \"content\": \"$(cat ./docs/CODEOWNERS.b64)\"
    }" 

