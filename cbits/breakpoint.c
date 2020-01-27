#include <stdio.h>
#include <stdint.h>
#include <pthread.h>

#define LOG_SIZE 4096

enum entry_type {
  ENTRY_NONE,
  ENTRY_WORD,
  ENTRY_STRING
};

struct log_entry {
  enum entry_type ty;
  union {
    uintptr_t word;
    const char *string;
  };
};

volatile struct log_entry the_log[LOG_SIZE] = {};
volatile int log_idx = 0;
volatile int lock = 0;

volatile const char* last_label = NULL;

void print_log() {
  printf("The log:\n");
  for (int i=0; i<LOG_SIZE; i++) {
    volatile struct log_entry *entry = &the_log[(log_idx + i) % LOG_SIZE];
    switch (entry->ty) {
      case ENTRY_NONE:
        break;
      case ENTRY_STRING:
        printf("  string: %s\n", entry->string);
        break;
      case ENTRY_WORD:
        printf("  word: %lu\n", entry->word);
        break;
    }
  }
  printf("the end.\n");
}

static void log_it(struct log_entry entry) {
  while (__sync_lock_test_and_set(&lock, 1))
    while (lock);
  the_log[log_idx] = entry;
  log_idx = (log_idx + 1) % LOG_SIZE;
  lock = 0;
}

void c_log_string(const char *x) {
  struct log_entry entry = {
    .ty = ENTRY_STRING,
    .string = x,
  };
  log_it(entry);
}

void c_log_word(uintptr_t x) {
  struct log_entry entry = {
    .ty = ENTRY_WORD,
    .word = x,
  };
  log_it(entry);
}

void labelled(const char* s) {
  // silly non-noop thing to hopefully prevent 'labelled'
  // from being optimized away
  last_label = s;
}

void c_breakpoint(const char* label) {
  __asm__("int $3");
  labelled(label);
}

void c_log_tid() {
  pthread_t tid = pthread_self();
  c_log_word(tid);
}

struct thing { uint64_t a, b, c, d; };
