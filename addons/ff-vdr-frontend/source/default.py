# SPDX-License-Identifier: GPL-2.0

import xbmc, xbmcaddon, os, subprocess
addonIconFile = xbmc.translatePath(os.path.join(xbmcaddon.Addon().getAddonInfo('path'), 'resources', 'icon.png'))
xbmc.executebuiltin('Notification("VDR","Starting VDR-Frontend...",1000,' + addonIconFile + ')')
subprocess.call(['/bin/systemctl', '--no-block', 'start', 'vdr-frontend.service'])
