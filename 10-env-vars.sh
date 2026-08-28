#!/bin/bash
#
# Nom script  : 10-env-vars.sh
# Objectf     : Création de variables d'environnement dans github
# Date        : 27/08/2026
# Programmeur : Julio Torres 
# OS cible    : Linux 
#

set -a 
source .env 

OWNER=$1
DEPOT=$2 
ENV=$3
ENV_FILE=$4

# Etapa 1 - recupérer le repo id: 
REPO_ID=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${AUTH}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/$OWNER/$DEPOT  | jq '.id')


# Etapa 2 : Lire le fichier .env et envoyer les variables à l'API

while IFS='=' read -r variavel valor || [[ -n "$variavel" ]]; do
    # Ignorer lignes vides et commentaires
    [[ -z "$variavel" || "$variavel" =~ ^[[:space:]]*# ]] && continue

    # Remove "export " et spaces au tour du nom
    variavel="${variavel#export }"
    variavel="${variavel#"${variavel%%[![:space:]]*}"}"
    variavel="${variavel%"${variavel##*[![:space:]]}"}"

    # Remove spaces et guillemets externes simples ou duples du valeur
    valor="${valor#"${valor%%[![:space:]]*}"}"
    valor="${valor%"${valor##*[![:space:]]}"}"

    if [[ "$valor" == \"*\" && "$valor" == *\" ]]; then
        valor="${valor:1}"
        valor="${valor%\"}"
    elif [[ "$valor" == \'*\' && "$valor" == *\' ]]; then
        valor="${valor:1}"
        valor="${valor%\'}"
    fi

    echo "Enviando $variavel"

    echo "curl com as variaveis: $(printf '{"name":"%s","value":"%s"}' "$variavel" "$valor")" 

    curl -X POST \
        -H "Accept: application/vnd.github+json" \
        -H "Authorization: Bearer ${AUTH}" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        https://api.github.com/repositories/$REPO_ID/environments/$ENV/variables \
        -d "$(printf '{"name":"%s","value":"%s"}' "$variavel" "$valor")"

    echo
done < "$ENV_FILE"