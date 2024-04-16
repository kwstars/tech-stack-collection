#include <stdio.h>

int main() {
  int i = 10;
  int *p = &i;

  printf("Value of i: %d\n", i);            // 10
  printf("Address of i: %p\n", (void *)&i); // 0x7ffeeb0b4a4c
  printf("Value of p: %p\n", (void *)p);    // 0x7ffeeb0b4a4c
  printf("Value pointed by p: %d\n", *p);   // 10

  return 0;
}