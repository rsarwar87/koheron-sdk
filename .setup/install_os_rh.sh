echo "TODO"
dnf install bc zerofree perl-core zlib-devel openssl-devel -y
wget -P /tmp  https://mirror.ghettoforge.org/distributions/gf/el/9/gf/x86_64/gf-release-9-13.gf.el9.noarch.rpm
rpm -Uvh /tmp/gf-release*rpm
dnf --enablerepo=gf install qemu-user-static-aarch64
dnf --enablerepo=gf install qemu-user-static-arm
dnf install uboot-tools
#	sudo apt-get install -y libssl-dev bc qemu-user-static zerofree
#	sudo apt-get install -y lib32stdc++6 lib32z1 u-boot-tools

