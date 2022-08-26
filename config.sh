# SPDX-License-Identifier: GPL-2.0-or-later

# ---
# *ELEC build system specific options
# ---
export DISTRO=${DISTRO:-"CoreELEC"}
export PROJECT=${PROJECT:-"Amlogic-ce"}
export DEVICE=${DEVICE:-"Amlogic-ng"}
export SUBDEVICES=${SUBDEVICES:-"Odroid_N2"}
export ARCH=${ARCH:-"arm"}
export BUILDER_NAME=${BUILDER_NAME:-"df"}
export BUILDER_VERSION=${BUILDER_VERSION:-"1"}

# ---
# ff-vdr-elec build system specific options
# ---

# Root directory of CoreELEC build system
export DISTRO_DIR=${DISTRO_DIR:-~/${DISTRO}}

# Root directory of ff-vdr-elec build system
export FF_VDR_DISTRO_DIR=${FF_VDR_DISTRO_DIR:-~/ff-vdr-elec}

# Path to addon build list
export FF_VDR_ADDON_BUILD_LIST=${FF_VDR_ADDON_BUILD_LIST:-${FF_VDR_DISTRO_DIR}/addon_build_list}

# ---
# kodi addon repository deployment specific options
# ---

# Root directory of local kodi addon repository
export REPO_DIR=${REPO_DIR:-~/ff-vdr-repo}

# URL for accessing project on github
export GIT_REPO_URL=${GIT_REPO_URL:-"git@github.com-ff-vdr-repo:durchflieger/ff-vdr-coreelec-n2-odroid-repo.git"}

# URL of github ghpages
export REPO_URL=${REPO_URL:-"https://durchflieger.github.io/ff-vdr-coreelec-n2-odroid-repo"}

# Set to yes if update_repository.sh should automatically commit and push changes to github
export GIT_COMMIT="no"

# Name of kodi repository addon
export REPO_ADDON_NAME="ff-vdr-repository"
