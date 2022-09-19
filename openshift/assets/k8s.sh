#!/bin/bash -x 
PS1=1
source ~/.bashrc

OUT_FILE=~/creds.yaml
DONE_FILE=/usr/local/etc/k8s.sh.done

_user=student
infra_project=infra
work_project=work

infra_context=${infra_project}-${_user}
work_context=${work_project}-${_user}

oc config use-context ${infra_context}
curr_project=$(oc project -q)

####deploy postgres
pgpass=$(cat /proc/sys/kernel/random/uuid)
oc create secret generic pg-postgresql --from-literal=postgres-password="$pgpass" --dry-run=client -oyaml \
| kubectl apply -f-
oc apply -f /usr/local/k8s -n "${curr_project}"

echo -e "postgres:\n  addr: pg.${curr_project}.svc.cluster.local:5432\n  user: postgres\n  password: $pgpass" > $OUT_FILE
####end

####deploy kafka
sed "s/PROJECT_PLACEHOLDER/${curr_project}/g" /usr/local/k8s_tpl/kafka_tpl.yaml |oc apply -f-
echo -e "kafka:\n  addr: kafka.${curr_project}.svc.cluster.local:9092" >> $OUT_FILE
####end

oc config use-context ${work_context}
touch $DONE_FILE

