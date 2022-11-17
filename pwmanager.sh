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

function help {
  echo "Hello World"
}

function get_pw {
  echo "Hello World"
}

function decrypt_pw_db {
  echo "Hello World"
}

function save_pw {
  echo "Hello World"
}

function delete_pw {
  echo "Hello World"
}

help

get_pw

decrypt_pw_db

save_pw

delete_pw
