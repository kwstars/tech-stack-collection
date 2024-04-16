#include <stdio.h>
#include <stdlib.h>

// 定义一个结构体，其中包含一个灵活数组成员
struct FlexibleArrayMember {
  int length;
  int array[]; // 这是一个灵活数组成员
};

int main() {
  // 创建一个指向FlexibleArrayMember的指针
  struct FlexibleArrayMember *fam;

  // 使用malloc分配内存，足够存储结构体本身以及5个int
  fam = malloc(sizeof(struct FlexibleArrayMember) + 5 * sizeof(int));

  // 设置length字段
  fam->length = 5;

  // 使用灵活数组成员
  for (int i = 0; i < fam->length; i++) {
    fam->array[i] = i;
  }

  // 打印灵活数组成员的值
  for (int i = 0; i < fam->length; i++) {
    printf("%d ", fam->array[i]);
  }

  // 释放内存
  free(fam);

  return 0;
}