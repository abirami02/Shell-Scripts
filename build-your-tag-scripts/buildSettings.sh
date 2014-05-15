#!/bin/sh

BUILD_TMP="$1"
PROVISONING_PROFILE="$2"
DEVELOPER_NAME="$3"

#echo "$PROVISONING_PROFILE"
#echo "$DEVELOPER_NAME"

rm -rf $BUILD_TMP/buildSettings.xcconfig

touch $BUILD_TMP/buildSettings.xcconfig

uuid=`grep UUID -A1 -a "$PROVISONING_PROFILE" | grep -o "[-A-Z0-9]\{36\}"`
#echo "$uuid"

echo "PROVISONING_PROFILE = $uuid" >> "$BUILD_TMP"/buildSettings.xcconfig
echo "CODE_SIGN_IDENTITY = $DEVELOPER_NAME" >> "$BUILD_TMP"/buildSettings.xcconfig
