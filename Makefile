GO_EASY_ON_ME = 1

TWEAK_NAME = PageHolder
PageHolder_FILES = PHModel.mm Tweak.xm
PageHolder_FRAMEWORKS = UIKit CoreGraphics
PageHolder_CFLAGS = -w

SUBPROJECTS = Preferences

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
