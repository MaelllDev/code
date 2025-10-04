#!/bin/bash
# ==========================================
# Script de instalação do Playit
# Criado por: maelldev
# GitHub: github.com/maelldev
# ==========================================

set -e  # Para o script se houver algum erro

# Função para limpar e sair em caso de erro
cleanup_on_error() {
    tput setaf 1
    printf "\n❌ Erro durante a instalação!\n"
    tput setaf 3
    printf "Por favor, verifique sua conexão e permissões.\n"
    tput sgr0
    exit 1
}

# Configura trap para capturar erros
trap cleanup_on_error ERR

# Função para verificar se está rodando como root
check_sudo() {
    if [ "$EUID" -eq 0 ]; then 
        tput setaf 1
        printf "⚠️  Não execute este script como root diretamente!\n"
        tput setaf 3
        printf "Execute como usuário normal. O script usará sudo quando necessário.\n"
        tput sgr0
        exit 1
    fi
}

# Função para verificar dependências
check_dependencies() {
    local deps=("curl" "gpg" "apt")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        tput setaf 1
        printf "❌ Dependências faltando: ${missing[*]}\n"
        tput setaf 3
        printf "Instale-as com: sudo apt install ${missing[*]}\n"
        tput sgr0
        exit 1
    fi
}

# Função para texto animado
print_animated() {
    local text="$1"
    local color="$2"
    tput setaf "$color"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep 0.02
    done
    tput sgr0
    printf "\n"
}

# Função para barra de progresso
progress_bar() {
    tput setaf 6
    printf "["
    for i in {1..30}; do
        printf "="
        sleep 0.03
    done
    printf "]"
    tput setaf 2
    printf " ✓\n"
    tput sgr0
}

# Função para executar comandos com tratamento de erros
run_command() {
    local description="$1"
    local command="$2"
    
    if eval "$command"; then
        return 0
    else
        tput setaf 1
        printf "\n❌ Falha: %s\n" "$description"
        tput sgr0
        return 1
    fi
}

# Banner inicial
clear
tput setaf 5
printf "╔═════════════════════════════════════════╗\n"
printf "║                                         ║\n"
printf "║      PLAYIT INSTALLER v1.0              ║\n"
printf "║      Tunnel Service - Setup             ║\n"
printf "║                                         ║\n"
printf "║      Script por: maelldev               ║\n"
printf "║                                         ║\n"
printf "╚═════════════════════════════════════════╝\n"
tput sgr0
printf "\n"

tput setaf 3
printf "⚡ Este script irá instalar o Playit no seu sistema\n"
tput sgr0
printf "\n"

# Verificações iniciais
tput setaf 6
printf "🔍 Verificando sistema...\n"
tput sgr0
check_sudo
check_dependencies
tput setaf 2
printf "✓ Sistema compatível\n"
tput sgr0
printf "\n"

tput setaf 6
printf "Pressione "
tput bold
printf "ENTER"
tput sgr0
tput setaf 6
printf " para iniciar a instalação...\n"
tput sgr0
read -r

clear
tput setaf 4
printf "════════════════════════════════════════\n"
tput sgr0
print_animated "  🚀 INICIANDO INSTALAÇÃO DO PLAYIT" 2
tput setaf 4
printf "════════════════════════════════════════\n"
tput sgr0
printf "\n"
sleep 1

# Passo 1
tput setaf 3
printf "[1/4] "
tput sgr0
printf "Adicionando chave GPG do repositório...\n"
run_command "Adicionar chave GPG" \
    "curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null 2>&1"
progress_bar
printf "\n"
sleep 0.5

# Passo 2
tput setaf 3
printf "[2/4] "
tput sgr0
printf "Adicionando repositório às sources...\n"
run_command "Adicionar repositório" \
    "echo 'deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./' | sudo tee /etc/apt/sources.list.d/playit-cloud.list >/dev/null 2>&1"
progress_bar
printf "\n"
sleep 0.5

# Passo 3
tput setaf 3
printf "[3/4] "
tput sgr0
printf "Atualizando lista de pacotes...\n"
run_command "Atualizar apt" \
    "sudo apt update >/dev/null 2>&1"
progress_bar
printf "\n"
sleep 0.5

# Passo 4
tput setaf 3
printf "[4/4] "
tput sgr0
printf "Instalando Playit...\n"
run_command "Instalar Playit" \
    "sudo apt install playit -y >/dev/null 2>&1"
progress_bar
printf "\n"
sleep 1

# Mensagem de sucesso
clear
tput setaf 2
printf "╔═════════════════════════════════════════╗\n"
printf "║                                         ║\n"
printf "║       ✓ INSTALAÇÃO CONCLUÍDA!           ║\n"
printf "║                                         ║\n"
printf "║    Playit instalado com sucesso! 🎉     ║\n"
printf "║                                         ║\n"
printf "║    Script por: maelldev                 ║\n"
printf "║                                         ║\n"
printf "╚═════════════════════════════════════════╝\n"
tput sgr0
printf "\n"

# Verificar se Playit foi instalado corretamente
if command -v playit &> /dev/null; then
    tput setaf 2
    printf "✓ Playit instalado com sucesso\n"
    tput sgr0
else
    tput setaf 1
    printf "⚠️  Aviso: Playit pode não ter sido instalado corretamente\n"
    tput sgr0
    exit 1
fi

printf "\n"
print_animated "🔥 Iniciando Playit em 3 segundos..." 6
sleep 1
tput setaf 6
printf "3...\n"
sleep 1
printf "2...\n"
sleep 1
printf "1...\n"
tput sgr0
sleep 1
printf "\n"
tput setaf 2
printf "🚀 Executando Playit...\n"
tput setaf 6
printf "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
tput sgr0
printf "\n"
sleep 0.5

# Inicia o Playit
playit
