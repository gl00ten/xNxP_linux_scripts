#!/usr/bin/env bash

# Don't run the whole thing with sudo (some installs expect user). Enter sudo password when prompted.
# Historical post-install for Debian/Ubuntu (2018-era package list; many bits are outdated).
########################################################
# Run this after a fresh Debian/Ubuntu install.
########################################################

sudo apt-get update
#sudo apt-get install -y ntp #no longer neccessary? #TODO check
sudo apt-get dist-upgrade -y --fix-missing --fix-broken --purge
##Languages https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
sudo apt-get install -y language-pack-pt language-pack-fr language-pack-zh-hans language-pack-zh-hant language-pack-ja language-pack-en
sudo apt-get install -y $(check-language-support)
##Standard stuff everyone should have
sudo apt-get install -y apt curl wget apt-transport-https dirmngr
sudo apt-get install -y build-essential git
#Stuff nice for machine work
sudo apt-get install -y ssh nano lynis glances ncdu synaptic preload fail2ban
##Extra stuff
sudo apt-get install -y steam hexchat workrave
#sudo apt-get install -y intel-microcode # if not intel disable this!!

##Python and java
sudo apt-get install -y python3 idle3 default-jdk default-jre

##Sublime3 : https://www.sublimetext.com/docs/3/linux_repositories.html
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install -y sublime-text
##Keybase https://keybase.io/docs/the_app/install_linux
if [ ! -f ./keybase_amd64.deb ]; then
  curl -O https://prerelease.keybase.io/keybase_amd64.deb
  # if you see an error about missing `libappindicator1`
  # from the next command, you can ignore it, as the
  # subsequent command corrects it
  sudo dpkg -i keybase_amd64.deb
  sudo apt-get install -y -f
  run_keybase
fi

##### node.js
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

curl https://install.meteor.com/ | sh

###haskell

sudo apt-get install -y haskell-platform

##Erase old downloaded archive files
sudo apt-get autoclean -y
##Remove automatically all unused packages
sudo apt-get autoremove -y --purge
##Reboot
#sudo reboot

##TODO
# activate all repositories
# add repositories if needed
# see if that website has an api of sortes
# dist-update
# install fonts and other media ubuntu shtuff like restricted extras
# install more shtuff (skype etc, make a list)

