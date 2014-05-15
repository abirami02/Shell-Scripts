#!/bin/sh

# **** This script will generate Genwi Android library application with dynamic netid ****

echo "**************[JOB STAGE] BUILDING ANDROID PROJECT **************** "

customerName=$1
appName="$2"
netid=$3
bundleId=$4
sourcePath=$5
bundleVersionShortString=$6
bundleVersion=$7
releaseType=$8

deeplinkName=gw$netid

echo "$deeplinkName"

custFolder="/Users/abirami/Documents/repos/Customers"

PUB_BUILDS="/Users/abirami/Documents/publishedBuilds/androidBuilds"

if [ -d "$sourcePath/Customers/$customerName" ]; then
    PRJ_DIR="$sourcePath/AndroidFramework"
else
    PRJ_DIR="$sourcePath/AndroidFramework"
fi

SDK_DIR="$PRJ_DIR"	
cd $PRJ_DIR

echo "### Android Framework building"

cp $PRJ_DIR/AndroidManifest.xml $sourcePath/AppSDKs/Buildscripts/

    if [ "$inappBilling" == "Yes" ]
    then
        echo "*************[JOB STAGE] MODIFYING ANDROID MANIFEST FILE FOR INAPP PURCHASE ************* "
        ant -file $sourcePath/AppSDKs/Buildscripts/build.xml inappbilling
    fi
    echo "*************[JOB STAGE] MODIFYING ANDROID MANIFEST FILE FOR NET ID ************* "
    echo $netid
    
    if [ "$netid" == "none" ] 
    then
	echo "netid :" $netid
 	ant -file $sourcePath/AppSDKs/Buildscripts/build.xml customize -Dnetid="" -DbundleId="com.genwi.instaapp" -DappName="$appName" -DbundleVersionShortString="$bundleVersionShortString" -DbundleVersion="$bundleVersion" -DdeeplinkName="$deeplinkName"
    else 
       ant -file $sourcePath/AppSDKs/Buildscripts/build.xml customize -Dnetid=$netid -DbundleId="com.genwi.instaapp" -DappName="$appName" -DbundleVersionShortString="$bundleVersionShortString" -DbundleVersion="$bundleVersion" -DdeeplinkName="$deeplinkName"

    fi

cp -R $sourcePath/AppSDKs/Buildscripts/AndroidManifest.xml $PRJ_DIR/

cd $custFolder/"$customerName"/

if [ -d 'Android' ]; then
echo "*************[JOB STAGE]COPYING THE CUSTOMER ASSETS ************* "
    rm -rf "${SDK_DIR}"/res/drawable-land/*
    rm -rf "${SDK_DIR}"/res/drawable-land-hdpi/*
    rm -rf "${SDK_DIR}"/res/drawable-land-xhdpi/*
    rm -rf "${SDK_DIR}"/res/drawable-port-hdpi/*
    rm -rf "${SDK_DIR}"/res/drawable-port-xhdpi/*

    cp -Rf $custFolder/"$customerName"/Android/drawable/default_launcher.png "${SDK_DIR}"/res/drawable/
    cp -Rf $custFolder/"$customerName"/Android/drawable/launcher.png "${SDK_DIR}"/res/drawable/
    cp -Rf $custFolder/"$customerName"/Android/drawable-land/* "${SDK_DIR}"/res/drawable-land/
    cp -Rf $custFolder/"$customerName"/Android/drawable-land-hdpi/* "${SDK_DIR}"/res/drawable-land-hdpi/
    cp -Rf $custFolder/"$customerName"/Android/drawable-land-xhdpi/* "${SDK_DIR}"/res/drawable-land-xhdpi/
    cp -Rf $custFolder/"$customerName"/Android/drawable-port-hdpi/* "${SDK_DIR}"/res/drawable-port-hdpi/
    cp -Rf $custFolder/"$customerName"/Android/drawable-port-xhdpi/ "${SDK_DIR}"/res/drawable-port-xhdpi/
fi

if [ -d $custFolder/"$customerName"/Android/'Keystore' ]; then
echo "*************[JOB STAGE]COPYING THE CUSTOMER KEYSTORE ************* "
echo "$PRJ_DIR"
    rm -rf "$PRJ_DIR"/gradle.properties
    cp -Rf $custFolder/"$customerName"/Android/Keystore/*.keystore "$PRJ_DIR"/.
    cp -Rf $custFolder/"$customerName"/Android/Keystore/project.properties "$PRJ_DIR"/gradle.properties
    echo "copied"
    
else 
echo "*************[JOB STAGE]COPYING THE DEFAULT KEYSTORE ************* "
    cp -rf $custFolder/InstaApp/Android/Keystore/ "$sourcePath/AndroidFramework"/
fi

cd $PRJ_DIR/

echo "**************[JOB STAGE] BUILDING THE PACKAGE USING GRADLE **************** "

gradle assemble -PpackageName=$bundleId -PversionCode=$bundleVersion -PversionName=$bundleVersionShortString >> gradle.out



cd $PRJ_DIR/build/apk
if [ $releaseType == "Development" ] && [ -f "AndroidFramework-debug-unaligned.apk" ]; then
    mv AndroidFramework-debug-unaligned.apk dev-"$appName".apk
    echo "**************[JOB STAGE] APK FILE GENERATED **************** "
    cd ..

elif [ $releaseType == "Distribution" ] && [ -f "AndroidFramework-release.apk" ]; then
    mv AndroidFramework-release.apk "$appName".apk
    echo "**************[JOB STAGE] APK FILE GENERATED **************** "
    cd ..
fi

echo "**************[JOB STAGE] BUILD SUCCESSFUL **************** "
cd ..

cd $PUB_BUILDS
Today=$(date +%m%d%y-%T)
mkdir $Today
cp $PRJ_DIR/build/apk/*"$appName".apk $PUB_BUILDS/$Today

#echo "Published Android build is Available at"
#echo `pwd`


cd $PUB_BUILDS/$Today

size=$(ls -alert *.apk | awk '{ print $5}')
if [ $size -gt "3000000" ]; then
    echo "**************[JOB STAGE] APK IS MORE THAN 3MB, EXITING **************** "
    echo $size
#exit 1
else
    echo "**************[JOB STAGE] APK IS LESS THAN 3MB **************** "
fi
