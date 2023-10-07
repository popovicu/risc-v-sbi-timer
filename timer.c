/*
  OpenSBI-based timer example for RISC-V. If unfamiliar with SBI and OpenSBI, please read:
  https://popovicu.com/posts/risc-v-sbi-and-full-boot-process/

  Please build the latest OpenSBI from source to get the optimal result.
 */

#define HELLO_WORLD_MSG "Hello world! We're about to use the timer.\n"
#define HELLO_TIMER_MSG "Hello from the timer interrupt!\n"
#define MAIN_THREAD_MSG "Main thread still running.\n"

/*
  Struct containing the return status of OpenSBI.
  https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/binary-encoding.adoc
 */
struct SbiRet {
  long error;
  long value;
};

/*
  Uses OpenSBI to print to the debug console.
  https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-debug-console.adoc
 */
struct SbiRet debug_print(char *message, int len) {
  struct SbiRet return_status;
  
  asm(
      "li a7, 0x4442434E\n\t"
      "li a6, 0x00\n\t"
      "li a2, 0\n\t"
      "mv a1, %2\n\t"
      "mv a0, %3\n\t"
      "ecall\n\t"
      "mv %0, a0\n\t"
      "mv %1, a1\n"
      : /* Outputs: */ "=r"(return_status.error), "=r"(return_status.value)
      : /* Inputs: */ "r"(message), "r"(len)
      : /* Clobbered registers: */ "a0", "a1", "a2", "a6", "a7");

  return return_status;
}

void setup_s_mode_interrupt(void *handler_ptr) {
  asm(
      "csrw stvec, %0\n\t" // Set the interrupt address for S-mode
      "csrsi sstatus, 2" // Set the S-level interrupt enable flag (SIE)
      : /* Outputs: none*/
      : /* Inputs: */ "r"(handler_ptr)
      : /* Clobbered registers: none*/
      );
}

struct SbiRet set_timer_in_near_future() {
  struct SbiRet return_status;
  
  asm(
      "rdtime t0\n\t" // Get the current time.
      "li t1, 10000000\n\t" // Get something to add to the current time, so we have a future time.
      "add a0, t0, t1\n\t" // Calculate the time in the future.
      "li a7, 0x54494D45\n\t"
      "li a6, 0x00\n\t"
      "ecall\n\t"
      "mv %0, a0\n\t"
      "mv %1, a1\n"
      : /* Outputs: */ "=r"(return_status.error), "=r"(return_status.value)
      : /* Inputs: none */
      : /* Clobbered registers: */ "a0", "a1", "a6", "a7", "t0", "t1"
      );

  return return_status;
}

void enable_s_mode_timer_interrupt() {
  asm(
      "li t1, 32\n\t"
      "csrs sie, t1\n" // Timer interrupt enable flag: STIE
      ::: /* Clobbered registers: */ "t1"
      );
}

void clear_timer_pending_bit() {
  asm(
      "li t0, 32\n\t"
      "csrc sip, t0\n"
      ::: /* Clobbered registers: */ "t0"
      );
}

__attribute__((interrupt ("supervisor")))
__attribute__((section (".text.interrupt")))
void s_mode_interrupt_handler(void) {
  // We only expect the timer interrupt to happen here, no need to inspect the cause.
  clear_timer_pending_bit();

  set_timer_in_near_future();
  // Instead of re-setting the timer for the future, we could also disable the timer.
  //   li t3, 32
  //   csrc sie, t3     # Disable the timer interrupt enable flag (STIE)
  
  debug_print(HELLO_TIMER_MSG, sizeof(HELLO_TIMER_MSG));
}

void main() {
  struct SbiRet initial_print_status = debug_print(HELLO_WORLD_MSG, sizeof(HELLO_WORLD_MSG));

  if (initial_print_status.error) {
    // This will just send us back to boot.s if there's an error.
    // None of the printing will happen later, you'll get a blank output.
    // This likely needs you need to build the latest OpenSBI.
    return;
  }

  setup_s_mode_interrupt(&s_mode_interrupt_handler);
  set_timer_in_near_future();
  enable_s_mode_timer_interrupt();

  while (1) {
    debug_print(MAIN_THREAD_MSG, sizeof(MAIN_THREAD_MSG));
    for (int i = 0; i < 300000000; i++); // Simulate a delay
  }
}
