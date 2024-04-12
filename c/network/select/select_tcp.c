#include <arpa/inet.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 54321
#define MAX_LINE 4096

int main() {
  int listen_sock, client_sock, max_sock;
  struct sockaddr_in server_addr;
  char buffer[MAX_LINE];
  // 定义文件描述符集合：readfds
  // 用于存储需要读取的文件描述符，writefds
  // 用于存储需要写入的文件描述符，rset 和
  // wset 用于存储 select 函数的结果
  fd_set readfds, writefds, rset, wset;

  if ((listen_sock = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
    perror("socket failed");
    exit(EXIT_FAILURE);
  }
  int on = 1;
  setsockopt(listen_sock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

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

  FD_ZERO(&readfds);
  FD_SET(listen_sock, &readfds);
  FD_ZERO(&writefds);

  max_sock = listen_sock;

  while (1) {
    rset = readfds;
    wset = writefds;
    int num_ready_fds = select(max_sock + 1, &rset, &wset, NULL, NULL);
    if (num_ready_fds == -1) {
      printf("select error: %s(errno: %d)\n", strerror(errno), errno);
      return 0;
    }
    if (FD_ISSET(listen_sock, &rset)) {
      struct sockaddr_in client;
      socklen_t len = sizeof(client);
      if ((client_sock =
               accept(listen_sock, (struct sockaddr *)&client, &len)) == -1) {
        printf("accept socket error: %s(errno: %d)\n", strerror(errno), errno);
        return 0;
      }
      FD_SET(client_sock, &readfds);
      if (client_sock > max_sock)
        max_sock = client_sock;
      if (--num_ready_fds == 0)
        continue;
    }

    int i = 0;
    for (i = listen_sock + 1; i <= max_sock; i++) {
      int n = -1;
      if (FD_ISSET(i, &rset)) {
        n = recv(i, buffer, MAX_LINE, 0);
        if (n > 0) {
          buffer[n] = '\0';
          printf("recv msg from client (socket %d): %s", i, buffer);
          FD_SET(i, &writefds);
        } else if (n == 0) {
          printf("client (socket %d) closed the connection\n", i);
          FD_CLR(i, &readfds);  // Clear the socket from the read set
          FD_CLR(i, &writefds); // Clear the socket from the write set
          close(i);             // Close the client socket
          continue;
        } else {
          printf("recv error: %s(errno: %d)\n", strerror(errno), errno);
          continue;
        }
        if (--num_ready_fds == 0)
          break;
      }

      if (FD_ISSET(i, &wset)) {
        if (n == -1) { // Check if n has been assigned
          continue;
        }
        if (send(i, buffer, n, 0) == -1) {
          printf("send error: %s(errno: %d)\n", strerror(errno), errno);
          continue;
        }
        FD_CLR(i, &writefds);
        FD_SET(i, &readfds);
      }
    }
  }

  return 0;
}