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

echo "Nom du depot: " $DEPOT
echo "Description: " $DESC
echo "Homepage: " $HOMEPAGE

curl -X POST  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type: application/json" \
-H "Authorization: token ${AUTH}"  \
-i https://api.github.com/user/repos \
-d "{
        \"name\":\"$DEPOT\",
        \"description\":\"$DESC\",
        \"homepage\":\"$HOMEPAGE\",
        \"private\":false,
        \"has_issues\":true,
        \"has_projects\":true,
        \"has_wiki\":true,
        \"web_commit_signoff_required\":true, 
        \"auto_init\":true
    }"
