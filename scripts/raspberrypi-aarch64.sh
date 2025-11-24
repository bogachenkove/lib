#!/bin/bash

# Raspberry Pi aarch64
# Author: Bogachenko Vyacheslav <bogachenkove@gmail.com>
# License: MIT license <https://raw.githubusercontent.com/bogachenko/lib/master/LICENSE.md>
# Last update: November 2025

echo NETWORK INFORMATION RETRIEVAL.
echo Running a script to get information about the network in the operating system.
if ping -c 1 "1.1.1.1" >/dev/null; then
    echo "Internet connection detected. Proceeding with the script."
else
    echo "No internet connection detected. Exiting script."
    exit 1
fi

echo SUPERUSER RIGHTS RETRIEVAL.
if [[ $(id -u) -ne 0 ]]; then
    echo "Running a script to obtain superuser rights in the operating system."
    exit 1
fi

# Configuring APT files
curl -o ~/00-apt-conf https://raw.githubusercontent.com/bogachenko/lib/master/config/raspberrypi-aarch64/00-apt-conf;sudo mv ~/00-apt-conf /etc/apt/apt.conf.d/00-apt-conf

# Configuring localization files
sudo sh -c "echo \"en_US.UTF-8 UTF-8\" > /etc/locale.gen";sudo locale-gen >> /dev/null;sudo sh -c "echo \"en_US.UTF-8 UTF-8\" > /etc/default/locale";echo 'LANG=en_US.UTF-8' | sudo tee -a /etc/environment;echo 'LC_ALL=en_US.UTF-8' | sudo tee -a /etc/environment

echo 'Updating the package list.'
sudo apt update && sudo apt upgrade

echo 'Installing the core packages.'
sudo apt install --no-install-recommends --no-install-suggests --yes \
 xorg mesa-utils lm-sensors htop ufw gpm apache2 cmake plymouth vim git lshw dnsmasq hostapd \
 encfs cryfs whois default-jre-headless lsof
echo 'Installing the sub-core packages.'
sudo apt install --no-install-recommends --no-install-suggests --yes \
 wireplumber pipewire pipewire-jack pipewire-alsa pipewire-pulse ffmpeg i2pd tor obfs4proxy privoxy \
 fonts-ubuntu fonts-noto-color-emoji fonts-noto-mono fonts-noto fonts-liberation fonts-dejavu \
 fonts-noto-cjk ttf-mscorefonts-installer fonts-font-awesome ranger realvnc-vnc-server realvnc-vnc-viewer
echo 'Installing the extra packages.'
sudo apt install --no-install-recommends --no-install-suggests --yes \
 tmux firefox chromium vlc scrot rxvt-unicode speedtest-cli retroarch yt-dlp transmission-cli sddm \
 awesome feh
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardVPNCLI/HEAD/scripts/release/install.sh | sh -s -- -v
curl -fsSL https://raw.githubusercontent.com/AdguardTeam/AdGuardCLI/release/install.sh | sh -s -- -v

echo 'Enabling firewall rules.'
sudo rm -r /etc/ufw/applications.d/*
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp           # SSH
sudo ufw allow 443              # HTTPS/DNSCrypt
sudo ufw allow 465              # SMTP
sudo ufw allow 53               # DNS
sudo ufw allow 631/tcp          # Internet Printing Protocol
sudo ufw allow 67/udp           # DHCP server v4
sudo ufw allow 68/udp           # DHCP client v4
sudo ufw allow 546/udp          # DHCP client v6
sudo ufw allow 547/udp          # DHCP server v6
sudo ufw allow 80               # HTTP
sudo ufw allow 8080             # Apache
sudo ufw allow 8081             # AdGuardHome control panel
#sudo ufw allow 3129             # AdGuard HTTP
#sudo ufw allow 1081             # AdGuard SOCKS5
sudo ufw allow 8118/tcp         # Privoxy
sudo ufw allow 853              # DoT/DoQ
sudo ufw allow 9050/tcp         # TOR
sudo ufw allow 993              # IMAPS
sudo ufw enable

echo 'Enabling services.'
enable_services=(
 vncserver-virtuald
 vncserver-x11-serviced
)
disable_services=(
  dnsmasq
  hostapd
)
for service in "${enable_services[@]}"; do
  sudo systemctl enable "${service}.service"
done
for service in "${disable_services[@]}"; do
  sudo systemctl disable "${service}.service"
done
