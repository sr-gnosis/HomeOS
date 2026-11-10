.POSIX:

SHELL=/bin/sh

CC=cc
CFLAGS=-g -O2 -pipe -Wall -Wextra
CPPFLAGS=-I. -I./limine_bootloader
LDFLAGS=
LIBS=

# Alvo padrão: compila tanto o utilitário limine quanto o kernel
.PHONY: all
all: limine src/kernel/kernel.elf

.PHONY: clean
clean:
	rm -f limine limine.exe src/kernel/kernel.elf

# Compila o utilitário limine na raiz
limine: limine.c
	$(CC) $(CFLAGS) -std=c99 -D_FILE_OFFSET_BITS=64 $(CPPFLAGS) $(LDFLAGS) limine.c $(LIBS) -o $@

# Compila o kernel do HomeOS
src/kernel/kernel.elf: src/kernel/kernel.c src/kernel/limine.h linker.ld
	$(CC) $(CFLAGS) -ffreestanding -fno-stack-protector -fno-pie -no-pie \
	-mcmodel=kernel -mno-red-zone -mno-mmx -mno-sse -mno-sse2 \
	-nostdlib -nostartfiles -T linker.ld src/kernel/kernel.c -o $@