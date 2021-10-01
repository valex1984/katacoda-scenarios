package k8s.all

allow[msg] {                                                                                                           
  item := input.items[_] 
  item.kind == "Deployment"                   
  item.spec.replicas > 1 
  msg := sprintf("[STD-CN-SI-2] Deployment '%v': Проверка на кол-во реплик пройдена. Реплик: %d", [item.metadata.name, item.spec.replicas])       
}

deny[msg] {
  item := input.items[_]   
  item.kind == "Deployment"                 
  item.spec.replicas == 1 
  msg := sprintf("[STD-CN-SI-2] Deployment '%v': Проверка на кол-во реплик не пройдена. Реплик: %d", [item.metadata.name, item.spec.replicas])       
}


rs_owner_map[name] = owner {
    item := input.items[_] 
    item.kind == "Pod"                   
    name := item.metadata.name
    owner:=item.metadata.ownerReferences[_]
    owner.kind == "ReplicaSet"
}

all_owners_map[name] = owner {
    item := input.items[_] 
    item.kind == "Pod"                   
    name := item.metadata.name
    owner:=item.metadata.ownerReferences[_]
}

allow[msg] {  
    item := input.items[_]                                                                                                         
    item.kind == "Pod"                   
    owner := all_owners_map[item.metadata.name]
    msg := sprintf("[STD-CN-RS-3.1, STD-CN-NT-2.63] Pod '%v': входит в %v '%v, масштабировние и устойчивость обеспечиваются оркестратором'", [item.metadata.name, owner.kind, owner.name])       
}

deny[msg] {
  item := input.items[_]   
  item.kind == "Pod"                   
  not rs_owner_map[item.metadata.name]
  msg := sprintf("[STD-CN-RS-3.1, STD-CN-NT-2.63] Pod '%v': не использует Deployment, масштабировние и устойчивость невозможны", [item.metadata.name])       
}

deployment_owner_map[name] = owner {
    item := input.items[_] 
    item.kind == "ReplicaSet"                   
    name := item.metadata.name
    owner:=item.metadata.ownerReferences[_]
    owner.kind == "Deployment"
}

all_owners_map[name] = owner {
    item := input.items[_] 
    item.kind == "ReplicaSet"                   
    name := item.metadata.name
    owner:=item.metadata.ownerReferences[_]
}

allow[msg] {  
    item := input.items[_]                                                                                                         
    item.kind == "ReplicaSet"                   
    owner := all_owners_map[item.metadata.name]
    msg := sprintf("[STD-CN-RS-3.1, STD-CN-NT-2.63] ReplicaSet '%v': входит в %v '%v'", [item.metadata.name, owner.kind, owner.name])       
}

deny[msg] {
  item := input.items[_]   
  item.kind == "ReplicaSet"                   
  not deployment_owner_map[item.metadata.name]
  msg := sprintf("[STD-CN-RS-3.1, STD-CN-NT-2.63] ReplicaSet '%v': не использует Deployment", [item.metadata.name])       
}

allow[msg] {                                                                                                           
  item := input.items[_] 
  item.kind == "DestinationRule"                   
  item.spec.trafficPolicy.tls.mode == "ISTIO_MUTUAL" 
  msg := sprintf("[STD-CN-SI-2] DestinationRule '%v': trafficPolicy.tls.mode=ISTIO_MUTUAL шифрование трафика включено", [item.metadata.name])       
}

deny[msg] {
  item := input.items[_]   
  item.kind == "DestinationRule"                 
  item.spec.trafficPolicy.tls.mode != "ISTIO_MUTUAL"
  msg := sprintf("[STD-CN-SI-2] DestinationRule '%v': trafficPolicy.tls.mode=%v шифрование не обеспечивается централизовано на уровне service mesh", [item.metadata.name, item.spec.trafficPolicy.tls.mode])       
}

pa_list[pa] {
  item := input.items[_]   
  item.kind == "PeerAuthentication"                   
  pa := item
}

deny[msg] {
  count(pa_list) == 0
  msg := "[STD-CN-SI-2] Нет объектов политики PeerAuthentication, шифрование трафика не гарантируется политикой"      
}

dr_list[dr] {
  item := input.items[_]   
  item.kind == "DestinationRule"                   
  dr := item
}

deny[msg] {
  count(dr_list) == 0
  msg := "[STD-CN-SI-2] Нет объектов DestinationRule, шифрование трафика не гарантируется"    
}


error[{"reason": reason, "item": item}] {
    item := input.items[_]
    item.kind != "Deployment"
    item.kind != "Pod"
    item.kind != "ReplicaSet"
    item.kind != "DestinationRule"
    item.kind != "PeerAuthentication"
    reason:="Unexpected item.kind"
}

policy := { "allow": allow, "deny": deny, "err": error }