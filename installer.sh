#!/usr/bin/env bash
#
# @author     Leon Kiefer
# @date       16.11.2022#

read -p "Do you want to update your packages before proceeding? [Y/n] " -r res
echo

if [[ $res == "" || $res == "y" || $res == "Y" ]]; then
  # sudo apt update
  # sudo apt upgrade -y
  # sudo apt autoremove -y
  echo "Hello World"
elif [[ $res == "n" ]]; then
  echo "Proceed without updating packages"
else
  echo "Error: faulty input"
fi

# if [ "$(dpkg-query -W -f='${Status}' xclip 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
#   echo 'xclip not installed .... installing now!'
#   sudo apt install xclip -y
# fi