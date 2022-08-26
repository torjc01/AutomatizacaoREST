#!/bin/bash
#
# Nom script  : 05-branches-protection.sh
# Objectf     : Protection des branches utilisées dans le dépôt 
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
# PARAMS      : DEPOT USERNAME
# Protection des branches 

set -e
# set -vx
source ./couleurs.sh 

DEPOT=$1
PROFILE=$2

#Protection de la branche prod

echo ${GREEN}"Protection de la branche prod"${RESET}
curl \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/branches/prod/protection \
  -d '{
        "required_status_checks": null,
        "enforce_admins": true,
        "required_pull_request_reviews" : 
            {
                "dismiss_stale_reviews": false,
                "require_code_owner_reviews": true,
                "required_approving_review_count": 1
            },
        "restrictions":null, 
        "required_conversation_resolution": true
    }' 

# Require signed commits 
# post/repos/{owner}/{repo}/branches/{branch}/protection/required_signatures
# https://docs.github.com/en/rest/branches/branch-protection#create-commit-signature-protection

echo ${GREEN}"Protection de la branche prod: {owner}require signed commits"${RESET}
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Content-type: application/json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/branches/prod/protection/required_signatures


if [ $PROFILE -eq 2 ]
then
    #Protection de la branche pre-prod

    echo ${GREEN}"Protection de la branche pre-prod"${RESET}
    curl \
    -X PUT \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: token $AUTH" \
    https://api.github.com/repos/torjc01/${DEPOT}/branches/pre-prod/protection \
    -d '{
            "required_status_checks": null,
            "enforce_admins": true,
            "required_pull_request_reviews" : 
                {
                    "dismiss_stale_reviews": false,
                    "require_code_owner_reviews": true,
                    "required_approving_review_count": 1
                },
            "restrictions":null, 
            "required_conversation_resolution": true
        }' 

    # Require signed commits 
    # post/repos/{owner}/{repo}/branches/{branch}/protection/required_signatures
    # https://docs.github.com/en/rest/branches/branch-protection#create-commit-signature-protection

    echo ${GREEN}"Protection de la branche pre-prod: {owner}require signed commits"${RESET}
    curl \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Content-type: application/json" \
    -H "Authorization: token $AUTH" \
    https://api.github.com/repos/torjc01/${DEPOT}/branches/pre-prod/protection/required_signatures

    #
fi

#Protection de la branche dev

echo ${GREEN}"Protection de la branche dev"${RESET}
curl \
  -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/branches/dev/protection \
  -d '{
        "required_status_checks": null,
        "enforce_admins": true,
        "required_pull_request_reviews" : 
            {
                "dismiss_stale_reviews": false,
                "require_code_owner_reviews": false
            },
        "restrictions":null, 
        "required_conversation_resolution": true
    }' 

# Require signed commits 
# post/repos/{owner}/{repo}/branches/{branch}/protection/required_signatures
# https://docs.github.com/en/rest/branches/branch-protection#create-commit-signature-protection

echo ${GREEN}"Protection de la branche dev: {owner}require signed commits"${RESET}
curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Content-type: application/json" \
  -H "Authorization: token $AUTH" \
  https://api.github.com/repos/torjc01/${DEPOT}/branches/dev/protection/required_signatures
