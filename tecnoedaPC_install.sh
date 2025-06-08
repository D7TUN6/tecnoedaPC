# Execute all commands from root user
#sudo su

# List disks
lsblk

# Prompt user for disk
read -p "Please select your disk: (e.g: /dev/sda)" disk

# Check for disk correct format
if [[ ! "$disk" =~ ^/dev/[a-z]+[a-z0-9]*$ ]]; then
  echo "ERROR: incorrect disk format. Use /dev/diskname"
  exit 1
fi

# Calculate disk parts names
if [[ "$disk" =~ /dev/nvme[0-9]+n[0-9]+$ ]] || [[ "disk" =~ /dev/mmcblk[0-9]+$ ]]; then
  part1="${disk}p1"
  part2="${disk}p2"
else
  part1="${disk}1"
  part2="${disk}2"
fi

# Last warning
#echo "WARNING: ALL DATA ON DISK $disk WILL BE DESTROYED!"
#read -p "Are you sure? (y/n): " confirm
#if [[ "{$confirm,,}" != "y" ]]; then
#  echo "Installation cancelled."
#  exit 1
#fi

# Partioning disk
parted "$disk" --script mklabel gpt
parted "$disk" --script mkpart primary 1MiB 33MiB
parted "$disk" --script set 1 bios_grub on
parted "$disk" --script mkpart primary 33MiB 100%

# Format and mount disk
mkfs.btrfs -f "$part2"
mount "$part2" /mnt
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@boot
umount -l /mnt
mount --mkdir -o subvol=@root "$part2" /mnt
mount --mkdir -o subvol=@home "$part2" /mnt/home
mount --mkdir -o subvol=@boot "$part2" /mnt/boot

# Generate config (hardware-configuration.nix only)
nixos-generate-config --root /mnt
rm -rf /mnt/etc/nixos/configuration.nix
mkdir /mnt/etc/nixos/generated_conf
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/generated_conf/hardware-configuration.nix
cd /mnt/etc/nixos/

# Get the configuration from github.com and install it
git clone https://github.com/D7TUN6/tecnoedaPC.git
mv tecnoedaPC/* /mnt/etc/nixos
rm -rf /mnt/etc/nixos/tecnoedaPC
mv /mnt/etc/nixos/generated_conf/hardware-configuration.nix /mnt/etc/nixos/
rm -rf /mnt/etc/nixos/generated_conf

# Install NixOS
nixos-install --flake /mnt/etc/nixos#tecnoedaPC

# Umount partitions
umount -l /mnt/boot
umount -l /mnt/home
umount -l /mnt/

# Goodbye message if installation is success
echo "Installation finished, enjoy your NixOS"
