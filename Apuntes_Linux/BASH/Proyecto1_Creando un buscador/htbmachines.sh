#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Variables globales
main_url="https://htbmachines.github.io/bundle.js"


function ctrl_c(){
  echo -e  "\n\n ${redColour}[!]Saliendo ....\n ${endColour}"
  tput cnorm && exit 1
}

# Ctrl + c 
trap ctrl_c INT


function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Uso: ${endColour}"
 
  echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de máquina ${endColour}"

  echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Descargamos o actualizamos los archivos necesarios ${endColour}"
  echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda ${endColour} \n"

  

  
}

function searchMachine(){
  machineName="$1"

  echo "$machineName"
}

function updateFiles(){

  if [ ! -f bundle.js  ]; then 
  echo -e "\n ${purpleColour}[+]${endColour} ${yellowColour}El archivo no existe${endColour}, ${grayColour}comenzamos con la descarga de archivos necesarios...${endColour}"
  tput civis;
  curl -s $main_url > bundle.js
  js-beautify bundle.js | sponge bundle.js
  
  echo -e "${purpleColour}[+]${endColour} ${greenColour}Los archivos han sido descargados ${endColour}"
  
  else 
  echo -e "\n ${yellowColour}[!]${endColour} ${grayColour}Comenzamos con las actualizaciones...${endColour}"

    fi 
}
# Indicadores
#
# Vamos a usarlo para ver si el usuario ha hecho uso del parámetro m, en vez de hacerlo en el propio getopts
declare -i parameter_counter=0


# Creamos el parámetro m,h y u, h lo utilizaremos para mostrar la ayuda (y en caso de usar mal la sintaxis) y la m para indicar la máquina que buscamos
# la u la utilizamos para comprobar si hay updates en el archivo de búsqueda y realizar el update en tal caso

while getopts "m:hu" arg; do 

  case $arg in 
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    h) ;;

  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
   
 else
 helpPanel
fi
