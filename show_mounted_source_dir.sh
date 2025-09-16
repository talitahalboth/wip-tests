#!/bin/bash

echo "======================================"
echo "MOUNTED_SOURCE_DIR Environment Info"
echo "======================================"
echo

# Show the environment variable value
echo "1. MOUNTED_SOURCE_DIR value:"
echo "   ${MOUNTED_SOURCE_DIR:-'Not set'}"
echo

# Show if the directory exists and basic info
if [ -n "${MOUNTED_SOURCE_DIR}" ]; then
    echo "2. Directory existence check:"
    if [ -d "${MOUNTED_SOURCE_DIR}" ]; then
        echo "   ✓ Directory exists"
        echo "   Path: ${MOUNTED_SOURCE_DIR}"
        echo "   Real path: $(realpath "${MOUNTED_SOURCE_DIR}" 2>/dev/null || echo "Cannot resolve")"
    else
        echo "   ✗ Directory does not exist"
    fi
    echo

    echo "3. Directory contents:"
    if [ -d "${MOUNTED_SOURCE_DIR}" ]; then
        echo "   Files and directories in ${MOUNTED_SOURCE_DIR}:"
        ls -la "${MOUNTED_SOURCE_DIR}" | sed 's/^/     /'
    else
        echo "   Cannot list contents - directory doesn't exist"
    fi
    echo

    echo "4. Directory size and file count:"
    if [ -d "${MOUNTED_SOURCE_DIR}" ]; then
        echo "   Total size: $(du -sh "${MOUNTED_SOURCE_DIR}" 2>/dev/null | cut -f1 || echo "Cannot calculate")"
        echo "   File count: $(find "${MOUNTED_SOURCE_DIR}" -type f 2>/dev/null | wc -l || echo "Cannot count")"
        echo "   Directory count: $(find "${MOUNTED_SOURCE_DIR}" -type d 2>/dev/null | wc -l || echo "Cannot count")"
    else
        echo "   Cannot calculate - directory doesn't exist"
    fi
    echo

    echo "5. Permissions and ownership:"
    if [ -d "${MOUNTED_SOURCE_DIR}" ]; then
        stat "${MOUNTED_SOURCE_DIR}" | sed 's/^/     /'
    else
        echo "   Cannot show permissions - directory doesn't exist"
    fi
    echo

    echo "6. Mount information:"
    mount | grep "${MOUNTED_SOURCE_DIR}" | sed 's/^/     /' || echo "   No specific mount information found for this directory"
    echo

    echo "7. Disk usage for the mount point:"
    df -h "${MOUNTED_SOURCE_DIR}" 2>/dev/null | sed 's/^/     /' || echo "   Cannot show disk usage"
    echo
else
    echo "2. MOUNTED_SOURCE_DIR is not set in the environment"
    echo
fi

echo "8. Related environment variables:"
env | grep -i mount | sed 's/^/     /' || echo "   No mount-related environment variables found"
echo

echo "9. Current working directory for comparison:"
echo "   PWD: $(pwd)"
echo "   Are they the same? $([ "${MOUNTED_SOURCE_DIR}" = "$(pwd)" ] && echo "Yes" || echo "No")"
echo

echo "======================================"
echo "End of MOUNTED_SOURCE_DIR Info"
echo "======================================"