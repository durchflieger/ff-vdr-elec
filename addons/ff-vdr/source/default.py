# SPDX-License-Identifier: GPL-2.0

import subprocess
import xbmc
import xbmcaddon
import os.path

class Monitor(xbmc.Monitor):

   def __init__(self, *args, **kwargs):
      xbmc.Monitor.__init__(self)
      self.addonPath = xbmcaddon.Addon().getAddonInfo('path')

   def onSettingsChanged(self):
      subprocess.check_call(["/bin/sh", self.addonPath + "configure.sh"])


if __name__ == "__main__":
   path = xbmcaddon.Addon().getAddonInfo('path')
   if not os.path.exists(path + ".installed"):
      subprocess.check_call(["/bin/sh", path + "install.sh"])

   Monitor().waitForAbort()
