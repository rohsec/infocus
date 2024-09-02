#!/usr/bin/bash

################ CONSTANTS ####################
bred='\033[1;31m'
bblue='\033[1;34m'
bgreen='\033[1;32m'
yellow='\033[0;33m'
red='\033[0;31m'
blue='\033[0;34m'
green='\033[0;32m'
reset='\033[0m'
dir="$HOME/.infocus"
################ LOGO ########################
logo(){
printf """▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖ ▗▄▖  ▗▄▄▖▗▖ ▗▖ ▗▄▄▖
  █  ▐▛▚▖▐▌▐▌   ▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌   
  █  ▐▌ ▝▜▌▐▛▀▀▘▐▌ ▐▌▐▌   ▐▌ ▐▌ ▝▀▚▖
▗▄█▄▖▐▌  ▐▌▐▌   ▝▚▄▞▘▝▚▄▄▖▝▚▄▞▘▗▄▄▞▘                            
  <---- https://x.com/rohsec ---->
"""
}

############### USAGE ########################
usage(){
echo "Usage: $0 [block|unblock|stats] [domain]"
    echo ""
    echo "Options:"
    echo "  block [domain]      Block access to the specified domain."
    echo "  unblock [domain]    Unblock access to the specified domain."
    echo "  stats               Display the current blocking statistics."
    echo ""
    echo "Examples:"
    echo "  $0 block example.com   # Block access to example.com"
    echo "  $0 unblock example.com # Unblock access to example.com"
    echo "  $0 stats               # Show blocking statistics"
    echo ""
    echo "Note:"
    echo "  - If no valid option is provided, this usage message will be shown."
}

################ BLOCKER ######################
block(){
echo "127.0.0.1 $1 #infocus $(date +%d/%m/%Y)" >> /etc/hosts 
printf "\n$yellow[ * ] $bred$1$bblue is now added to blocklist$reset"
}

################# UNBLOCKER ####################
unblock(){
#x=$(cat test|egrep -i '#infocus'|egrep -i $1)
sed -i "/$1/d" /etc/hosts
printf "\n$yellow[ * ] $bgreen$1$bblue removed from the blocklist$reset"
#sed -i "/^$/d" test
}

##################### STATS #######################
stats(){
printf """\n$yellow===============================\n${bblue}User:$reset $bgreen$(whoami)\t${bblue}OS: $bgreen$(uname -o)\n${bblue}Block Count: $bred$(cat /etc/hosts|egrep -i '#infocus'|wc -l)\n$reset"""
printf "\n${bred}Domain\t\t${bred}Blocked Since\n$reset"
cat /etc/hosts|egrep -i '#infocus'|awk '{print $2"\t"$4}'
printf "\n$yellow===============================$reset"
}

####################### MAIN ########################
main(){
logo
[[ ! -d "$dir" ]] && (mkdir $dir && cp /etc/hosts /etc/hosts.bck)||:
if [[ ! -z $1  && $1 == "block" && ! -z $2 ]]; then
	block $2
elif [[ ! -z $1 && $1 == "unblock" && ! -z $2 ]]; then
	unblock $2
elif [[ ! -z $1 && $1 == "stats" ]]; then
	stats	
else
	usage
fi

}

############## SCRIPT START ##################
main $1 $2
