#!/bin/bash
# ==========================================
# Script de instalação do Playit
# Criado por: maelldev
# GitHub: github.com/maelldev
# ==========================================

set -e  # Para o script se houver algum erro

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # Sem cor

# Função para limpar e sair em caso de erro
cleanup_on_error() {
    echo -e "\n${RED}❌ Erro durante a instalação!${NC}"
    echo -e "${YELLOW}Por favor, verifique sua conexão e permissões.${NC}"
    exit 1
}

# Configura trap para capturar erros
trap cleanup_on_error ERR

# Função para verificar se está rodando como root
check_sudo() {
    if [ "$EUID" -eq 0 ]; then 
        echo -e "${RED}⚠️  Não execute este script como root diretamente!${NC}"
        echo -e "${YELLOW}Execute como usuário normal. O script usará sudo quando necessário.${NC}"
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
        echo -e "${RED}❌ Dependências faltando: ${missing[*]}${NC}"
        echo -e "${YELLOW}Instale-as com: sudo apt install ${missing[*]}${NC}"
        exit 1
    fi
}

# Função para texto animado
print_animated() {
    text="$1"
    color="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -n -e "${color}${text:$i:1}${NC}"
        sleep 0.02
    done
    echo ""
}

# Função para barra de progresso
progress_bar() {
    echo -n -e "${CYAN}["
    for i in {1..30}; do
        echo -n "="
        sleep 0.03
    done
    echo -e "]${NC} ${GREEN}✓${NC}"
}

# Função para executar comandos com tratamento de erros
run_command() {
    local description="$1"
    local command="$2"
    
    if eval "$command"; then
        return 0
    else
        echo -e "\n${RED}❌ Falha: $description${NC}"
        return 1
    fi
}

# Banner inicial
clear
echo -e "${PURPLE}"
echo "╔═════════════════════════════════════════╗"
echo "║                                         ║"
echo "║      PLAYIT INSTALLER v1.0              ║"
echo "║      Tunnel Service - Setup             ║"
echo "║                                         ║"
echo "║      Script por: ${WHITE}maelldev${PURPLE}                 ║"
echo "║                                         ║"
echo "╚═════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${YELLOW}⚡ Este script irá instalar o Playit no seu sistema${NC}"
echo ""

# Verificações iniciais
echo -e "${CYAN}🔍 Verificando sistema...${NC}"
check_sudo
check_dependencies
echo -e "${GREEN}✓ Sistema compatível${NC}"
echo ""

echo -e "${CYAN}Pressione ${WHITE}ENTER${CYAN} para iniciar a instalação...${NC}"
read -r

clear
echo -e "${BLUE}════════════════════════════════════════${NC}"
print_animated "  🚀 INICIANDO INSTALAÇÃO DO PLAYIT" "$GREEN"
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo ""
sleep 1

# Passo 1
echo -e "${YELLOW}[1/4]${NC} ${WHITE}Adicionando chave GPG do repositório...${NC}"
run_command "Adicionar chave GPG" \
    "curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null 2>&1"
progress_bar
echo ""
sleep 0.5

# Passo 2
echo -e "${YELLOW}[2/4]${NC} ${WHITE}Adicionando repositório às sources...${NC}"
run_command "Adicionar repositório" \
    "echo 'deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./' | sudo tee /etc/apt/sources.list.d/playit-cloud.list >/dev/null 2>&1"
progress_bar
echo ""
sleep 0.5

# Passo 3
echo -e "${YELLOW}[3/4]${NC} ${WHITE}Atualizando lista de pacotes...${NC}"
run_command "Atualizar apt" \
    "sudo apt update >/dev/null 2>&1"
progress_bar
echo ""
sleep 0.5

# Passo 4
echo -e "${YELLOW}[4/4]${NC} ${WHITE}Instalando Playit...${NC}"
run_command "Instalar Playit" \
    "sudo apt install playit -y >/dev/null 2>&1"
progress_bar
echo ""
sleep 1

# Mensagem de sucesso
clear
echo -e "${GREEN}"
echo "╔═════════════════════════════════════════╗"
echo "║                                         ║"
echo "║       ✓ INSTALAÇÃO CONCLUÍDA!           ║"
echo "║                                         ║"
echo "║    Playit instalado com sucesso! 🎉     ║"
echo "║                                         ║"
echo "║    Script por: maelldev                 ║"
echo "║                                         ║"
echo "╚═════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Verificar se Playit foi instalado corretamente
if command -v playit &> /dev/null; then
    echo -e "${GREEN}✓ Playit versão: $(playit --version 2>/dev/null || echo 'instalado')${NC}"
else
    echo -e "${RED}⚠️  Aviso: Playit pode não ter sido instalado corretamente${NC}"
    exit 1
fi

echo ""
print_animated "🔥 Iniciando Playit em 3 segundos..." "$CYAN"
sleep 1
echo -e "${CYAN}3...${NC}"
sleep 1
echo -e "${CYAN}2...${NC}"
sleep 1
echo -e "${CYAN}1...${NC}"
sleep 1
echo ""
echo -e "${GREEN}🚀 Executando Playit...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
sleep 0.5

# Inicia o Playit
playit
