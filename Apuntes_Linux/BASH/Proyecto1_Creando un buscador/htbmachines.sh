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

#Funciones

function helpPanel(){
  echo -e "\n${yellowColour}[+] ${endColour} ${grayColour}Uso: ${endColour}\n"
  echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Buscar por un nombre de máquina ${endColour}"
  echo -e "\t ${purpleColour}i)${endColour} ${grayColour}Buscar por IP ${endColour}"
  echo -e "\t ${purpleColour}d)${endColour} ${grayColour}Buscar por la dificultad de una máquina${endColour}"
  echo -e "\t ${purpleColour}o)${endColour} ${grayColour}Buscar por sistema operativo de una máquina${endColour}"
  echo -e "\t ${purpleColour}s)${endColour} ${grayColour}Buscar por skills${endColour}"
  echo -e "\t ${purpleColour}c)${endColour} ${grayColour}Buscar por máquina de un certificado${endColour}"
  echo -e "\t ${purpleColour}y)${endColour} ${grayColour}Obtener link de la resolución de la máquina${endColour}" 
  echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Descargamos o actualizamos los archivos necesarios ${endColour}"
  echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Mostrar este panel de ayuda ${endColour}"

  echo -e "\n${turquoiseColour}[?] ${grayColour}Tener en cuenta que se puede hacer llamadas a varios parámetros para hacer búsquedas conjuntas, las posibilidades son:${endColour}\n"
  echo -e "\t${greenColour}[+]${grayColour} Búsqueda conjunta de ${yellowcolour}certficado y sistema operativo${endColour}"
  echo -e "\t${greenColour}[+]${grayColour} Búsqueda conjunta de ${yellowcolour}certficado y dificultad${endColour}"
  echo -e "\t${greenColour}[+]${grayColour} Búsqueda conjunta de ${yellowcolour}dificultad y sistema operativo${endColour}"
}

function getMachinesSO(){
  so="$1"
  so_upper=${so^}

  results_check="$(cat bundle.js | grep -i "so: \"$so_upper\"" -B 5| grep name | awk '{print $NF}'| tr -d '"'| tr -d ',' | column)"

 if [ "$results_check" ]; then
    echo -e "\n ${purpleColour}[+] ${grayColour}Representando las máquinas con sistema operativo ${yellowColour}$so_upper${endColour}\n\n"
    cat bundle.js | grep "so: \"$so_upper\"" -i -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  
  else 
   echo -e "\n ${redColour}[!] ${grayColour}No existe el sistema operativo ${yellowColour}$so_upper${grayColour} en ninguna máquina${endColour}"
  fi
 
  

}
function getMachinesDifficulty(){
  difficulty=$1
  difficulty_upper=${difficulty^} 
  results_check="$(cat bundle.js | grep "dificultad: \"$difficulty_upper\"" -i -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
  
  if [ "$results_check" ]; then
    echo -e "\n ${purpleColour}[+] ${grayColour}Representando las máquinas con dificultad ${yellowColour}$difficulty_upper${endColour}\n\n"
    cat bundle.js | grep "dificultad: \"$difficulty_upper\"" -i -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  
  else 
   echo -e "\ ${redcolour}[!] ${graycolour}no existe la dificultad ${yellowcolour}$difficulty_upper${grayColour} en ninguna máquina${endColour}"
  fi
}
function getYoutubeLink(){

  machineName="$1"
  machineName_upper=${machineName^}
  
  youtubeLink="$(cat bundle.js | awk "/name: \"$machineName_upper\"/,/resuelta:/"| grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'  | grep "youtube" | awk '{print $NF}')"

  if [ youtubeLink ]; then
    
    echo -e "\n ${purpleColour}[+] ${grayColour}El tutorial para esta máquina está en el siguiente enlace: ${yellowColour}$youtubeLink ${endColour}"

  else

    echo -e "\n ${redColour}[!] ${grayColour}la máquina $machineName no existe ${endColour}"
  fi

}

