本库放在Libs下：$(PROJECT_DIR)/company/Libs/GYencryption/

Library Search Paths：设置为如下：
$(PROJECT_DIR)/company/Libs/GYencryption/Release$(EFFECTIVE_PLATFORM_NAME)/

lipo -info
Release-iphoneos/libGYencryption.a are: armv7 arm64 armv7s
Release-iphonesimulator/libGYencryption.a are: i386 x86_64