#!/bin/bash
#
# Nom script  : 02-creation-depot.sh
# Objectf     : Création du depot 
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
#

set -e
# set -vx
source ./couleurs.sh 

DEPOT=$1
DESC=$2
HOMEPAGE=$3 
VISIB=$4
ORG=$5
OWNER=$6

echo "Nom du depot: " $DEPOT
echo "Description: " $DESC
echo "Homepage: " $HOMEPAGE
echo "Visibilidade privado?: " $VISIB

if [ "$ORG" = true ]; then
    echo "Création du dépôt dans l'organisation"
    ENDPOINT=https://api.github.com/orgs/$OWNER/repos
else
    echo "Création du dépôt dans l'utilisateur"
    ENDPOINT=https://api.github.com/user/repos
fi

## https://api.github.com/orgs/CQEN-QDCE/repos \ 
## https://api.github.com/user/repos

curl -X POST  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type: application/json" \
-H "Authorization: token ${AUTH}"  \
-i $ENDPOINT \
-d "{
        \"name\":\"$DEPOT\",
        \"description\":\"$DESC\",
        \"homepage\":\"$HOMEPAGE\",
        \"private\":"$VISIB",
        \"has_issues\":true,
        \"has_projects\":true,
        \"has_wiki\":true,
        \"web_commit_signoff_required\":true, 
        \"auto_init\":true
    }"
