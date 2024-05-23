#!/bin/bash

VENV_DONE=/tmp/venv_installed

spinner() {
  local i sp n
  sp='/-\|'
  n=${#sp}
  printf ' '
  while sleep 0.2; do
    printf "%s\b" "${sp:i++%n:1}"
  done
}

function install_venv() {
  echo -e "\n[INFO] Installing venv"
  if [ ! -f "$VENV_DONE" ]; then
    python3.11 -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    echo "export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt" >>  ~/.bashrc && \
    echo "source /opt/venv/bin/activate" >>  ~/.bashrc && \
    pip3 install gigachat
    touch $VENV_DONE
  else
    echo already installed
  fi
}

# wait for cluster readiness
launch.sh

spinner &
install_venv
#stop spinner
kill "$!"
