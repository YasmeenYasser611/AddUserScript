#!/bin/bash

# Check if a string argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <string_to_encrypt>"
    exit 1
fi

# The input string
input_string="$1"

# Hash the string using sha256
encrypted_string=$(echo -n "$input_string" | sha256sum | awk '{print $1}')

# Write the encrypted string to a file
output_file="hashed_output.txt"
echo "$encrypted_string" > "$output_file"

# Notify the user
echo "The SHA256 hash of the input string has been saved to $output_file."

