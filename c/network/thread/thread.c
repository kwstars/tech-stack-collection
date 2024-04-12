#include <arpa/inet.h>
#include <netinet/in.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define HOST "127.0.0.1"
#define PORT 54321

void *connection_handler(void *arg);

int main() {
  int server_socket;
  struct sockaddr_in server_addr, client_addr;
  socklen_t addr_len = sizeof(client_addr);

  // 创建服务器 socket
  server_socket = socket(AF_INET, SOCK_STREAM, 0);
  if (server_socket == -1) {
    perror("socket() failed");
    return 1;
  }

  // 设置 socket 选项以重用地址
  int opt = 1;
  setsockopt(server_socket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

  // 绑定服务器 socket
  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = inet_addr(HOST);
  server_addr.sin_port = htons(PORT);
  if (bind(server_socket, (struct sockaddr *)&server_addr,
           sizeof(server_addr)) < 0) {
    perror("bind() failed");
    return 1;
  }

  // 开始监听
  if (listen(server_socket, SOMAXCONN) < 0) {
    perror("listen() failed");
    return 1;
  }

  printf("TCP 服务器在 %s:%d 上运行\n", HOST, PORT);

  while (1) {
    // 接受新的连接请求
    int *new_socket = malloc(sizeof(int));
    *new_socket =
        accept(server_socket, (struct sockaddr *)&client_addr, &addr_len);
    if (*new_socket == -1) {
      perror("accept() failed");
      free(new_socket);
      continue;
    }

    printf("新的连接来自 %s:%d\n", inet_ntoa(client_addr.sin_addr),
           ntohs(client_addr.sin_port));

    // 创建一个新线程来处理这个连接
    pthread_t thread_id;
    if (pthread_create(&thread_id, NULL, connection_handler, new_socket) != 0) {
      perror("pthread_create() failed");
      close(*new_socket);
      free(new_socket);
      continue;
    }
    pthread_detach(thread_id);
  }

  close(server_socket);
  return 0;
}

void *connection_handler(void *arg) {
  int client_socket = *(int *)arg;
  free(arg);
  char buffer[1024] = {0};
  int bytes_read;

  // 处理客户端连接
  while ((bytes_read = recv(client_socket, buffer, 1024, 0)) > 0) {
    // 回送数据给客户端
    send(client_socket, buffer, bytes_read, 0);
  }

  // 客户端断开连接
  close(client_socket);
  printf("客户端断开连接\n");
  pthread_exit(NULL);
}