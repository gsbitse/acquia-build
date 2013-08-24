#!/bin/sh

############################################
# run update.php on the site
#

echo "start of build_prod.sh on acquia: server = $1 rebuild = $2"

##########################################################
# get the password and account email
#

cd ~/build

read -r PASSWORD < settings/password.txt
read -r ACCTEMAIL < settings/email.txt

echo "account email: $ACCTEMAIL"

##########################################################
# change to the docroot directory
#

build_dir="/mnt/gfs/home/gsbpublic/build/bin/acquia-build"

cd /mnt/www/html/gsbpublic/docroot
site_url="http://gsbpublic.prod.acquia-sites.com/"

pwd

##########################################################
# save the docroot directory
#

docroot_dir=$PWD

##########################################################
# sleep for 2 minutes to give time for the pushed code to appear.
echo "Sleeping for 2 minutes to give time for the code to appear."
sleep 120

##########################################################
# run update.php
#

#cd ${docroot_dir}
#ret_code=$(drush updb -y)
#echo "drush updb ret_code = $ret_code"

##########################################################
# do feature revert
#

#if test $2 != "true"
#then
#  cd ${docroot_dir}
#  ret_code=$(drush eval "features_revert();")
#  echo "drush features_revert ret_code = $ret_code"
#fi

echo "end of build_prod.sh on acquia"

return 0

##########################################################
# end of build script
#
