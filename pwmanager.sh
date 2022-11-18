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
  echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  echo "pwmanager -k KEY [-d pw_db] [-f PUBLIC_KEY] [-l PW_LENGTH] [-p PASSWORD] [-m MODE]"
  echo "    -k: password identifier key (required)"
  echo "    -d: encrypted password database file (optional)"
  echo "    -f: gpg public key (optional)"
  echo "    -l: password length (optional)"
  echo "    -p: user provided password (required for add mode)"
  echo "    -m: mode: create (default), read, update, delete"
  exit
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
  local pw_db=$1
  local pubkey=$2
  local tmp_db

  tmp_db=$(mktemp /tmp/tmp/.XXXXXXXXXXXXXXXXXXXXX)

  chmod 600 $tmp_db

  gpg --quiet --recipient-file $pubkey --decrypt $pw_db > $tmp_tmp_db

  echo $tmp_db
}

save_pw() {
  local id=$1
  local pw=$2
  local pw_db=$3
  local pubkey=$4

  local tmp_db=$(decrypt_pw_db $pw_db $pubkey)

  if [ "$(get_password $id $pw_db $pubkey)" ]; then
    echo "Password with $id already exists."
    rm $tmp_db
    exit 1
  fi

  echo "$id,$pw" >> tmp_db

  gpg --yes --recipient-file $pubkey --output $pw_db --encrypt $tmp_db

  rm $tmp_db
}

delete_pw() {
  local id=$1
  local pw_db=$2
  local pubkey=$3

  local tmp_db=$(decrypt_pw_db $pw_db $pubkey)

  sed "/^$id,/d" $tmp_db | gpg --yes --recipient-file $pubkey --output $pw_db --encrypt

  rm $tmp_db
}

while getopts k:p:f:l:m: pm_opts 2>/dev/null; do
  case $pm_opts in
    k) id=$OPTARG
      ;;
    d) pw_db=$OPTARG
      ;;
    f) pubkey=$OPTARG
      ;;
    l) pw_length=$OPTARG
      ;;
    m) crud=$OPTARG
      ;;
    p) pw=$OPTARG
      ;;
    ?) help
  esac
done

if [ -z "$id" ]; then
  help
fi

if [ ! -e $pubkey ]; then
  echo "Public key $pubkey does not exist!"
  read -p "Do you want to create a new key in this location? [Y/n] " -r res

  if [[ $res == "" || $res == "y" || $res == "Y" ]]; then
    fingerprint=$(gpg --full-generate-key | grep -m 1 -o "[A-Z0-9]\{40\}")

    gpg --armor --export $fingerprint > $pubkey

    chmod 600 $pubkey
  else
    exit
  fi
fi

if [ ! -e $pw_db ]; then
  echo "Encrypted password database $pw_db does not exist!"
  read -p "Do you want to create a new database in this location? [Y/n] " -r res

  if [[ $res == "" || $res == "y" || $res == "Y" ]]; then
    echo "" | gpg --recipient-file $pubkey --output $pw_db --encrypt
    chmod 600 $pw_db
  else
    exit
  fi
fi

case "$crud" in
  create)
    pw=$(pwgen -s -1 $pw_length)
    save_pw $id $pw $pw_db $pubkey
    echo $pw | xclip -sel clip
    ;;
  read)
    get_pw $id $pw_db $pubkey
    ;;
  update)
    save_pw $id $pw $pw_db $pubkey
    ;;
  delete)
    delete_pw $id $pw_db $pubkey
    ;;
esac