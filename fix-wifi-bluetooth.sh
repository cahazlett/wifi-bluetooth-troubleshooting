#!/bin/bash
# Script to restore working Wi-Fi (MT7922) and Bluetooth on Ubuntu

echo "Restoring Wi-Fi and Bluetooth configuration..."

# Step 1: Set up kernel module options
echo "options mt7921e disable_aspm=1" | sudo tee /etc/modprobe.d/mt7921e.conf
echo "options btusb enable_autosuspend=0" | sudo tee /etc/modprobe.d/btusb-nosuspend.conf

# Step 2: Update initramfs for changes
sudo update-initramfs -u

# Step 3: Disable Wi-Fi power save settings
echo "[connection]
wifi.powersave = 2" | sudo tee /etc/NetworkManager/conf.d/wifi-powersave.conf

# Step 4: Set the correct regulatory domain (example: US)
sudo iw reg set US

# Step 5: Restart NetworkManager and Bluetooth services
sudo systemctl restart NetworkManager
sudo systemctl stop bluetooth
sudo systemctl start bluetooth

# Step 6: Reload Wi-Fi and Bluetooth modules
nmcli radio wifi off
sudo modprobe -r btusb btmtk mt7921e mt7921_common mt76_connac_lib mt76
sudo modprobe mt7921e disable_aspm=1
sudo modprobe btusb enable_autosuspend=0
nmcli radio wifi on

# Step 7: Reconnect to Wi-Fi
# Replace YOUR_WIFI_SSID with your actual network name
nmcli con down YOUR_WIFI_SSID && nmcli con up YOUR_WIFI_SSID

echo "✅ Configuration restored. Wi-Fi and Bluetooth should now be working!"
