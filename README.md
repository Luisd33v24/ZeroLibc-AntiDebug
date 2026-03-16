# No-Libc Anti-Debug Protector

Uma Prova de Conceito (PoC) desenvolvida em x86-64 Assembly (Linux) para demonstrar técnicas de evasão de análise estática e detecção de depuradores (Anti-Debugging).

O projeto não possui dependências externas (sem libc), interagindo diretamente com o Kernel via syscalls.

## Estrutura do Projeto

ZeroLibc-AntiDebug/
├── .github/          # Políticas de segurança e templates
│   └── SECURITY.md
├── src/              # Código-fonte principal em Assembly
│   └── protector.asm
├── tests/            # Scripts para automação e validação
│   └── test.sh
├── Makefile          # Automação da compilação e geração do build
├── README.md         # Documentação do projeto
├── LICENSE           # Licença do repositório
└── .gitignore        # Arquivos e pastas ignoradas (ex: pasta build/)

## Funcionalidades

* **Zero Dependencies**: Binário puro, linkado estaticamente. Retorna "not a dynamic executable" ao ser analisado com ldd.
* **Time-Based Anti-Debugging**: Utiliza a instrução RDTSC para medir o tempo de execução. O código usa CPUID e RDTSCP para serializar as instruções e garantir precisão contra a execução out-of-order da CPU.
* **Syscall Obfuscation**: Máscaras matemáticas nos registradores antes das invocações syscall para dificultar a leitura imediata em descompiladores.
* **Exit Codes Dinâmicos**: Retorna código de saída 0 para execuções seguras e 1 quando um depurador é detectado, facilitando a automação de testes.

## Requisitos

* Linux (x86-64) ou ambiente WSL
* NASM (Netwide Assembler)
* GNU Binutils (ld)
* strace (Opcional, apenas para validar a detecção)

## Como Usar

Clone o repositório e compile o projeto utilizando o comando make. O binário será gerado de forma isolada dentro da pasta build/.

1. Para compilar e rodar normalmente:
    make
    ./build/protector

Saída esperada (Ambiente Seguro):
    [+] Execucao limpa. Sistema seguro.

2. Para testar o mecanismo de detecção anexando um tracer:
    strace ./build/protector

Saída esperada (Sob Análise):
    [-] ALERTA: Debugger ou VM detectado! Abortando.

## Como Testar (Script Automatizado)

O repositório inclui um script para validar se o limite de ciclos de CPU (threshold) está bem calibrado para a sua máquina. Ele executa o binário nativamente e depois sob o strace para checar os Exit Codes.

Para rodar os testes, utilize os comandos a partir da raiz do repositório:
    chmod +x tests/test.sh
    ./tests/test.sh

---
**Aviso:** Este projeto possui fins estritamente educacionais e de pesquisa em segurança da informação e engenharia reversa. Teste apenas em ambientes controlados e não utilize para fins maliciosos.