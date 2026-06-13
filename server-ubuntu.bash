#!/usr/bin/env bash
# Debian/Ubuntu server bootstrap notes (run commands manually or adapt).
# Not a fully automated script.

sudo apt-get update
#sudo apt install ntp -y 
sudo apt-get dist-upgrade -y

sudo apt install build-essential -y 
sudo apt install curl wget apt-transport-https dirmngr -y
sudo apt install fail2ban -y
sudo apt install sudo -y
sudo apt install  ssh -y

sudo apt-get autoremove --purge -y
sudo apt-get autoclean 

#useradd -m -d /home/ssarah ssarah
#addgroup ssarah sudo

#create user
#change password access
#change root password


#ssh config
#remove root login
#remove ssh access through password




#apt install ufw
#allow http https ssh different port
