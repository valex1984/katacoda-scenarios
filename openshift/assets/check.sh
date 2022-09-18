#!/bin/bash

_user=student
infra_project=infra
work_project=work

infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}

oc config use-context ${infra_context} > /dev/null
curr_project=$(oc project -q)

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

echo "[INFO] waiting for starting infra pods..."
while true
    do 
    count=$(oc get po --ignore-not-found|wc -l)
    [[ $count -gt 0 ]] && break
    sleep 2
done
echo "[INFO] done"
echo "[INFO] waiting for infra pods is ready.."
oc wait --for=condition=ready pod  --all --timeout=3m  >/dev/null 2>&1
test $? -eq 1 && echo "[ERROR] infra pods not ready" && kill "$!" && exit 1

kill "$!"
echo "[INFO] done"

oc config use-context ${work_context} > /dev/null
