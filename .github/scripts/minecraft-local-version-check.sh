#!/bin/bash

_folder=${1:-'minecraft-01'}

sudo cat /home/minecraft/deployed/$_folder/logs/latest.log | grep net.minecraftforge.fml.VersionChecker/ | grep 'Found status:'
