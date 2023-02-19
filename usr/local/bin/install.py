import os.path
import subprocess
from os import path

if path.isfile('/etc/installed.lock'):
    print("installed")
else:
    subprocess.call("gnome-terminal -- \"/usr/local/bin/installstuff.sh\"")