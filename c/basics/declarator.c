#include <stdio.h>

int i;          // i是一个整数
int *p;         // p是一个指向整数的指针
int a[10];      // a是一个包含10个整数的数组
extern int a[]; // a是一个在其他地方定义的整数数组

// abs是一个接受一个整数参数并返回整数的函数
int abs(int i) { return i >= 0 ? i : -i; }

// swap是一个接受两个指向整数的指针参数并无返回值的函数
void swap(int *a, int *b) {
  int temp = *a;
  *a = *b;
  *b = temp;
}

// find_largest是一个接受一个整数数组和一个整数参数并返回整数的函数
int find_largest(int a[], int n) {
  int max = a[0];
  for (int i = 1; i < n; i++) {
    if (a[i] > max) {
      max = a[i];
    }
  }
  return max;
}

// ap是一个包含10个指向整数的指针的数组
int *ap[10];

// fp是一个接受一个浮点数参数并返回一个指向浮点数的指针的函数
float *fp(float f) {
  static float x;
  x = f;
  return &x;
}

void myFunction(int x) { printf("%d\n", x); }

// pf是一个指向一个接受一个整数参数并无返回值的函数的指针
void (*pf)(int) = myFunction;