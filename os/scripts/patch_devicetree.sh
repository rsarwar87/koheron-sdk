#set -e

tmp_os_path=$1
board_path=$2
v_ver=$3

(cd ${tmp_os_path} && diff -rupN devicetree.orig devicetree > devicetree.patch)
cp ${tmp_os_path}/devicetree.patch ${board_path}/patches/devicetree_${v_ver}.patch
echo "Device tree patched"
