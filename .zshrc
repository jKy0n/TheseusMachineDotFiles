#
#
# export GTK_THEME=Catppuccin-Dark-Macchiato
#export QT_QPA_PLATFORMTHEME="qt5ct"

export EDITOR=nvim
export VISUAL=nvim
#export DISTCC_JOBS=28

export TMUX_POWERLINE_THEME=my-theme
export TMUX_POWERLINE_DIR_USER_THEMES="~/.dotfiles/.config/tmux-powerline/themes/"
export TMUX_POWERLINE_SEG_WEATHER_LAT="-24.012042"
export TMUX_POWERLINE_SEG_WEATHER_LON="-46.404200"

source /home/jkyon/.dotfiles/.zshrc_secret

# The following lines were added by compinstall   
zstyle :compinstall filename '/home/jkyon/.zshrc'


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.       
# Initialization code that may require console input (password prompts, [y/n]          
# confirmations, etc.) must go above this block; everything else may go below.         
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then 
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"          
fi                                                                                     


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

# Compinit and completion setup
autoload -Uz compinit
compinit
setopt COMPLETE_ALIASES
# End of lines added by compinstall


zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
'+l:|?=** r:|?=**'


# Add color to zsh (not shure if working
# remove ls highlight color
_ls_colors=":ow=01;33"
zstyle ':completion:*:default' list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors


# Verificar se a variável de ambiente específica da distribuição está definida
if [[ "$(cat /etc/*-release)" == *"Gentoo"* ]]; then
    # Configurações específicas para o Gentoo
    source /usr/share/zsh/site-functions/powerlevel10k/powerlevel10k.zsh-theme
elif [[ "$(cat /etc/*-release)" == *"Arch Linux"* ]]; then
    # Configurações específicas para o Arch Linux
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# elif [[ "$(tty)" == "/dev/tty1" ]]; then
#     # Configurações específicas para o tty
#     source /home/jkyon/powerlevel10k.config/jkyon/tty/powerlevel10k.zsh-them
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Verificar se a variável de ambiente específica da distribuição está definida
if [[ "$(cat /etc/*-release)" == *"Gentoo"* ]]; then
    # Configurações específicas para o Gentoo
    source /usr/share/zsh/site-functions/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
    source /usr/share/zsh/site-functions/zsh-history-substring-search.zsh
    source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
    source ~/.dotfiles/.config/zsh/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh

elif [[ "$(cat /etc/*-release)" == *"Arch Linux"* ]]; then
    # Configurações específicas para o Arch Linux
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi


# typeset -g POWERLEVEL9K_INSTANT_PROMPT=off


# Load Aliases list
alias show-alias='bat --color=always ~/ShellScript/aliases.sh'
source ~/ShellScript/aliases.sh


# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line              
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line                    
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode                 
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char           
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char                    
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history             
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history           
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char                  
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char                   
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history 
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history       
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete          

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# History Search with arrow keys
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Enable autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# Use the suggestions
bindkey '^[[C' autosuggest-accept


# Jump words with Ctrl + arrowKeys
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word



# Alacritty window name
if [[ "${TERM}" != "" && "${TERM}" == "alacritty" ]]
then
    precmd()
    {
        # output on which level (%L) this shell is running on.
        # append the current directory (%~), substitute home directories with a tilde.
        # "\a" bell (man 2 echo)
        # "print" must be used here; echo cannot handle prompt expansions (%L)
        # print -Pn "\e]1;$(id --user --name)@$(hostname): zsh[%L] %~\a"
        # print -Pn "\e]1;$(id --user --name): zsh[%L] %~\a"
        print -Pn "\e]1;Alacritty - zsh[%L] %~ - job #${job_count}\a"
    }

    preexec()
    {
        # output current executed command with parameters
        # echo -en "\e]1;$(id --user --name)@$(hostname): ${1}\a"
        #echo -en "\e]1;$(id --user --name): ${1}\a"
        echo -en "\e]1;Alacritty - ${1}\a"
    }
fi


# Start tmux by default
[[ -z $TMUX ]] && exec tmux
