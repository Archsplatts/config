#!/bin/bash

set -e

# Définition des couleurs
VERT='\033[0;32m'
ROUGE='\033[0;31m'
JAUNE='\033[1;33m'
NC='\033[0m'

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${ROUGE}Veuillez lancer ce script avec sudo ou en root.${NC}"
  exit 1
fi   

USER="$SUDO_USER"

echo -e "${VERT}                                   ▄▄                    ${NC}"
echo -e "${VERT}                  █▄                ██       █▄  █▄      ${NC}"
echo -e "${VERT}       ▄          ██                ██      ▄██▄▄██▄     ${NC}"
echo -e "${VERT} ▄▀▀█▄ ████▄▄███▀ ████▄ ▄██▀█ ████▄ ██ ▄▀▀█▄ ██  ██ ▄██▀█${NC}"
echo -e "${VERT} ▄█▀██ ██   ██    ██ ██ ▀███▄ ██ ██ ██ ▄█▀██ ██  ██ ▀███▄${NC}"
echo -e "${VERT}▄▀█▄██▄█▀  ▄▀███▄▄██ ███▄▄██▀▄████▀▄██▄▀█▄██▄██ ▄███▄▄██▀${NC}"
echo -e "${VERT}                              ██                         ${NC}"
echo -e "${VERT}                              ▀                          ${NC}"

echo -e "${JAUNE}Bienvenue dans le script de configuration Archsplatts !${NC}\n"

if [ -t 0 ]; then
    read -p "Appuyez sur Entrée pour continuer... "
fi   

#!/bin/bash

 # --- 1.Reflector --- #
echo -e "${JAUNE}Mise à jour de la liste des miroirs${NC}\n"

if ! pacman -S --needed --noconfirm reflector; then
    echo -e "${ROUGE}Échec de l'installation de reflector.${NC}"
    exit 1
fi

if [[ -f /etc/pacman.d/mirrorlist ]]; then
    cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak."$(date +%F)"
    echo -e "${JAUNE}Sauvegarde créée : mirrorlist.bak.$(date +%F)${NC}"
fi

if reflector --country France,Germany --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose; then
	echo -e "${VERT}✓ Liste des miroirs optimisée.${NC}\n"
else
    echo -e "${ROUGE}⚠ Erreur lors de la génération de la liste des miroirs.${NC}"
    exit 1
fi

#!/bin/bash

# --- 2.Activation du dépôt multilib et mise à jour du système --- #
echo -e "${JAUNE}Activation du dépôt multilib${NC}\n"

cp /etc/pacman.conf /etc/pacman.conf.backup

if grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "${VERT}✓ Dépôt multilib déjà activé.${NC}\n"
else
    sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
    
    # Vérifier que ça a marché
    if grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo -e "${VERT}✓ Dépôt multilib activé avec succès.${NC}\n"
    else
        echo -e "${ROUGE}✗ Erreur lors de l'activation de multilib.${NC}"
        mv /etc/pacman.conf.backup /etc/pacman.conf
        exit 1
    fi
fi

echo -e "${JAUNE}Mise à jour d'Arch Linux${NC}\n"

if pacman -Syyu --noconfirm; then
    echo -e "${VERT}✓ Mise à jour terminée avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de la mise à jour.${NC}"
    exit 1
fi

#!/bin/bash

# --- 3.Installation des pilotes de la carte graphique --- #
 PAQUETS_AMD=(
	"lib32-mesa"
	"lib32-vulkan-icd-loader"
	"lib32-vulkan-radeon"
	"mesa" 
	"vulkan-icd-loader"
	"vulkan-radeon"
)
 
echo -e "${JAUNE}Installation des pilotes de la carte graphique${NC}\n"

if pacman -S --needed --noconfirm "${PAQUETS_AMD[@]}"; then
    echo -e "${VERT}✓ Pilotes de la carte graphique installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

# --- 4.Installation de Sway --- #
 PAQUETS_DE=(
	"autotiling" 
	"brightnessctl"
	"flameshot" 
	"foot"
	"gammastep" 
	"grim"
	"mako"
	"pavucontrol"
	"polkit" 
	"polkit-gnome"  
	"qt6-wayland"
	"rofi" 
	"sddm"
	"sddm-kcm"
	"slurp"
	"sway"
	"swaybg"
	"swayidle"
	"swaylock"
	"swayosd" 
	"thunar"
	"thunar-archive-plugin"
	"thunar-volman"
	"waybar"
	"wmenu"
	"wl-clipboard" 
	"xdg-desktop-portal-gtk" 
	"xdg-desktop-portal-wlr" 
	"xorg-xwayland"
)

echo -e "${JAUNE}Installation de l'environnement de bureau${NC}\n"

if pacman -S --needed --noconfirm "${PAQUETS_DE[@]}"; then
    echo -e "${VERT}✓ Environnement de bureau installé avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

# --- 5.Installation des paquets M.A.O --- #
PAQUETS_MAO=(
 	"guitarix" 
	"helvum" 
	"reaper"
)

echo -e "${JAUNE}Installation des paquets M.A.O${NC}\n"
  
if pacman -S --needed --noconfirm "${PAQUETS_MAO[@]}"; then
    echo -e "${VERT}✓ Paquets M.A.O installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

# --- 6.Installation des paquets multimedia --- #
PAQUETS_MULTIMEDIA=(
	"amberol" 
	"discord" 
	"ffmpeg"
	"firefox" 
	"gamemode" 
	"gst-libav"
	"gst-plugins-bad"
	"gst-plugins-base" 
	"gst-plugins-good" 
	"gst-plugins-ugly"
	"lib32-gamemode"
	"lib32-mangohud" 
	"mangohud"
	"showtime" 
	"steam" 
	"thunderbird" 
	"transmission-gtk"
)

