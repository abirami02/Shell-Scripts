#!/bin/sh


sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/build-your-own-app_new.sh $netid  $BUILD_NUMBER "$customerName" $testflightUpload "$WORKSPACE" $emailID $domain $pushNotification Development $devBundleId $bundleVersion $bundleVersionShortString $TargetedDeviceFamily $BUILD_ID $inappBilling $orientationiPhone $orientationiPad "$appName" "$devCodeSignName" $svnTag $devProvisioningProfile $StatusBarStyle $ControllerBasedStatusBar $svnRepository "$releaseNotes" $JOB_NAME


sh /Users/abirami/Documents/QA/QA/Build_Automation_Scripts/build-your-tag-scripts/build-your-own-app_new.sh $netid  $BUILD_NUMBER "$customerName" No "$WORKSPACE" $emailID $domain $pushNotification Distribution $distributionBundleId $bundleVersion $bundleVersionShortString $TargetedDeviceFamily $BUILD_ID $inappBilling $orientationiPhone $orientationiPad "$appName" "$distributionCodeSignName" $svnTag $distributionProvisioningProfile $StatusBarStyle $ControllerBasedStatusBar $svnRepository "$releaseNotes" $JOB_NAME
