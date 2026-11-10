ENTRY(kernel_main)

SECTIONS
{
    /*
     * Limine bootloader scans the .limine_requests section to fill responses.
     * This section MUST be kept in the final binary.
     */
    .limine_requests :
    {
        KEEP(*(.limine_requests))
    }

    /*
     * The kernel is mapped in the higher half of the virtual address space.
     * Standard address for x86_64 kernels.
     */
    . = 0xFFFFFFFF80000000;

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
