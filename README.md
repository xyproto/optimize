Optimize
========

Tweak a modern Linux system for better desktop performance.

Pull requests for additional tweaks are welcome!


Requirements
------------

* **<a href="http://setconf.roboticoverlords.org">setconf</a>**, for the configuration-related tweaks
* **pacman**, for the pacman-related tweaks


Quick installation of setconf, if you don't have it on your system
-------------------------------------------------------------------

* For Arch Linux:

```bash
pacman -S setconf
```

* For other systems:

** Download and extract the files to a temporary directory:

```bash
curl -o- http://setconf.roboticoverlords.org/setconf-0.6.2.tar.xz | tar JxC /tmp
```

** Install setconf (become root first and don't use "sudo", if you prefer):

```bash
sudo install -Dm755 /tmp/setconf-0.6.2/setconf.py /usr/bin/setconf
sudo install -Dm755 /tmp/setconf-0.6.2/setconf.1 /usr/share/man/man1/setconf.1
sudo gzip /usr/share/man/man1/setconf.1
```
