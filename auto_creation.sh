#!/bin/bash
#
# Nom script  : auto_creation.sh
# Objectf     : Automatiser le processus de création de dépôts dans le 
#               GitHub du CQEN. 
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
#

# ==== Définition de traitement des erreurs
set -e
# set -vx  # Lance le script avec les sysouts pour débogage. Décommenter au cas du debogue.

# === Carrega as variaveis de ambiente do arquivo .env
if [ -f .env ]; then
  #  export $(cat .env | sed 's/#.*//g' | xargs)
    set -a
    source .env
fi
# ==== Definition de couleurs === # 
source ./couleurs.sh

# ==== Définition de variables globales ==== # 
# == Infos sur l'organisation
HOSTNAME=https://api.github.com
GITHUB=https://www.github.com
ORG=CQEN-QDCE
CEAI_CQEN_ID="4838586"

# #######################################################################################

# Validation de la presence de la clé github
if [ -z $AUTH ]; then 
    echo ${RED}"*************************************************************"
    echo "ERRO: Token d'autentication personnel de GitHub non créé."
    echo "Dans votre cli, executez la commande "
    echo "    export AUTH=<votre token personnelle>"
    echo "Le script va quitter avec code d'erreur 100"
    echo "Merci de redémarrer le script"
    echo "*************************************************************"${RESET}
    exit 100
fi

echo " "
echo ${GREEN}"BEM-VINDO À CRIAÇÃO AUTOMATIZADA DE REPOSITÓRIOS GITHUB." ${RESET}
echo ""

# ==== Demanda de informações ao usuário.
echo ${MAGENTA}"Por favor informe os parâmetros que seguem.... "${RESET}
echo " "

echo ${YELLOW}"INFORMAÇÕES SOBRE O REPOSITÓRIO"${RESET}
# Nom du dépôt 
echo -n ${GREEN}"Nome do repositório : "${RESET}
read DEPOT
echo " "

# Descrição do repositório
echo -n ${GREEN}"Descrição do repositório (opcional) : "${RESET}
read DESC
echo " "

echo -n ${GREEN}"Owner do repositório: "
echo "Escolha uma das opcoes numericas abaixo:"
echo "1 - torjc01"
echo "2 - RegimentalEthos"${RESET}
read OWNER
echo " " 

[[ -z "$OWNER" ]] &&
 OWNER=1

case $OWNER in 
    1)
        echo "Owner do repositório : torjc01"
        OWNER=torjc01
        ORG=false
        ;;
    2)
        echo "Owner do repositório : RegimentalEthos"
        OWNER=RegimentalEthos
        ORG=true
        ;;
    *)
        echo "ERRO: Owner do repositório inválido."
        echo "Default owner: torjc01"
        sleep 1
        OWNER=torjc01
        ORG=false
        ;;
esac

# Visibilidade do repositório
echo -n ${GREEN}"Visibilidade do repositório (público/privado) : "${RESET}
echo "Escolha uma das opcoes numericas abaixo:"
echo "1 - publico"
echo "2 - privado"

read VISIB
[[ -z "$VISIB" ]] &&
 VISIB=1

echo " "

case $VISIB in 
    1) 
        echo "Visibilidade: público" 
        VISIB=false
        ;;
    2) 
        echo "Visibilidade: privado"
        VISIB=true
        ;;
    *) 
        echo ${YELLOW}"Opcao de visibilidade inválida." 
        echo "Atribuindo visibilidade default: público"${RESET}
        VISIB=false
        ;;
esac
echo " " 

echo ${YELLOW}"INFORMACOES SOBRE O FLUXO DE TRABALHO"${RESET}
# Escolha de fluxo de trabalho
echo -n ${GREEN}"Digite 1 para DEV->PROD, ou 2 para DEV->PRE-PROD->PROD : "${RESET}
read PROFILE


[[ -z "$PROFILE" ]] &&
 PROFILE=1 

case $PROFILE in 
    1)
        echo "DEV->PROD"
        ;;
    2)
        echo "DEV->PRE-PROD->PROD"
        ;;
    *)
        echo ${YELLOW}"Opcao de profile inválida."
        echo "Atribuindo provile default 1:DEV->PROD"${RESET}
        sleep 1
        PROFILE=1
        ;;