echo -e "${JAUNE}Installation des paquets multimedia${NC}\n"
  
if pacman -S --needed --noconfirm "${PAQUETS_MULTIMEDIA[@]}"; then
    echo -e "${VERT}✓ Paquets multimedia installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

# --- 7.Installation des utilitaires --- #
PAQUETS_UTILS=(
	"7zip" 
	"arch-wiki-docs"
	"base-devel"
	"bat" 
	"bleachbit" 
	"btop" 
	"calcurse"
	"chafa" 
	"cpupower" 
	"dust" 
	"fastfetch" 
	"galculator"
	"geany" 
	"git"
	"gnome-clocks" 
	"gvfs"
	"gvfs-mtp" 
	"imagemagick" 
	"impression" 
	"lact" 
	"libappindicator" 
	"libmtp"
	"loupe" 
	"lxappearance" 
	"micro" 
	"network-manager-applet" 
	"pacman-contrib" 
	"papers" 
	"realtime-privileges" 
 	"starship"
 	"timeshift" 
	"trash-cli" 
	"ufw" 
	"unzip"
	"wev"
	"wget" 
	"xarchiver"
	"xdg-utils" 
	"yazi" 
	"zip"
	"zsh-autosuggestions" 
	"zsh-completions" 
	"zsh-history-substring-search" 
	"zsh-syntax-highlighting"
)

echo -e "${JAUNE}Installation des utilitaires${NC}\n"

if pacman -S --needed --noconfirm "${PAQUETS_UTILS[@]}"; then
    echo -e "${VERT}✓ Utilitaires installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

# --- 8.Installation des thèmes et des polices --- #
PAQUETS_THEMES=(
	"breeze-cursors" 
	"noto-fonts"
	"noto-fonts-emoji"
	"papirus-icon-theme" 
	"ttf-hack-nerd"
	"ttf-jetbrains-mono-nerd" 
	"ttf-nerd-fonts-symbols"
	"ttf-nerd-fonts-symbols-common"
	"ttf-ubuntu-font-family" 
	"ttf-ubuntu-mono-nerd"
)

echo -e "${JAUNE}Installation des thèmes et des polices${NC}\n"

if pacman -S --needed --noconfirm "${PAQUETS_THEMES[@]}"; then
    echo -e "${VERT}✓ Thèmes et polices installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

#!/bin/bash

USER="${SUDO_USER:-$(whoami)}"

# --- 9. Installation de Yay (AUR Helper) --- #
echo -e "\n${JAUNE}Installation de Yay (AUR Helper)${NC}\n"

# Vérifier que USER n'est pas vide et n'est pas root
if [[ -z "$USER" || "$USER" == "root" ]]; then
    echo -e "${ROUGE}✗ Erreur : Yay ne peut pas être installé en tant que root.${NC}"
    exit 1
fi

if ! sudo -u "$USER" command -v yay &> /dev/null; then
    echo "Installation des prérequis (git, base-devel)..."
    pacman -S --needed --noconfirm git base-devel
    
    echo "Clonage et compilation de yay pour l'utilisateur $USER..."
    
    # Créer un répertoire temporaire sécurisé
    TEMP_DIR=$(sudo -u "$USER" mktemp -d) || exit 1
    trap "sudo rm -rf '$TEMP_DIR'" EXIT
    
    if ! sudo -u "$USER" git clone https://aur.archlinux.org/yay.git "$TEMP_DIR/yay"; then
        echo -e "${ROUGE}✗ Échec du clonage du dépôt.${NC}"
        exit 1
    fi
    
    if sudo -u "$USER" bash -c "cd '$TEMP_DIR/yay' && makepkg -si --noconfirm"; then
        echo -e "${VERT}✓ Yay installé avec succès.${NC}"
    else
        echo -e "${ROUGE}✗ Échec de l'installation de Yay.${NC}"
        echo "Note: Assurez-vous que l'utilisateur $USER a les droits sudo pour pacman/makepkg."
        exit 1
    fi
else
    echo -e "${VERT}✓ Yay est déjà installé pour $USER.${NC}"
fi

#!/bin/bash

# --- 10.Activation des services système--- #
echo -e "${JAUNE}Activation des services${NC}\n"

# UFW (Pare-feu) - Service Système
echo "Activation du pare-feu UFW..."

ufw default deny incoming
ufw default allow outgoing

systemctl enable --now ufw.service
echo -e "${VERT}✓ UFW activé.${NC}"

# LACT (Contrôleur AMD) - Service Système
echo "Activation du service LACT..."
systemctl enable --now lactd.service
echo -e "${VERT}✓ LACT activé.${NC}"

echo -e "${VERT}✓ Tous les services système ont été activés avec succès.${NC}\n"

#!/bin/bash

# --- 11.Configuration du shell ---#
echo -e "${JAUNE}Configuration du shell Zsh${NC}\n"

if getent passwd "$USER" | grep -q "/bin/zsh$"; then
    echo -e "${VERT}✓ Le shell est déjà Zsh pour $USER. Aucune action requise.${NC}"
else
    echo "Changement du shell vers Zsh..."
    chsh -s /bin/zsh "$USER"
    echo -e "${VERT}✓ Shell changé avec succès.${NC}"
fi

#!/bin/bash

# --- 12.Ajout de l'utilisateur aux groupes --- #
echo -e "\n${JAUNE}Configuration des groupes utilisateur${NC}"

usermod -aG audio,input,gamemode,realtime,render,video "$USER"

echo -e "${VERT}✓ Utilisateur ajouté aux groupes.${NC}\n"
