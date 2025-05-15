#!/bin/bash

usage() {
  echo "Usage:"
  echo "  Encrypt: $0 -e -i input_file -o output_file"
  echo "  Decrypt: $0 -d -i input_file -o output_file"
  exit 1
}

# Parse options
while getopts ":edi:o:" opt; do
  case $opt in
  e) MODE="encrypt" ;;
  d) MODE="decrypt" ;;
  i) INPUT="$OPTARG" ;;
  o) OUTPUT="$OPTARG" ;;
  *) usage ;;
  esac
done

# Check required parameters
if [[ -z "$MODE" || -z "$INPUT" || -z "$OUTPUT" ]]; then
  usage
fi

# Prompt for password securely
read -s -p "Enter password: " PASSWORD
echo
read -s -p "Confirm password: " CONFIRM
echo

if [[ "$PASSWORD" != "$CONFIRM" ]]; then
  echo "Passwords do not match."
  exit 1
fi

# Use OpenSSL with PBKDF2 for key derivation and AES-256 encryption
if [[ "$MODE" == "encrypt" ]]; then
  openssl enc -aes-256-cbc -salt -pbkdf2 -in "$INPUT" -out "$OUTPUT" -pass pass:"$PASSWORD"
  [[ $? -eq 0 ]] && echo "Encrypted successfully: $OUTPUT" || echo "Encryption failed."

elif [[ "$MODE" == "decrypt" ]]; then
  openssl enc -d -aes-256-cbc -pbkdf2 -in "$INPUT" -out "$OUTPUT" -pass pass:"$PASSWORD"
  [[ $? -eq 0 ]] && echo "Decrypted successfully: $OUTPUT" || echo "Decryption failed."
fi
