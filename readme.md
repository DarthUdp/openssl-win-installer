# OpenSSL installer for windows
Easy install of OpenSSL for windows using the binaries provided by the
[curl for windows](https://github.com/curl/curl-for-win) project, this repo
contains a python script, an NSIS script and a .bat file to setup an
evironment for easier windows usage.

These generate unmodified installers made directly from the files available
from the project's app veyor retrieved via API, and should be reproductible.

# Building
To build the installer you will need NSIS 3.06.1 or later and Python 3.6 or later
- not required but suggested, create a virtual environment to install the python dependencies to
- install all dependencies listed in requirements.txt with `pip install -r requirements.txt`
- rename settings.tamplate.yml to settings.yml
- run make_installer.py

You should now have an installer that you can use or distribute, enjoy! :^)

# License
The NSIS source script, python build helper and bat file are hebreby released to the
public domain.

the openssl source and or binaries are under their own license
found in the LICENSE.txt of an installation or in the downloaded zip file in
the dl folder and the expanded openssl folder.
