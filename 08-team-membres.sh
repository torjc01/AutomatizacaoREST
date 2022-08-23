#!/bin/bash
#
# Nom script  : 07-environnements-creation.sh
# Objectf     : Création des environnements utilisés dans les depots
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
# PARAMS      : TEAM MEMBER ROLE

# https://docs.github.com/en/rest/teams/members#add-or-update-team-membership-for-a-user
# put/orgs/{org}/teams/{team_slug}/memberships/{username}

set -e
# set -vx
source ./couleurs.sh 

TEAM=$1
MEMBER=$2
ROLE=$3

echo "Ajoute le username $MEMBER a l'equipe $TEAM avec le role de $ROLE"
curl \
-X PUT  \
-H "Accept: application/vnd.github+json" \
-H "Content-Type: application/json" \
-H "Authorization: token ${AUTH}"  \
-i https://api.github.com/orgs/CQEN-QDCE/teams/$TEAM/memberships/$MEMBER \
-d  "{
        \"role\": \"$ROLE\"
    }" 