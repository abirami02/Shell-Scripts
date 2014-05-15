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
    cp -rf $custFolder/"$customerName"/Android/drawable-port-xhdpi/ "${SDK_DIR}"/res/drawable-port-xhdpi/
fi

cd $custFolder/"$customerName"/Android/
if [ -d 'Keystore' ]; then
echo "*************[JOB STAGE]COPYING THE CUSTOMER KEYSTORE ************* "
    cp -rf $custFolder/"$customerName"/Android/Keystore/ "${SDK_DIR}"/
else 
echo "*************[JOB STAGE]COPYING THE DEFAULT KEYSTORE ************* "
    cp -rf $custFolder/InstaApp/Android/Keystore/ "${SDK_DIR}"/
fi

cd $PRJ_DIR/

echo "**************[JOB STAGE] BUILDING THE PACKAGE USING GRADLE **************** "

gradle assembleDebug -PpackageName=$bundleId >> gradle.out


echo "**************[JOB STAGE] APK FILE GENERATED **************** "

cd $PRJ_DIR/build/apk
if [ ! -f "AndroidFramework-debug-unaligned.apk" ]; then
 echo "**************[JOB STAGE] APK FILE NOT GENERATED, BUILD FAILED **************** "
    exit 1

else
    mv AndroidFramework-debug-unaligned.apk "$appName".apk
    echo "**************[JOB STAGE] APK FILE GENERATED **************** "
    cd ..

echo "**************[JOB STAGE] BUILD SUCCESSFUL **************** "
cd ..

cd $PUB_BUILDS
Today=$(date +%m%d%y-%T)
mkdir $Today
cp $PRJ_DIR/build/apk/"$appName".apk $PUB_BUILDS/$Today

echo "Published Android build is Available at"
echo `pwd`


cd $PUB_BUILDS/$Today

size=$(ls -alert "$appName".apk | awk '{ print $5}')
if [ $size -gt "3000000" ]; then
    echo "**************[JOB STAGE] APK IS MORE THAN 3MB, EXITING **************** "
    echo $size
#exit 1
else
    echo "**************[JOB STAGE] APK IS LESS THAN 3MB **************** "
fi
fi
