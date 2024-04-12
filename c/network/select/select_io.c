#include <stdio.h>
#include <stdlib.h>
#include <sys/select.h>

int main(void) {
  fd_set readfds; // 文件描述符集，用于存储待监视的文件描述符
  struct timeval tv; // timeval 结构体，用于设置超时时间
  int retval;

  /* Watch stdin (fd 0) to see when it has input. */
  // 监视标准输入（文件描述符为0），以检查是否有输入数据
  FD_ZERO(&readfds); // 清空文件描述符集
  FD_SET(0, &readfds); // 将标准输入（文件描述符为0）添加到文件描述符集中

  /* Wait up to five seconds. */
  // 设置等待时间为5秒

  tv.tv_sec = 5;
  tv.tv_usec = 0;

  retval = select(1, &readfds, NULL, NULL, &tv);
  // 使用 select 函数监视文件描述符集中的描述符，等待可读事件，最多等待5秒

  /* Don't rely on the value of tv now! */
  // 在此之后不要依赖 tv 的值了

  if (retval == -1)
    // select 函数返回错误，输出错误信息
    perror("select()");
  else if (retval)
    // select 函数返回大于0，表示有数据可读
    /* FD_ISSET(0, &rfds) will be true. */
    printf("Data is available now.\n");
  else
    // select 函数返回0，表示等待超时，没有数据可读
    printf("No data within five seconds.\n");

  exit(EXIT_SUCCESS);
}