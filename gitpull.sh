#!/bin/sh

#####################################################
# run git pull to update the files in acquia-build
#

echo "running git pull to update acquia-build"
cd ~/build/bin/acquia-build
pwd
git pull
echo "end of git pull to update acquia-build"
