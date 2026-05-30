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

# --- 1.Mise à jour de la liste des miroirs --- #
echo -e "${JAUNE}Mise à jour de la liste des miroirs${NC}\n"

pacman -S --needed --noconfirm reflector
reflector --country France,Germany --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose

echo -e "${VERT}✓ Liste des miroirs optimisée.${NC}\n"

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

# --- 3.Installation des pilotes de la carte graphique --- #
 PAQUETS_AMD=(
	"lib32-mesa"
	"lib32-vulkan-radeon"
	"mesa" 
	"opencl-mesa"
	"vulkan-radeon" 
	"xf86-video-amdgpu" 	 
)	
 
echo -e "${JAUNE}Installation des pilotes de la carte graphique${NC}\n"

if pacman -S --needed --noconfirm "${PAQUETS_AMD[@]}"; then
    echo -e "${VERT}✓ Pilotes de la carte graphique installés avec succès.${NC}"
else
    echo -e "${ROUGE}✗ Échec de l'installation.${NC}"
    exit 1
fi

# --- 4.Installation de Sway --- #
 PAQUETS_DE=(
	"autotiling" 
	"flameshot" 
	"foot" 
	"gammastep" 
	"grim" 
	"mako" 
	"pavucontrol" 
	"polkit" 
	"polkit-gnome"  
	"rofi" 
	"slurp" 
	"sway" 
	"swaybg" 
	"swayidle" 
	"swaylock" 
	"swayosd" 
	"waybar" 
	"wl-clipboard" 
	"wmenu" 
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

# --- 5.Installation des paquets multimedia --- #
PAQUETS_MULTIMEDIA=(
	"amberol" 
	"discord" 
	"firefox" 
	"gamemode" 
	"guitarix" 
	"helvum" 
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

# --- 6.Installation des utilitaires --- #
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
	"libappindicator-gtk3" 
	"libmtp"
	"loupe" 
	"lxappearance" 
	"micro" 
	"network-manager-applet" 
	"pacman-contrib" 
	"papers" 
	"realtime-privileges" 
	"reflector" 
	"sof-firmware" 
	"starship"
	"testdisk" 
	"timeshift" 
	"trash-cli" 
	"ufw" 
	"unzip"
	"usbutils"
	"wev"
	"wget" 
	"xarchiver"
	"xdg-utils" 
	"yazi" 
	"zip"
	"zsh" 
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

# --- 7.Installation des thèmes et des polices --- #
PAQUETS_THEMES=(
	"breeze-cursors" 
	"papirus-icon-theme" 
	"ttf-jetbrains-mono-nerd" 
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

# --- 8.Activation des services --- #
echo -e "${JAUNE}Activation des services${NC}\n"

# Activation de UFW
if ! systemctl is-active --quiet ufw.service; then
    echo "Activation du pare-feu UFW..."
    systemctl enable --now ufw.service
else
    echo "Le service UFW est déjà actif."
fi

# Activation de LACT
if ! systemctl is-active --quiet lactd.service; then
    echo "Activation du service LACT (gestion GPU)..."
    systemctl enable --now lactd.service
else
    echo "Le service LACT est déjà actif."
fi

echo -e "${VERT}✓ Services système configurés.${NC}\n"

# --- 9.Changement de shell pour Zsh --- #
echo -e "${JAUNE}Configuration du shell Zsh${NC}\n"
UTILISATEUR=${SUDO_USER:-$USER}

if getent passwd "$UTILISATEUR" | grep -q "/bin/zsh$"; then
    echo -e "${VERT}✓ Le shell est déjà Zsh pour $UTILISATEUR. Aucune action requise.${NC}"
else
    echo "Changement du shell vers Zsh..."
    chsh -s /bin/zsh "$UTILISATEUR"
    echo -e "${VERT}✓ Shell changé avec succès.${NC}"
fi

# --- 10.Ajout de l'utilisateur aux groupes --- #
echo -e "\n${JAUNE}Configuration des groupes utilisateur...${NC}"
UTILISATEUR=${SUDO_USER:-$USER}

usermod -aG audio,gamemode,realtime "$UTILISATEUR"

echo -e "${VERT}✓ Utilisateur ajouté aux groupes.${NC}\n"

echo -e "${JAUNE}Note : Un redémarrage est nécessaire pour appliquer les changements.${NC}"   

if [ -t 0 ]; then
    read -p "Installation terminée appuyez sur Entrée pour quitter... "
fi 
