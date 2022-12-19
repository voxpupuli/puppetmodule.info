#!/usr/bin/env puma

root = File.dirname(__FILE__) + '/../'

directory root
rackup root + 'config.ru'
environment 'production'
#bind 'tcp://127.0.0.1:8080'
# When systemd socket activation is detected, only use those sockets. This
# makes FOREMAN_BIND redundant. The code is still there for non-systemd
# deployments.
bind_to_activated_sockets 'only'

#daemonize unless ENV['DOCKERIZED']
#pidfile root + 'tmp/pids/server.pid'
#unless ENV['DOCKERIZED']
#  stdout_redirect root + 'log/puma.log', root + 'log/puma.err.log', true
#end
threads 8, 32
workers 3
# === Puma control rack application ===
activate_control_app "unix://#{root}/sockets/pumactl.sock"
