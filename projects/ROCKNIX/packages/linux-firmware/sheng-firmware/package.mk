# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2026-present ROCKNIX

PKG_NAME="sheng-firmware"
PKG_VERSION="2c1e2729a085c7f0470c855d236e49455c4601f0"
PKG_LICENSE="proprietary"
PKG_SITE="https://github.com/ianchb/sheng-firmware"
PKG_URL="https://github.com/ianchb/sheng-firmware/archive/${PKG_VERSION}.tar.gz"
PKG_LONGDESC="sheng-firmware: Device firmware for the Xiaomi Pad 6S Pro (SM8550, sheng)"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/$(get_full_firmware_dir)
  # Repo layout maps directly onto /lib/firmware: qcom/sm8550/sheng/*,
  # ath12k/WCN7850/*, cirrus/*, novatek/*, nanosic/*, qca/*, fpcsheng.elf
  cp -a ${PKG_BUILD}/* ${INSTALL}/$(get_full_firmware_dir)
}
