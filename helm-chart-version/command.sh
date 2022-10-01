#!/bin/bash

# Exit if any of the intermediate steps fail
# set -e

read -d EOF
app_version=$(echo "$REPLY" | jq -r .app_version)
chart_version=$(echo "$REPLY" | jq -r .chart_version)

if [[ -z "$chart_version" ]]
then
    echo "Missing chart_version" >&2
    exit 3
fi

if [[ -z "$app_version" ]]
then
    new_version="$chart_version"
else
    new_version="$chart_version.$app_version"
    sed -i "s/^appVersion:.*$/appVersion: \"$app_version\"/" Chart.yaml
fi


sed -i "s/^version:.*$/version: \"$new_version\"/" Chart.yaml

jq -n --arg version "$new_version" '{"version":$version}'