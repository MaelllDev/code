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
curl -SsL https://playit-cloud.github.io/ppa/key.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/playit.gpg >/dev/null 2>&1
progress_bar
echo ""
sleep 0.5

# Passo 2
echo -e "${YELLOW}[2/4]${NC} ${WHITE}Adicionando repositório às sources...${NC}"
echo "deb [signed-by=/etc/apt/trusted.gpg.d/playit.gpg] https://playit-cloud.github.io/ppa/data ./" | sudo tee /etc/apt/sources.list.d/playit-cloud.list >/dev/null 2>&1
progress_bar
echo ""
sleep 0.5

# Passo 3
echo -e "${YELLOW}[3/4]${NC} ${WHITE}Atualizando lista de pacotes...${NC}"
sudo apt update >/dev/null 2>&1
progress_bar
echo ""
sleep 0.5

# Passo 4
echo -e "${YELLOW}[4/4]${NC} ${WHITE}Instalando Playit...${NC}"
sudo apt install playit -y >/dev/null 2>&1
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
echo ""
sleep 0.5

# Inicia o Playit
playit
