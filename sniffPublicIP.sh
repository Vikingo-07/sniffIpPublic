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

trap ctrl_c INT

function ctrl_c(){
        echo -e "\n${redColour}[!]${endColour} ${grayColour}Exiting...\n${endColour}"
        rm ut.tmp 2>/dev/null
        tput cnorm; exit 1
}

function helpPanel(){
	clear
 	echo -e "\n${grayColour}[${endColour}${yellowColour}*${endColour}${grayColour}]${endColour}${yellowColour} Help Panel${endColour}"
 	echo -e "${yellowColour}"; for i in $(seq 1 47); do echo -n "-"; done; echo -e "${endColour}"
	echo -e "\n${greenColour}   - Use mode:${endColour}${turquoiseColour} ./infoIpPublic.sh${endColour} ${purpleColour}-i${endColour} ${grayColour}IP${endColour}"
	echo -e "\n${grayColour}\t Eg: ${endColour}${turquoiseColour}./infoIpPublic${endColour} ${purpleColour}-i${endColour} ${grayColour}$(echo $((RANDOM%126))).$(echo $((RANDOM%255))).$(echo $((RANDOM%255))).$(echo $((RANDOM%255)))${endColour}"
	echo -e "\n${greenColour}   - For file extraction:${endColour}${greyColour} use ${endColour}${purpleColour}-e${endColour}"
	echo -e "${yellowColour}"; for i in $(seq 1 47); do echo -n "-"; done; echo -e "${endColour}"
	tput cnorm; exit 1
}

parameter_counter=0; extract=0; while getopts "i:e" arg; do
	case $arg in
		i) ip=$OPTARG; let parameter_counter+=1;;
		e) extract=1;;
		*) helpPanel;;
	esac
done

if [ $parameter_counter -eq 0 ]; then
	helpPanel;
else
	tput civis; touch ut.tmp
	echo -ne "\n${turquoiseColour}Validating Public IP${endColour}${grayColour}...${endColour}"
	curl -s ip-api.com/$ip | tr -d '{' | tr -d '}' | tr -d '"' | tr -d ',' > ut.tmp
	cat ut.tmp | grep "fail" > /dev/null
	if [ $(echo $?) -eq 0 ]; then
		echo -e "${grayColour}[${endColour}${redColour}X${endColour}${grayColour}]${endColour}"
		sleep 1; clear
		echo -e "${grayColour}IP ${endColour}${redColour}$ip${endColour}${grayColour} is invalid.${endColour}"
		tput cnorm; exit 1
	else
		echo -e "${grayColour}[${endColour}${greenColour}V${endColour}${grayColour}]${endColour}"
		sleep 1; clear
		echo -ne "\n${turquoiseColour}Information of IP Public${endColour}${yellowColour} $ip${endColour}:"
		cat ut.tmp
		if [ $extract -eq 1 ]; then
			echo -ne "\n${turquoiseColour}Extracting information${endColour}${grayColour}...${endColour}"
			cp ut.tmp infoOutIP.txt
			if [ $(echo $?) -eq 0 ]; then
				sleep 1; echo -e "${grayColour}[${endColour}${greenColour}V${endColour}${grayColour}]${endColour}"
				echo -ne "\n${turquoiseColour}File name: ${endColour}${yellowColour} infoOutIP.txt${endColour}:"
			else
				sleep 1; echo -e "${grayColour}[${endColour}${redColour}X${endColour}${grayColour}]${endColour}"
				echo -ne "\n${redColour}We cant extract the file, try again.${endColour}"
			fi
		fi
		rm ut.tmp 2>/dev/null
		tput cnorm; exit 0
	fi
fi
