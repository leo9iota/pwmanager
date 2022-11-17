#!/usr/bin/env bash
#
# @author     Leon Kiefer
# @date       16.11.2022

user_home=$(eval echo ~$USERNAME)

pw_db="$user_home/.pwmanager_db"

pubkey="$user_home/.pwmanager_pubkey"

crud="create"

pw_length=69

pw=

id=

help() {
  echo '________  _  _______ _____    ____ _____     ____   ___________ '
  echo '\____ \ \/ \/ /     \\__  \  /    \\__  \   / ___\_/ __ \_  __ \'
  echo '|  |_> >     /  Y Y  \/ __ \|   |  \/ __ \_/ /_/  >  ___/|  | \/'
  echo '|   __/ \/\_/|__|_|  (____  /___|  (____  /\___  / \___  >__|   '
  echo '|__|               \/     \/     \/     \//_____/      \/       '
}

get_pw() {
  local id=$1
  local pw_db=$2
  local pubkey=$3

  local tmp_db=$(decrypt_pw_db $pw_db $pubkey)

  local pw=$(awk -F"^$id," '{printf $2}' $tmp_db)

  [ $pw ] && echo $pw

  rm $tmp_db
}

decrypt_pw_db() {
  echo "Hello World"
}

save_pw() {
  echo "Hello World"
}

delete_pw() {
  echo "Hello World"
}

help

get_pw

decrypt_pw_db

save_pw

delete_pw
