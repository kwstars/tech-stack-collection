#include <arpa/inet.h>  // for htonl(), htons()
#include <errno.h>      // for errno
#include <netinet/in.h> // for struct sockaddr_in
#include <signal.h>     // for signal(), SIGPIPE, SIG_IGN
#include <stdio.h>      // for error()
#include <stdlib.h>     // for exit()
#include <string.h>     // for memset()
#include <sys/socket.h> // for socket(), setsockopt(), bind(), listen(), accept()
#include <sys/wait.h>   // for waitpid(), WNOHANG
#include <unistd.h>     // for close(), fork()

#define SERV_PORT 54321
#define LISTENQ 1024
#define MAX_LINE 4096

void sigchld_handler(int sig) {
  // 使用 waitpid 函数循环等待所有子进程结束。参数 -1 表示等待任何子进程，0
  // 表示立即返回（不阻塞），WNOHANG 表示如果没有已结束的子进程则立即返回 0。
  while (waitpid(-1, 0, WNOHANG) > 0)
    ;
  // 函数返回
  return;
}

int tcp_server_listen(int port) {
  // 创建一个 socket，用于监听客户端的连接请求
  int listener_fd = socket(AF_INET, SOCK_STREAM, 0);
  if (listener_fd < 0) {
    perror("socket creation failed");
    exit(1);
  }

  // 初始化服务器的地址结构
  struct sockaddr_in server_addr = {0};
  server_addr.sin_family = AF_INET; // 使用 IPv4 地址
  server_addr.sin_addr.s_addr =
      htonl(INADDR_ANY); // 服务器可以在任何网络接口上接收连接
  server_addr.sin_port = htons(port); // 设置服务器监听的端口号

  // 设置 socket 选项，允许在同一个端口上启动多个服务器进程
  int on = 1;
  if (setsockopt(listener_fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on)) < 0) {
    perror("setsockopt(SO_REUSEADDR) failed");
    close(listener_fd);
    return -1;
  }

  // 将 socket 绑定到指定的地址和端口上
  if (bind(listener_fd, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
      0) {
    perror("bind failed");
    close(listener_fd);
    return -1;
  }

  // 开始监听客户端的连接请求
  if (listen(listener_fd, LISTENQ) < 0) {
    perror("listen failed");
    close(listener_fd);
    return -1;
  }

  // 忽略 SIGPIPE 信号，防止在写入已关闭的 socket 时程序退出
  signal(SIGPIPE, SIG_IGN);

  // 返回监听 socket 的文件描述符
  return listener_fd;
}

void child_run(int fd) {
  char ch;
  char outbuf[MAX_LINE + 1];
  size_t outbuf_used = 0;

  while (recv(fd, &ch, 1, 0) > 0) {
    if (outbuf_used < sizeof(outbuf) - 1) {
      outbuf[outbuf_used++] = ch;
    } else {
      // 缓冲区已满,发送数据并清空缓冲区
      send(fd, outbuf, outbuf_used, 0);
      outbuf_used = 0;
      // 将当前字符添加到缓冲区中
      outbuf[outbuf_used++] = ch;
    }

    if (ch == '\n') {
      send(fd, outbuf, outbuf_used, 0);
      outbuf_used = 0;
    }
  }

  // 发送最后的数据
  if (outbuf_used > 0) {
    send(fd, outbuf, outbuf_used, 0);
  }
}

int main(int argc, char const *argv[]) {
  printf("Starting server...\n");
  int listener_fd = tcp_server_listen(SERV_PORT);
  if (listener_fd < 0) {
    fprintf(stderr, "Failed to start server\n");
    return 1;
  }
  printf("Server started, listening on port %d\n", SERV_PORT);
  signal(SIGCHLD, sigchld_handler);

  while (1) {
    struct sockaddr_storage ss;
    socklen_t slen = sizeof(ss);
    printf("Waiting for a connection...\n");
    int fd = accept(listener_fd, (struct sockaddr *)&ss, &slen);
    if (fd < 0) {
      perror("accept failed");
      continue;
    }

    printf("Received a connection\n");
    pid_t pid = fork();
    if (pid == 0) {
      printf("In child process\n");
      close(listener_fd);
      child_run(fd);
      printf("Child process finished\n");
      exit(0);
    } else if (pid > 0) {
      printf("In parent process, closing connection\n");
      close(fd);
    } else {
      perror("fork failed");
      close(fd);
    }
  }

  return 0;
}