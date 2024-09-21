#!/bin/bash

string4=$(openssl rand -hex 32 | cut -c 1-4)
string8=$(openssl rand -hex 32  | cut -c 1-8)
string12=$(openssl rand -hex 32 | cut -c 1-12)
string16=$(openssl rand -hex 32 | cut -c 1-16)
device="android-$string16"
uuid=$(openssl rand -hex 32 | cut -c 1-32)
phone="$string8-$string4-$string4-$string4-$string12"
guid="$string8-$string4-$string4-$string4-$string12"
header='Connection: "close", "Accept": "*/*", "Content-type": "application/x-www-form-urlencoded; charset=UTF-8", "Cookie2": "$Version=1" "Accept-Language": "en-US", "User-Agent": "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'
var=$(curl -i -s -H "$header" https://i.instagram.com/api/v1/si/fetch_headers/?challenge_type=signup&guid=$uuid > /dev/null)
var2=$(echo $var | grep -o 'csrftoken=.*' | cut -d ';' -f1 | cut -d '=' -f2)
ig_sig="4f8732eb9ba7d1c8e8897a75d6474d4eb3f5279137431b2aafb71fafe2abe178"


banner() {
clear
printf " \e[0m\n"
printf " \e[1;93m _   _        __      _ _                        \e[0m\n"
printf " \e[1;93m| | | |      / _|    | | |                \e[1;92m   _   \e[0m\n"
printf " \e[1;93m| | | |_ __ | |_ ___ | | | _____      __  \e[1;92m _| |_ \e[0m\n"
printf " \e[1;93m| | | | '_ \|  _/ _ \| | |/ _ \ \ /\ / /  \e[1;92m|_   _|\e[0m\n"
printf " \e[1;93m| |_| | | | | || (_) | | | (_) \ V  V /   \e[1;92m  |_|  \e[0m\n"
printf " \e[1;93m \___/|_| |_|_| \___/|_|_|\___/ \_/\_/           \e[0m\n"
printf " \e[0m\n"
printf " \e[1;96m [\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;92m Created By HTR-TECH (Tahmid Rayat)\e[0m\n"
printf " \e[0m\n"
}


user_login() {

if [[ $user == "" ]]; then
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Instagram Login\e[0m\n"
printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Input Username\e[1;96m : \e[0m\e[1;92m' user
fi

if [[ -e .cookie.$user ]]; then
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Login Creds Found for \e[0m\e[1;92m %s\e[0m\n" $user
default_use_cookie="Y"

printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Use Previous Creds ?\e[0m\e[1;96m [Y/n] : \e[0m\e[1;92m ' use_cookie
use_cookie="${use_cookie:-${default_use_cookie}}"

if [[ $use_cookie == *'Y'* || $use_cookie == *'y'* ]]; then
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Logging in using Previous Creds...\e[0m\n"
else
rm -rf .cookie.$user
user_login
fi

else

printf "\n"
read -s -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Input Password\e[1;96m : \e[0m' pass
printf "\n"
data='{"phone_id":"'$phone'", "_csrftoken":"'$var2'", "username":"'$user'", "guid":"'$guid'", "device_id":"'$device'", "password":"'$pass'", "login_attempt_count":"0"}'

IFS=$'\n'

hmac=$(echo -n "$data" | cut -d " " -f2)
useragent='User-Agent: "Instagram 10.26.0 Android (18/4.3; 320dpi; 720x1280; Xiaomi; HM 1SW; armani; qcom; en_US)"'

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;93m Logging in as\e[0m\e[1;92m %s\e[0m\e[1;93m ...\e[0m\n" $user
printf "\n"
IFS=$'\n'
var=$(curl -c .cookie.$user -d "ig_sig_key_version=4&signed_body=$hmac.$data" -s --user-agent "$useragent" -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/accounts/login/" | grep -o "logged_in_user\|challenge\|many tries\|Please wait" | uniq ); 

if [[ $var == "challenge" ]]; then 
    printf " \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\e[1;93m IP Blocked \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\n" 
    exit 1; 
elif [[ $var == "logged_in_user" ]]; then 
    printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;92m Successfully Logged in!\e[0m\n" 
elif [[ $var == "Please wait" ]]; then 
    echo " Please wait"; 
fi 

fi

}


followers_info() {

user_id=$(curl -L -s 'https://www.instagram.com/'$user_account'' > .getid && grep -o  'profilePage_[0-9]*.' .getid | cut -d "_" -f2 | tr -d '"')

curl -L -b .cookie.$user -s --user-agent "$useragent" -w "\n%{http_code}\n" -H "$header" "https://i.instagram.com/api/v1/friendships/$user_id/followers" > $user_account.followers.temp

cp $user_account.followers.temp $user_account.followers.00
count=0

while [[ true ]]; do
big_list=$(grep -o '"big_list": true' $user_account.followers.temp)
maxid=$(grep -o '"next_max_id": "[^ ]*.' $user_account.followers.temp | cut -d " " -f2 | tr -d '"' | tr -d ',')

if [[ $big_list == *'big_list": true'* ]]; then
url="https://i.instagram.com/api/v1/friendships/$user_id/followers/?rank_token=$user_id\_$guid&max_id=$maxid"

curl -L -b .cookie.$user -s --user-agent "$useragent" -H "$header" "$url" > $user_account.followers.temp

cp $user_account.followers.temp $user_account.followers.$count

unset maxid
unset url
unset big_list
else
grep -o 'username": "[^ ]*.' $user_account.followers.* | cut -d " " -f2 | tr -d '"' | tr -d ',' | sort > $user_account.followers_temp
mkdir core
cat $user_account.followers_temp | uniq > core/$user_account.followers_list.txt
rm -rf $user_account.followers_temp

tot_followers=$(wc -l core/$user_account.followers_list.txt | cut -d " " -f1)
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m You have\e[0m\e[92m %s\e[0m\e[1;96m followers.\e[0m\n" $tot_followers
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Followers List Saved at :\e[0m\e[1;92m core/%s.followers_list.txt\e[0m\n" $user_account
printf "\n"

if [[ ! -d .$user_account/raw_followers/ ]]; then
mkdir -p .$user_account/raw_followers/
fi
cat $user_account.followers.* > .$user_account/raw_followers/backup.followers.txt
rm -rf $user_account.followers.*

break

fi
echo $count
let count+=1

done
}


menu() {

printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m01\e[0m\e[1;96m]\e[0m\e[1;93m Get Followers List\e[0m\n"
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m02\e[0m\e[1;96m]\e[0m\e[1;93m Activate Unfollower\e[0m\n"
printf "\n"
printf " \e[1;96m[\e[0m\e[1;97m03\e[0m\e[1;96m]\e[0m\e[1;93m More Tools from Us\e[0m\n"
printf "\n"

read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Choose an Option\e[1;96m : \e[0m\e[1;92m' option
printf "\n"

if [[ $option == 1 || $option == 01 ]]; then
user_login
default_user=$user

printf "\n"
read -p $' \e[1;96m[\e[0m\e[1;97m+\e[0m\e[1;96m]\e[0m\e[1;96m Account \e[0m\e[1;93m(Leave blank for Current acc): \e[0m\e[1;92m' user_account

user_account="${user_account:-${default_user}}"
followers_info

elif [[ $option == 2 || $option == 02 ]]; then
user_login
bot

elif [[ $option == 3 || $option == 03 ]]; then
xdg-open https://github.com/htr-tech/
sleep 2
exit 1

else
printf "\n"
printf " \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\e[1;93m Invalid Option \e[1;96m[\e[0m\e[1;91m!\e[0m\e[1;96m]\e[0m\n"
sleep 2
menu

fi
}

banner
menu
