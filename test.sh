#!/bin/bash
set -e  # Aborta o script se qualquer comando falhar

echo "[*] Compilando o projeto..."
if make > /dev/null; then
    echo "[OK] Compilacao concluida."
else
    echo "[ERRO] Falha na compilação. Verifique o Makefile e o NASM."
    exit 1
fi

echo -e "\n[*] Teste 1: Execucao Limpa (Nativa)"
if ./protector; then
    echo " -> [PASSOU] Execucao normal validada (Exit Code 0)."
else
    echo " -> [FALHOU] Falso positivo! O THRESHOLD pode estar baixo."
fi

echo -e "\n[*] Teste 2: Execucao sob Tracing (strace)"
# Aqui não usamos set -e pois esperamos que o strace retorne erro (Exit 1)
set +e
strace -q -e trace=none ./protector > /dev/null 2>&1
if [ $? -eq 1 ]; then
    echo " -> [PASSOU] Depurador detectado com sucesso (Exit Code 1)."
else
    echo " -> [FALHOU] Evasao falhou! O THRESHOLD pode estar alto."
fi

echo -e "\n[*] Testes concluidos."