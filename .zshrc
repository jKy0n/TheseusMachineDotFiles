# Define o diretório onde os arquivos de configuração estão localizados
ZSHRC_D="$HOME/.zshrc.d"

# Detecta a distribuição ou se está no TTY e carrega o arquivo correspondente
if [[ "$(tty)" == "/dev/tty1" ]]; then
    [ -r "$ZSHRC_D/zshrc.tty" ] && source "$ZSHRC_D/zshrc.tty"
else
    case "$(cat /etc/*-release)" in
        *Gentoo*) [ -r "$ZSHRC_D/zshrc.gentoo" ] && source "$ZSHRC_D/zshrc.gentoo" ;;
        *Arch*) [ -r "$ZSHRC_D/zshrc.arch" ] && source "$ZSHRC_D/zshrc.arch" ;;
        *) echo "Configuração padrão não encontrada para esta distribuição. Configure manualmente." ;;
    esac
fi


# Iniciar o Tmux automaticamente, se não estiver dentro de uma sessão
if [[ -t 1 ]]; then
    if command -v tmux >/dev/null 2>&1; then
        if [[ -z "$TMUX" ]]; then
            # Cria uma nova sessão numerada sempre
            tmux new-session
        fi
    fi
fi