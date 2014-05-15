#/bin/sh
                         # buildLib.sh
                         #
                         # Created by .

sourceFolder=$1
customerName="$2"

PROJDIR=$sourceFolder/iOSFramework

echo "***************[JOB STAGE] COPYING THE PUBLIC INTERFACE FILES *******************"
if [ -d "$sourceFolder/Customers/$customerName/AppSDKs/SDKv1" ]; then
	NEW_PATH="$sourceFolder/Customers/$customerName/AppSDKs/SDKv1"
        echo "${NEW_PATH}"
	cp -Rf "${PROJDIR}"/Classes/'Public Interface'/* "${NEW_PATH}"/'Public Interface'/.
else
if [ -d "$sourceFolder/Customers/$customerName/Customer Code" ]; then
        NEW_PATH="$sourceFolder/AppSDKs/SDKv1"
	cp -Rf "${PROJDIR}"/Classes/'Public Interface'/ "${NEW_PATH}"/'Public Interface'/
else
	NEW_PATH="$sourceFolder/AppSDKs/SDKv1"
fi
fi

#echo $NEW_PATH
custFolder="/Users/abirami/Documents/repos/Customers/"

TARGET_NAME="Genwi_Lib"
                         TARGET_SDK="iphoneos"
                         PROJECT_BUILDDIR="build/Release-iphoneos"
                         cd "${PROJDIR}"
#echo `pwd`
            cd "${NEW_PATH}"

echo "***************[JOB STAGE] BUILDING LIBRARY *******************"
#cp -rf $custFolder/InstaApp/Assets/* "${NEW_PATH}"/Resources/Application/Images/
#cp -rf $custFolder/InstaApp/'Universal Settings 4.0'/* "${PROJDIR}"/
#cp -rf $custFolder/InstaApp/'Universal Settings 4.0'/Genwi_IPad-Info.plist "${NEW_PATH}"/Genwi_Builder/Genwi-Info.plist

cd "${PROJDIR}"

                         xcodebuild -target "${TARGET_NAME}" -sdk iphonesimulator -configuration Release build -arch i386 VALID_ARCHS=i386 >> xcode.out
                         xcodebuild -target "${TARGET_NAME}" -sdk "${TARGET_SDK}" -configuration Release build -arch armv7 VALID_ARCHS=armv7 >> xcode1.out
                         if [ $? != 0 ]; then
                         exit 1
                         else

cd "${PROJECT_BUILDDIR}"

if [ ! -f "libgenwistatic.a" ]; then
exit 1
fi

for entry in *
do
if [ $entry == "libgenwistatic.a" ]; then
    mv "${PROJDIR}/build/Release-iphoneos"/libgenwistatic.a "${NEW_PATH}"/libgenwistatic.a
else
    mv "${PROJDIR}/build/Release-iphoneos"/libgenwi_i386.a "${NEW_PATH}"/libgenwistatic.a
fi
done

PROJECT_BUILDDIR="${PROJDIR}/build/Release-iphonesimulator"
cd "${PROJECT_BUILDDIR}"

for entry in *
do
if [ $entry == "libgenwistatic.a" ]; then
    echo "***************[JOB STAGE] BUILDING LIBRARY COMPLETED *******************"
    mv "${PROJDIR}/build/Release-iphonesimulator"/libgenwistatic.a "${NEW_PATH}"/libgenwi_i386.a
else
    mv "${PROJDIR}/build/Release-iphonesimulator"/libgenwi_i386.a "${NEW_PATH}"/libgenwi_i386.a
fi
done
fi

rm -rf "${NEW_PATH}"/build/
if [ -f "${NEW_PATH}"/*.ipa ]; then
	rm "${NEW_PATH}"/*.ipa
fi
rm "${NEW_PATH}"/*.txt

echo "*************[JOB STAGE] SDKV1 ZIP STARTED *************"
rm -rf "${NEW_PATH}"/SDKv1.zip
cd "${NEW_PATH}"/..
zip -r SDKv1.zip SDKv1 >> zip.out
echo "*************[JOB STAGE] SDKV1 ZIP COMPLETED *************"
