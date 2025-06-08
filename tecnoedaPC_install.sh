sudo su
wipefs -a /dev/vda
cfdisk /dev/sda
mkfs.btrfs -f /dev/vda2
mkfs.btrfs -f /dev/vda3
mount /dev/sda3 /mnt
mount --mkdir /dev/vda2 /mnt/boot
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
umount -l /mnt
mount -o subvol=@root /dev/vda3 /mnt
mount -o subvol=@home /dev/vda3 /mnt/home
nixos-generate-config --root /mnt
rm -rf /mnt/etc/nixos/configuration.nix
mkdir /mnt/etc/nixos/generated_conf
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/generated_conf/hardware-configuration.nix
cd /mnt/etc/nixos/
git clone https://github.com/D7TUN6/tecnoedaPC.git
mv tecnoedaPC/* /mnt/etc/nixos
rm -rf /mnt/etc/nixos/tecnoedaPC
mv /mnt/etc/nixos/generated_conf/hardware-configuration.nix /mnt/etc/nixos/
rm -rf /mnt/etc/nixos/generated_conf
nixos-install --flake /mnt/etc/nixos#tecnoedaPC
