#include <arpa/inet.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>

#define MAX_CLIENTS 30
#define PORT 54321

int main() {
  int listen_sock, client_sock, max_sock, activity, i, sd;
  int client_sockets[MAX_CLIENTS];
  struct sockaddr_in server_addr;
  char buffer[1025];
  fd_set readfds;

  for (i = 0; i < MAX_CLIENTS; i++) {
    client_sockets[i] = 0;
  }

  if ((listen_sock = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
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

  while (1) {
    FD_ZERO(&readfds);
    FD_SET(listen_sock, &readfds);
    max_sock = listen_sock;

    for (i = 0; i < MAX_CLIENTS; i++) {
      sd = client_sockets[i];
      if (sd > 0) {
        FD_SET(sd, &readfds);
      }
      if (sd > max_sock) {
        max_sock = sd;
      }
    }

    activity = select(max_sock + 1, &readfds, NULL, NULL, NULL);

    if ((activity < 0) && (errno != EINTR)) {
      printf("select error");
    }

    if (FD_ISSET(listen_sock, &readfds)) {
      if ((client_sock = accept(listen_sock, NULL, NULL)) < 0) {
        perror("accept failed");
        exit(EXIT_FAILURE);
      }

      for (i = 0; i < MAX_CLIENTS; i++) {
        if (client_sockets[i] == 0) {
          client_sockets[i] = client_sock;
          break;
        }
      }
    }

    for (i = 0; i < MAX_CLIENTS; i++) {
      sd = client_sockets[i];
      if (FD_ISSET(sd, &readfds)) {
        int len;
        if ((len = read(sd, buffer, 1024)) == 0) {
          close(sd);
          client_sockets[i] = 0;
        } else {
          buffer[len] = '\0';
          send(sd, buffer, strlen(buffer), 0);
        }
      }
    }
  }

  return 0;
}