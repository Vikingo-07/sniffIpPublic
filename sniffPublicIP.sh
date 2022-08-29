#!/bin/bash

#author: Moriconi Lorenzo

#colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

clear
if [ $(echo $1 | wc -c) -eq 1 ]; then
    echo -e "\n${grayColour}[${endColour}${yellowColour}*${endColour}${grayColour}]${endColour}${yellowColour} Help Panel${endColour}"
    echo -e "${yellowColour}"; for i in $(seq 1 40); do echo -n "-"; done; echo -e "${endColour}"
    echo -e "\n${purpleColour}   - Use mode:${endColour}${turquoiseColour} ./infoIpPublic.sh${endColour} ${redColour}IP${endColour}"
    echo -e "\n${grayColour}   Example: ${endColour}${turquoiseColour}./infoIpPublic${endColour} ${redColour}$(echo $((RANDOM%126))).$(echo $((RANDOM%255))).$(echo $((RANDOM%255))).$(echo $((RANDOM%255)))${endColour}"
    echo -e "${yellowColour}"; for i in $(seq 1 40); do echo -n "-"; done; echo -e "${endColour}"
    exit 1
else
	tput civis; touch ut.tmp; ip=$1
	echo -ne "\n${turquoiseColour}Validating IP Public${endColour}${grayColour}...${endColour}"
	curl -s ip-api.com/$ip | tr -d '{' | tr -d '}' | tr -d '"' | tr -d ',' > ut.tmp
	cat ut.tmp | grep "fail" > /dev/null
	if [ $(echo $?) -eq 0 ]; then
		echo -e "${grayColour}[${endColour}${redColour}X${endColour}${grayColour}]${endColour}"
		sleep 1; clear
		echo -e "${grayColour}IP ${endColour}${redColour}$1${endColour}${grayColour} is invalid.${endColour}"
		tput cnorm; exit 1
	else
		echo -e "${grayColour}[${endColour}${greenColour}V${endColour}${grayColour}]${endColour}"
		sleep 1; clear
		echo -ne "\n${turquoiseColour}Information of IP Public${endColour}${yellowColour} $ip${endColour}:"		
		cat ut.tmp
	fi
	rm ut.tmp 2>/dev/null
	tput cnorm; exit 0
fi
