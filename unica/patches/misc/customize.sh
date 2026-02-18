# Crok's RAM Managment Fix
# https://github.com/crok/crokrammgmtfix/blob/master/service.sh#L27-L32
echo "Adding crok's ram management fix.."
[ -f "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc" ] && rm -f "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc"
{
    echo "on post-fs-data"
    echo "    exec_background -- /system/bin/cmd device_config set_sync_disabled_for_tests persistent"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_cached_processes 256"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_phantom_processes 2147483647"
    echo "    exec_background -- /system/bin/cmd settings put global settings_enable_monitor_phantom_procs false"
    echo "    exec_background -- /system/bin/cmd device_config put activity_manager max_empty_time_millis 43200000"
    echo "    exec_background -- /system/bin/cmd"
} >> "$WORK_DIR/system/system/etc/init/ram_mgmt_fix.rc"
SET_METADATA "system" "system/etc/init/ram_mgmt_fix.rc" 0 0 644 "u:object_r:system_file:s0"