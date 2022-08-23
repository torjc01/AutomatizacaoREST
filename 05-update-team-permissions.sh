#!/bin/bash
#
# Nom script  : 05-update-team-permissions.sh
# Objectf     : Mise à jour des autorisations d'équipe  
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
#

set -e
# set -vx
source ./couleurs.sh 

# Création des branches 

# Add or update team repository permissions
# https://docs.github.com/en/rest/teams/teams#add-or-update-team-repository-permissions

DEPOT=$1

curl -X PUT  \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token ${AUTH}"  \
-i https://api.github.com/orgs/CQEN-QDCE/teams/ceai-cqen/repos/CQEN-QDCE/${DEPOT} \
-d '{
        "permission" : "admin" 
    }'

# Véerifier résultat dans : settings -> collaborators and teams