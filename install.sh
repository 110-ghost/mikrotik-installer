#!/bin/bash -e

VERSION="7.20.7"
echo "VERSION : $VERSION"
echo
echo "=== GHOST ==="
echo "=== MikroTik Installer ==="
echo

sleep 3



USERNAME="ghost"
PASSWORD='ghost@ghost'

SSH_PORT="2525"
WINBOX_PORT="2526"

wget -4 "https://github.com/110-ghost/mikrotik-installer/releases/download/v7.20.7/chr-7.20.7.img.zip" -O chr.img.zip

gunzip -c chr.img.zip > chr.img

STORAGE=$(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1; exit}')
echo "STORAGE is $STORAGE"

ETH=$(ip route show default | sed -n 's/.* dev \([^ ]*\) .*/\1/p')
echo "ETH is $ETH"

ADDRESS=$(ip -4 addr show "$ETH" | awk '/inet / {print $2; exit}')
echo "ADDRESS is $ADDRESS"

GATEWAY=$(ip route show default | awk '/default/ {print $3; exit}')
echo "GATEWAY is $GATEWAY"

echo
echo "=== Installing MikroTik CHR ==="
echo "IP      : $ADDRESS"
echo "Gateway : $GATEWAY"
echo "SSH     : $SSH_PORT"
echo

# Mount CHR image and create first-boot autorun
LOOP=$(losetup --find --show --partscan chr.img)

sleep 2

echo "Loop device: $LOOP"

# CHR image normally contains a writable partition.
# Find the filesystem partition.
PARTITION="${LOOP}p2"

mkdir -p /mnt/chr

mount "$PARTITION" /mnt/chr

cat > /mnt/chr/autorun.scr <<EOF

# ============================================================
# ghost - Initial Configuration
# ============================================================

# ------------------------------------------------------------
# User
# ------------------------------------------------------------

/user add name=$USERNAME group=full password="$PASSWORD"

/user disable [find name="admin"]

# ------------------------------------------------------------
# SSH
# ------------------------------------------------------------

/ip service set ssh disabled=no port=$SSH_PORT

# ------------------------------------------------------------
# Winbox
# ------------------------------------------------------------

/ip service set winbox disabled=no port=$WINBOX_PORT

# ------------------------------------------------------------
# Disable unnecessary services
# ------------------------------------------------------------

/ip service set telnet disabled=yes
/ip service set ftp disabled=yes
/ip service set www disabled=yes
/ip service set www-ssl disabled=yes
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes

# ------------------------------------------------------------
# Router identity
# ------------------------------------------------------------

/system identity set name="ghost-MikroTik"

# ------------------------------------------------------------
# DNS
# Router can use DNS, but does NOT act as public DNS server
# ------------------------------------------------------------

/ip dns set servers=1.1.1.1,9.9.9.9 allow-remote-requests=no

# ------------------------------------------------------------
# Disable MAC based management
# ------------------------------------------------------------

/tool mac-server set allowed-interface-list=none
/tool mac-server mac-winbox set allowed-interface-list=none

# ------------------------------------------------------------
# Disable Neighbor Discovery
# ------------------------------------------------------------

/ip neighbor discovery-settings set discover-interface-list=none

# ------------------------------------------------------------
# Disable bandwidth server
# ------------------------------------------------------------

/tool bandwidth-server set enabled=no

# ------------------------------------------------------------
# Disable IPv6
# ------------------------------------------------------------

/ipv6 settings set disable-ipv6=yes

# ------------------------------------------------------------
# IPv4 INPUT FIREWALL
#
# Allow:
#   ICMP
#   SSH     TCP/$SSH_PORT
#   Winbox  TCP/$WINBOX_PORT
#
# Drop everything else destined to the router itself.
# ------------------------------------------------------------

/ip firewall filter add chain=input action=accept connection-state=established,related,untracked comment="INPUT - established related untracked"

/ip firewall filter add chain=input action=drop connection-state=invalid comment="INPUT - drop invalid"

/ip firewall filter add chain=input action=accept protocol=icmp comment="INPUT - allow ICMP"

/ip firewall filter add chain=input action=accept protocol=tcp dst-port=$SSH_PORT connection-state=new comment="INPUT - allow SSH"

/ip firewall filter add chain=input action=accept protocol=tcp dst-port=$WINBOX_PORT connection-state=new comment="INPUT - allow Winbox"

/ip firewall filter add chain=input action=drop comment="INPUT - drop everything else"

EOF

sync

umount /mnt/chr
losetup -d "$LOOP"

echo
echo "=== Writing CHR to disk ==="

dd if=chr.img of="/dev/$STORAGE" bs=4M oflag=sync

sync

echo
echo "================================"
echo " MikroTik CHR installation done"
echo "================================"
echo
echo "SSH Port : $SSH_PORT"
echo "Winbox   : $WINBOX_PORT"
echo "Username : $USERNAME"
echo "Password : $PASSWORD"
echo
echo "Rebooting..."
sleep 5

echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
