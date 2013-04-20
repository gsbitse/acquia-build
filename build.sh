#!/bin/sh

############################################
# run update.php on the site
#

echo "start of build.sh on acquia: server = $1 rebuild = $2"

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

if test $1 = "dev"
then
  cd /mnt/www/html/gsbpublicdev/docroot
fi

if test $1 = "dev2"
then
  cd /mnt/www/html/gsbpublicdev2/docroot
fi

if test $1 = "stage"
then
  cd /mnt/www/html/gsbpublictest/docroot
fi

if test $1 = "stage2"
then
  cd /mnt/www/html/gsbpublicstg2/docroot
fi

if test $1 = "sandbox"
then
  cd /mnt/www/html/gsbpublicsand/docroot
fi

if test $1 = "loadtest"
then
  cd /mnt/www/html/gsbpubliclt/docroot
fi

if test $1 = "prod"
then
  cd /mnt/www/html/gsbpublic/docroot
fi

pwd

##########################################################
# save the docroot directory
#

docroot_dir=$PWD

##########################################################
# run drush site install and script (after the install) 
#

ret_code=0

if test $2 = "true"
then
  ret_code=$(drush si -y --site-name="gsbpublic" --account-pass="$PASSWORD" --acount-mail="$ACCTEMAIL" gsb_public)
  echo "drush si ret_code = $ret_code"
  ret_code=$(drush scr --yes $build_dir/after_build.php)
  echo "product sub ret_code = $ret_code"
fi

##########################################################
# run drush script to clear apc
#

# ret_code=$(drush scr --yes $build_dir/apc_clear.php)
ret_code=$(drush cc apc)
echo "apc cache cleared"


##########################################################
# save the docroot directory
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush updb -y)
  echo "drush updb ret_code = $ret_code"
fi

echo "end of build.sh on acquia"

return 0

##########################################################
# end of build script
#

