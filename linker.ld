OUTPUT_FORMAT(elf64-x86-64)
ENTRY(kernel_main)

SECTIONS
{
    /*
     * O endereço da higher-half deve vir ANTES de qualquer seção
     * para que todo o kernel seja mapeado na parte superior da memória.
     */
    . = 0xFFFFFFFF80000000;

    /*
     * Limine bootloader scans the .limine_requests section to fill responses.
     * This section MUST be kept in the final binary.
     */
    .limine_requests :
    {
        KEEP(*(.limine_requests))
    }

    .text :
    {
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(.bss)
        *(COMMON)
    }
}