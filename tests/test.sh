#!/bin/bash

# Volta para a raiz do projeto
cd "$(dirname "$0")/.."

set -e

echo "[*] Compilando o projeto..."
make clean > /dev/null
if make > /dev/null; then
    echo "[OK] Compilacao concluida."
else
    echo "[ERRO] Falha na compilação. Verifique o Makefile e o NASM."
    exit 1
fi

echo -e "\n[*] Teste 1: Execucao Limpa (Nativa)"
# Executa o binário a partir da pasta build/
if ./build/protector; then
    echo " -> [PASSOU] Execucao normal validada (Exit Code 0)."
else
    echo " -> [FALHOU] Falso positivo! O THRESHOLD pode estar baixo."
fi

echo -e "\n[*] Teste 2: Execucao sob Tracing (strace)"
set +e
# Executa o binário a partir da pasta build/
strace -q -e trace=none ./build/protector > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo " -> [PASSOU] Depurador detectado com sucesso (Exit Code 1)."
else
    echo " -> [FALHOU] Evasao falhou! O THRESHOLD pode estar alto."
fi

echo -e "\n[*] Testes concluidos."