export BAT_THEME="Catppuccin Mocha"
export EDITOR="micro"
export MICRO_TRUECOLOR=1

# Nettoyage
alias cleancache="sudo pacman -Sc"
alias cleanorphans="sudo pacman -Rs $(pacman -Qdtq)"
alias orphans="pacman -Qdtq"

# Sway
alias bar="yazi ~/.config/waybar"
alias conf="yazi .config"
alias sw="micro ~/.config/sway/config"
alias rof="yazi ~/.config/rofi"

# Système
alias batexp="bat ~/Info/ExpList"
alias batlist="bat ~/Info/PkgList"
alias cache="dust .cache"
alias cleantemp="sudo rm -rf /var/cache/pacman/pkg/download-*"
alias conf="yazi .config"
alias error="journalctl -p 3 -xb"
alias mirrors="sudo reflector --country France,Germany --latest 10  --protocol https --sort rate --save /etc/pacman.d/mirrorlist --verbose && sudo pacman -Syyu"
alias rm="trash -v"
alias zshrc="micro .zshrc"

# Utilitaires
alias c="clear"
alias ff="fastfetch"
alias fm="yazi"
alias info="yazi ~/Info"
alias pkglist="pacman -Qqe > ~/Info/ExpList && pacman -Qq > ~/Info/PkgList"
alias todo="calcurse"
alias toshiba="yazi /run/media/bloodsplatts/ToshibaExt4"

# History file for zsh
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

bindkey '^[[3~' delete-char

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh   

eval "$(starship init zsh)"
