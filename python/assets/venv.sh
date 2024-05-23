#!/bin/bash -x 
PS1=1
source ~/.bashrc
venv_name=.venv

DONE_FILE=/usr/local/etc/venv.done

[ -f $DONE_FILE ] && exit 0

python3 -m venv $venv_name && source ${venv_name}/bin/activate

echo "source $venv_name/bin/activate" >>  ~/.bashrc

touch $DONE_FILE