esac
echo " " 
echo ${YELLOW}"INFORMACAO SOBRE VOCÊ (SYSADMIN)"${RESET}

# Recuperation des valeurs par la config de git 
USERNAME=$(git config user.name)
EMAIL=$(git config user.email)

# ==== Validation des informations fournies 
echo ""
echo "Aqui estão os dados digitados. Verifique se as informações são exatas: "
echo ${YELLOW}"DEPOT"${RESET}
echo "Nome do projeto             : "${RED}$DEPOT ${RESET}
echo "Descrição do projeto        : "${RED}$DESC ${RESET}
echo "Visibilidade: é privado?    : "${RED}$VISIB ${RESET}
echo "Owner do projeto            : "${RED}$OWNER ${RESET}
echo "É organização?              : "${RED}$ORG ${RESET}
echo ${YELLOW}"FLUXO DE TRABALHO    "${RESET}
tmp=$([[ $PROFILE -eq 1 ]] && echo "DEV->PROD" || echo "DEV->PRE-PROD->PROD")
echo "Tipo de fluxo trabalho      : "${RED}$PROFILE":"$tmp ${RESET}  
echo ${YELLOW}"VOCE - O SYSADMIN" ${RESET}
echo "Seu nome                    : "${RED}$USERNAME ${RESET}
echo "Seu email                   : "${RED}$EMAIL ${RESET}
echo ""
echo "Todos os dados estao corretos? (S/N)"
read CONF
echo ""


case $CONF in 

    S|s|Y|y|O|o)
        echo "Dados confirmados."
        ;;
    N|n)
        echo ${RED}"******************************************"
        echo "ERRO: Dados nao confirmados."
        echo "O script vai sair com codigo de erro 1"
        echo "Por favor, execute o script de novo"
        echo "******************************************"${RESET}
        exit 1
        ;;
    *)
        echo ${RED}"******************************************"
        echo "ERRO: Opcao invalida."
        echo "O script vai sair com codigo de erro 1"
        echo "Por favor, execute o script de novo"
        echo "******************************************"${RESET}
        exit 2
        ;;
esac

# ####################################################################################
#   ETAPA 2 - EXECUÇÃO DOS SCRIPTS DE CRIAÇÃO DE REPOSITÓRIOS
# ####################################################################################


echo " "
echo ${MAGENTA}"CREATION DU DÉPÔT"${RESET}
echo " "

# Formation de l'adresse de la homepage
HOMEPAGE=$GITHUB/$OWNER/$DEPOT

echo "Nom depot : " $DEPOT
echo "Descrição: " $DESC
echo "Homepage: " $HOMEPAGE
echo "Visibilidade privado?: " $VISIB

./02-creation-depot.sh "$DEPOT" "$DESC" "$HOMEPAGE" "$VISIB" "$ORG" "$OWNER"


echo " "
echo ${MAGENTA}"CREATION DES BRANCHES"${RESET}
echo " "

./03-branches-creation.sh "$DEPOT" "$PROFILE" "$OWNER" "$ORG"


echo " "
echo ${MAGENTA}"INSERTION DES FICHIERS"${RESET}
echo " "
# La création automatisée des fichiers est suspendue, jusqu'à la solution du problème 
# décrit dans l'issue Sign-off et signature de fichiers inclus via REST API 
# (https://github.com/CQEN-QDCE/CreerDepotCQEN/issues/1). 
./04-fichiers-creation.sh "$DEPOT" "$USERNAME" "$EMAIL" "$OWNER"

#echo " "
#echo ${MAGENTA}"MISE A JOUR DES PERMISSIONS D'EQUIPE"${RESET}
#echo " "

#./05-update-team-permissions.sh "$DEPOT"


echo " "
echo ${MAGENTA}"PROTECTION DES BRANCHES"${RESET}
echo " "

./06-branches-protection.sh "$DEPOT" "$PROFILE" "$OWNER"

echo " "
echo ${MAGENTA}"CREATION DES ENVIRONNEMENTS"${RESET}
echo " "

./07-environnments-creation.sh "$DEPOT" "$PROFILE" "$OWNER"

echo " "
echo ${MAGENTA}"SUPPRIME LA BRANCHE MAIN"${RESET}
echo " "

./09-supprime-branche-main.sh "$DEPOT" "$OWNER" 
