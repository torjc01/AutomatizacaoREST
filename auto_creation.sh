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

# ==== Definition de couleurs === # 
source ./couleurs.sh

# ==== Définition de variables globales ==== # 
# == Infos sur l'organisation
HOSTNAME=https://api.github.com
GITHUB=https://www.github.com

# #######################################################################################

# Validation de la presence de la clé github
if [ -z $AUTH ]; then 
    echo ${RED}"*************************************************************"
    echo "ERREUR: Token d'autentication personnel de GitHub non créé."
    echo "Dans votre cli, executez la commande "
    echo "    export AUTH=<votre token personnelle>"
    echo "Le script va quitter avec code d'erreur 100"
    echo "Merci de redémarrer le script"
    echo "*************************************************************"${RESET}
    exit 100
fi

echo " "
echo ${GREEN}"BIENVENU À LA CRÉATION AUTOMATISÉE DE DÉPÔT GITHUB DU CQEN." ${RESET}
echo ""

# ==== Demande de l'info à l'utilisateur. 
echo ${MAGENTA}"Veuillez informer les paramètres qui suivent.... "
echo " "

echo ${YELLOW}"INFORMATIONS SUR LE DEPOT"${RESET}
# Nom du dépôt 
read -e -i "$depot" -p ${GREEN}"Nom du dépôt : "${RESET} INPUT 
DEPOT="${INPUT:-depot}"

# Description
read -e -i "$desc" -p ${GREEN}"Description du dépôt (optionnel): "${RESET} INPUT
DESC="${INPUT:-$desc}"
echo " "

echo ${YELLOW}"INFORMATIONS SUR LE FLUX DE TRAVAIL"${RESET}
# Choix du flux de travail 
read -e -i "$profile" -p ${GREEN}"Saisssez 1 pour DEV->PROD, ou 2 pour DEV->PRE-PROD->PROD: "${RESET} INPUT
PROFILE="${INPUT:-$profile}"

[[ -z "$PROFILE" ]] &&
 PROFILE=1 

case $PROFILE in 
    1)
        echo "Simples"
        ;;
    2)
        echo "Longo"
        ;;
    *)
        echo "ERREUR: Option invalide."
        echo "Defaulting à la version simple"
        PROFILE=1
        ;;
esac
echo "PROFILE: " $PROFILE

echo ${YELLOW}"INFORMATION SUR VOUS (SYSADMIN)"${RESET}
# Nom usager github du admin de systemes
read -e -i "$username" -p ${GREEN}"Votre nom d'usager github : "${RESET} INPUT
USERNAME="${INPUT:-$username}"

# Email du admin de systemes
read -e -i "$email" -p ${GREEN}"Votre email : "${RESET} INPUT
EMAIL="${INPUT:-$email}"

# ==== Validation des informations fournies 
echo ""
echo "Voici les données saisies. Vérifiez si elles sont exactes: "
echo ${YELLOW}"DEPOT"${RESET}
echo "Nom du projet      : "${RED}$DEPOT ${RESET}
echo "Description projet : "${RED}$DESC ${RESET}
echo ${YELLOW}"EQUIPE DE TRAVAIL"${RESET}
echo "Nom equipe travail : "${RED}$NOM_EQUIPE ${RESET}
echo "Desc equipe travail: "${RED}$DESCTEAM ${RESET}
echo "Mainteneur         : "${RED}$MAINTENEUR ${RESET}
echo ${YELLOW}"VOUS - LE SYSADMIN"${RESET}
echo "Votre nom d'usager : "${RED}$USERNAME ${RESET}
echo "Votre courriel     : "${RED}$EMAIL ${RESET}

# echo "Votre auth token   : "${RED}$AUTH ${RESET}
echo ""
echo "Tous les données sont correctes? (O/N)"
read CONFIRMATION 
echo ""


case $CONFIRMATION in 

    O | o)
        echo "Données confirmées."
        ;;
    N | n)
        echo ${RED}"******************************************"
        echo "ERREUR: Données non confirmées."
        echo "Le script va quitter avec code d'erreur 1"
        echo "Merci de redémarrer le script"
        echo "******************************************"${RESET}
        exit 1
        ;;
    *)
         ${RED}"******************************************"
        echo "ERREUR: Option invalide."
        echo "Le script va quitter avec code d'erreur 2"
        echo "Merci de redémarrer le script"
        "******************************************"${RESET}
        exit 2
        ;;
esac


echo " "
echo ${MAGENTA}"CREATION DU DÉPÔT"${RESET}
echo " "

# Formation de l'adresse de la homepage
HOMEPAGE=$GITHUB/CQEN-QDCE/$DEPOT

echo "Nom depot : " $DEPOT
echo "Description: " $DESCRIPTION
echo "Homepage: " $HOMEPAGE

./02-creation-depot.sh "$DEPOT" "$DESC" "$HOMEPAGE"


echo " "
echo ${MAGENTA}"CREATION DES BRANCHES"${RESET}
echo " "

./03-branches-creation.sh "$DEPOT" "$PROFILE"


echo " "
echo ${MAGENTA}"PROTECTION DES BRANCHES"${RESET}
echo " "

./06-branches-protection.sh "$DEPOT" "$PROFILE"


echo " "
echo ${MAGENTA}"CREATION DES ENVIRONNEMENTS"${RESET}
echo " "

./07-environnments-creation.sh "$DEPOT"


# echo " "
# echo ${MAGENTA}"SUPPRIME LA BRANCHE MAIN"${RESET}
# echo " "

# ./09-supprime-branche-main.sh "$DEPOT"
