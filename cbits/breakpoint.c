#include <stdint.h>
#include <pthread.h>

#define LOG_SIZE 4096

volatile uint64_t word_log[LOG_SIZE];
volatile int log_idx = 0;
volatile int lock = 0;

volatile char* last_label = NULL;

void c_log_word(uint64_t x) {
  while (__sync_lock_test_and_set(&lock, 1))
      while (lock);
  word_log[log_idx] = x;
  log_idx = (log_idx + 1) % LOG_SIZE;
  lock = 0;
}

void labelled(char* s) {
  // silly non-noop thing to hopefully prevent 'labelled'
  // from being optimized away
  last_label = s;
}

void c_breakpoint(char* label) {
  __asm__("int $3");
  labelled(label);
}

void c_log_tid() {
  pthread_t tid = pthread_self();
  c_log_word(tid);
}

struct thing { uint64_t a, b, c, d; };
