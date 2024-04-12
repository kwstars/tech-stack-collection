#include <netinet/in.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define MAX_CLIENTS 30
#define PORT 54321

int main() {
  int listen_sock, client_sock, i;
  struct sockaddr_in server_addr;
  // 定义一个pollfd结构体数组fds，用于存储poll要监听的文件描述符列表
  struct pollfd fds[MAX_CLIENTS];

  if ((listen_sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }

  server_addr.sin_family = AF_INET;
  server_addr.sin_addr.s_addr = INADDR_ANY;
  server_addr.sin_port = htons(PORT);

  if (bind(listen_sock, (struct sockaddr *)&server_addr, sizeof(server_addr)) <
      0) {
    perror("bind failed");
    exit(EXIT_FAILURE);
  }

  if (listen(listen_sock, 3) < 0) {
    perror("listen failed");
    exit(EXIT_FAILURE);
  }

  memset(fds, 0, sizeof(fds));
  fds[0].fd = listen_sock;
  fds[0].events = POLLIN;

  while (1) {
    if (poll(fds, MAX_CLIENTS, -1) < 0) {
      perror("poll failed");
      exit(EXIT_FAILURE);
    }

    if (fds[0].revents & POLLIN) {
      if ((client_sock = accept(listen_sock, NULL, NULL)) < 0) {
        perror("accept failed");
        exit(EXIT_FAILURE);
      }

      for (i = 1; i < MAX_CLIENTS; i++) {
        if (fds[i].fd == 0) {
          fds[i].fd = client_sock;
          fds[i].events = POLLIN;
          break;
        }
      }
    }

    for (i = 1; i < MAX_CLIENTS; i++) {
      if (fds[i].revents & POLLIN) {
        char buffer[1025];
        int len = read(fds[i].fd, buffer, 1024);
        if (len <= 0) {
          close(fds[i].fd);
          fds[i].fd = 0;
        } else {
          buffer[len] = '\0';
          send(fds[i].fd, buffer, strlen(buffer), 0);
        }
      }
    }
  }

  return 0;
}