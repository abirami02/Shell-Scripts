#!/bin/sh
# build.sh
#
# Created by somashekar. please contact me for any queries somashekar@genwi.com


APPLICATION_NAME=$2
PROJECT_NAME="GenwiAppSDKv1"
TARGET_SDK="iphoneos"
BUILD_TMP="/Users/abirami/Documents/builds"
PUB_BUILDS="/Users/abirami/Documents/publishedBuilds/iosBuilds"
custFolder="/Users/abirami/Documents/repos/Customers"
BUNDLE_IDENTIFIER=$3
NET_ID=$1
BUNDLE_ID=$5
BUNDLE_VERSION=$4
customerName=$7
releaseType=$6
orientationiPhone=$8
orientationiPad=${9}
provisioningProfile=${12}
sourceFolder=${11}
codeSignName="${10}"
TargetedDeviceFamily=${13}
StatusBarStyle=${14}
ControllerBasedStatusBar=${15}

#deeplinkName=$(echo $customerName | tr -d ' ' | tr '[:upper:]' '[:lower:]')
deeplinkName=gw$NET_ID


if [ -d "$sourceFolder/Customers/$customerName/AppSDKs/SDKv1" ]; then
echo "********* BUILDING APP WITH CUSTOMER SDK PROJECT AND PLIST *********"
	SDK_DIR="$sourceFolder/Customers/$customerName/AppSDKs/SDKv1"
	SRC_DIR="$sourceFolder/Customers/$customerName/AppSDKs"
	cp -Rf $custFolder/$customerName/'Universal Settings 4.0'/Genwi_IPad-Info.plist $SDK_DIR/Genwi_Builder/Genwi-Info.plist
else
if [ -d "$sourceFolder/Customers/$customerName/Customer Code" ]; then
echo "********* BUILDING APP WITH CUSTOMER CODE FILES *********"
	cp -Rf "$sourceFolder/Customers/$customerName/Customer Code/" "$sourceFolder/AppSDKs/SDKv1/Customer Code/." 
	SDK_DIR=$sourceFolder/AppSDKs/SDKv1
	SRC_DIR=$sourceFolder/AppSDKs
	#cp -Rf $custFolder/$customerName/'Universal Settings 4.0'/Genwi_IPad-Info.plist $SDK_DIR/Genwi_Builder/Genwi-Info.plist
else
echo "********* BUILDING APP WITHOUT CUSTOMIZATION *********"
	SDK_DIR=$sourceFolder/AppSDKs/SDKv1
        SRC_DIR=$sourceFolder/AppSDKs

fi
fi

echo $sourceFolder

