#!/bin/bash

# Specify the path to the .gitmodules file
gitmodules_file=".gitmodules"

# Check if the file exists
if [ -f "$gitmodules_file" ]; then
  # Read each line from the file
  while IFS= read -r line; do
    if [[ $line == \[submodule* ]]; then
      # Extract submodule path
      path=$(echo $line | awk -F '"' '{print $2}')
      # Read the next line for the URL
      IFS= read -r url
      IFS= read -r url
      url=$(echo $url | awk -F '=' '{print $2}' | tr -d ' ')
      
      # Check if submodule path exists
      if [ -d "$path" ]; then
        echo "Updating submodule at path: $path"
        git submodule update --init --remote -- "$path"
      else
        echo "Adding submodule at path: $path"
        echo "URL: $url"
        git submodule add $url "$path"
      fi
    fi
  done < "$gitmodules_file"
else
  echo "Error: $gitmodules_file not found."
fi
