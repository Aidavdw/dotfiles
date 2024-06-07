#!/bin/sh

execCommand=$1
className=$2
workspaceOnStart=$3

running=$(hyprctl -j clients | jq -r ".[] | select(.class == \"${className}\") | .workspace.id")
echo $running

if [[ $running != "" ]]
then
	echo "focus"
	hyprctl dispatch workspace $running    
else 
	echo "start"
	hyprctl dispatch workspace $workspaceOnStart 
	${execCommand} & 
fi
