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

while ! resolvectl query $proxy_host > /dev/null; do sleep 1;done
oc config use-context ${infra_context} > /dev/null

echo "[INFO] waiting for infra pods is ready.."
count=$(oc get po --ignore-not-found|wc -l)
[[ $count -eq 0 ]] && sleep 10 #wait for pods scheduled
oc wait --for=condition=ready pod  --all --timeout=3m  >/dev/null 2>&1
test $? -eq 1 && echo "[ERROR] infra pods not ready" && kill "$!" && exit 1

kill "$!"
echo "[INFO] done"

oc config use-context ${work_context} > /dev/null
