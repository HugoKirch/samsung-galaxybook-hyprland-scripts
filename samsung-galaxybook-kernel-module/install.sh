#! /bin/bash

# This script is used to install the samsung-galaxybook kernel module
# The module implements features unavailable in the mainline kernel
# The module is available at https://github.com/joshuagrisham/samsung-galaxybook-extras

source_dir='/path/to/the/repo/samsung-galaxybook-extras/driver' # change this to the path of the repo

echo "Installing the Samsung Galaxy Book module"

echo "copying the x509 genkey file"

sudo cp x509.genkey /usr/src/linux/certs

echo "Generating the x509 key"

(cd /usr/src/linux/certs; sudo openssl req -new -nodes -utf8 -sha512 -days 36500 -batch -x509 -config x509.genkey -outform DER -out signing_key.x509 -keyout signing_key.pem)

echo "compiling the module"

(cd ${source_dir}; make -C /lib/modules/`uname -r`/build M=$PWD)

echo "installing the module"

(cd ${source_dir}; sudo make -C /lib/modules/`uname -r`/build M=$PWD modules_install)

echo "loading the module"

sudo depmod

sudo modprobe samsung-galaxybook

(echo "samsung-galaxybook" | sudo tee -a /etc/modules)

echo "done"