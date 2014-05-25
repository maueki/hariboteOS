OUTPUT_FORMAT("binary")/* We want raw binary image */
OUTPUT_ARCH(i386:x86-64)

/* Specify input and output sections */

SECTIONS {
  .text   0x7c00       : { *(.text) }    /* Executable codes */
  .data                : { *(.data) }    /* Initialized data */
  .bss                 : { *(.bss) }     /* Uninitialized data */
  .rodata              : { *(.rodata*) } /* Constant data (R/O) */
  .sign   0x7c00 + 510 : { *(.sign) }    /* Boot signature */
}