rm -Rf ~/Library/MobileDevice/Provisioning\ Profiles/*

if [ "$TargetedDeviceFamily" == "iPhone" ]
then
        TARGETED_DEVICE_FAMILY=1
elif [ "$TargetedDeviceFamily" == "iPad" ]
then
        TARGETED_DEVICE_FAMILY=2
elif [ "$TargetedDeviceFamily" == "Universal" ]
then
        TARGETED_DEVICE_FAMILY=1,2
fi

# Overriding plist file.
if [ $NET_ID == "none" ]; then
/usr/libexec/PlistBuddy -c "Set :netId ''" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
else
/usr/libexec/PlistBuddy -c "Set :netId '${NET_ID}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
fi
/usr/libexec/PlistBuddy -c "Set :CFBundleName '${APPLICATION_NAME}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName '${APPLICATION_NAME}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier '${BUNDLE_IDENTIFIER}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${BUNDLE_ID}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${BUNDLE_VERSION}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :UIStatusBarStyle '${StatusBarStyle}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :UIViewControllerBasedStatusBarAppearance '${ControllerBasedStatusBar}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLSchemes:0 '${deeplinkName}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleURLTypes:0:CFBundleURLName '${BUNDLE_IDENTIFIER}'" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist

echo "**************[JOB STAGE] MODIFYING PLIST FOR ORIENTATION CHANGES **************"
if [ "$orientationiPhone" == "Portrait" ]
then
    echo "iPhone-Portrait"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~iphone" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~iphone:3" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~iphone:2" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Print :UISupportedInterfaceOrientations~iphone" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
elif [ "$orientationiPhone" == "Landscape" ];
then
    echo "iPhone-Landscape"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~iphone" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~iphone:0" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~iphone:0" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Print :UISupportedInterfaceOrientations~iphone" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
else
    echo "Both"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~iphone" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
fi

if [ "$orientationiPad" == "Portrait" ]
then
    echo "iPad-Portrait"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~ipad" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad:3" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad:2" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Print :UISupportedInterfaceOrientations~ipad" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
elif [ "$orientationiPad" == "Landscape" ];
then
    echo "iPad-Landscape"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~ipad" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad:0" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Delete :UISupportedInterfaceOrientations~ipad:0" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    /usr/libexec/PlistBuddy -c "Print :UISupportedInterfaceOrientations~ipad" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
else
    echo "iPad-Both"
    /usr/libexec/PlistBuddy -c "Copy :UISupportedInterfaceOrientations UISupportedInterfaceOrientations~ipad" "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
fi


echo "**************[JOB STAGE] BUILDING PROJECT **************"
cd "${SDK_DIR}"
echo `pwd`
echo "$releaseType"

security unlock-keychain -p abigenwi123 login.keychain

echo "*************[JOB STAGE] BUILDING APPLICATION *************"
if [ "$releaseType" == "Distribution" ]
then
    echo "*************[JOB STAGE] COPYING DISTRUBUTION PROFILE *************"
    cp -R $custFolder/"$customerName"/'Provisioning Profiles'/Distribution/$provisioningProfile  ~/Library/MobileDevice/'Provisioning Profiles'/
    PROVISONING_PROFILE=$custFolder/"$customerName"/'Provisioning Profiles'/Distribution/$provisioningProfile
    echo $PROVISONING_PROFILE
    DEVELOPER_NAME="$codeSignName"
    PROJECT_BUILDDIR="${SDK_DIR}/build/Release-iphoneos"
    xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Release TARGETED_DEVICE_FAMILY="${TARGETED_DEVICE_FAMILY}" >> output.txt

else 
if [ "$releaseType" == "Development" ] && [ "$provisioningProfile" != "DEFAULT1" ] && [ "$provisioningProfile" != "DEFAULT2" ];
then
    cp -R $custFolder/"$customerName"/'Provisioning Profiles'/Development/$provisioningProfile  ~/Library/MobileDevice/'Provisioning Profiles'/
    PROVISONING_PROFILE=$custFolder/"$customerName"/'Provisioning Profiles'/Development/$provisioningProfile
    echo $PROVISONING_PROFILE
    DEVELOPER_NAME='iPhone Developer: Prabhanjan Gurumohan (9Z6884U42H)'
    PROJECT_BUILDDIR="${SDK_DIR}/build/Debug-iphoneos"
    xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Debug TARGETED_DEVICE_FAMILY="${TARGETED_DEVICE_FAMILY}" >> output.txt

else
if [ "$releaseType" == "Development" ] && [ "$provisioningProfile" == "DEFAULT1" ];
then 
    cp -R '/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Team.mobileprovision' ~/Library/MobileDevice/'Provisioning Profiles'/
    cp -R '/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Team.mobileprovision' /Users/abirami/Documents/tools/pprofile/
    #PROVISONING_PROFILE="/Users/abirami/Documents/tools/pprofile/Genwi_Team.mobileprovision"
    PROVISONING_PROFILE="/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Team.mobileprovision"
    DEVELOPER_NAME='iPhone Developer: Prabhanjan Gurumohan (9Z6884U42H)'
    PROJECT_BUILDDIR="${SDK_DIR}/build/Debug-iphoneos"
    xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Debug TARGETED_DEVICE_FAMILY="${TARGETED_DEVICE_FAMILY}" >> output.txt

else
if [ "$releaseType" == "Development" ] && [ "$provisioningProfile" == "DEFAULT2" ];
then
    cp -R '/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Development_Profile.mobileprovision' ~/Library/MobileDevice/'Provisioning Profiles'/
    #cp -R '/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Team.mobileprovision' /Users/abirami/Documents/tools/pprofile/
    #PROVISONING_PROFILE="/Users/abirami/Documents/tools/pprofile/Genwi_Team.mobileprovision"
    PROVISONING_PROFILE="/Users/abirami/Documents/repos/Customers/GENWI Developer Profiles/com.genwi.*/Genwi_Development_Profile.mobileprovision"
    DEVELOPER_NAME='iPhone Developer: Rama Sagiraju (8484LMU7ZP)'
    PROJECT_BUILDDIR="${SDK_DIR}/build/Debug-iphoneos"
    xcodebuild -target "${PROJECT_NAME}" -sdk "${TARGET_SDK}" -configuration Debug TARGETED_DEVICE_FAMILY="${TARGETED_DEVICE_FAMILY}" >> output.txt

    fi
    fi
fi
fi

#Creating the BuildSettings file
sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/buildSettings.sh "$BUILD_TMP" "$PROVISONING_PROFILE" "$DEVELOPER_NAME"


if [ $? != 0 ]
    then
    exit 1
fi
echo `pwd`
echo "*************[JOB STAGE] GENERATING XCODE ARCHIVE *************"
echo "Building Archive file"

if [ -f "$SDK_DIR/*.xcarchive" ];then
	rm -rf *.xcarchive
fi 

xcodebuild -scheme ${PROJECT_NAME} -configuration Release -xcconfig "$BUILD_TMP/buildSettings.xcconfig" -archivePath "${SDK_DIR}"  archive >> archive.out
echo "*************[JOB STAGE] GENERATING XCODE ARCHIVE COMPLETED *************"

echo "*************[JOB STAGE] GENERATING IPA *************"
/usr/bin/xcrun -sdk ${TARGET_SDK} PackageApplication -v "${PROJECT_BUILDDIR}/GenwiAppSDKv1.app" -o "${SDK_DIR}/${APPLICATION_NAME}.ipa" --sign "${DEVELOPER_NAME}" --embed "${PROVISONING_PROFILE}" >> output.txt
echo `pwd`

echo "*************[JOB STAGE] GENERATING IPA COMPLETED *************"
cd "${SRC_DIR}"
echo `pwd`
cd SDKv1

if [ ! -f "${APPLICATION_NAME}.ipa" ]; then
    echo "*************[JOB STAGE] BUILD FAILED, EXITING *************"
    exit 1
else
   echo "*************[JOB STAGE] BUILDING IPA COMPLETED ************* "
   cd ..

echo `pwd`
cd $PUB_BUILDS
Today=$(date +%m%d%y-%T)
mkdir $Today

cp "$SDK_DIR"/"${APPLICATION_NAME}".ipa $PUB_BUILDS/$Today
cd $PUB_BUILDS/$Today

echo "********************* BUILD SUCCESSFUL ***************************"
echo "Published IOS build is Available at"
echo `pwd`

cd $PUB_BUILDS/$Today

size=$(ls -alert "${APPLICATION_NAME}".ipa | awk '{ print $5}')

if [ $size -gt "3000000" ] ;
then
    echo "*************[JOB STAGE] THE IPA IS MORE THAN 3MB, EXITING *************"
    echo $size
else
    echo "*************[JOB STAGE] THE IPA IS LESS THAN 3MB *************"
    echo $size
fi
fi 
