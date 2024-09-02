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
    wget http://nexus:8081/repository/binaries/geth/1.14.8/geth -O /usr/local/bin/geth && \
    chmod +x /usr/local/bin/geth
    test $? -eq 1 && echo "[ERROR] cannot access nexus repo" && kill "$!" && exit 1

    python3.11 -m venv /opt/venv && \
    source /opt/venv/bin/activate && \
    echo "export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt" >>  ~/.bashrc && \
    echo "source /opt/venv/bin/activate" >>  ~/.bashrc && \
    pip3 install -r ~/requirements.txt
    test $? -eq 1 && echo "[ERROR] cannot prepare venv" && kill "$!" && exit 1

    touch $VENV_DONE
  else
    echo already installed
  fi
}

spinner &
install_venv
#stop spinner
kill "$!"
