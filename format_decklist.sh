#!/bin/bash

# These commands will PERMANENTLY AND WITHOUT WARNING modify the input file
sed -i '/^[^0-9]/d' "$1" # Remove lines that don't begin with a number
sed -i '/^\s*$/d' "$1" # Remove empty lines
sed -i 's/\r$//g' "$1" # Remove trailing carriage returns