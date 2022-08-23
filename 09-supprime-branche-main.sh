#!/bin/bash
#
# Nom script  : 09-supprime-branche-main.sh
# Objectf     : Suppression de la branche main du dépôt
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
# PARAMS      : TEAM MEMBER ROLE

set -e
# set -vx
source ./couleurs.sh 

DEPOT=$1

# Supprime la branche main, qui ne sera pas utilisée dans le contexte de ce dépôt
echo "Suppression de la branche main"

curl \
  -s -X DELETE \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/CQEN-QDCE/$DEPOT/git/refs/heads/main
