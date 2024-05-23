#!/bin/bash
venv_name=".venv"

DONE_FILE=/usr/local/etc/venv.done

[ -f $DONE_FILE ] && exit 0

python3 -m venv /opt/${venv_name}

echo "source /opt/${venv_name}/bin/activate" >>  ~/.bashrc

touch $DONE_FILE


