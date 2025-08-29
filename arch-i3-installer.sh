#!/bin/bash
# Arch Linux Minimal Installer mit i3 für Low-End Laptops
# inspiriert von Omarchy, angepasst auf i3

set -e

# --- Variablen ---
USERNAME="sonke"   # <--- ändern!
HOSTNAME="archi3"

# --- System Update ---
echo "[*] System aktualisieren..."
pacman -Syu --noconfirm

# --- Basis Tools ---
echo "[*] Basis-Pakete installieren..."
pacman -S --needed --noconfirm \
    base-devel git nano vim sudo \
    networkmanager wget curl htop

# --- Grafik / Xorg ---
echo "[*] Xorg installieren..."
pacman -S --needed --noconfirm \
    xorg-server xorg-xinit xorg-drivers mesa

# --- i3 & Desktop ---
echo "[*] i3 + Tools installieren..."
pacman -S --needed --noconfirm \
    i3-gaps i3status dmenu \
    alacritty feh picom \
    lightdm lightdm-gtk-greeter

# --- Laptop-Optimierungen ---
echo "[*] Laptop-Pakete installieren..."
pacman -S --needed --noconfirm \
    xfce4-power-manager acpi \
    pulseaudio pavucontrol \
    thunar gvfs gvfs-mtp \
    firefox

# --- User Setup ---
echo "[*] Benutzer $USERNAME anlegen..."
if ! id -u "$USERNAME" >/dev/null 2>&1; then
    useradd -m -G wheel -s /bin/bash "$USERNAME"
    echo "Setze Passwort für Benutzer $USERNAME:"
    passwd "$USERNAME"
fi

# --- Sudo-Rechte ---
echo "[*] Sudo konfigurieren..."
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# --- Hostname setzen ---
echo "$HOSTNAME" > /etc/hostname

# --- Services aktivieren ---
echo "[*] Services aktivieren..."
systemctl enable NetworkManager
systemctl enable lightdm

# --- Default .xinitrc ---
echo "[*] Xinit konfigurieren..."
cat <<EOF > /home/$USERNAME/.xinitrc
#!/bin/sh
exec i3
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.xinitrc
chmod +x /home/$USERNAME/.xinitrc

# --- Fertig ---
echo
echo "======================================================"
echo "Installation abgeschlossen!"
echo "Starte neu:   reboot"
echo "Login mit Benutzer: $USERNAME"
echo "i3 startet automatisch mit LightDM."
echo "======================================================"
