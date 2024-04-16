#include <stdio.h>

void printValues(int *const, const int *, const int *const);

int main() {
  int x = 10;
  int y = 20;
  int z = 30;

  int *const ptr1 = &x;       // Constant Pointer
  const int *ptr2 = &y;       // Pointer to Constant
  const int *const ptr3 = &z; // Constant Pointer to a Constant

  printValues(ptr1, ptr2, ptr3);

  return 0;
}

void printValues(int *const ptr1, const int *ptr2, const int *const ptr3) {
  printf("ptr1 points to: %d\n", *ptr1);
  printf("ptr2 points to: %d\n", *ptr2);
  printf("ptr3 points to: %d\n", *ptr3);

  int a = 100;
  int b = 200;
  int c = 300;

  // ptr1 can change the value it points to and cannot point to another location
  *ptr1 = a;
  // ptr1 = &a; // This would cause a compile error

  // ptr2 can point to another location but cannot change the value it points to
  ptr2 = &b;
  // *ptr2 = b; // This would cause a compile error

  // ptr3 cannot change the value it points to and cannot point to another
  // location *ptr3 = c; // This would cause a compile error ptr3 = &c; // This
  // would cause a compile error
}