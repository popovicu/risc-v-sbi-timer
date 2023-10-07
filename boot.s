        .global _start
        .section .text

_start: la sp, _STACK_PTR
	call main
	j .
