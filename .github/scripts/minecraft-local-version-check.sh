#!/bin/bash

_folder=${1:-'minecraft-01'}

currentt=`sudo cat /home/minecraft/deployed/$_folder/logs/latest.log | grep net.minecraftforge.fml.VersionChecker/ | grep 'Found status:'  | awk -F': ' '{print $4}' | awk -F' ' '{print $1}'`
target=`sudo cat /home/minecraft/deployed/$_folder/logs/latest.log | grep net.minecraftforge.fml.VersionChecker/ | grep 'Found status:'  | awk -F': ' '{print $5}'`
