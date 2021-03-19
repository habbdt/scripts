#!/bin/bash

###################readme#############
# check specific cipher suite support
######################################

# error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions

# user input
INPUT_FILE=${1}
CIPHER=${2:-3DES}

# input validation
if [ "$#" -ne 1 ]
then
    echo "Usage: 3des_cipher_checker.sh <input_file_hostname_ip> <cipher>"
    echo "input_file: list of the hostname or ip address"
    echo "cipher: check support for specific support is enabled"
    exit
fi

# check if sslscan is installed or not

if ! [ -x "$(command -v sslscan)" ]; then
  echo 'Error: sslscan is not installed.' >&2
  exit 1
fi

function cipher_scanner() {
  while IFS= read -r line; do
      SSL_SCAN="$(sslscan --no-renegotiation --no-heartbleed --no-fallback --no-groups \
                  --no-compression --tlsall --no-cipher-details \
                  $line | egrep '(TLS)' | grep $CIPHER)"

      if [ -z "$SSL_SCAN" ]
      then
        echo "[x] $line not vulnerable"
      else
        echo "[!] $line vulnerable to 3DES"
      fi
  done < <(cat $INPUT_FILE)
}

# run
cipher_scanner