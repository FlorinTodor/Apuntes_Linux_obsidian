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
  echo -e "\n${yellowColour}[+] ${endColour} ${grayColour}Uso: ${endColour}"
  echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de máquina ${endColour}"
  echo -e "\t ${purpleColour}i)${endColour} ${grayColour}Buscar por IP ${endColour}"
  echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Descargamos o actualizamos los archivos necesarios ${endColour}"
  echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda ${endColour} \n"

  

  
}

function searchMachine(){
  machineName="$1"

  echo -e "\n ${purpleColour}[+] ${grayColour}Mostramos la información relevante de la máquina ${yellowColour}$machineName ${endColour} \n"
  
  cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/"| grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'


}

function updateFiles(){

  if [ ! -f bundle.js  ]; then 
  echo -e "\n ${purpleColour}[+] ${endColour} ${yellowColour}El archivo no existe${endColour}, ${grayColour}comenzamos con la descarga de archivos necesarios...${endColour}"
  tput civis;
  curl -s $main_url > bundle.js
  js-beautify bundle.js | sponge bundle.js
  
  echo -e "\n ${purpleColour}[+] ${endColour} ${greenColour}Los archivos han sido descargados ${endColour}"
  tput cnorm
  else 

  tput civis
  echo -e "\n ${purpleColour}[+] ${endColour}${yellowColour}Comprobando si hay actualizaciones pendientes...${endColour}"
  sleep 2
  #Comprobaciones
  curl -s $main_url > bundle_tmp.js

  js-beautify bundle_tmp.js | sponge bundle_tmp.js
  
  md5_value=$(md5sum bundle.js | awk '{print $1}')
  md5_tmp_value=$(md5sum bundle_tmp.js | awk '{print $1}')


    if [ "$md5_value" != "$md5_tmp_value" ]; then

      echo -e "\n ${purpleColour}[+] ${endColour} ${grayColour}Hay actualizaciones, ${blueColour}comenzando la actualización${endColour}"
      rm bundle.js && mv bundle_tmp.js bundle.js

      else
        echo -e "\n ${purpleColour}[+] ${endColour} ${grayColour}No hay actualizaciones${endColour}"
        rm -f bundle_tmp.js

    fi 
  tput cnorm
  fi 
}
# Indicadores
#
# Vamos a usarlo para ver si el usuario ha hecho uso del parámetro m, en vez de hacerlo en el propio getopts
declare -i parameter_counter=0

function searchIp(){
  ipAddress=$1
  machineName=$( cat bundle.js | grep "\ip: \"$ipAddress\"" -B 3 | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

  echo -e "\n ${purpleColour}[+] ${grayColour}La correspondiente máquina para la IP ${yellowColour} $ipAddress ${grayColour}es ${blueColour}$machineName${endColour} \n"

  #searchMachine $machineName
}

# Creamos el parámetro m,h y u, h lo utilizaremos para mostrar la ayuda (y en caso de usar mal la sintaxis) y la m para indicar la máquina que buscamos
# la u la utilizamos para comprobar si hay updates en el archivo de búsqueda y realizar el update en tal caso

while getopts "m:i:uh" arg; do 

  case $arg in 
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipadress=$OPTARG; let parameter_counter+=3;;
    h) ;;

  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIp $ipadress
else
 helpPanel
fi
