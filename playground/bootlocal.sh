#!/bin/sh
#
# This script is not necessary if you have Docker and want to try out
# the network playground.  In that case, simply run "./build.sh" and
# then "./launch.sh" and finally something like "./play.sh h1" in this
# directory and you should be off and running.
#
# The purpose of this script, by contrast, is to run the second of the
# above commands inside of the "boot2docker" virtual machine image that
# this project distributes to make the network playground easy to launch
# for people without Linux or any Docker experience.  When placed in the
# special location "/var/lib/boot2dockern/bootlocal.sh" and marked as
# executable inside of a "boot2docker" virtual machine, this script will
# start up the playground whenever the machine is booted.

# To get a "boot2docker" image ready with this script installed, "ssh"
# to it and run:
#
#     $ cd /var/lib/boot2docker
#     $ sudo wget ftp://ftp.nl.netbsd.org/vol/2/metalab/distributions/tinycorelinux/4.x/x86/tcz/bridge-utils.tcz
#     $ git clone https://github.com/brandon-rhodes/fopnp.git
#     $ sudo mkdir fopnp
#     $ sudo chown docker.staff fopnp
#     $ sudo cp fopnp/playground/bootlocal.sh .
#     $ fopnp/playground/build.sh
#
# You can then reboot the image and the playground should be available
# every time it starts, perhaps with a minute delay while the launch
# script finishes running.

exec &> /var/lib/boot2docker/bootlocal.log
rm -f /home/docker/'boot2docker, please format-me'
touch /home/docker/playground-is-starting-up

# Install the "brctl" command, which will disappear every time the
# "boot2docker" image is rebooted, directly from an image we keep here
# in the persistent directory.  (Letting "./launch.sh" do the install
# would instead try to download it afresh every time we boot.)

cd /var/lib/boot2docker
sudo -u docker tce-load -i bridge-utils.tcz

# Launch the machine images and configure the network.

cd fopnp/playground
sh -v ./launch.sh

# Give the user a convenient symlink to the "fopnp" repository.  We do
# this last, as a signal to the user that the playground has finished
# being set up.

ln -s /var/lib/boot2docker/fopnp /home/docker
ln -s /var/lib/boot2docker/fopnp/playground/play.sh /home/docker/play.sh
rm -f /home/docker/playground-is-starting-up