function searchIp(){
  ipAddress=$1
  machineName=$( cat bundle.js | grep "\ip: \"$ipAddress\"" -B 3 | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
  
  if [ "$machineName" ]; then
  echo -e "\n ${purpleColour}[+] ${grayColour}La correspondiente máquina para la IP ${yellowColour} $ipAddress ${grayColour}es ${blueColour}$machineName${endColour} \n" 
  else
  echo -e "\n ${redColour}[!] ${grayColour}No existe ninguna máquina asociada a esta IP${yellowColour} $ipAddress${endColour}"
  fi #searchMachine $machineName
}

function searchMachine(){
  machineName="$1"
   machineName_upper=${machineName^}
  machineName_checker=$(cat bundle.js | awk "/name: \"$machineName_upper\"/,/resuelta:/"| grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')
 


  if [ "$machineName_checker" ]; then

  echo -e "\n ${purpleColour}[+] ${grayColour}Mostramos la información relevante de la máquina ${yellowColour}$machineName_upper ${endColour} \n"
  

  cat bundle.js | awk "/name: \"$machineName_upper\"/,/resuelta:/"| grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//'
  else
    
    echo -e "\n ${redColour}[!] ${grayColour}la máquina $machineName_upper no existe ${endColour}"

  fi
    

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
function getOSDifficultyMachines(){
  difficulty="$1"
  os="$2"

  # Asegura que el parámetro -i esté antes del patrón y utiliza -C para el contexto de líneas
  results_check="$(cat bundle.js | grep -i "so: \"$so\"" -C 4 | grep -i "dificultad: \"$difficulty\"" -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"
  
  if [ "$results_check" ]; then

    difficulty_upper="${difficulty^}"
    so_upper="${so^}"

    echo -e "\n ${purpleColour}[+] ${grayColour}Representando las máquinas con dificultad ${yellowColour}$difficulty_upper${grayColour} y con sistema operativo ${blueColour}$so_upper${endColour}\n\n"
    
    # Asegura el uso correcto de -i y -C en ambos grep para la salida final
    cat bundle.js | grep -i "so: \"$so\"" -C 4 | grep -i "dificultad: \"$difficulty\"" -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n ${redColour}[?]${grayColour} Si estás seguro de que la sintaxis está bien, seguramente que la${yellowColour} Dificultad o el Sistema Operativo ${grayColour}no exista en ninguna máquina ${endColour} \n"
  fi
}

function getMachinesSkills(){

  skill=$1
 
  skill_checker="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6| grep "name: "| awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"


  if [ "$skill_checker" ]; then
    
    echo -e "\n ${purpleColour}[+] ${grayColour}Mostramos las máquinas con Skill ${yellowColour}${skill^}${endColour}\n\n"

    cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6| grep "name: "| awk '{print $NF}' | tr -d '"' | tr -d ',' | column

  else
    
    echo -e "\n ${redColour}[!] ${grayColour}No existe ninguna máquina con skill ${yellowColour}${skill^}${endColour}"
  fi

}

function getMachinesCertificate(){
  
  certificate="$1"

  certificate_checker="$(cat bundle.js | grep "like: " -B 6| awk '{print $NF}'| cat bundle.js | grep "like: " -B 7 | grep -vE "id:|sku:|ip:|so:|dificultad:|skills:" | grep -i $certificate -B 1 | grep "name: "| awk '{print $NF}' | tr -d '"'| tr -d ',' | column)"
  
  if [ "$certificate_checker" ]; then
    echo -e "\n ${purpleColour}[+]${grayColour}Las siguientes máquinas son para prepararse el certificado ${yellowColour}${certificate^^}${endColour}\n\n"

   cat bundle.js | grep "like: " -B 6| awk '{print $NF}'| cat bundle.js | grep "like: " -B 7 | grep -vE "id:|sku:|ip:|so:|dificultad:|skills:" | grep -i $certificate -B 1 | grep "name: "| awk '{print $NF}' | tr -d '"'| tr -d ',' | column 

  else
    
    echo -e "\n ${redColour}[!] ${grayColour}No existe ninguna máquina para el certificado de  ${yellowColour}${certificate^}${endColour}"

  fi
 }

 function getOSCertificate(){
  so="$1"
  so_upper=${so^}
  certificate="$2"
  certificate_upper=${certificate^}

  result_checker="$(cat bundle.js | grep "like: " -B 6| awk '{print $NF}'| cat bundle.js | grep "like: " -B 7 | grep -vE "id:|sku:|ip:|dificultad:|skills:" | grep -i "$certificate"  -B 2 | grep -i "$so" -B 2 | grep "name: "| awk '{print $NF}'| tr -d '"' | tr -d ',' | column)"

  if [ "$result_checker" ]; then

    echo -e "\n ${purpleColour}[+] ${grayColour}Las máquinas cuyo Sistema operativo es ${yellowColour}$so_upper ${grayColour}y que son para prepararse el certificado ${blueColour}$certificate_upper ${grayColour}son ${endColour}\n\n"

    cat bundle.js | grep "like: " -B 6| awk '{print $NF}'| cat bundle.js | grep "like: " -B 7 | grep -vE "id:|sku:|ip:|dificultad:|skills:" | grep -i "$certificate" -B 2| grep -i $so -B 2 | grep "name: "| awk '{print $NF}'| tr -d '"' | tr -d ',' | column
  else 

    
    echo -e "\n ${redColour}[!] ${grayColour}No existe ninguna máquina para el certificado de ${yellowColour}${certificate^^} ${grayColour} con Sistema operativo ${yellowColour} ${so^}${endColour}"
    
  fi
 }
function getDifficultyCertificate(){
  
  difficulty="$1"
  certificate="$2"

  result_checker="$(cat bundle.js | grep "like: " -B 10 | grep -vE "id:|sku:|so:|skills:|youtube:|resulta:|ip:" | grep -i "$certificate" -B 3 | grep -i "$difficulty" -B 3| grep "name: "| awk '{print $NF}'| tr -d '"'| tr -d ',' | column)"
  
  if [ "$result_checker" ]; then

    echo -e "\n ${purpleColour}[+] ${grayColour}Mostramos las máquinas cuya dificultad es ${yellowColour}${difficulty^} ${grayColour}y que son para prepararse el certificado ${blueColour}${certificate^}:${endColour}\n"

   cat bundle.js | grep "like: " -B 10 | grep -vE "id:|sku:|so:|skills:|youtube:|resulta:|ip:" | grep -i "$certificate" -B 3 | grep -i "$difficulty" -B 3| grep "name: "| awk '{print $NF}'| tr -d '"'| tr -d ',' | column

  else 

    echo -e "\n ${redColour}[!] ${grayColour}No existe ninguna máquina para el certificado de ${yellowColour}${certificate^^} ${grayColour} con Dificultad ${yellowColour} ${difficulty^^}${endColour}"

  fi
    
 }
# Indicadores
#
# Vamos a usarlo para ver si el usuario ha hecho uso del parámetro m, en vez de hacerlo en el propio getopts
declare -i parameter_counter=0

#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0
declare -i chivato_certificate=0

# Creamos el parámetro m,h y u, h lo utilizaremos para mostrar la ayuda (y en caso de usar mal la sintaxis) y la m para indicar la máquina que buscamos
# la u la utilizamos para comprobar si hay updates en el archivo de búsqueda y realizar el update en tal caso

while getopts "m:i:y:d:o:s:c:uh" arg; do 

  case $arg in 
    m) machineName="$OPTARG"; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    i) ipadress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; chivato_difficulty=1;let parameter_counter+=5;;
    o) so="$OPTARG"; chivato_os=1;let parameter_counter+=6;;
    s) skill="$OPTARG"; let parameter_counter+=7;;
    c) certificate="$OPTARG"; chivato_certificate=1; let parameter_counter+=8;;
    h) ;;

  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine "$machineName"
elif [ $chivato_os -eq 1 ] && [ $chivato_certificate ]; then

  getOSCertificate "$so" "$certificate"

elif [ $chivato_difficulty -eq 1 ] && [ $chivato_certificate -eq 1 ]; then
  getDifficultyCertificate "$difficulty" "$certificate"


elif [ $chivato_os -eq 1 ] && [ $chivato_difficulty -eq 1 ]; then 
  getOSDifficultyMachines "$difficulty" "$so" 
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  searchIp $ipadress

elif [ $parameter_counter -eq 4 ]; then 
  
  getYoutubeLink "$machineName"

elif [ $parameter_counter -eq 5 ]; then
  
  getMachinesDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then
  getMachinesSO "$so"

elif [ $parameter_counter -eq 7 ]; then

  getMachinesSkills "$skill"
elif [ $parameter_counter -eq 8 ]; then

  getMachinesCertificate "$certificate"



else
 helpPanel
fi
