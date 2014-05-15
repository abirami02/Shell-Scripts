#!/bin/sh

domain=$1
SVN_TAG=$2
customer="Instaapp"
SVN_URL="https://somashekar@svn/repos/tags/certified"

cd /Users/abirami/Documents/ios_build/tagBuilds

## Checking for iOS or Android
if [ $domain == iOS ];
then
    cd $domain
else
    cd $domain
fi
## Checking for SVN Tag and SVN check out
if [ -d "$SVN_TAG" ]; then
#      rm -rf $SVN_TAG
#      mkdir $SVN_TAG
   cd $SVN_TAG/$SVN_TAG
echo "***************[JOB STAGE] SVN Update is INPROGRESS *******************"   
svn cleanup
svn update
echo "SVN update completed." 
else
   mkdir $SVN_TAG
   cd $SVN_TAG
echo "***************[JOB STAGE] SVN Tag Check out is INPROGRESS *******************"
   svn co https://somashekar@svn/repos/tags/certified/$domain/$SVN_TAG
echo "SVN Check out completed."
fi

if [ $domain == iOS ];
then
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/buildLib.sh $domain $SVN_TAG
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/build.sh
else
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/android_build.sh $customer $domain $SVN_TAG
fi

