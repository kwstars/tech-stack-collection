#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/socket.h>
#include <unistd.h>

#define MAX_EVENTS 128
#define PORT 54321

int main() {
  // 定义一个epoll_event结构体变量ev，用于在调用epoll_ctl时指定事件类型和与事件关联的文件描述符
  // 定义一个epoll_event类型的数组events，用于在调用epoll_wait时接收已经就绪的事件
  struct epoll_event ev, *events;
  // 定义一个整型变量listen_sock，用于存储监听socket的文件描述符
  // 定义一个整型变量conn_sock，用于存储接受的连接的文件描述符
  // 定义一个整型变量nfds，用于存储epoll_wait返回的就绪的文件描述符的数量
  // 定义一个整型变量epollfd，用于存储epoll实例的文件描述符
  int listen_sock, conn_sock, nfds, epollfd;

  // 创建监听socket
  listen_sock = socket(AF_INET, SOCK_STREAM, 0);

  int on = 1;
  setsockopt(listen_sock, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

  // 绑定到本地端口
  struct sockaddr_in serv_addr;
  memset(&serv_addr, 0, sizeof(serv_addr));
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
  serv_addr.sin_port = htons(PORT);
  bind(listen_sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

  // 开始监听
  listen(listen_sock, 10);

  // 创建epoll实例
  epollfd = epoll_create1(0);
  if (epollfd == -1) {
    perror("epoll_create1");
    exit(EXIT_FAILURE);
  }

  // 设置要监听的事件类型为EPOLLIN，表示当listen_sock上有数据可读时，epoll_wait会返回。水平触发模式下，只要文件描述符就绪，无论是否处理，epoll都会持续通知你。
  ev.events = EPOLLIN;
  ev.data.fd = listen_sock;
  // 将listen_sock添加到epoll的监听列表
  if (epoll_ctl(epollfd, EPOLL_CTL_ADD, listen_sock, &ev) == -1) {
    perror("epoll_ctl: listen_sock");
    exit(EXIT_FAILURE);
  }

  events = (struct epoll_event *)calloc(MAX_EVENTS, sizeof(ev));
  // 无限循环，服务器持续运行
  for (;;) {
    // 等待epoll事件的发生
    nfds = epoll_wait(epollfd, events, MAX_EVENTS, -1);
    printf("epoll_wait wakeup, nfds: %d\n", nfds);
    // 如果epoll_wait调用失败，打印错误信息并退出
    if (nfds == -1) {
      perror("epoll_wait");
      exit(EXIT_FAILURE);
    }

    // 处理所有已经就绪的事件
    for (int n = 0; n < nfds; ++n) {
      // 如果就绪的文件描述符是监听socket，表示有新的连接请求
      if (events[n].data.fd == listen_sock) {
        struct sockaddr_in client_addr;
        socklen_t client_addr_len = sizeof(client_addr);
        // 接受新的连接
        conn_sock = accept(listen_sock, (struct sockaddr *)&client_addr,
                           &client_addr_len);
        // 如果accept调用失败，打印错误信息并退出
        if (conn_sock == -1) {
          perror("accept");
          exit(EXIT_FAILURE);
        }
        // 设置新的连接socket的事件为EPOLLIN |
        // EPOLLET，表示当有数据可读或者连接关闭时，epoll_wait会返回。边缘触发模式下，epoll只会通知你一次，直到下次再有相应事件发生。
        ev.events = EPOLLIN | EPOLLET;
        ev.data.fd = conn_sock;
        // 将新的连接socket添加到epoll的监听列表
        if (epoll_ctl(epollfd, EPOLL_CTL_ADD, conn_sock, &ev) == -1) {
          perror("epoll_ctl: conn_sock");
          exit(EXIT_FAILURE);
        }
      } else {
        // 如果就绪的文件描述符不是监听socket，表示有数据可读
        char buf[256];
        // 读取数据
        int len = read(events[n].data.fd, buf, sizeof(buf) - 1);
        // 如果读取成功，打印接收到的数据
        if (len > 0) {
          buf[len] = '\0';
          printf("Received: %s", buf);
        }
      }
    }
  }

  free(events);
  close(epollfd);
  close(listen_sock);
  return 0;
}