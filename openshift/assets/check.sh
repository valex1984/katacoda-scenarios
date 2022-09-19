#!/bin/bash

_user=student
infra_project=infra
work_project=work
DONE_FILE=/usr/local/etc/k8s.sh.done

infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}

spinner() {
    local i sp n
    sp='/-\|'
    n=${#sp}
    printf ' '
    while sleep 0.2; do
        printf "%s\b" "${sp:i++%n:1}"
    done
}

spinner &

# sync with install script
while ! [ -f $DONE_FILE ]; do sleep 1 ;done

echo "[INFO] waiting for infra pods is ready.."
# switch to infra context 
oc config use-context ${infra_context}
#wait for pods scheduled
while true;
    do
    count=$(oc get po --ignore-not-found|wc -l)
    [[ $count -eq 0 ]] && sleep 1 || break 
done
oc wait --for=condition=ready pod  --all --timeout=3m  #>/dev/null 2>&1
test $? -eq 1 && echo "[ERROR] infra pods not ready" && kill "$!" && exit 1

# switch to work context 
oc config use-context ${work_context}
kill "$!"
echo "[INFO] done"