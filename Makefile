#
# Copyright (C) 2010-2011 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-mentohust-with-mentohust
PKG_VERSION:=0.12
PKG_RELEASE:=1
PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/FanFansfan/mentohust-minimal
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=1a5151ea9044706115c86aed9fa7fac795518c3f

PO2LMO:=$(BUILD_DIR)/luci/build/po2lmo

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_OPTIONS += \
	-DBUILD_OPENWRT=1 -NO_DYLOAD=0

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  DEPENDS:=+libpcap
  TITLE:=luci-app-mentohust-with-mentohust
endef

define Package/$(PKG_NAME)/description
 mentohust & its web UI                           
endef


define Package/$(PKG_NAME)/postinst
#!/bin/sh 
[ -n "$${IPKG_INSTROOT}" ] || {
	( . /etc/uci-defaults/luci-mentohust ) && rm -f /etc/uci-defaults/luci-mentohust
	chmod 755 /etc/init.d/mentohust >/dev/null 2>&1
	/etc/init.d/mentohust enable >/dev/null 2>&1
	exit 0
}
endef

define Package/$(PKG_NAME)/install
	$(CP) ./root/* $(1)
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n $(1)/usr/lib/lua/luci
	#$(PO2LMO) ./po/zh-cn/mentohust.po $(1)/usr/lib/lua/luci/i18n/mentohust.zh-cn.lmo
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci
	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mentohust $(1)/usr/bin
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
