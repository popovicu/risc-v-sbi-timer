# RISC-V interrupts with OpenSBI timer example

This repository has an example of how to use interrupts in C with RISC-V. GCC tooling is assumed (this matters for things like `__attribute__` that the example depends on).

To build the binary, simply run:

```
make timer
```

(you may have to override the `CROSS_COMPILE` `make` settings in order to utilize the right GCC tooling on your machine)

Latest OpenSBI is recommended for the optimal experience here (older OpenSBI implementations may not have all the services enabled; we're using the debug console for printing to UART + timer facilities). If you don't know what SBI layer on RISC-V is, or if you haven't worked with OpenSBI before, please check the following article: https://popovicu.com/posts/risc-v-sbi-and-full-boot-process/

The article above should also fully explain all the flags used with QEMU below to run the example. Therefore, after building the `timer` binary, execute it on QEMU with the following command:

```
qemu-system-riscv64 -machine virt -kernel timer -bios PATH_TO_YOUR_OPENSBI_CLONED_REPO/build/platform/generic/firmware/fw_dynamic.bin -nographic
```

Sample output below:

```
Hello world! We're about to use the timer.
Main thread still running.
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Main thread still running.
Hello from the timer interrupt!
Main thread still running.
Hello from the timer interrupt!
```

## Detailed explanation

The code for this repository is meant to accompany the article available at:

https://popovicu.com/posts/risc-v-interrupts-with-timer-example