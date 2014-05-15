#!/bin/sh

## Input Parameters from hudson
netid=$1
domain=$7
releaseType=$9
customerName=$3
bundleId=${10}
bundleVersion=${11}
bundleVersionShortString=${12}
TargetedDeviceFamily=${13}
appName="${18}"
codeSignName="${19}"

BUILD_NUMBER=$2
BUILD_ID=${14}
WORKSPACE=$5

testflightUpload=$4
pushNotification=$8
inappBilling=${15}
orientationiPhone=${16}
orientationiPad=${17}
StatusBarStyle=${22}
ControllerBasedStatusBar=${23}

provisioningProfile=${21}
emailID=$6

SVN_TAG=${20}
svnRepository=${24}

releaseNotes="${25}"
jobName=${26}

count=$(echo $#)

#Build location
buildLoc="/Users/abirami/Documents/genwiBuilds"
echo $count

echo " ************* GENERATING $releaseType BUILD ************* "
echo " ************* INPUT VALUES FOR $releaseType BUILD ************* "
echo "domain =" $domain
echo "netid =" $netid
echo "customerName =" $customerName
echo "appName =" "$appName"
echo "releaseType =" $releaseType
echo "bundleId =" $bundleId
echo "bundleVersion =" $bundleVersion
echo "bundleVersionShortString =" $bundleVersionShortString
echo "provisioningProfile =" $provisioningProfile
echo "codeSignName =" $codeSignName
echo "TargetedDeviceFamily =" $TargetedDeviceFamily
echo "orientationiPhone =" $orientationiPhone
echo "orientationiPad =" $orientationiPad
echo "StatusBarStyle =" $StatusBarStyle
echo "ControllerBasedStatusBarAppearance=" $ControllerBasedStatusBar
echo "testflightUpload =" $testflightUpload
echo "pushNotification =" $pushNotification
echo "inappBilling =" $inappBilling
echo "emailID =" $emailID
echo "SVN TAG =" $svnTag
echo "svnRepository =" $svnRepository
echo "releaseNotes =" $releaseNotes



#Exiting the script if parameters are less than 21
if [ $count -lt 26 ] || [ '$codeSignName' == 'None' ] || [ '$provisioningProfile' == 'None' ] ;
then
echo "************* ERROR IN INPUT VALUES, PLEASE ENTER ALL THE INPUT VALUES CORRECTLY AND PROVISIONING PROFILE IS NOT NONE *************"
exit 1

else

#Displaying archive location in hudson console
if [ $domain == "iOS" ]
then
    echo " ************* BUILD LOCATION ************* "
    echo "After Successful completion of the job, the builds will be available at"
    echo "Public Network - http://182.73.7.129/private/build-output/ios-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/"
    echo "India Network - http://gwindia.local/private/build-output/ios-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/"
else
    echo " ************* BUILD LOCATION ************* "
    echo "After Successful completion of the job, the builds will be available at"
    echo "Public Network - http://182.73.7.129/private/build-output/android-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/"
    echo "India Network - http://gwindia.local/private/build-output/android-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/"
fi

echo "************* CONNECTING TO VPN ************* "
osascript /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/connectVPN.scpt
sleep 20
echo "Done"

cd "$buildLoc/$domain"

    if [ $SVN_TAG == "Latest" ]; then
	if [ $domain == "iOS" ]; then
        	sourcePath=$buildLoc/$domain/NativeSrc_iOS_4.0_02072013
	else 
		sourcePath=$buildLoc/$domain/NativeSrc_Android_4.0_04082013
	fi
        
	cd $sourcePath
        
	echo "***************[JOB STAGE] SVN UPDATE STARTED *******************"
    svn cleanup
    svn revert -R . >> revert.out
	svn update
	echo "***************[JOB STAGE] SVN UPDATE COMPLETED *******************"
   
  elif [ -d "$buildLoc/$domain/$SVN_TAG" ]; then
	
        cd $buildLoc/$domain/$SVN_TAG/$SVN_TAG
	echo "***************[JOB STAGE] SVN UPDATE STARTED *******************"
    svn cleanup
    svn revert -R . >> rever.out
    svn update
	echo "***************[JOB STAGE] SVN UPDATE COMPLETED *******************"

	sourcePath="$buildLoc/$domain/$SVN_TAG/$SVN_TAG"
    else
        mkdir $SVN_TAG
        cd $buildLoc/$domain/$SVN_TAG
	

	if [ $svnRepository == "Tag" ]; then
        	echo "***************[JOB STAGE] SVN TAG CHECKOUT STARTED *******************"
        	svn co https://abirami@svn/repos/tags/certified/$domain/$SVN_TAG
		echo "***************[JOB STAGE] SVN TAG CHECKOUT COMPLETED *******************"
	elif [ $svnRepository == "Branch" ]; then
		echo "***************[JOB STAGE] SVN BRANCH CHECKOUT STARTED *******************"
		svn co https://abirami@svn/repos/branches/$SVN_TAG
		echo "***************[JOB STAGE] SVN BRANCH CHECKOUT COMPLETED *******************"
	elif [ $svnRepository == "Trunk" ]; then
		echo "***************[JOB STAGE] SVN TRUNK CHECKOUT STARTED *******************"
		svn co https://abirami@172.16.1.77/repos/trunk/native/$SVN_TAG
		echo "***************[JOB STAGE] SVN TRUNK CHECKOUT COMPLETED *******************"
	fi
	

        cd $SVN_TAG
        sourcePath=$(echo `pwd`)
    fi
	if [ -d "$sourcePath/Customers/$customerName/AppSDKs/SDKv1" ]; then
                   SDK_DIR="$sourcePath/Customers/$customerName/AppSDKs/SDKv1"
                else
                  SDK_DIR="$sourcePath/AppSDKs/SDKv1"
        fi


# Passing arguments to build scripts
if [ $domain == "iOS" ]; then
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/copyAssets.sh "$customerName" $domain "$sourcePath" $releaseType $provisioningProfile
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/buildLib.sh $sourcePath "$customerName"
    #sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/copyAssets.sh "$customerName" $domain $sourcePath
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/build.sh $netid "$appName" $bundleId $bundleVersion $bundleVersionShortString $releaseType "$customerName" $orientationiPhone $orientationiPad "$codeSignName" $sourcePath $provisioningProfile $TargetedDeviceFamily $StatusBarStyle $ControllerBasedStatusBar

else
    sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/copyAssets.sh "$customerName" $domain $sourcePath
   	sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/android_gradle.sh "$customerName" "$appName" $netid $bundleId $sourcePath $bundleVersionShortString $bundleVersion $releaseType
fi

echo "*************[JOB STAGE] COPYING BUILDS TO OUTPUT DIRECTORY ************* "
if [ $domain == 'iOS' ]; then
	if [ ! -f "$SDK_DIR"/"$appName".ipa ]; then
		exit 1
   	else 
   		cd /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/
    		mkdir $BUILD_ID["${BUILD_NUMBER}"]
   	if [ "$releaseType" == "Development" ]; then
   		cp "$SDK_DIR"/"$appName".ipa /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/dev-"$appName".ipa
   		cp $sourcePath/AppSDKs/SDKv1.zip /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/dev-SDKv1.zip
		cp -Rf $sourcePath/AppSDKs/*.xcarchive /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/dev-SDKv1.xcarchive
   	else
   		cp "$SDK_DIR"/"$appName".ipa /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/
		cp -Rf $sourcePath/AppSDKs/*.xcarchive /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/
   		#cp $sourcePath/AppSDKs/SDKv1.zip /Users/apache/Documents/private/build-output/ios-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/
   	fi
    	cp "$SDK_DIR"/"$appName".ipa "$WORKSPACE"/
	if [ $testflightUpload == "Yes" ]; then
		echo "*************[JOB STAGE] UPLOADING THE BUILD TO TEST FLIGHT *************"
		ipaDir="$SDK_DIR"
		sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/testflight.sh "$appName".ipa "$ipaDir" $BUILD_NUMBER "$releaseNotes" "$emailID" $jobName
	fi
	fi

#elif [ $domain == "Android" ] && [ $svnRepository != "Trunk" ]; then
#	if [ ! -f "$SDK_DIR"/bin/"$appName".apk ]; then
#	exit 1
#	else
#		apkDir="$SDK_DIR"/bin/
#		cd /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/
 #       	mkdir $BUILD_ID["${BUILD_NUMBER}"]
#		cp "$SDK_DIR"/bin/"$appName".apk /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/
 #       	cp "$SDK_DIR"/SDKv1.zip /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/
#		cp "$SDK_DIR"/bin/"$appName".apk "$WORKSPACE"/
#	fi
elif [ $domain == "Android" ]; then
	if [ ! -f $sourcePath/AndroidFramework/build/apk/*"$appName".apk ]; then
        exit 1
        else
		apkDir=$sourcePath/AndroidFramework/build/apk/
        	cd /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/
        	mkdir $BUILD_ID["${BUILD_NUMBER}"]
	if [ $releaseType == "Development" ]; then
        	cp $sourcePath/AndroidFramework/build/apk/dev-"$appName".apk /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/dev-"$appName".apk
	else
		cp $sourcePath/AndroidFramework/build/apk/"$appName".apk /Users/apache/Documents/private/build-output/android-builds/build-your-own-app/$BUILD_ID["${BUILD_NUMBER}"]/"$appName".apk
	fi
	fi 

    #if [ $testflightUpload == "Yes" ]; then
    #echo "*************[JOB STAGE] UPLOADING THE BUILD TO TEST FLIGHT *************"
    #sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/testflight.sh "$appName".apk "$apkDir" $BUILD_NUMBER "$releaseNotes" "$emailID" $jobName
    #fi
fi

#echo "************* DISCONNECTING VPN ************* "
#osascript /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/disconnectVPN.scpt
echo "Done"

cd "$WORKSPACE/"

echo "************* SENDING MAIL ************* "
echo "The builds are available at: " >> mail_$BUILD_NUMBER.txt
echo "Public Network - http://182.73.7.129/private/build-output/ios-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/" >> mail_$BUILD_NUMBER.txt
echo "India Network - http://gwindia.local/private/build-output/ios-builds/build-your-own-app/$BUILD_ID[${BUILD_NUMBER}]/" >> mail_$BUILD_NUMBER.txt

(
echo "From: abirami@genwi.com"
echo "To: abirami@genwi.com $emailID"
echo "MIME-Version: 1.0"
echo "Subject: Build Your Own App - Job Status" 
echo "Content-Type: text/html" 
cat mail_$BUILD_NUMBER.txt
) | sendmail -t
fi
