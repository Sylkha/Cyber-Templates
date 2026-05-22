#!/bin/bash

# This script belongs to Hack4u academy, s4vitar

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
 echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
 tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
 echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
 echo -e "\tm) Buscar por un nombre de máquina"
 echo -e "\tu) Descargar o actualizar archivos necesarios"
 echo -e "\th) Mostrar este panel de ayuda\n"
}

function searchMachine(){
 machineName="$1"
 echo "Buscando la máquina ${machineName}..."
 
 cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^*//'
}

function updateFiles(){
 echo -e "\n[+] Comenzamos con las actualizaciones"
 tput civis

 if [ -f bundle.js ]; then
  curl -s $main_url > bundle_temp.js
  js-beautify bundle_temp.js | sponge bundle_temp.js
  md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
  md5_origin_value=$(md5sum bundle.js | awk '{print $1}')
  if [ "$md5_temp_value" == "$md5_origin_value" ]; then
    echo "[+] No hay actualizaciones"
    rm bundle_temp.js
  else
    echo "[+] Hay actualizaciones"
    rm bundle.js && mv bundle_temp.js bundle.js
  fi

 else
  echo -e "\n[+] Descargando archivos necesarios..."
  curl -s $main_url > bundle.js
  js-beautify bundle.js | sponge bundle.js
  echo -e "\n[+] Todos los archivos han sido descargados" 
 fi

 tput cnorm
}

function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"

  check_results=$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)

  if [ "$check_results" ]; then
          echo -e "[+] Listando máquinas de dificultad $difficulty que tengan sistema operativo $os"
          echo -e "$check_results"
  else
          echo -e "[+] No se han encontrado máquinas con esas características"
  fi
}

# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ud:o:h" arg; do
 case $arg in
  m) machineName=$OPTARG; let parameter_counter+=1;; 
  u) let parameter_counter+=2;;
  d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=3;;
  o) os="$OPTARG"; chivato_os=1; let parameter_counter+=4;;
  h) helpPanel;;
 esac
done

if [ $parameter_counter -eq 1 ]; then
 searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
 updateFiles
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
 getOSDifficultyMachines $difficulty $os
else
 helpPanel
fi
