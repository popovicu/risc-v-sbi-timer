CROSS_COMPILE=riscv64-linux-gnu-

timer: timer.o boot.o timer.ld
	${CROSS_COMPILE}ld -T timer.ld --no-dynamic-linker -static -nostdlib -o timer timer.o boot.o

boot.o: boot.s timer.ld
	${CROSS_COMPILE}as -march=rv64i -mabi=lp64 -o boot.o -c boot.s

timer.o: timer.s
	${CROSS_COMPILE}as -march=rv64i -mabi=lp64 -o timer.o -c timer.s

timer.s: timer.c
	${CROSS_COMPILE}gcc -march=rv64i -mabi=lp64 -S timer.c
