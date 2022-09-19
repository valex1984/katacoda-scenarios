#!/bin/bash

_user=student
infra_project=infra
work_project=work
proxy_host=nexus

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

# check if proxy_host already resolvable
while ! resolvectl query $proxy_host > /dev/null 2>&1; do sleep 1;done
# check if config has been copied
while ! [ -f ~/.kube/config ]; do sleep 1 ;done

echo "[INFO] waiting for infra pods is ready.."
# switch to infra context 
sleep 10
oc config use-context ${infra_context} > /dev/null
#wait for pods scheduled
while true;
    do
    count=$(oc get po --ignore-not-found|wc -l)
    [[ $count -eq 0 ]] && sleep 2 || break 
done
oc wait --for=condition=ready pod  --all --timeout=3m  #>/dev/null 2>&1
test $? -eq 1 && echo "[ERROR] infra pods not ready" && kill "$!" && exit 1

# switch to work context 
oc config use-context ${work_context} > /dev/null

kill "$!"
echo "[INFO] done"