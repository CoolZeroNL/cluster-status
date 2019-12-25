#!/bin/bash

cat latest.log | grep net.minecraftforge.fml.VersionChecker/ | grep 'Found status:'
