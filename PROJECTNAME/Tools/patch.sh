#!/bin/sh

TEMP_PATH="${SRCROOT}/Temp"
IPA_PATH="${SRCROOT}/IPA"

TARGET_IPA_PATH=""
DUMMY_DISPLAY_NAME="" # To be found in Step 0
TARGET_BUNDLE_ID="" # To be found in Step 0
TEMP_APP_PATH=""   # To be found in Step 1
TARGET_APP_PATH="" # To be found in Step 2
TARGET_APP_FRAMEWORKS_PATH="" # To be found in Step 4
PATCH_FRAMEWORK_NAME=""


# ---------------------------------------------------
# 0. Prepare Working Enviroment

rm -rf "$TEMP_PATH" || true
mkdir -p "$TEMP_PATH" || true

TARGET_IPA_PATH=$(find "$IPA_PATH/"*.ipa)
echo "Find .ipa file: $TARGET_IPA_PATH"


DUMMY_DISPLAY_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName"  "${SRCROOT}/$TARGET_NAME/Info.plist")
echo "DUMMY_DISPLAY_NAME: $DUMMY_DISPLAY_NAME"

TARGET_BUNDLE_ID="$PRODUCT_BUNDLE_IDENTIFIER"
echo "TARGET_BUNDLE_ID: $TARGET_BUNDLE_ID"


# ---------------------------------------------------
# 1. Extract Target IPA

unzip -oqq "$TARGET_IPA_PATH" -d "$TEMP_PATH"
TEMP_APP_PATH=$(set -- "$TEMP_PATH/Payload/"*.app; echo "$1")
echo "TEMP_APP_PATH: $TEMP_APP_PATH"

ExecutableFileName=$(/usr/libexec/PlistBuddy -c "Print CFBundleExecutable " $TEMP_APP_PATH/Info.plist)

echo $ExecutableFileName

${SRCROOT}/Tools/restore-symbol $TEMP_APP_PATH/$ExecutableFileName

# ---------------------------------------------------
# 2. Overwrite DummyApp IPA with Target App Contents

TARGET_APP_PATH="$BUILT_PRODUCTS_DIR/$TARGET_NAME.app"
echo "TARGET_APP_PATH: $TARGET_APP_PATH"

open $BUILT_PRODUCTS_DIR

rm -rf "$TARGET_APP_PATH" || true
mkdir -p "$TARGET_APP_PATH" || true
cp -rf "$TEMP_APP_PATH/" "$TARGET_APP_PATH/"


# ---------------------------------------------------
# 3. Inject the Executable We Wrote and Built (IPAPatch.framework)

cd $BUILT_PRODUCTS_DIR

PATCH_FRAMEWORK_NAME=$TARGET_NAME"PATCH"
PATCH_FRAMEWORK=$TARGET_NAME"PATCH.framework"
mkdir -p $TARGET_NAME.app/Frameworks/
cp -rf $PATCH_FRAMEWORK $TARGET_NAME.app/Frameworks/

cd $TARGET_APP_PATH
${SRCROOT}/Tools/yololib $ExecutableFileName Frameworks/$PATCH_FRAMEWORK/$PATCH_FRAMEWORK_NAME

chmod +x $ExecutableFileName

# ---------------------------------------------------
# 5. Remove Plugins/Watch (AppExtensions), To Simplify the Signing Process

rm -rf "$TARGET_APP_PATH/PlugIns" || true
rm -rf "$TARGET_APP_PATH/Watch" || true




# ---------------------------------------------------
# 7. Update Info.plist for Target App

TARGET_DISPLAY_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleDisplayName"  "$TARGET_APP_PATH/Info.plist")
TARGET_DISPLAY_NAME="$DUMMY_DISPLAY_NAME$TARGET_DISPLAY_NAME"

/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier $PRODUCT_BUNDLE_IDENTIFIER" "$TARGET_APP_PATH/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $TARGET_DISPLAY_NAME" "$TARGET_APP_PATH/Info.plist"



# ---------------------------------------------------
# 8. Code Sign All The Things

for DYLIB in "$TARGET_APP_PATH/Frameworks/"*
do
    /usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" "$DYLIB"
done


/usr/bin/codesign --force --sign "$EXPANDED_CODE_SIGN_IDENTITY" --timestamp=none "$TARGET_APP_PATH/$ExecutableFileName"




# ---------------------------------------------------
# 9. Install
#
#    Nothing To Do, Xcode Will Automatically Install the DummyApp We Overwrited



