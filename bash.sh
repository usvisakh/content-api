#!/bin/bash -x


current_version="1.0"
increment=0.1

# Split the version into major and minor components
IFS='.' read -ra version_parts <<< "$current_version"
major="${version_parts[0]}"
minor="${version_parts[1]}"

# Convert the minor version to a floating-point number
minor_float=$(echo "scale=1; $minor + $increment" | bc)

# Update the version components based on the increment
if (( $(echo "$minor_float > 9.9" | bc -l) )); then
  major=$((major + 1))
  minor_float=0.0
fi

# Combine the updated version components
new_version="$major.$minor_float"

echo "New version: $new_version"


