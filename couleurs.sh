#!/bin/bash
#
# Nom script  : couleurs.sh
# Objectf     : Déclaration des couleurs utilisées dans les scripts.  
# Date        : 21/07/2022
# Programmeur : Julio Torres 
# OS cible    : Linux 
#
# ==== Definition de couleurs === # 
BLACK=`tput setaf 0`
RED=`tput setaf 1`  
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
MAGENTA=`tput setaf 5`
CYAN=`tput setaf 6`
WHITE=`tput setaf 7`
BOLD=`tput bold`
RESET=`tput sgr0`

# Color       #define       Value       RGB
# black     COLOR_BLACK       0         0, 0, 0
# red       COLOR_RED         1         max,0,0
# green     COLOR_GREEN       2         0,max,0
# yellow    COLOR_YELLOW      3         max,max,0
# blue      COLOR_BLUE        4         0,0,max
# magenta   COLOR_MAGENTA     5         max,0,max
# cyan      COLOR_CYAN        6         0,max,max
# white     COLOR_WHITE       7         max,max,max