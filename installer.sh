#!/usr/bin/env bash
#
# @author     Leon Kiefer
# @date       16.11.2022#

read -p "Do you want to update your packages before proceeding? [Y/n] " -r res

if [[ $res == "" || $res == "y" || $res == "Y" ]]; then
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
elif [[ $res == "n" ]]; then
  echo "Proceed without updating packages"
else
  echo "Error: faulty input"
fi

if [ "$(dpkg-query -W -f='${Status}' xclip 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
  echo 'xclip not installed .... installing now!'
  sudo apt install xclip -y
fi

echo "adding alias to ~/.bashrc"
echo "# pbcopy & pbpaste alias" >> ~/.bashrc
echo "alias pbcopy='xclip -sel clip'" >> ~/.bashrc
echo "alias pbpaste='xclip -sel clip -o'" >> ~/.bashrc

source ~/.bashrc