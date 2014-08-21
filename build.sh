#!/bin/sh

############################################
# run update.php on the site
#

echo "start of build.sh on acquia: server = $1 rebuild = $2"

##########################################################
# get the password and account email
#

# Check to see if the code update finished before continuing.
echo "Waiting for the git repository to be updated."
COUNT=0;
while [ ! -f "update-finished.txt" ]; # true if /your/file does not exist
do
  sleep 1
  COUNT=$((COUNT+1))
  if [ $COUNT = 120 ]; then
    echo "It seemed to take too long to update the git files."
    exit 1
  fi
done

rm update-finished.txt

cd ~/build


### OLD ###
#read -r PASSWORD < settings/password.txt
#read -r ACCTEMAIL < settings/email.txt

PASSWORD=blah
ACCTEMAIL=blah@example.com

echo "account email: $ACCTEMAIL"

##########################################################
# change to the docroot directory
#

build_dir="/mnt/gfs/home/gsbpublic/build/bin/acquia-build"

if test $1 = "dev"
then
  cd /mnt/www/html/gsbpublicdev/docroot
  site_url="http://gsbpublicdev.prod.acquia-sites.com/"
fi

if test $1 = "dev2"
then
  cd /mnt/www/html/gsbpublicdev2/docroot
  site_url="http://gsbpublicdev2.prod.acquia-sites.com/"
fi

if test $1 = "stage"
then
  cd /mnt/www/html/gsbpublicstg/docroot
  site_url="http://gsbpublicstg.prod.acquia-sites.com/"
fi

if test $1 = "stage2"
then
  cd /mnt/www/html/gsbpublicstg2/docroot
  site_url="http://gsbpublicstg2.prod.acquia-sites.com/"
fi

pwd

##########################################################
# save the docroot directory
#

docroot_dir=$PWD

##########################################################
# sleep for 2 minutes to give time for the pushed code to appear.
#echo "Sleeping for 2 minutes to give time for the code to appear."
#sleep 120

##########################################################
# run drush site install and script (after the install) 
#

ret_code=0

if test $2 = "true"
then
  ret_code=$(drush5 si -y --site-name="gsbpublic" --account-pass="$PASSWORD" --account-mail="$ACCTEMAIL" gsb_public)
  echo "drush5 si ret_code = $ret_code"
fi

##########################################################
# save the docroot directory
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 updb -y)
  echo "drush5 updb ret_code = $ret_code"
fi

##########################################################
# do feature revert
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 fra -y)
  echo "drush5 features_revert ret_code = $ret_code"
fi

##########################################################
# Set our google analytics account for stage.
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 vset -y 'googleanalytics_account' 'UA-17436788-1')
  echo "drush5 vset -y 'googleanalytics_account' 'UA-17436788-1' = $ret_code"
fi

##########################################################
# Set the faculty profile webservice url.
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 vset -y 'gsb_feature_faculty_ct_service_url' 'https://gsbapps-qa.stanford.edu/utilitywebservice/global/UtilityWebservice.asmx')
  echo "drush5 vset -y 'gsb_feature_faculty_ct_service_url' 'https://gsbapps-qa.stanford.edu/utilitywebservice/global/UtilityWebservice.asmx' = $ret_code"
fi

##########################################################
# Enable development modules
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 en -y devel)
  echo "drush5 en -y devel = $ret_code"
  ret_code=$(drush5 vd)
  echo "drush5 vd = $ret_code"
fi

##########################################################
# do a clear cache all
#

if test $2 != "true"
then
  cd ${docroot_dir}
  ret_code=$(drush5 cc all)
  echo "drush5 cc all ret_code = $ret_code"
fi


echo "end of build.sh on acquia"

return 0

##########################################################
# end of build script
#

