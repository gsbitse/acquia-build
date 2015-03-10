#!/bin/sh

############################################
# run update.php on the site
#

echo "start of build.sh on acquia: server = $1"

##########################################################
# get the password and account email
#

# Check to see if the code update finished before continuing.
echo "Waiting for the git repository to be updated."
COUNT=0;
while [ ! -f "~/update-finished.txt" ]; # true if /your/file does not exist
do
  sleep 1
  COUNT=$((COUNT+1))
  if [ $COUNT = 120 ]; then
    echo "It seemed to take too long to update the git files."
    exit 1
  fi
done

rm -f ~/update-finished.txt

cd ~/build

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
  cd /mnt/www/html/gsbpublicstg/docroot
fi

if test $1 = "stage2"
then
  cd /mnt/www/html/gsbpublicstg2/docroot
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

##########################################################
# run updates
#

cd ${docroot_dir}
ret_code=$(drush5 updb -y)
echo "drush5 updb ret_code = $ret_code"

##########################################################
# do feature revert
#

cd ${docroot_dir}
ret_code=$(drush5 fra -y)
echo "drush5 features_revert ret_code = $ret_code"


##########################################################
# Set our google analytics account for stage.
#

cd ${docroot_dir}
ret_code=$(drush5 vset -y 'googleanalytics_account' 'UA-17436788-1')
echo "drush5 vset -y 'googleanalytics_account' 'UA-17436788-1' = $ret_code"


##########################################################
# Set the faculty profile webservice url.
#

cd ${docroot_dir}
ret_code=$(drush5 vset -y 'gsb_feature_faculty_ct_service_url' 'https://gsbapps-qa.stanford.edu/utilitywebservice/global/UtilityWebservice.asmx')
echo "drush5 vset -y 'gsb_feature_faculty_ct_service_url' 'https://gsbapps-qa.stanford.edu/utilitywebservice/global/UtilityWebservice.asmx' = $ret_code"

##########################################################
# Enable development modules
#

cd ${docroot_dir}
ret_code=$(drush5 en -y devel)
echo "drush5 en -y devel = $ret_code"
ret_code=$(drush5 vd)
echo "drush5 vd = $ret_code"

##########################################################
# do a clear cache all
#

cd ${docroot_dir}
ret_code=$(drush5 cc all)
echo "drush5 cc all ret_code = $ret_code"


echo "end of build.sh on acquia"

return 0

##########################################################
# end of build script
#
