include theos/makefiles/common.mk

TWEAK_NAME = CydiaSpotlight
CydiaSpotlight_FILES = Tweak.xm
CydiaSpotlight_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
