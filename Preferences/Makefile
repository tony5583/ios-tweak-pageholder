GO_EASY_ON_ME = 1

BUNDLE_NAME = PageHolder
PageHolder_FILES = ../PHModel.mm PHPreferencesViewController.mm
PageHolder_INSTALL_PATH = /Library/PreferenceBundles
PageHolder_FRAMEWORKS = UIKit
PageHolder_PRIVATE_FRAMEWORKS = Preferences

include ../theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	@mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences
	@cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PageHolder.plist
