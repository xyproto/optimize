Optimize
========

Tweak a modern Linux system for better desktop performance.

Pull requests for additional tweaks are welcome!


Requirements
------------

* **bash**
* **<a href="http://setconf.roboticoverlords.org">setconf</a>**, for the configuration-related tweaks


Quick manual installation of setconf
------------------------------------

Download and extract the files to a temporary directory and install the executable and man page. (Run the installation commands as root if you prefer not to use sudo):

```bash
curl -o- http://setconf.roboticoverlords.org/setconf-0.6.2.tar.xz | tar JxC /tmp
sudo install -Dm755 /tmp/setconf-0.6.2/setconf.py /usr/bin/setconf
sudo install -Dm644 /tmp/setconf-0.6.2/setconf.1.gz /usr/share/man/man1/setconf.1.gz
```

setconf comes with a self-test, if you want to check that it is working properly:

```bash
setconf --test
```


Arch Linux installation
------------------------

optimize is available as `optimize-git` on AUR. Install with your favorite AUR helper for an easy installation.

setconf is available as an official package.

