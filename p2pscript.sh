    #!/bin/bash

    #Enter the shared drive name that you want to mount or contribute to the cloud instance
echo -n "Enter the Network Share Name "
read NETWORKSHARE

# Enter the path to mount the above drive
echo -n "Enter location to mount the Network Share "
read MOUNTPATH

# Need to enter the login details to mount the above drive.. 
# Enter the username of the system from which u shared the drive
echo -n "Enter the username for the Network Share "
read USERNAME

# Enter the password
echo -n "Enter the password for the Network Share "
read PASSWORD

# This command mounts the drive specified above on to the path specified above.
sudo mount -t cifs $NETWORKSHARE $MOUNTPATH -o username=$USERNAME,password=$PASSWORD,iocharset=utf8,file_mode=0777,dir_mode=0777

# Enter the size that you want to contrbute to the Logical Volume or the final cloud instance
echo -n "Enter the partition size in units for the Network Share "
read SIZE

# Create an image file of that size metioned above.
sudo dd if=/dev/zero of=$MOUNTPATH/disk1.img bs=1 count=1024 seek=$SIZE
# Create a loopback device
sudo losetup -f $MOUNTPATH/disk1.img
echo -n "********************************************************************"
echo -n
sudo losetup -a
echo -n "********************************************************************"
# The above command displays the name of the loopback device that is jst created. Then enter the same below.
echo -n
echo -n "Enter the device name that was created using the mount path "
echo $MOUNTPATH
read DEVICENAME
# Commands to remove any missing volumes in the volume group. 
sudo vgreduce stack-volumes --removemissing
# Command to create a physical volume with that network shared device
sudo pvcreate $DEVICENAME
# Command to extend the volume group 'stack-volumes'
sudo vgextend stack-volumes $DEVICENAME
# Command to display the volume group
sudo pvdisplay


