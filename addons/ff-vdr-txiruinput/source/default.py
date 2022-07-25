# SPDX-License-Identifier: GPL-2.0

import subprocess
import xbmcaddon
import os.path

if __name__ == "__main__":
   path = xbmcaddon.Addon().getAddonInfo('path')
   if not os.path.exists(path + ".installed"):
      subprocess.check_call(["/bin/sh", path + "install.sh"])
