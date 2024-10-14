# sync rom
sudo apt update
sudo apt upgrade
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
sudo install repo /usr/local/bin
rm repo


sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo apt-get install openjdk-8-jre

-- Install build tools
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip schedtool
mkdir nusan
cd nusan
git config --global user.email "dynemuhamad@gmail.com"
  git config --global user.name "UdyneO2"
repo init -u https://github.com/NusantaraProject-ROM/android_manifest -b 10
repo init -u https://github.com/Exynos3475/local_manifest.git --depth 1 -b lineage-17.1 .repo/local_manifests
repo sync --force-sync -j$( nproc --all )

# build rom
source build/envsetup.sh
lunch nad_j1xlte-user
export TZ=Asia/Dhaka #put before last build command
make nad

# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
