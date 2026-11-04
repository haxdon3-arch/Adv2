TARGET := iphone:clang:latest:14.0
ARCHS = arm64
DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = adspeed

adspeed_CFLAGS = -fobjc-arc
adspeed_CCFLAGS = -std=c++11 -fno-rtti -fno-exceptions -DNDEBUG
adspeed_FILES = Tweak.xm
adspeed_FRAMEWORKS = UIKit QuartzCore CoreGraphics AVFoundation
adspeed_LDFLAGS = -Wl,-not_for_dyld_shared_cache

include $(THEOS_MAKE_PATH)/tweak.mk
