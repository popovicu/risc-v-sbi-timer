MEMORY {
  kernel_space (rwx) : ORIGIN = 0x80200000, LENGTH = 2 * 1024 * 1024
}

SECTIONS {
  .text : {
    boot.o(.text)
    *(.text)
  } > kernel_space

  .text.interrupt : ALIGN(4) {} 

  .data : {
    *(.data)
  } > kernel_space

  .rodata : {
    *(.rodata)
  } > kernel_space

  .bss : {
    *(.bss)
  } > kernel_space

  . = ALIGN(8);
  . = . + 4096;
  _STACK_PTR = .;
}
