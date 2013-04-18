#!/bin/sh

############################################
# run update.php on the site
#

echo "start of build.sh on acquia: server = $1 rebuild = $2"

read -r PASSWORD < ../../settings/password.txt

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

#ret_code=$(drush updatedb --backend)

ret_code=0

if test $2 = "true"
then
  ret_code=$(drush si -y --site-name="gsbpublic" --account-pass="$PASSWORD" --acount-mail="gmercer@stanford.edu" gsb_public)
  echo "drush si ret_code = $ret_code"
  ret_code=$(drush scr --yes ~/build/bin/acquia-build/after_build.php)
  echo "product sub ret_code = $ret_code"
fi

if test $2 != "true"
then
  ret_code=$(drush updb -y)
  echo "drush updb ret_code = $ret_code"
fi

echo "end of build.sh on acquia"

return 0

############################################
# end of build script


