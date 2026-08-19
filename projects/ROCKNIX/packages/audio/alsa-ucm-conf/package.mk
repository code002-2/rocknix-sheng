# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="alsa-ucm-conf"
PKG_VERSION="d28a4484c81088c8ea51d44fb1535cef40f4a475"
PKG_LICENSE="BSD-3c"
PKG_SITE="https://github.com/map220v/alsa-ucm-conf"
PKG_URL="https://github.com/map220v/alsa-ucm-conf.git"
PKG_GIT_CLONE_BRANCH="mainline"
PKG_GIT_CLONE_SINGLE="yes"
PKG_GIT_CLONE_DEPTH="1"
PKG_LONGDESC="ALSA Use Case Manager configuration (and topologies)"
PKG_TOOLCHAIN="manual"
PKG_PATCH_DIRS+=" ${DEVICE}"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/alsa/
  cp -PR ${PKG_BUILD}/ucm2 ${INSTALL}/usr/share/alsa/
  # work around scripts/build removing empty directories, this leads to errors in ucm
  touch ${INSTALL}/usr/share/alsa/ucm2/conf.virt.d/.dont_remove_this_dir
}
