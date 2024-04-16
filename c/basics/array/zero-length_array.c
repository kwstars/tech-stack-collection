#include <stdio.h>
#include <stdlib.h>

// 定义一个结构体，其中包含一个零长度数组
struct ZeroLengthArray {
  int length;
  int array[0]; // 这是一个零长度数组
};

int main() {
  // 创建一个指向ZeroLengthArray的指针
  struct ZeroLengthArray *zla;

  // 使用malloc分配内存，足够存储结构体本身以及5个int
  zla = malloc(sizeof(struct ZeroLengthArray) + 5 * sizeof(int));

  // 设置length字段
  zla->length = 5;

  // 使用零长度数组
  for (int i = 0; i < zla->length; i++) {
    zla->array[i] = i;
  }

  // 打印零长度数组的值
  for (int i = 0; i < zla->length; i++) {
    printf("%d ", zla->array[i]);
  }

  // 释放内存
  free(zla);

  return 0;
}