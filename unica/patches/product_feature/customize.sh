echo "- Decompiling.."
DECODE_APK "system/framework/ssrm.jar"
DECODE_APK "system/framework/esecomm.jar"
DECODE_APK "system/framework/services.jar"
DECODE_APK "system/priv-app/SecSettings/SecSettings.apk"
DECODE_APK "system/framework/framework.jar"
DECODE_APK "system/framework/gamemanager.jar"
DECODE_APK "system/framework/secinputdev-service.jar"
DECODE_APK "system/priv-app/SettingsProvider/SettingsProvider.apk"
DECODE_APK "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk"
DECODE_APK "system_ext/priv-app/SystemUI/SystemUI.apk"

if [[ "$SOURCE_HFR_MODE" != "$TARGET_HFR_MODE" ]]; then
    LOG_STEP_IN "- Applying HFR_MODE patches"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/framework/framework.jar/smali_classes6/com/samsung/android/rune/CoreRune.smali
    system/framework/gamemanager.jar/smali/com/samsung/android/game/GameManagerService.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/SemInputDeviceManagerService.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/utils/SemInputFeatures.smali
    system/framework/secinputdev-service.jar/smali/com/samsung/android/hardware/secinputdev/utils/SemInputFeaturesExtra.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    system/priv-app/SettingsProvider/SettingsProvider.apk/smali/com/android/providers/settings/DatabaseHelper.smali
    system_ext/priv-app/SystemUI/SystemUI.apk/smali/com/android/systemui/LsRune.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_HFR_MODE\"/\"$TARGET_HFR_MODE\"/g" "$APKTOOL_DIR/$f"
    done
    LOG_STEP_OUT
fi

if [[ "$SOURCE_MDNIE_SUPPORTED_MODES" != "$TARGET_MDNIE_SUPPORTED_MODES" ]] || \
    [[ "$SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION" != "$TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION" ]]; then
    LOG_STEP_IN "- Applying mDNIe features patches"

    FTP="
    system/framework/services.jar/smali_classes2/com/samsung/android/hardware/display/SemMdnieManagerService.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_MDNIE_SUPPORTED_MODES\"/\"$TARGET_MDNIE_SUPPORTED_MODES\"/g" "$APKTOOL_DIR/$f"
        sed -i "s/\"$SOURCE_MDNIE_WEAKNESS_SOLUTION_FUNCTION\"/\"$TARGET_MDNIE_WEAKNESS_SOLUTION_FUNCTION\"/g" "$APKTOOL_DIR/$f"
    done
    LOG_STEP_OUT
fi

if [[ "$SOURCE_HFR_SUPPORTED_REFRESH_RATE" != "$TARGET_HFR_SUPPORTED_REFRESH_RATE" ]]; then
    LOG_STEP_IN "- Applying HFR_SUPPORTED_REFRESH_RATE patches"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    "
    for f in $FTP; do
        if [[ "$TARGET_HFR_SUPPORTED_REFRESH_RATE" != "none" ]]; then
            sed -i "s/\"$SOURCE_HFR_SUPPORTED_REFRESH_RATE\"/\"$TARGET_HFR_SUPPORTED_REFRESH_RATE\"/g" "$APKTOOL_DIR/$f"
        else
            sed -i "s/\"$SOURCE_HFR_SUPPORTED_REFRESH_RATE\"/\"\"/g" "$APKTOOL_DIR/$f"
        fi
    done
    LOG_STEP_OUT
fi

if [[ "$SOURCE_HFR_DEFAULT_REFRESH_RATE" != "$TARGET_HFR_DEFAULT_REFRESH_RATE" ]]; then
    LOG_STEP_IN "- Applying HFR_DEFAULT_REFRESH_RATE patches"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/hardware/display/RefreshRateConfig.smali
    system/priv-app/SecSettings/SecSettings.apk/smali_classes4/com/samsung/android/settings/display/SecDisplayUtils.smali
    system/priv-app/SettingsProvider/SettingsProvider.apk/smali/com/android/providers/settings/DatabaseHelper.smali
    "
    for f in $FTP; do
        sed -i "s/\"$SOURCE_HFR_DEFAULT_REFRESH_RATE\"/\"$TARGET_HFR_DEFAULT_REFRESH_RATE\"/g" "$APKTOOL_DIR/$f"
    done
    LOG_STEP_OUT
fi

if [[ "$SOURCE_DVFS_CONFIG_NAME" != "$TARGET_DVFS_CONFIG_NAME" ]]; then
    LOG_STEP_IN "- Applying SSRM patches"
    
    ADD_TO_WORK_DIR "dm1qxxx" "system" "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk" 0 0 644 "u:object_r:system_file:s0"
    APPLY_PATCH "system" "system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk" \
        "$SRC_DIR/unica/patches/product_feature/sdhms/0001-Remove-SSRM-Warning.patch"

    FTP="
    system/framework/ssrm.jar/smali/com/android/server/ssrm/Feature.smali
    "

    for f in $FTP; do
        sed -i "s/$SOURCE_SSRM_CONFIG_NAME/$TARGET_SSRM_CONFIG_NAME/g" "$APKTOOL_DIR/$f"
        sed -i "s/$SOURCE_DVFS_CONFIG_NAME/$TARGET_DVFS_CONFIG_NAME/g" "$APKTOOL_DIR/$f"
    done
    LOG_STEP_OUT
fi

if [[ "$SOURCE_MULTI_MIC_MANAGER_VERSION" != "$TARGET_MULTI_MIC_MANAGER_VERSION" ]]; then
    LOG_STEP_IN "- Applying SemMultiMicManager patches"

    DECODE_APK "system" "system/framework/framework.jar"

    FTP="
    system/framework/framework.jar/smali_classes6/com/samsung/android/camera/mic/SemMultiMicManager.smali
    "
    for f in $FTP; do
        sed -i "s/$SOURCE_MULTI_MIC_MANAGER_VERSION/$TARGET_MULTI_MIC_MANAGER_VERSION/g" "$APKTOOL_DIR/$f"
    done
    LOG_STEP_OUT
fi

if $SOURCE_AUDIO_SUPPORT_DUAL_SPEAKER; then
    if ! $TARGET_AUDIO_SUPPORT_DUAL_SPEAKER; then
        echo "- Applying dual speaker patches"
        APPLY_PATCH "system" "system/framework/framework.jar" "$SRC_DIR/unica/patches/product_feature/audio/0001-Audio-Patch.patch"
        APPLY_PATCH "system" "system/framework/services.jar" "$SRC_DIR/unica/patches/product_feature/audio/0002-Audio-Patch.patch"
    fi
fi

echo "- Applying Brightness patches"
       APPLY_PATCH "system" "system/framework/framework.jar" "$SRC_DIR/unica/patches/product_feature/brightness/0001-Remove-Brightness-Threshold.patch"
