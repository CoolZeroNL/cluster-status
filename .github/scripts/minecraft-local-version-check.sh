#!/bin/bash

folder='minecraft-00'

sudo cat /home/minecraft/deployed/$_folder/logs/latest.log | grep net.minecraftforge.fml.VersionChecker/ | grep 'Found status:'
