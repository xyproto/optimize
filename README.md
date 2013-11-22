Optimize
========

Tweak a modern Linux system for better desktop performance.

Pull requests for additional tweaks are welcome!


Requirements
------------

* **bash**
* **<a href="http://setconf.roboticoverlords.org">setconf</a>**, for the configuration-related tweaks


Quick installation of setconf
-----------------------------

For Arch Linux:

```bash
pacman -S setconf
```

For other systems:

* Download and extract the files to a temporary directory and install the executable and man page. (Run the three last commands as root if you prefer not to use sudo):

```bash
curl -o- http://setconf.roboticoverlords.org/setconf-0.6.2.tar.xz | tar JxC /tmp
sudo install -Dm755 /tmp/setconf-0.6.2/setconf.py /usr/bin/setconf
sudo install -Dm755 /tmp/setconf-0.6.2/setconf.1 /usr/share/man/man1/setconf.1
sudo gzip /usr/share/man/man1/setconf.1
```
