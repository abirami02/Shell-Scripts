#!/bin/bash
#
# 
# This script is created by Somashekar@genwi.com, please send queries.

IPA_NAME=$1
IPA_DIR="$2"
BUILD_NUMBER=$3
releaseNotes="$4"

echo $IPA_NAME
echo $IPA_DIR

API_TOKEN="ab6d5624cd8068787a1a93cace205868_MTAyMDMxNjIwMTMtMDQtMzAgMDc6MjI6NTAuNDI5NjEx"
TEAM_TOKEN="03b11f206959e5c3c48943b13d4d763c_MTg5MTE"
#IPA_DIR="/Users/abirami/Documents/android_build/genwiviewer/NativeSrc_Android_4.0_04082013/AppSDKs/SDKv1/bin"
#IPA_Name="Genwi Viewer.apk"
echo "Uploading to TestFlight ...... "

cd "${IPA_DIR}"
Today=$(date +%m%d%y-%T)

/usr/bin/curl "http://testflightapp.com/api/builds.json" \
-F file=@"${IPA_NAME}" \
-F api_token="${API_TOKEN}" \
-F team_token="${TEAM_TOKEN}" \
-F notes="'${releaseNotes}'. Hudson Job Link - http://gwindia.local/hudson/job/Build-Your-Own-App/${BUILD_NUMBER} OR http://182.73.7.129/hudson/job/Build-Your-Own-App/${BUILD_NUMBER}" \
-F distribution_lists="AutomatedBuildsEmails" \
-F notify=True

echo "Uploaded to TestFlight ...... "

