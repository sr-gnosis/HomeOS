# homeOS - A Learning Operating System

homeOS is a minimal, bootable operating system for the x86_64 architecture, created for educational purposes.

## Project Goal
The primary objective of this first version is to achieve a successful boot process that initializes a kernel and displays a welcome message on the screen.

## Architecture
- **Architecture**: x86_64
- **Bootloader**: Limine
- **Language**: C (Kernel) and Assembly (Entry point)
- **Build System**: GNU Make

## Project Structure
- `src/kernel/`: Core kernel logic and hardware initialization.
- `src/boot/`: Bootloader-specific entry and configuration.
- `limine/`: Limine bootloader binaries and headers.
- `Makefile`: Build instructions.

## Compilation Instructions

### Prerequisites
You will need a cross-compiler for x86_64 (e.g., `x86_64-elf-gcc` and `x86_64-elf-binutils`). 
If you are on Windows, it is recommended to use WSL2 or a Linux environment.

1. **Install Limine**: 
   Follow the instructions in the Limine repository to build the bootloader.
2. **Build the project**:
   ```bash
   make
   ```
3. **Run/Test**:
   The build process generates an ISO image. You can test it using QEMU:
   ```bash
   qemu-system-x86_64 -cdrom homeos.iso
   ```

## Technical Decisions
- **Limine Bootloader**: Chosen because it simplifies the transition from the bootloader to the kernel, providing a modern interface for memory maps and framebuffer access, avoiding the complexity of writing a custom multiboot2 loader.
- **C Language**: Used for the majority of the kernel to ensure modularity and readability, while keeping Assembly to the absolute minimum required for the entry point.
