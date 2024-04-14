#!/bin/bash

if [[ -n "$USERNAME" ]] && [[ -n "$PASSWORD" ]]; then
  htpasswd -bc /etc/nginx/htpasswd $USERNAME $PASSWORD
  echo Done.
else
  echo Using no auth.
  sed -i 's%auth_basic "Restricted";% %g' /etc/nginx/conf.d/default.conf
  sed -i 's%auth_basic_user_file htpasswd;% %g' /etc/nginx/conf.d/default.conf
fi

# 启动 tcpdump 在后台抓包，保存到 /tmp/tcpdump.pcap
tcpdump -i any -w /pcap/webdav.pcap &
# 启动 Nginx
exec nginx -g 'daemon off;'
