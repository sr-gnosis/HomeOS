# Build settings
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ISO_NAME = homeos.iso

CFLAGS = -ffreestanding -mcmodel=kernel -mno-red-zone -Wall -Wextra -std=gnu11
LDFLAGS = -T linker.ld -nostdlib

# Objects
OBJS = src/kernel/kernel.o

all: $(ISO_NAME)

$(ISO_NAME): build/kernel.elf
	mkdir -p iso_root
	cp build/kernel.elf iso_root/
	cp limine.conf iso_root/
	cp limine/limine-bios.sys iso_root/
	cp limine/limine-uefi-cd.bin iso_root/
	xorriso -as mkisofs -b limine-bios.sys -no-emul-boot -boot-load-size 4 -boot-info-table --efi-boot limine-uefi-cd.bin -efi-boot-part 1 -o $(ISO_NAME) iso_root

build/kernel.elf: $(OBJS)
	mkdir -p build
	$(LD) $(LDFLAGS) -o build/kernel.elf $(OBJS)

src/kernel/kernel.o: src/kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf build iso_root $(ISO_NAME) src/kernel/*.o

.PHONY: all clean
