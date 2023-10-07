	.file	"timer.c"
	.option pic
	.text
	.align	2
	.globl	debug_print
	.type	debug_print, @function
debug_print:
	addi	sp,sp,-64
	sd	s0,56(sp)
	addi	s0,sp,64
	sd	a0,-56(s0)
	mv	a5,a1
	sw	a5,-60(s0)
	ld	a5,-56(s0)
	lw	a4,-60(s0)
#APP
# 26 "timer.c" 1
	li a7, 0x4442434E
	li a6, 0x00
	li a2, 0
	mv a1, a5
	mv a0, a4
	ecall
	mv a4, a0
	mv a5, a1

# 0 "" 2
#NO_APP
	sd	a4,-48(s0)
	sd	a5,-40(s0)
	ld	a5,-48(s0)
	sd	a5,-32(s0)
	ld	a5,-40(s0)
	sd	a5,-24(s0)
	ld	a4,-32(s0)
	ld	a5,-24(s0)
	mv	t1,a4
	mv	t2,a5
	mv	a4,t1
	mv	a5,t2
	mv	a0,a4
	mv	a1,a5
	ld	s0,56(sp)
	addi	sp,sp,64
	jr	ra
	.size	debug_print, .-debug_print
	.align	2
	.globl	setup_s_mode_interrupt
	.type	setup_s_mode_interrupt, @function
setup_s_mode_interrupt:
	addi	sp,sp,-32
	sd	s0,24(sp)
	addi	s0,sp,32
	sd	a0,-24(s0)
	ld	a5,-24(s0)
#APP
# 43 "timer.c" 1
	csrw stvec, a5
	csrsi sstatus, 2
# 0 "" 2
#NO_APP
	nop
	ld	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	setup_s_mode_interrupt, .-setup_s_mode_interrupt
	.align	2
	.globl	set_timer_in_near_future
	.type	set_timer_in_near_future, @function
set_timer_in_near_future:
	addi	sp,sp,-48
	sd	s0,40(sp)
	addi	s0,sp,48
#APP
# 55 "timer.c" 1
	rdtime t0
	li t1, 10000000
	add a0, t0, t1
	li a7, 0x54494D45
	li a6, 0x00
	ecall
	mv a4, a0
	mv a5, a1

# 0 "" 2
#NO_APP
	sd	a4,-48(s0)
	sd	a5,-40(s0)
	ld	a5,-48(s0)
	sd	a5,-32(s0)
	ld	a5,-40(s0)
	sd	a5,-24(s0)
	ld	a4,-32(s0)
	ld	a5,-24(s0)
	mv	a2,a4
	mv	a3,a5
	mv	a4,a2
	mv	a5,a3
	mv	a0,a4
	mv	a1,a5
	ld	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	set_timer_in_near_future, .-set_timer_in_near_future
	.align	2
	.globl	enable_s_mode_timer_interrupt
	.type	enable_s_mode_timer_interrupt, @function
enable_s_mode_timer_interrupt:
	addi	sp,sp,-16
	sd	s0,8(sp)
	addi	s0,sp,16
#APP
# 73 "timer.c" 1
	li t1, 32
	csrs sie, t1

# 0 "" 2
#NO_APP
	nop
	ld	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	enable_s_mode_timer_interrupt, .-enable_s_mode_timer_interrupt
	.align	2
	.globl	clear_timer_pending_bit
	.type	clear_timer_pending_bit, @function
clear_timer_pending_bit:
	addi	sp,sp,-16
	sd	s0,8(sp)
	addi	s0,sp,16
#APP
# 81 "timer.c" 1
	li t0, 32
	csrc sip, t0

# 0 "" 2
#NO_APP
	nop
	ld	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	clear_timer_pending_bit, .-clear_timer_pending_bit
	.section	.rodata
	.align	3
.LC0:
	.string	"Hello from the timer interrupt!\n"
	.section	.text.interrupt,"ax",@progbits
	.align	2
	.globl	s_mode_interrupt_handler
	.type	s_mode_interrupt_handler, @function
s_mode_interrupt_handler:
	addi	sp,sp,-144
	sd	ra,136(sp)
	sd	t0,128(sp)
	sd	t1,120(sp)
	sd	t2,112(sp)
	sd	s0,104(sp)
	sd	a0,96(sp)
	sd	a1,88(sp)
	sd	a2,80(sp)
	sd	a3,72(sp)
	sd	a4,64(sp)
	sd	a5,56(sp)
	sd	a6,48(sp)
	sd	a7,40(sp)
	sd	t3,32(sp)
	sd	t4,24(sp)
	sd	t5,16(sp)
	sd	t6,8(sp)
	addi	s0,sp,144
	call	clear_timer_pending_bit
	call	set_timer_in_near_future
	li	a1,33
	lla	a0,.LC0
	call	debug_print
	nop
	ld	ra,136(sp)
	ld	t0,128(sp)
	ld	t1,120(sp)
	ld	t2,112(sp)
	ld	s0,104(sp)
	ld	a0,96(sp)
	ld	a1,88(sp)
	ld	a2,80(sp)
	ld	a3,72(sp)
	ld	a4,64(sp)
	ld	a5,56(sp)
	ld	a6,48(sp)
	ld	a7,40(sp)
	ld	t3,32(sp)
	ld	t4,24(sp)
	ld	t5,16(sp)
	ld	t6,8(sp)
	addi	sp,sp,144
	sret
	.size	s_mode_interrupt_handler, .-s_mode_interrupt_handler
	.section	.rodata
	.align	3
.LC1:
	.string	"Hello world! We're about to use the timer.\n"
	.align	3
.LC2:
	.string	"Main thread still running.\n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	li	a1,44
	lla	a0,.LC1
	call	debug_print
	mv	a4,a0
	mv	a5,a1
	sd	a4,-40(s0)
	sd	a5,-32(s0)
	ld	a5,-40(s0)
	bne	a5,zero,.L16
	lla	a0,s_mode_interrupt_handler
	call	setup_s_mode_interrupt
	call	set_timer_in_near_future
	call	enable_s_mode_timer_interrupt
.L14:
	li	a1,28
	lla	a0,.LC2
	call	debug_print
	sw	zero,-20(s0)
	j	.L12
.L13:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L12:
	lw	a5,-20(s0)
	sext.w	a4,a5
	li	a5,299999232
	addi	a5,a5,767
	ble	a4,a5,.L13
	j	.L14
.L16:
	nop
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (Debian 10.2.1-6) 10.2.1 20210110"
	.section	.note.GNU-stack,"",@progbits
