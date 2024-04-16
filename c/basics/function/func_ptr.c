#include <stdio.h>

#include <stdio.h>

void printInteger(int x) { printf("%d\n", x); }

int *getStaticIntegerPointer() {
  static int x = 5;
  return &x; // 返回一个指向int的指针
}

int main() {
  void (*fp1)(int); // 函数指针，指向一个接受int参数并返回void的函数
  fp1 = &printInteger; // 让fp指向printInteger
  (*fp1)(5);           // 使用函数指针调用函数，输出5

  int *(*fp2)(); // 指向返回int指针的函数的函数指针
  fp2 = &getStaticIntegerPointer; // 让fp指向getStaticIntegerPointer
  int *xp = (*fp2)();             // 调用函数并获取返回的指针
  printf("%d\n", *xp);            // 输出5

  return 0;
}