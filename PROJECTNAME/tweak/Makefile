TWEAK_NAME = PROJECTNAMEPATCH

$(shell mkdir -p layout/DEBIAN/ "layout/Library/MobileSubstrate/DynamicLibraries/")
$(shell cp control layout/DEBIAN/)
$(shell ibtool --target-device iphone --target-device ipad --minimum-deployment-target 8.0 --output-format human-readable-text --compilation-directory "layout/Library/MobileSubstrate/DynamicLibraries/PROJECTNAMEPATCH.storyboardc" ../PROJECTNAMEPATCH/PROJECTNAMEPATCH.storyboard)

THEOS_DEVICE_IP = 192.168.200.13
ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

PROJECTNAMEPATCH_FILES = $(wildcard ../PROJECTNAMEPATCH/Tools/*.m) $(wildcard ../PROJECTNAMEPATCH/Tools/*.c) $(wildcard ../PROJECTNAMEPATCH/*.m)
PROJECTNAMEPATCH_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SanGuoGuaJi"
