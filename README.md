# Compilando C + Assembly (32 bits) no WSL Ubuntu

Passo a passo para instalar o WSL com Ubuntu no Windows e usá-lo para compilar um programa em C que chama uma função escrita em Assembly (`.c` + `.s`) com o parâmetro `-m32`.

## Sumário

1. [Instalação do WSL](#1-instalação-do-wsl)
2. [Abrir o terminal do WSL Ubuntu](#2-abrir-o-terminal-do-wsl-ubuntu)
3. [Criar usuário e senha](#3-criar-usuário-e-senha)
4. [Atualizar o sistema (update + upgrade)](#4-atualizar-o-sistema-update--upgrade)
5. [Instalar o GCC e o gcc-multilib](#5-instalar-o-gcc-e-o-gcc-multilib)
6. [Atualizar novamente (e `--fix-missing` se precisar)](#6-atualizar-novamente-e---fix-missing-se-precisar)
7. [Instalar o nano ou o vim](#7-instalar-o-nano-ou-o-vim)
8. [Editar arquivos `.c` e `.s` com nano / vim](#8-editar-arquivos-c-e-s-com-nano--vim)
9. [Compilar com `-m32`](#9-compilar-com--m32)
10. [Rodar o programa (`chmod +x` e `./`)](#10-rodar-o-programa-chmod-x-e-)
11. [Testar com o código de exemplo](#11-testar-com-o-código-de-exemplo)

---

## 1. Instalação do WSL

Abra o **PowerShell como Administrador** (clique com o botão direito no menu Iniciar → *Terminal (Admin)*) e execute:

```powershell
wsl --install
```

Esse comando habilita os recursos necessários e instala o **Ubuntu** como distribuição padrão. Ao terminar, **reinicie o computador**.

> Se o WSL já estiver instalado mas sem o Ubuntu, use:
> ```powershell
> wsl --install -d Ubuntu
> ```
> Para ver as distribuições disponíveis: `wsl --list --online`

## 2. Abrir o terminal do WSL Ubuntu

Depois de reiniciar, abra o Ubuntu de uma destas formas:

- Menu Iniciar → digite **Ubuntu** e abra o aplicativo; ou
- No PowerShell / Terminal do Windows, digite:
  ```powershell
  wsl
  ```
- No **Windows Terminal**, clique na setinha ao lado da aba (`˅`) e escolha **Ubuntu**.

## 3. Criar usuário e senha

Na primeira vez que o Ubuntu abrir, ele vai terminar a instalação e pedir:

```
Enter new UNIX username: seu_usuario
New password:
Retype new password:
```

- O nome de usuário deve ser em **minúsculas** e sem espaços.
- Ao digitar a senha **nada aparece na tela** — isso é normal. Digite e pressione Enter.
- Essa senha será pedida sempre que você usar `sudo`. Não esqueça dela!

## 4. Atualizar o sistema (update + upgrade)

```bash
sudo apt update
sudo apt upgrade -y
```

- `apt update` atualiza a lista de pacotes disponíveis.
- `apt upgrade` instala as versões mais novas dos pacotes já instalados.

## 5. Instalar o GCC e o gcc-multilib

```bash
sudo apt install -y gcc gcc-multilib
```

- `gcc` → o compilador C (também monta arquivos Assembly `.s`).
- `gcc-multilib` → bibliotecas de 32 bits, **necessárias para o parâmetro `-m32`** funcionar em um sistema 64 bits.

Para conferir a instalação:

```bash
gcc --version
```

## 6. Atualizar novamente (e `--fix-missing` se precisar)

```bash
sudo apt update
sudo apt upgrade -y
```

Se alguma instalação falhar com erro de pacote não encontrado (ex.: `Unable to fetch some archives`), rode:

```bash
sudo apt update --fix-missing
sudo apt install -y gcc gcc-multilib --fix-missing
```

## 7. Instalar o nano ou o vim

Escolha um editor de texto de terminal (ou instale os dois):

```bash
sudo apt install -y nano
sudo apt install -y vim
```

> O **nano** é mais simples para iniciantes. O **vim** é mais poderoso, mas tem uma curva de aprendizado maior.

## 8. Editar arquivos `.c` e `.s` com nano / vim

### Usando o nano

```bash
nano funcao.c
```

| Ação                 | Atalho                                |
|----------------------|---------------------------------------|
| Digitar / editar     | é só digitar normalmente              |
| Salvar               | `Ctrl + O` e depois `Enter`           |
| Sair                 | `Ctrl + X`                            |
| Recortar linha       | `Ctrl + K`                            |
| Colar                | `Ctrl + U`                            |
| Procurar             | `Ctrl + W`                            |

> Para colar texto copiado do Windows no terminal: **botão direito do mouse** ou `Ctrl + Shift + V`.

### Usando o vim

```bash
vim funcao.s
```

O vim tem **modos**. Ao abrir, ele está no *modo normal* (não digita texto).

| Ação                          | Comando                              |
|-------------------------------|--------------------------------------|
| Entrar no modo de inserção    | `i`                                  |
| Voltar ao modo normal         | `Esc`                                |
| Salvar                        | `Esc` → `:w` → `Enter`               |
| Salvar e sair                 | `Esc` → `:wq` → `Enter`              |
| Sair sem salvar               | `Esc` → `:q!` → `Enter`              |
| Apagar linha (modo normal)    | `dd`                                 |
| Desfazer (modo normal)        | `u`                                  |

## 9. Compilar com `-m32`

Com os dois arquivos (`funcao.c` e `funcao.s`) na mesma pasta:

```bash
gcc -m32 funcao.c funcao.s -o funcao
```

- `-m32` → gera um executável de **32 bits** (necessário porque o Assembly usa registradores de 32 bits como `%eax`, `%ebp`, `%esp` e passagem de parâmetros pela pilha).
- `funcao.c funcao.s` → arquivos de entrada (o GCC compila o C e monta o Assembly).
- `-o funcao` → nome do executável gerado. **Atenção:** o nome deve vir logo depois do `-o`.

Se aparecer um erro como `fatal error: bits/libc-header-start.h: No such file or directory`, o `gcc-multilib` não está instalado — volte ao [passo 5](#5-instalar-o-gcc-e-o-gcc-multilib).

## 10. Rodar o programa (`chmod +x` e `./`)

Dê permissão de execução (normalmente o GCC já faz isso, mas não custa garantir):

```bash
chmod +x funcao
```

Execute:

```bash
./funcao
```

O `./` diz ao terminal para rodar o arquivo que está **na pasta atual**.

## 11. Testar com o código de exemplo

Este repositório já contém os dois arquivos de exemplo. O programa lê **três inteiros** e imprime a **soma** deles, sendo a soma feita pela função `func` escrita em Assembly.

### [`funcao.c`](funcao.c)

```c
#include <stdio.h>
int func(int a, int b, int c);
int main(void){
	int a,b,c;
	scanf("%d %d %d",&a,&b,&c);
	printf("%d",func(a,b,c));
	return(0);
}
```

### [`funcao.s`](funcao.s)

```asm
.text
.globl func
func:
	pushl %ebp
	movl %esp, %ebp
	subl $0, %esp

	movl 8(%ebp), %eax
	addl 12(%ebp), %eax
	addl 16(%ebp), %eax

	movl %ebp, %esp
	popl %ebp
ret
```

**Como funciona:** em 32 bits, os parâmetros são passados pela pilha. Depois do `pushl %ebp`, o primeiro parâmetro (`a`) fica em `8(%ebp)`, o segundo (`b`) em `12(%ebp)` e o terceiro (`c`) em `16(%ebp)`. A soma é acumulada em `%eax`, que é o registrador de retorno da função.

### Passo a passo do teste

```bash
# 1. Clone o repositório (ou crie os arquivos com nano/vim)
git clone https://github.com/luanfrombrazil/gcc-c-assembly.git
cd gcc-c-assembly

# 2. Compile
gcc -m32 funcao.c funcao.s -o funcao

# 3. Rode
chmod +x funcao
./funcao
```

Digite três números separados por espaço e pressione Enter:

```
1 2 3
6
```

Ou passe a entrada direto:

```bash
echo "10 20 30" | ./funcao
```

Saída esperada: `60`

> **Dica:** os arquivos do Windows ficam acessíveis no WSL em `/mnt/c/`. Por exemplo, `C:\Users\SeuNome` é `/mnt/c/Users/SeuNome`.

---

<br>

> *— Se um homem criar uma máquina para calcular, que mal há nisso?*
>
> *— Você pensa que o perigo estava nas engrenagens e nos circuitos, garoto? O problema nunca foram as máquinas superarem os homens em malícia. O perigo real foi que os homens entregaram sua capacidade de pensar às máquinas.*
>
> *— Eles se tornaram preguiçosos?*
>
> *— Pior do que isso. Eles se tornaram escravos por escolha própria. Ao permitirem que as máquinas decidissem, que as máquinas calculassem o futuro e removessem o peso das escolhas, os seres humanos abdicaram de sua própria alma. Quem tinha as máquinas mais complexas governava os outros. A mente humana decaiu, atrofiou. Nós nos transformamos em rebanhos dependentes de metal e silício.*
>
> <p align="right"><b>Dune</b>, Frank Herbert</p>
