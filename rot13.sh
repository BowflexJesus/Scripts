#!/bin/bash

# filename: rot13.sh
# author: Matthew Darby
# description: A simple bash script that can encrypt or decrypt a file using a
# ROT13 substitution cipher. The encryption/decryption method is the same for
# both, using tr https://www.geeksforgeeks.org/tr-command-unixlinux-examples/
#
# example usage:
# ./rot13.sh <input file>
#
# user@pc:~$./rot13.sh data.txt
# Do you want to encrypt or decrypt the file?
# Choose [E]ncrypt or [D]ecrypt: e
# The password is 5Te8Y4drgCRfCx8ugdwuEX8KFC6k2EUu
#

fileLines=`cat $1`  # Holds the raw contents of the file
shouldLoop=true  # A bool that is used to determine valid user input

# Ask the user whether to encrypt of decrypt
echo Do you want to encrypt or decrypt the file?

while $shouldLoop
do
    # Read the user's answer (case insensitive)
    read -p "Choose [E]ncrypt or [D]ecrypt:" ans
    shouldLoop=false
    # Encrypt
    if [ $ans == 'E' ] || [ $ans == 'e' ]
    then
        echo Encrypting your file...
        echo $fileLines | tr 'A-Za-z' 'N-ZA-Mn-za-m'
    # Decrypt
    elif [ $ans == 'D' ] || [ $ans == 'd' ]
    then
        echo Decrypting your file...
        echo $fileLines | tr 'A-Za-z' 'N-ZA-Mn-za-m'
    # User entered an invalid answer so we loop again
    else
        echo Invalid selection: Try again
        shouldLoop=true
    fi
done
