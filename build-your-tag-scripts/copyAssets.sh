#!/bin/sh

customerName="$1"
domain=$2
sourcePath=$3
releaseType=$4
provisioningProfile=$5

custFolder="/Users/abirami/Documents/repos/Customers/"

echo $sourcePath

if [ -d "$sourcePath/Customers/$customerName/AppSDKs/SDKv1" ]; then
                   SDK_DIR="$sourcePath/Customers/$customerName/AppSDKs/SDKv1"
                else
                  SDK_DIR="$sourcePath/AppSDKs/SDKv1"
        fi



cd $custFolder
echo `pwd`
echo "*************[JOB STAGE] SVN UPDATE FOR CUSTOMER FOLDER STARTED ************* "
svn update
echo "*************[JOB STAGE] SVN UPDATE FOR CUSTOMER FOLDER COMPLETED ************* "

if [ "$domain" == "Android" ] 
then
echo "Android"
    if [ -d "$customerName" ]; then
        cd "$customerName"
        if [ -f "Android/paths.xml" ] || [ -f "Android/config.xml" ]; then
                echo "********* COPYING paths.xml **********"
                cp -Rf Android/paths.xml $sourcePath/AndroidFramework/res/values/paths.xml
                cp -Rf Android/config.xml $sourcePath/AndroidFramework/res/values/config.xml
	fi
		
	if [ -f 'Universal Settings 4.0'/'appcolour.json' ]; then
			echo "********* COPYING appcolour.json FOR CUSTOMISATION  **********"
                	cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/appcolour.json $sourcePath/AndroidFramework/assets/appcolour.json
	elif [ -f 'Universal Settings 4.0'/'newsfeed.json' ]; then
		cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/newsfeed.json $sourcePath/AndroidFramework/assets/newsfeed.json
	fi

     else
            echo "*************[JOB STAGE] CUSTOMER FOLDER DOES NOT EXIST, EXITING *************"
            exit 1
    fi
fi

if [ "$domain" == "iOS" ]
then
echo "iOS"
    if [ -d "$customerName" ]; then
        cd "$customerName"
        else
            echo "*************[JOB STAGE] CUSTOMER FOLDER DOES NOT EXIST, EXITING *************"
            exit 1
    fi

    if [ "$releaseType" == "Distribution" ]
    then
        cd /Users/abirami/Documents/repos/Customers/"$customerName"/"Provisioning Profiles"/Distribution/
        if [ -f "$provisioningProfile" ]; then
            echo "*************[JOB STAGE] INSTALLING DISTRIBUTION PROFILES *************"
            privateKey="$(cat password.txt)"
            security unlock-keychain -p abigenwi123 login.keychain
            security import ./Certificates.p12 -P "$privateKey" -k login.keychain -A -T /usr/bin/codesign
            sudo security unlock-keychain -p "abigenwi123" "/Library/Keychains/System.keychain"
            sudo security import ./Certificates.p12 -P "$privateKey" -k "/Library/Keychains/System.keychain" -A -T /usr/bin/codesign
        else
            echo "*************[JOB STAGE] THE $provisioningProfile DOES NOT EXIST, EXITING *************"
            exit 1;
        fi
    elif [ "$releaseType" == "Development" ] && [ "$provisioningProfile" != "DEFAULT1" ] && [ "$provisioningProfile" != "DEFAULT2" ];
    then
        cd /Users/abirami/Documents/repos/Customers/"$customerName"/"Provisioning Profiles"/Development/
        if [ -f $provisioningProfile ]; then
            echo "*************[JOB STAGE] INSTALLING DEVELOPMENT PROFILES *************"
            privateKey="$(cat password.txt)"
            security unlock-keychain -p abigenwi123 login.keychain
            security import ./Certificates.p12 -P "$privateKey" -k login.keychain -A -T /usr/bin/codesign
            sudo security unlock-keychain -p "abigenwi123" "/Library/Keychains/System.keychain"
            sudo security import ./Certificates.p12 -P "$privateKey" -k "/Library/Keychains/System.keychain" -A -T /usr/bin/codesign

        else
            echo "*************[JOB STAGE] THE $provisioningProfile DOES NOT EXIST, EXITING *************"
            exit 1;
        fi
    else
        echo "*************[JOB STAGE] USING $provisioningProfile GENWI PROFILES *************"
    fi



cd "$custFolder"/"$customerName"/Assets/

echo "*************[JOB STAGE] COPYING REQUIRED ASSETS ************* "
### Renaming ip_icon.png to icon.png for iPhone apps to upload icon to testflight
if [ -f "icon.png" ];
then
echo "copy1"
    cp -Rf $custFolder/"$customerName"/Assets/* "$SDK_DIR"/Resources/Application/Images/.
    cp -Rf $custFolder/"$customerName"/Assets/*icon* "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/.
    cp -Rf $custFolder/"$customerName"/Assets/Default* "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/LaunchImage.launchimage/.
else
    cp -Rf $custFolder/"$customerName"/Assets/* "$SDK_DIR"/Resources/Application/Images/.
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon.png "$SDK_DIR"/Resources/Application/Images/icon.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon@2x.png "$SDK_DIR"/Resources/Application/Images/icon@2x.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon7.png "$SDK_DIR"/Resources/Application/Images/icon7.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon7.png "$SDK_DIR"/Resources/Application/Images/icon7@2x.png
echo "copy2"
    cp -Rf $custFolder/"$customerName"/Assets/*icon* "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/.
    cp -Rf $custFolder/"$customerName"/Assets/Default* "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/LaunchImage.launchimage/.
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon.png "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/icon.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon@2x.png "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/icon@2x.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon7.png "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/icon7.png
    cp -Rf $custFolder/"$customerName"/Assets/ip_icon7.png "$SDK_DIR"/GenwiAppSDKv1/Images.xcassets/AppIcon.appiconset/icon7@2x.png
fi
### upload icon testflight done
cd ..

if [ -f 'Universal Settings 4.0/Genwi_IPad_Prefix.pch' ]; then
    echo "*************[JOB STAGE] COPYING THE $customerName PCH *************"
    cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/ $sourcePath/iOSFramework/
    #cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/Genwi_IPad-Info.plist "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    cp -Rf $custFolder/InstaApp/'Universal Settings 4.0'/Genwi_IPad-Info.plist "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    
	if [ -f 'Universal Settings 4.0'/'appcolour.plist' ] || [ -f 'Universal Settings 4.0'/'newsfeed.plist' ]; then
		echo "*************[JOB STAGE] COPYING THE plist *************"
    		cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/appcolour.plist "$SDK_DIR"/Resources/'Customization Assets'/appcolour.plist
		cp -Rf $custFolder/"$customerName"/'Universal Settings 4.0'/newsfeed.plist "$SDK_DIR"/Resources/'Customization Assets'/newsfeed.plist
    	fi
    echo "Done"
else
    echo "*************[JOB STAGE] COPYING THE DEFAULT INSTA APP PLIST AND PCH *************"
    cp -Rf $custFolder/InstaApp/'Universal Settings 4.0'/* $sourcePath/iOSFramework/.
    cp -Rf $custFolder/InstaApp/'Universal Settings 4.0'/Genwi_IPad-Info.plist "$SDK_DIR"/Genwi_Builder/Genwi-Info.plist
    echo "Done"
fi
fi
