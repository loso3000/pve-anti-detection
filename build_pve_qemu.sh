#以下两行docker里面运行需要sudo 如果pve里面运行请删除sudo
sudo apt-get update
sudo apt-get install -y libacl1-dev libaio-dev libattr1-dev libcap-ng-dev libcurl4-gnutls-dev libepoxy-dev libfdt-dev libgbm-dev libglusterfs-dev libgnutls28-dev libiscsi-dev libjpeg-dev libnuma-dev libpci-dev libpixman-1-dev libproxmox-backup-qemu0-dev librbd-dev libsdl1.2-dev libseccomp-dev libslirp-dev libspice-protocol-dev libspice-server-dev libsystemd-dev liburing-dev libusb-1.0-0-dev libusbredirparser-dev libvirglrenderer-dev meson python3-sphinx python3-sphinx-rtd-theme quilt xfslibs-dev
ls
df -h
git clone git://git.proxmox.com/git/pve-qemu.git
cd pve-qemu
TARGET_VERSION="9.1.2-1"
git fetch --tags 

TAG=$(git tag -l | grep -E "v?${TARGET_VERSION//./\\.}$" | head -1)

if [ -z "$TAG" ]; then
    echo "Error: Version $TARGET_VERSION not found in git tags"
    git tag -l | grep '9.1.2'
    exit 1
else
    echo "Found tag: $TAG"
    git checkout "$TAG"
fi
#git reset --hard 053f68a7aca508dc2dba9b8947b74a0704e51baf
git describe --tags 

exit
apt install devscripts -y
mk-build-deps --install
make
make clean
cp ../sedPatch-pve-qemu-kvm7-8-anti-dection.sh qemu/
cd qemu
chmod +x sedPatch-pve-qemu-kvm7-8-anti-dection.sh
bash sedPatch-pve-qemu-kvm7-8-anti-dection.sh
cp ../../smbios.h include/hw/firmware/smbios.h
cp ../../smbios.c hw/smbios/smbios.c
git diff > qemu-autoGenPatch.patch
cp qemu-autoGenPatch.patch ../
cd ..
apt install devscripts -y
mk-build-deps --install
make
