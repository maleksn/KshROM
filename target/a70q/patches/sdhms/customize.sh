echo "Adding ARMv8 SDHMS"
ADD_TO_WORK_DIR "dm1qksx" "system" "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk" 0 0 644 "u:object_r:system_file:s0"

echo "Add SM6150 flags on SSRM"

DECODE_APK "system/framework/ssrm.jar"
FTP="
system/framework/ssrm.jar/smali/com/android/server/ssrm/Feature.smali
"
for f in $FTP; do
sed -i "s/\"$SOURCE_DVFS_CONFIG_NAME\"/\"$TARGET_DVFS_CONFIG_NAME\"/g" "$APKTOOL_DIR/$f"
sed -i "s/$SOURCE_SSRM_CONFIG_NAME/$TARGET_SSRM_CONFIG_NAME/g" "$APKTOOL_DIR/$f"
done

echo "SDHMS was patched successfully!"