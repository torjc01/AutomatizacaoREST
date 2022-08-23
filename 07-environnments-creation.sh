#!/bin/bash
#
# Nom script  : 07-environnements-creation.sh
# Objectf     : Création des environnements utilisés dans les depots
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
# PARAMS      : DEPOT 

set -e
# set -vx
source ./couleurs.sh 

# Environnements 

DEPOT=$1

# Creation de l'environnement de dev
echo ${GREEN}"Création de l'environnement de dev"${RESET}

curl \
-X PUT \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token $AUTH" \
-H "Content-Type: application/json" \
-i "https://api.github.com/repos/torjc01/${DEPOT}/environments/dev" \
-d '{
        "wait_timer": 0,
        "reviewers": [
            
        ], 
        "deployment_branch_policy": 
            {"protected_branches": false, 
            "custom_branch_policies": true}
        
    }'

# Creation de l'environnement de pre-prod
echo ${GREEN}"Création de l'environnement de pre-prod"${RESET}

curl \
-X PUT \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token $AUTH" \
-H "Content-Type: application/json" \
-i "https://api.github.com/repos/torjc01/${DEPOT}/environments/pre-prod" \
-d '{
        "wait_timer": 0,
        "reviewers": [
            
        ], 
        "deployment_branch_policy": 
            {"protected_branches": false, 
            "custom_branch_policies": true}
        
    }'

# Creation de l'environnement de prod
echo ${GREEN}"Création de l'environnement de prod"${RESET}

curl \
-X PUT \
-H "Accept: application/vnd.github+json" \
-H "Authorization: token $AUTH" \
-H "Content-Type: application/json" \
-i "https://api.github.com/repos/torjc01/${DEPOT}/environments/prod" \
-d '{
        "wait_timer": 0,
        "reviewers": [
            
        ], 
        "deployment_branch_policy": 
            {"protected_branches": false, 
            "custom_branch_policies": true}
        
    }'
